package net.exkazuu

import java.io.FileInputStream
import java.util.ArrayList
import java.util.HashSet
import java.util.Properties
import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.support.ui.ExpectedConditions
import org.openqa.selenium.support.ui.WebDriverWait

class Main {

	def static nextPage(WebDriver driver) {
		val nextPageButton = driver.findElements(By::className("next_page"));
		if (nextPageButton.size > 0) {
			nextPageButton.get(0).click()
			true
		}
	}

	def static main(String[] args) {

		// Load user and pass from property file
		val userAndPass = new Properties;
		userAndPass.load(new FileInputStream(".properties"))
		val user = userAndPass.getProperty("name")
		val password = userAndPass.getProperty("pass")

		val repoInfos = new ArrayList<RepositoryInfo>();

		// Set PATH for chromedriver.exe
		val driver = new ChromeDriver()

		//val url = 'https://github.com/search?l=XML&p=95&q=%3CgroupId%3Eorg.seleniumhq.selenium%3C%2FgroupId%3E&s=&type=Code&l=XML'
		val url = 'https://github.com/search?l=XML&p=1&q=%3CgroupId%3Eorg.seleniumhq.selenium%3C%2FgroupId%3E&s=indexed&type=Code'
		driver.get(url)

		var hasNext = false

		do {
			val service = new RepositoryService()
			service.client.setCredentials(user, password)

			val elems = driver.findElements(By::xpath('//p[@class="title"]/a[1]'))
			val repoStrings = new HashSet<String>();
			for (elem : elems) {
				repoStrings += elem.text
			}
			hasNext = nextPage(driver)

			for (repoString : repoStrings) {
				val strs = repoString.split("/")
				val repo = service.getRepository(strs.get(0), strs.get(1))
				if (repo.description == null || !repo.description.toLowerCase.replace(" ", "").contains("webdriver"))
					System::out.println(repo.getWatchers() + "," + strs.get(0) + "," + strs.get(1))
			}

			new WebDriverWait(driver, 20).until(
				ExpectedConditions::invisibilityOfElementLocated(
					By::className('context-loader')
				))
		} while (hasNext)
		driver.close()
	}
}
