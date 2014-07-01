package net.exkazuu.probe

import java.io.File
import java.util.Map
import net.exkazuu.probe.common.Idioms
import net.exkazuu.probe.github.CodeSearchQuery
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.github.GithubRepositoryPage
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver

/**
 * An abstract class for scraping GitHub projects.
 * 
 * @author Kazunori Sakamoto
 */
abstract class GithubScraper {
	protected val static leastElapsedTime = 10 * 1000

	protected val File csvFile
	protected val WebDriver driver
	protected val CodeSearchQuery[] codeSearchQueries
	protected val Map<String, GithubRepositoryInfo> infos
	protected val int maxPageCount
	var lastSearchTime = 0L

	new(File csvFile, WebDriver driver, int maxPageCount, CodeSearchQuery[] codeSearchQueries) {
		this.csvFile = csvFile
		this.infos = GithubRepositoryInfo.readMap(csvFile)

		this.driver = driver
		this.maxPageCount = maxPageCount
		this.codeSearchQueries = codeSearchQueries
	}

	def gatherRepositoryAddress(String firstPageUrl) {
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
