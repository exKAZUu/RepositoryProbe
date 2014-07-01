package net.exkazuu.probe

import java.io.File
import java.util.Map
import net.exkazuu.probe.common.Idioms
import net.exkazuu.probe.github.CodeSearchQuery
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.github.GithubRepositoryPage
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import java.util.Properties
import java.io.FileInputStream
import com.google.common.base.Strings

/**
 * An abstract class for scraping GitHub projects.
 * 
 * @author Kazunori Sakamoto
 */
abstract class GithubScraper {
	protected var static leastElapsedTime = 10 * 1000

	protected val File csvFile
	protected val Map<String, GithubRepositoryInfo> infos
	protected val WebDriver driver
	protected val CodeSearchQuery[] codeSearchQueries
	protected val int maxPageCount
	var lastSearchTime = 0L

	new(File csvFile, WebDriver driver, int maxPageCount, CodeSearchQuery[] codeSearchQueries) {
		this.csvFile = csvFile
		this.infos = GithubRepositoryInfo.readMap(csvFile)

		this.driver = driver
		this.maxPageCount = maxPageCount
		this.codeSearchQueries = codeSearchQueries

		val propertyFile = new File("secret.properties")
		if (propertyFile.exists) {
			val properties = new Properties
			properties.load(new FileInputStream(propertyFile))
			val user = properties.getProperty("user")
			val password = properties.getProperty("password")
			if (!Strings.isNullOrEmpty(user) && !Strings.isNullOrEmpty(password)) {
				driver.get("https://github.com/login")
				driver.findElement(By.name("login")).sendKeys(user)
				driver.findElement(By.name("password")).sendKeys(password)
				driver.findElement(By.name("commit")).click()
				leastElapsedTime = 4 * 1000
			}
		}
	}

	def scrapeRepositories(String firstPageUrl) {
		var url = firstPageUrl
		var pageCount = 1
		while (url != null && pageCount <= maxPageCount) {
			System.out.print("page " + pageCount + " ")

			val searchResultUrl = url
			url = Idioms.retry(
				[ |
					openSearchResultPage(searchResultUrl)
					val nextPageUrl = getNextPageUrl(driver)
					scrapeProjectInformation()
					nextPageUrl
				], 10, null, true, true)

			System.out.println(" done")
			pageCount = pageCount + 1
		}
	}

	def openSearchResultPage(String url) {
		val elapsed = System.currentTimeMillis - lastSearchTime
		if (elapsed < leastElapsedTime) {
			Thread.sleep(leastElapsedTime - elapsed)
		}
		driver.get(url)
		lastSearchTime = System.currentTimeMillis
	}

	def scrapeProjectInformation() {
		for (urlOrSuffix : urlsOrSuffixes) {
			val url = if (urlOrSuffix.startsWith("http")) {
					urlOrSuffix
				} else {
					"https://github.com/" + urlOrSuffix
				}
			if (!infos.containsKey(url)) {
				System.out.print(".")
				val info = new GithubRepositoryPage(driver, url, codeSearchQueries).information
				infos.put(info.url, info)
			}
		}
	}

	abstract def String[] getUrlsOrSuffixes()

	def static getNextPageUrl(WebDriver driver) {
		val nextPageButton = driver.findElements(By::className("next_page"))
		if (nextPageButton.size > 0) {
			nextPageButton.get(0).getAttribute("href")
		} else {
			null
		}
	}
}
