package net.exkazuu

import org.openqa.selenium.WebDriver
import org.openqa.selenium.By
import java.util.Properties
import java.io.FileInputStream
import org.openqa.selenium.chrome.ChromeDriver
import java.util.HashSet
import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.support.ui.ExpectedConditions
import org.openqa.selenium.support.ui.WebDriverWait
import java.io.File
import java.io.PrintWriter
import java.io.BufferedWriter
import java.io.FileWriter
import java.io.FileReader
import java.io.BufferedReader

class SearchRepositoryAddressAndClone {
	def static nextPage(WebDriver driver) {
		val nextPageButton = driver.findElements(By::className("next_page"))
		if (nextPageButton.size > 0) {
			nextPageButton.get(0).click()
			return true
		}
	}

	def static void main(String[] args) {

		//		val userAndPass = new Properties()
		//		userAndPass.load(new FileInputStream(".properties"))
		//		val user = userAndPass.getProperty("name")
		//		val pass = userAndPass.getProperty("pass")
		//		val repoStrings = gatherRepositoryAddress(user, pass, 100)
		//		val file = new File("C:\\Study\\address.txt")
		//		val pw = new PrintWriter(new BufferedWriter(new FileWriter(file)))
		//		for (str : repoStrings) {
		//			pw.println(str)
		//		}
		//		pw.close
		//		System::out.println("Number of repositories : " + repoStrings.size)
		val gm = new GitManager("C:\\Study")

		val br = new BufferedReader(new FileReader("C:\\Study\\address.txt"))
		var count = 0;
		while (count < 549) {
			val str = br.readLine()
			if (count > 542) {
				val message = gm.clone(str)
				Thread::sleep(15 * 1000)
			}
			count = count + 1
		}
	}

	def static gatherRepositoryAddress(String user, String pass, int maxPageCount) {
		val driver = new ChromeDriver()
		val url = "https://github.com/search?l=java&q=pom.xml&ref=cmdform&type=Code"
		driver.get(url)

		val repoAddress = new HashSet<String>()
		var pageCount = 0
		while (pageCount < maxPageCount) {
			if (pageCount != 0) {
				nextPage(driver)
				new WebDriverWait(driver, 20).until(
					ExpectedConditions::invisibilityOfElementLocated(
						By::className('context-loader')
					)
				)
			}

			val service = new RepositoryService
			service.client.setCredentials(user, pass)
			val elems = driver.findElements(By::xpath('//p[@class="title"]/a[1]'))

			for (elem : elems) {
				repoAddress += "https://github.com/" + elem.text
			}

			pageCount = pageCount + 1
			Thread::sleep(15 * 1000)
		}

		driver.close
		return repoAddress
	}
}
