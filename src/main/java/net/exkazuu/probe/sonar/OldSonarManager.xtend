package net.exkazuu.probe.sonar

import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver

class OldSonarManager {
	val MavenManager mvnMan
	val WebDriver driver

	new(MavenManager mvnMan, WebDriver driver) {
		this.mvnMan = mvnMan
		this.driver = driver
	}

	def execute(GithubRepositoryInfo info) {
		mvnMan.execute("clean install -DskipTest=true")
		mvnMan.execute("sonar:sonar")

		driver.get("http://localhost:9000/sessions/login")
		Thread.sleep(10 * 1000)
		driver.findElements(By.xpath('//input[@id="login"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@id="password"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@type="submit"]')).get(0).click()
		Thread.sleep(10 * 1000)

		val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
		if (repos.size != 0) {
			repos.get(0).click
			Thread.sleep(10 * 1000)

			new SonarPage(driver).updateInformation(info)

			val deleteURL = driver.currentUrl.replace("dashboard/index", "project/deletion")
			driver.get(deleteURL)
			Thread.sleep(10 * 1000)
			driver.findElement(By.id("delete_resource")).click
			Thread.sleep(10 * 1000)
			driver.findElement(By.id("delete-project-submit")).click

			//driver.switchTo.alert.accept
			Thread.sleep(30 * 1000)
		}
	}
}
