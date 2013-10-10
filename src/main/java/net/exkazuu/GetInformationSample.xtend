package net.exkazuu

import java.util.Properties
import java.io.FileInputStream
import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.By

class GetInformationSample {
	def static void main(String[] args) {
		val properties = new Properties
		properties.load(new FileInputStream(".properties"))
		val user = properties.getProperty("name")
		val pass = properties.getProperty("pass")

		val driver = new ChromeDriver
		val minCount = 8790
		val maxCount = 8800

		(minCount .. maxCount).forEach [
			val service = new RepositoryService
			service.client.setCredentials(user, pass)
			val url = "https://github.com/search?p=1&q=size%3A" + it + ".." + it +
				"+path%3Apom.xml&ref=searchresults&type=Code"
			driver.get(url)
			val elems = driver.findElements(By.xpath('//p[@class="title"]/a[1]'))
			for (elem : elems) {
				System.out.println(elem.text)
			}
			Thread.sleep(15 * 1000)
		]
		driver.close
	}
}
