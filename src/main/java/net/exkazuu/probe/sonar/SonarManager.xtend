package net.exkazuu.probe.sonar

import java.io.File
import net.exkazuu.probe.common.Idioms
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver

import static extension net.exkazuu.probe.extensions.XProcess.*

class SonarManager {
	val WebDriver driver
	val File directory

	new(WebDriver driver) {
		this(driver, new File("SonarQube"))
	}

	new(WebDriver driver, File directory) {
		this.driver = driver
		this.directory = directory
		login()
	}

	def moveToTopPage() {
		driver.get("http://localhost:9000/")
	}

	def login() {
		driver.get("http://localhost:9000/sessions/login")
		driver.findElements(By.xpath('//input[@id="login"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@id="password"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@type="submit"]')).get(0).click()
	}

	def execute(MavenManager mvnMan, GithubRepositoryInfo info) {
		val time = System.currentTimeMillis
		mvnMan.start("clean install -DskipTest=true -Dgpg.skip=true").waitToFinish()

		Idioms.wait(
			[ |
				try {
					if (driver.findElement(By.className("marginbottom5")).text.contains(
						"Welcome to SonarQube Dashboard")) {
						return false
					}
				} catch (Exception e) {
				}
				true
			], 100)
		if (time + 60 * 1000 > System.currentTimeMillis) {
			Thread.sleep(time + 60 * 1000 - System.currentTimeMillis)
		}

		mvnMan.start("sonar:sonar").waitToFinish()

		moveToTopPage()
		val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
		if (repos.size != 0) {
			repos.get(0).click

			new SonarPage(driver).updateInformation(info)
			deleteFirstProjectData()
		} else {
			System.out.println("Failed to retrieve information.")
		}
	}

	def deleteFirstProjectData() {
		moveToTopPage()
		val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
		if (repos.size != 0) {
			repos.get(0).click

			val deleteURL = driver.currentUrl.replace("dashboard/index", "project/deletion")
			driver.get(deleteURL)
			Thread.sleep(1000)
			driver.findElement(By.id("delete_resource")).click()
			Thread.sleep(1000)
			Idioms.wait(
				[ |
					try {
						driver.findElement(By.id("delete-project-submit")).click()
						false
					} catch (Exception e) {
						true
					}
				], 100)
		} else {
			System.out.println("Failed to delete a measurement result.")
		}
	}

	def deleteDataFiles() {
		val dataFile = new File(directory + "/data/sonar.h2.db")
		if (dataFile.exists) {
			dataFile.delete
			System.out.println("file deleted")
		} else {
			System.out.println("file not found")
		}
	}
}
