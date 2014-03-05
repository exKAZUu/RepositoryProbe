package net.exkazuu.scraper

import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.util.HashMap
import net.exkazuu.utils.Idioms
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.io.CsvBeanWriter
import org.supercsv.prefs.CsvPreference

class GithubProjectInformationScraper {
	val static leastElapsedTime = 10 * 1000
	val static header = #["url", "mainBranch", "starCount", "forkCount", "commitCount", "branchCount", "releaseCount",
		"contributorCount", "openIssueCount", "closedIssueCount", "openPullRequestCount", "searchResultCount"]
	val static processors = #[null, null, new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(),
		new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt()]

	val WebDriver driver
	val String language
	val String keyword
	val String searchKeyword
	val int minSize
	val int maxSize
	val int maxPageCount
	val file = new File("repository.csv")
	val infos = loadExistingInfos(file)
	var lastSearchTime = 0L

	def static loadExistingInfos(File file) {
		val infos = new HashMap<String, GithubProjectInformation>()
		if (file.exists) {
			val reader = new FileReader(file)
			val csvReader = new CsvBeanReader(reader, CsvPreference.STANDARD_PREFERENCE)
			var GithubProjectInformation info = null
			csvReader.getHeader(true)

			while ((info = csvReader.read(typeof(GithubProjectInformation), header, processors)) != null) {
				infos.put(info.url, info)
			}
			csvReader.close
			reader.close
		}
		infos
	}

	new(WebDriver driver, String language, String keyword, String searchKeyword, int minSize, int maxSize,
		int maxPageCount) {
		this.driver = driver
		this.language = language
		this.keyword = keyword
		this.searchKeyword = searchKeyword
		this.minSize = minSize
		this.maxSize = maxSize
		this.maxPageCount = maxPageCount
	}

	def static void main(String[] args) {
		val scraper = new GithubProjectInformationScraper(new FirefoxDriver(), "ruby", "Capybara find", "click", 100,
			1000 * 1000, 1)
		scraper.start()
	}

	def void start() {
		for (size : minSize .. maxSize) {
			System.out.println("File size: " + size)
			val lastCount = infos.size
			gatherRepositoryAddress(size)
			if (lastCount != infos.size) {
				val writer = new FileWriter(file)
				val csvWriter = new CsvBeanWriter(writer, CsvPreference.STANDARD_PREFERENCE)
				csvWriter.writeHeader(header)
				for (info : infos.values) {
					csvWriter.write(info, header)
				}
				csvWriter.close
				writer.close
			}
		}
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

	def gatherRepositoryAddress(int size) {
		gatherRepositoryAddress(
			"https://github.com/search?l=" + language + "&q=" + keyword + "+size:" + size +
				"&ref=cmdform&type=Code")
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

	def scrapeProjectInformation() {
		val urlSuffixes = driver.findElements(By::xpath('//p[@class="title"]/a[1]')).map[it.text].toArray
		for (urlSuffix : urlSuffixes) {
			val url = "https://github.com/" + urlSuffix
			if (!infos.containsKey(url)) {
				System.out.print(".")
				val info = new GithubProjectPageScraper(driver, url, searchKeyword).information
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
}
