package net.exkazuu.probe

import java.io.File
import java.util.Map
import net.exkazuu.probe.common.Idioms
import net.exkazuu.probe.github.CodeSearchQuery
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.github.GithubRepositoryPage
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

import static extension net.exkazuu.probe.extensions.XWebElement.*

class GithubCodeSearchScraper {
	val static leastElapsedTime = 10 * 1000

	val WebDriver driver
	val CodeSearchQuery projectQuery
	val CodeSearchQuery[] repositoryQueries
	val int minSizeForSearching
	val int maxSizeForSearching
	val int maxPageCount
	val File csvFile
	val Map<String, GithubRepositoryInfo> infos
	var lastSearchTime = 0L

	new(File csvFile, WebDriver driver, CodeSearchQuery projectQuery, int minSize, int maxSize, int maxPageCount,
		CodeSearchQuery... repositoryQueries) {
		this.csvFile = csvFile
		this.infos = GithubRepositoryInfo.readMap(csvFile)
		this.driver = driver
		this.projectQuery = projectQuery
		this.repositoryQueries = repositoryQueries
		this.minSizeForSearching = minSize
		this.maxSizeForSearching = maxSize
		this.maxPageCount = maxPageCount
	}

	def start() {
		var size = minSizeForSearching
		while (0 <= size && size < maxSizeForSearching) {
			val maxSize = findGoodMaxSize(size)
			System.out.println("Range: " + size + " .. " + maxSize)
			val lastCount = infos.size
			gatherRepositoryAddress(constructSearchResultUrl(size, maxSize))
			if (lastCount != infos.size) {
				GithubRepositoryInfo.write(csvFile, infos.values)
			}
			size = maxSize + 1
		}
		driver.quit
	}

	def findGoodMaxSize(int size) {
		var range = 1
		do {
			openSearchResultPage(constructSearchResultUrl(size, size + range - 1))
			range = range * 2
		} while (resultCount <= maxPageCount * 10)
		range = range / 4
		if(range > 0) size + range - 1 else size
	}

	def openSearchResultPage(String url) {
		val elapsed = System.currentTimeMillis - lastSearchTime
		if (elapsed < leastElapsedTime) {
			Thread.sleep(leastElapsedTime - elapsed)
		}
		driver.get(url)
		lastSearchTime = System.currentTimeMillis
	}

	def constructSearchResultUrl(int minSize, int maxSize) {
		"https://github.com/search?l=" + projectQuery.language + "&q=" + projectQuery.keyword + "+size:" + minSize +
			".." + maxSize + "&ref=cmdform&type=Code"
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

	def getResultCount() {
		driver.findElement(By.className("menu")).findElements(By.tagName("li")).get(1).extractInteger(0)
	}

	def getUrlSuffixes() {
		driver.findElements(By.xpath('//p[@class="title"]/a[1]')).map[it.text].toArray
	}

	def scrapeProjectInformation() {
		for (urlSuffix : urlSuffixes) {
			val url = "https://github.com/" + urlSuffix
			if (!infos.containsKey(url)) {
				System.out.print(".")
				val info = new GithubRepositoryPage(driver, url, repositoryQueries).information
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
		if (args.length != 1) {
			System.out.println("Please specify one argument indicating a csv file for loading and saving results.")
			System.exit(-1)
		}

		val csvFile = new File(args.get(0))
		val driver = new FirefoxDriver()
		val scraper = new GithubCodeSearchScraper(csvFile, driver, new CodeSearchQuery("Capybara find", "ruby"), 1800,
			1000 * 1000, 10, new CodeSearchQuery("click", "ruby"), new CodeSearchQuery("click", "cucumber"))
		scraper.start()
	}
}
