package net.exkazuu.probe.sonar

import java.io.File
import net.exkazuu.probe.common.Idioms
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver

import static extension net.exkazuu.probe.extensions.XProcess.*
import org.openqa.selenium.JavascriptExecutor

class SonarManager {
	val WebDriver driver
	val File directory
	val waitMillsAfterDeletion = 120 * 1000
	var long lastMills

	new(WebDriver driver) {
		this(driver, new File("SonarQube"))
	}

	new(WebDriver driver, File directory) {
		this.driver = driver
		this.directory = directory
		this.lastMills = System.currentTimeMillis - waitMillsAfterDeletion
	}

	def moveToTopPage() {
		driver.get("http://localhost:9000/")
		Thread.sleep(1000)
	}

	def login() {
		driver.get("http://localhost:9000/sessions/login")
		driver.findElements(By.xpath('//input[@id="login"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@id="password"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@type="submit"]')).get(0).click()
		Thread.sleep(1000)
	}

	def execute(MavenManager mvnMan, GithubRepositoryInfo info) {
		mvnMan.start("clean install -DskipTest=true -Dgpg.skip=true").waitToFinish()

		val sleepMills = lastMills + waitMillsAfterDeletion - System.currentTimeMillis
		if (sleepMills > 0) {
			Thread.sleep(sleepMills)
		}

		mvnMan.start("sonar:sonar").waitToFinish()

		moveToTopPage()
		val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
		if (repos.size != 0) {
			if (repos.size != 1) {
				throw new Exception("The number of projects should be 1.")
			}
			repos.get(0).click

			new SonarPage(driver).updateInformation(info)
			deleteFirstProjectData()
			this.lastMills = System.currentTimeMillis - waitMillsAfterDeletion
		} else {
			System.out.println("Failed to retrieve information.")
		}
	}

	def deleteFirstProjectData() {
		login()
		val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
		if (repos.size != 0) {
			if (repos.size != 1) {
				throw new Exception("The number of projects should be 1.")
			}
			repos.get(0).click

			val deleteURL = driver.currentUrl.replace("dashboard/index", "project/deletion")
			driver.get(deleteURL)
			Thread.sleep(2000)
			(driver as JavascriptExecutor).executeScript("window.confirm = function(msg){return true;};");
			Thread.sleep(2000)
			driver.findElement(By.id("delete_resource")).click()
			Thread.sleep(2000)
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
