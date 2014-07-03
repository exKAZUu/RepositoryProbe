package net.exkazuu.probe.sonar

import net.exkazuu.probe.maven.MavenManager
import org.openqa.selenium.WebDriver
import org.openqa.selenium.By

class SonarManager {
	val MavenManager mvnMan
	val WebDriver driver

	new(MavenManager mvnMan, WebDriver driver) {
		this.mvnMan = mvnMan
		this.driver = driver
	}

	def SonarInfo execute() {
		mvnMan.execute("sonar:sonar")
		driver.get("http://localhost:9000/sessions/login")
		Thread.sleep(10 * 1000)
		driver.findElements(By.xpath('//input[@id="login"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@id="password"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@type="submit"]')).get(0).click()
		Thread.sleep(10 * 1000)
		
		val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
		if(repos.size != 0) {
			repos.get(0).click
			Thread.sleep(10 * 1000)
			val info = new SonarPage(driver).information
			
			val deleteURL = driver.currentUrl.replace("dashboard/index", "project/deletion")
			driver.get(deleteURL)
			Thread.sleep(10 * 1000)
			driver.findElement(By.xpath('//input[@id="delete_resource"]')).click
			Thread.sleep(10 * 1000)
			driver.switchTo.alert.accept
			
			info
		} else {
			val info = new SonarInfo
			info
		}
	}
}
