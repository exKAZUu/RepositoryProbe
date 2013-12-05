package net.exkazuu

import java.util.Properties
import java.io.FileInputStream
import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.By
import java.util.HashSet
import java.sql.Timestamp

class GetRepositoryInformation {
	def static void main(String[] args) {
		val properties = new Properties
		properties.load(new FileInputStream(".properties"))
		val user = properties.getProperty("name")
		val pass = properties.getProperty("pass")

		val driver = new ChromeDriver
		val minSize = 8790
		val maxSize = 8810

		(minSize .. maxSize).forEach [
			/* preparation */
			val dirPath = "C:\\Study\\Repos" + it
			val timestamp = new Timestamp(System.currentTimeMillis)
			/* generating addresses */
			val service = new RepositoryService
			service.client.setCredentials(user, pass)
			val url = "https://github.com/search?q=maven+extension%3Axml+path%3Apom.xml+size%3A" + it + ".." + it +
				"&type=Code&ref=searchresults"
			driver.get(url)
			val addressBook = new HashSet<String>
			val elems = driver.findElements(By.xpath('//p[@class="title"]/a[1]'))
			for (elem : elems) {
				val address = "https://github.com/" + elem.text + ".git"
				addressBook.add(address)
			}
			/* clone */
			val gm = new GitManager(dirPath)
			for (address : addressBook) {
				gm.clone(address)
			}
			Thread.sleep(20 * 1000)
			/* sonar */
			val mm = new MvnManager(dirPath)
			for (address : addressBook) {
				val name = address.substring(address.lastIndexOf('/') + 1, address.lastIndexOf('.'))
				mm.test(name)
				mm.sonar(name)
			}
		]
	}
}
