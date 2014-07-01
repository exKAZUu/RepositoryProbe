package net.exkazuu.probe

import java.io.FileInputStream
import java.util.Properties
import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.By
import org.openqa.selenium.chrome.ChromeDriver

/**
 * A class for counting the number of repositories which have pom.xml.
 * The size of pom.xml is limited to the range from minCount bytes to maxCount bytes. 
 * 
 * @author Ryohei Takasawa
 */

class CheckTheNumberOfRepositories {
	def static main(String[] args) {
		val userAndPass = new Properties
		userAndPass.load(new FileInputStream(".properties"))
		val user = userAndPass.getProperty("name")
		val pass = userAndPass.getProperty("pass")

		//		val path = userAndPass.getProperty("path")
		val driver = new ChromeDriver()
		val minCount = 0;
		val maxCount = 100;

		(minCount .. maxCount).forEach [
			val service = new RepositoryService()
			service.client.setCredentials(user, pass)
			val url = "https://github.com/search?p=1&q=size%3A" + it + ".." + it +
				"+path%3Apom.xml&ref=searchresults&type=Code"
			driver.get(url)
			val elem = driver.findElements(By.xpath('//a[@class="selected"]'))
			val str = elem.get(0).text.split('\n')
			if (str.size > 1) {
				System.out.println(it + "," + str.get(1))
			} else {
				System.out.println(it + "," + 0)
			}
			Thread.sleep(20 * 1000)
		]
		driver.quit
	}
}
