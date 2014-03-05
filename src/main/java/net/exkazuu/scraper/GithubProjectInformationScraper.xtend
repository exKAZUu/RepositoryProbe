package net.exkazuu.scraper

import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.util.ArrayList
import java.util.List
import java.util.Set
import net.exkazuu.utils.Idioms
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.io.CsvBeanWriter
import org.supercsv.prefs.CsvPreference

class GithubProjectInformationScraper {
	val static sleepTime = 10 * 1000

	def static void main(String[] args) {
		val file = new File("repository.csv")
		val header = #["url", "mainBranch", "starCount", "forkCount", "commitCount", "branchCount", "releaseCount",
			"contributorCount", "openIssueCount", "closedIssueCount", "openPullRequestCount", "searchResult"]
		val processors = #[null, null, new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(),
			new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt()]
		val infos = new ArrayList<GithubProjectInformation>()
		if (file.exists) {
			val reader = new FileReader(file)
			val csvReader = new CsvBeanReader(reader, CsvPreference.STANDARD_PREFERENCE)
			var GithubProjectInformation info = null
			csvReader.getHeader(true)

			while ((info = csvReader.read(typeof(GithubProjectInformation), header, processors)) != null) {
				infos += info
			}
			csvReader.close
			reader.close
		}

		val driver = new FirefoxDriver()
		for (size : 1 .. 1000 * 1000) {
			val lastCount = infos.size
			infos += gatherRepositoryAddress(driver, "ruby", "Capybara new", "click", size, size, 100, infos)
			if (lastCount != infos.size) {
				val writer = new FileWriter(file)
				val csvWriter = new CsvBeanWriter(writer, CsvPreference.STANDARD_PREFERENCE)
				csvWriter.writeHeader(header)
				for (info : infos) {
					csvWriter.write(info, header)
				}
				csvWriter.close
				writer.close
			}
			if (size % 5 == 0) {
				Thread::sleep(60 * 1000)
			}
		}
		driver.quit
	}

	def static gatherRepositoryAddress(WebDriver driver, String language, String keyword, String searchKeyword,
		int maxPageCount, List<GithubProjectInformation> infos) {
		gatherRepositoryAddress(driver,
			"https://github.com/search?l=" + language + "&q=" + keyword + "&ref=cmdform&type=Code", searchKeyword,
			maxPageCount, infos)
	}

	def static gatherRepositoryAddress(WebDriver driver, String language, String keyword, String searchKeyword,
		int minSize, int maxSize, int maxPageCount, List<GithubProjectInformation> infos) {
		gatherRepositoryAddress(driver,
			"https://github.com/search?l=" + language + "&q=" + keyword + "+size:" + minSize + ".." + maxSize +
				"&ref=cmdform&type=Code", searchKeyword, maxPageCount, infos)
	}

	def static gatherRepositoryAddress(WebDriver driver, String firstPageUrl, String searchKeyword, int maxPageCount,
		List<GithubProjectInformation> infos) {
		val visitedUrls = infos.map[it.url].toSet
		var url = firstPageUrl
		var pageCount = 1
		var currentSleepTime = 0
		while (url != null && pageCount <= maxPageCount) {
			Thread::sleep(currentSleepTime)
			currentSleepTime = sleepTime

			System.out.print("page " + pageCount + " ")

			val searchResultUrl = url
			url = Idioms.retry(
				[ |
					driver.get(searchResultUrl)
					val nextPageUrl = getNextPageUrl(driver)
					infos += scrapeProjectInformation(driver, searchKeyword, visitedUrls)
					nextPageUrl
				], 10, null, true, true)

			System.out.println(" done")
			pageCount = pageCount + 1
		}
		infos
	}

	def static scrapeProjectInformation(WebDriver driver, String searchKeyword, Set<String> visitedUrls) {
		val urlSuffixes = driver.findElements(By::xpath('//p[@class="title"]/a[1]')).map[it.text].toArray
		val projectInfos = new ArrayList<GithubProjectInformation>()

		for (urlSuffix : urlSuffixes) {
			val url = "https://github.com/" + urlSuffix
			if (!visitedUrls.contains(url)) {
				System.out.print(".")
				visitedUrls += url
				projectInfos += new GithubProjectPageScraper(driver, url, searchKeyword).information
			}
		}
		projectInfos
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
