package net.exkazuu.probe.sonar

import java.io.File
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver

import static extension net.exkazuu.probe.extensions.XProcess.*

class SonarManager {
	val MavenManager mvnMan
	val WebDriver driver
	val File directory

	new(MavenManager mvnMan, WebDriver driver) {
		this.mvnMan = mvnMan
		this.driver = driver
		this.directory = new File("SonarQube")
	}

	new(MavenManager mvnMan, WebDriver driver, File directory) {
		this.mvnMan = mvnMan
		this.driver = driver
		this.directory = directory
	}

	def moveToTopPage() {
		driver.get("http://localhost:9000/")
	}

	def login() {
		driver.get("http://localhost:9000/sessions/login")
		Thread.sleep(10 * 1000)
		driver.findElements(By.xpath('//input[@id="login"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@id="password"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@type="submit"]')).get(0).click()
		Thread.sleep(10 * 1000)
	}

	def execute(GithubRepositoryInfo info) {
		mvnMan.start("clean test").waitToFinish()
		mvnMan.start("sonar:sonar").waitToFinish()
		login
		moveToTopPage

		val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
		if (repos.size != 0) {
			repos.get(0).click
			Thread.sleep(10 * 1000)

			new SonarPage(driver).updateInformation(info)
			deleteFirstProjectData()
		}
	}

	def deleteFirstProjectData() {
		login
		moveToTopPage

		val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
		if (repos.size != 0) {
			repos.get(0).click
			Thread.sleep(10 * 1000)

			val deleteURL = driver.currentUrl.replace("dashboard/index", "project/deletion")
			driver.get(deleteURL)
			Thread.sleep(10 * 1000)
			driver.findElement(By.id("delete_resource")).click
			Thread.sleep(10 * 1000)
			driver.findElement(By.id("delete-project-submit")).click

			Thread.sleep(30 * 1000)
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
