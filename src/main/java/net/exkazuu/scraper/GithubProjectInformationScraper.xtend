package net.exkazuu.scraper

import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.util.HashMap
import java.util.Map
import net.exkazuu.utils.Idioms
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.io.CsvBeanWriter
import org.supercsv.prefs.CsvPreference

import static extension net.exkazuu.scraper.ScraperUtil.*

class GithubProjectInformationScraper {
	val static leastElapsedTime = 10 * 1000
	val static header = #["url", "mainBranch", "starCount", "forkCount", "commitCount", "branchCount", "releaseCount",
		"contributorCount", "openIssueCount", "closedIssueCount", "openPullRequestCount", "searchResultCount"]
	val static processors = #[null, null, new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(),
		new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt()]

	val WebDriver driver
	val SearchQuery projectQuery
	val SearchQuery[] repositoryQueries
	val int minSizeForSearching
	val int maxSizeForSearching
	val int maxPageCount
	val File csvFile
	val Map<String, GithubProjectInformation> infos
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

	new(File csvFile, WebDriver driver, SearchQuery projectQuery, int minSize, int maxSize, int maxPageCount,
		SearchQuery... repositoryQueries) {
		this.csvFile = csvFile
		this.infos = loadExistingInfos(csvFile)
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
				val writer = new FileWriter(csvFile)
				val csvWriter = new CsvBeanWriter(writer, CsvPreference.STANDARD_PREFERENCE)
				csvWriter.writeHeader(header)
				for (info : infos.values) {
					csvWriter.write(info, header)
				}
				csvWriter.close
				writer.close
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
		if (range > 0) size + range - 1 else size
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
				val info = new GithubProjectPageScraper(driver, url, repositoryQueries).information
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
			System.out.println("Please sepcify one argument indicating a csv file for loading and saving results.")
			System.exit(-1)
		}
		val scraper = new GithubProjectInformationScraper(new File(args.get(0)), new FirefoxDriver(),
			new SearchQuery("Capybara find", "ruby"), 1800, 1000 * 1000, 100, new SearchQuery("click", "ruby"),
			new SearchQuery("click", "cucumber"))
		scraper.start()
	}
}
