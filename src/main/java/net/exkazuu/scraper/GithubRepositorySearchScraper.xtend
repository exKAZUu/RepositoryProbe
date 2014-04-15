package net.exkazuu.scraper

import java.io.File
import java.util.Map
import net.exkazuu.scraper.page.GithubRepositoryPage
import net.exkazuu.scraper.query.CodeSearchQuery
import net.exkazuu.scraper.query.RepositorySearchQuery
import net.exkazuu.utils.Idioms
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

class GithubRepositorySearchScraper {
	val static leastElapsedTime = 10 * 1000

	val WebDriver driver
	val RepositorySearchQuery repositorySearchQuery
	val CodeSearchQuery[] codeSearchQueries
	val File csvFile
	val Map<String, GithubRepositoryInfo> infos
	val int maxPageCount
	var lastSearchTime = 0L

	new(File csvFile, WebDriver driver, RepositorySearchQuery repositorySearchQuery, int maxPageCount,
		CodeSearchQuery... codeSearchQueries) {
		this.csvFile = csvFile
		this.infos = GithubRepositoryInfo.readMap(csvFile)
		this.driver = driver
		this.repositorySearchQuery = repositorySearchQuery
		this.codeSearchQueries = codeSearchQueries
		this.maxPageCount = maxPageCount
	}

	def start() {
		gatherRepositoryAddress(repositorySearchQuery.queryUrl)
		GithubRepositoryInfo.write(csvFile, infos.values)
		driver.quit
	}

	def openSearchResultPage(String url) {
		val elapsed = System.currentTimeMillis - lastSearchTime
		if (elapsed < leastElapsedTime) {
			Thread.sleep(leastElapsedTime - elapsed)
		}
		driver.get(url)
		lastSearchTime = System.currentTimeMillis
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

	def String[] getUrls() {
		driver.findElements(By.className("repolist-name")).map [
			it.findElement(By.tagName("a")).getAttribute("href")
		].toArray(#[""])
	}

	def scrapeProjectInformation() {
		for (url : urls) {
			if (!infos.containsKey(url)) {
				System.out.print(".")
				val info = new GithubRepositoryPage(driver, url, codeSearchQueries).information
				infos.put(info.url, info)
			}
		}
	}

	def static getNextPageUrl(WebDriver driver) {
		val nextPageButton = driver.findElements(By::className("next_page"))
		if (nextPageButton.size > 0) {
			nextPageButton.get(0).getAttribute("href")
		} else {
			null
		}
	}

	def static void main(String[] args) {

		//		if (args.length != 1) {
		//			System.out.println("Please specify one argument indicating a csv file for loading and saving results.")
		//			System.exit(-1)
		//		}
		//		val scraper = new GithubRepositorySearchScraper(new File(args.get(0)), new FirefoxDriver(),
		//			new RepositorySearchQuery("java"), 100)
		//		scraper.start()
		#["java", "csharp", "javascript", "python", "php", "lua"].forEach [
			try {
				val scraper = new GithubRepositorySearchScraper(new File(it + ".csv"), new FirefoxDriver(),
					new RepositorySearchQuery(it), 100)
				scraper.start()
			} catch (Exception e) {
			}
		]
	}
}
