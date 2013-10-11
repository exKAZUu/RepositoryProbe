package net.exkazuu

import java.util.Properties
import java.io.FileInputStream
import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.By
import java.sql.Timestamp
import java.util.HashSet

class GetInformationSample {
	def static void main(String[] args) {
		val properties = new Properties
		properties.load(new FileInputStream(".properties"))
		val user = properties.getProperty("name")
		val pass = properties.getProperty("pass")

		/* generating address */
		val timestamp1 = new Timestamp(System.currentTimeMillis)
		System.out.println(timestamp1)

		val driver = new ChromeDriver
		val minCount = 8790
		val maxCount = 8800

		val addressBook = new HashSet<String>()
		(minCount .. maxCount).forEach [
			val service = new RepositoryService
			service.client.setCredentials(user, pass)
			val url = "https://github.com/search?p=1&q=size%3A" + it + ".." + it +
				"+path%3Apom.xml&ref=searchresults&type=Code"
			driver.get(url)
			val elems = driver.findElements(By.xpath('//p[@class="title"]/a[1]'))
			for (elem : elems) {
				val address = "git://github.com/" + elem.text + ".git"
				addressBook.add(address)
			}
			Thread.sleep(15 * 1000)
		]
		driver.close

		/* clone */
		val timestamp2 = new Timestamp(System.currentTimeMillis)
		System.out.println(timestamp2)

		val gm = new GitManager("C:\\Sample")
		for (address : addressBook) {
			gm.clone(address)
		}

		/* sonar */
		val timestamp3 = new Timestamp(System.currentTimeMillis)
		System.out.println(timestamp3)

		val mm = new MvnManager("C:\\Sample")
		for (address : addressBook) {
			val name = address.substring(address.lastIndexOf('/') + 1, address.lastIndexOf('.'))
			mm.sonar(name)
		}

		/* PIT */
		val timestamp4 = new Timestamp(System.currentTimeMillis)
		System.out.println(timestamp4)
		for (address : addressBook) {
			val name = address.substring(address.lastIndexOf('/') + 1, address.lastIndexOf('.'))
			mm.pit(name)
		}
	}
}
