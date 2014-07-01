package net.exkazuu.probe

import java.io.FileInputStream
import java.sql.Timestamp
import java.util.HashSet
import java.util.Properties
import net.exkazuu.probe.git.GitManager
import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.chrome.ChromeDriver
import net.exkazuu.probe.maven.OldMavenManager

/**
 * A class for measuring metrics by SonarQube and showing on the console.
 * The size of pom.xml is limited to the range from minCount bytes to maxCount bytes. 
 * Projects are cloned into the folder rootDirPath.
 * 
 * @author Ryohei Takasawa
 */

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
		val maxCount = 8810

		val rootDirPath = "C:\\Repos" + minCount + "to" + maxCount

		val addressBook = new HashSet<String>()
		(minCount .. maxCount).forEach [
			val service = new RepositoryService
			service.client.setCredentials(user, pass)
			//			val url = "https://github.com/search?p=1&q=size%3A" + it + ".." + it +
			//				"+path%3Apom.xml&ref=searchresults&type=Code"
			val url = "https://github.com/search?q=maven+extension%3Axml+path%3Apom.xml+size%3A" + it + ".." + it +
				"&type=Code&ref=searchresults"
			driver.get(url)
			val elems = driver.findElements(By.xpath('//p[@class="title"]/a[1]'))
			for (elem : elems) {
				val address = "https://github.com/" + elem.text + ".git"
				addressBook.add(address)
			}
			Thread.sleep(15 * 1000)
		]
		driver.close
		System.out.println("Number of repositories : " + addressBook.size)

		/* clone */
		val timestamp2 = new Timestamp(System.currentTimeMillis)
		System.out.println(timestamp2)

		val gm = new GitManager(rootDirPath)
		for (address : addressBook) {
			System.out.println(address)
			gm.clone(address)
		}

		/* sonar */
		val timestamp3 = new Timestamp(System.currentTimeMillis)
		System.out.println(timestamp3)

		val mm = new OldMavenManager(rootDirPath)
		for (address : addressBook) {
			val name = address.substring(address.lastIndexOf('/') + 1, address.lastIndexOf('.'))
			mm.test(name)
			mm.sonar(name)
		}

		/* get data from sonar */
		val timestamp4 = new Timestamp(System.currentTimeMillis)
		System.out.println(timestamp4)
		val sonarURL = "http://localhost:9000/"

		driver.get(sonarURL)
		val elems = driver.findElements(By.xpath('//a[@class="title"]/a[1]'))

		val loc = driver.findElements(By.id('m_ncloc'))
		val coverage = driver.findElements(By.id('m_coverage'))
		val success = driver.findElements(By.id('m_test_success_density'))
		for (l : loc) {
			System.out.println(l.text)
		}
		for (c : coverage) {
			System.out.println(c.text)
		}
		for (s : success) {
			System.out.println(s.text)
		}
		System.out.println(elems.size)
		for (elem : elems) {
			elem.click
			Thread.sleep(15 * 1000)
		}

		Thread.sleep(15 * 1000)
		driver.quit
	}

	def static nextPage(WebDriver driver) {
		val nextPageButton = driver.findElements(By::className("next_page"))
		if (nextPageButton.size > 0) {
			nextPageButton.get(0).click
			return true
		}
		return false
	}
}
