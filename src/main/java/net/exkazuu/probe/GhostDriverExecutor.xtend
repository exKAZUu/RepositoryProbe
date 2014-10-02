package net.exkazuu.probe

import org.openqa.selenium.By
import org.openqa.selenium.phantomjs.PhantomJSDriver
import org.openqa.selenium.phantomjs.PhantomJSDriverService
import org.openqa.selenium.remote.DesiredCapabilities

class GhostDriverExecutor {
	def static void main(String[] args) {
		val caps = new DesiredCapabilities
		caps.setCapability(
			PhantomJSDriverService.PHANTOMJS_EXECUTABLE_PATH_PROPERTY,
			"C:/Program Files/phantomjs-1.9.7-windows/phantomjs.exe"
		)
		val driver = new PhantomJSDriver(caps)
		driver.get("http://localhost:9000/")
		System.out.println(driver.getTitle())

		val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
		if (repos.size != 0) {
			if (repos.size != 1) {
				throw new Exception("The number of projects should be 1.")
			}
			repos.get(0).click

			System.out.println(driver.getTitle)
			System.out.println("LOC : " + driver.findElement(By.id("m_ncloc")).text)
		} else {
			System.out.println("Failed to retrieve information.")
		}

		driver.quit()
	}
}
