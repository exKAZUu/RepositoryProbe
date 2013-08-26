package net.exkazuu

import java.io.FileInputStream
import java.util.Properties
import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.By
import org.openqa.selenium.chrome.ChromeDriver

class CheckTheNumberOfRepositories {
	def static main(String[] args) {
		val userAndPass = new Properties
		userAndPass.load(new FileInputStream(".properties"))
		val user = userAndPass.getProperty("name")
		val pass = userAndPass.getProperty("pass")

		//		val path = userAndPass.getProperty("path")
		val driver = new ChromeDriver()
		var maxCount = 10;

		(1 .. maxCount).forEach [
			val service = new RepositoryService()
			service.client.setCredentials(user, pass)
			val min = it-1
			
			val url = "https://github.com/search?p=1&q=size%3A" + min + ".." + it +
				"+path%3Apom.xml&ref=searchresults&type=Code" //			driver.get(url)
			//			
			//			val elem = driver.findElements(By.xpath('h3'))
			//			System.out.println(elem)
			System.out.println(url)
			]
			driver.close
		}
	}
	