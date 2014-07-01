package net.exkazuu.probe

import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

import static extension net.exkazuu.probe.extensions.XCollection.*
import static extension net.exkazuu.probe.extensions.XString.*

/**
 * A class for counting the number of repositories which have pom.xml.
 * The size of pom.xml is limited to the range from minCount bytes to maxCount bytes. 
 * 
 * @author Ryohei Takasawa
 */
class CheckTheNumberOfRepositories {
	def static countRepositories(WebDriver driver, int minCount, int maxCount) {
		(minCount .. maxCount).map [
			val url = "https://github.com/search?p=1&q=size%3A" + it + ".." + it +
				"+path%3Apom.xml&ref=searchresults&type=Code"
			driver.get(url)
			Thread.sleep(10 * 1000)
			val elem = driver.findElements(By.xpath('//a[@class="selected"]'))
			val str = elem.get(0).text.split('\n')
			val count = str.getOrNull(1).parseIntegerRobustly(0)
			System.out.println(count)
			count
		]
	}

	def static main(String[] args) {

		//		val userAndPass = new Properties
		//		userAndPass.load(new FileInputStream(".properties"))
		//		val user = userAndPass.getProperty("name")
		//		val pass = userAndPass.getProperty("pass")
		//		val service = new RepositoryService()
		//		service.client.setCredentials(user, pass)
		//		val path = userAndPass.getProperty("path")
		val driver = new FirefoxDriver()
		val minCount = 8000;
		val maxCount = 8010;

		val counts = countRepositories(driver, minCount, maxCount)
		System.out.println("Sum: " + counts.fold(0, [a, b|a + b]))

		driver.quit
	}
}
