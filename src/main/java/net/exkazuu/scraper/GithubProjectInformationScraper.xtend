package net.exkazuu.scraper

import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.util.ArrayList
import java.util.List
import java.util.Set
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.htmlunit.HtmlUnitDriver
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.io.CsvBeanWriter
import org.supercsv.prefs.CsvPreference

class GithubProjectInformationScraper {
	val static sleepTime = 15 * 1000

	def static void main(String[] args) {
		val file = new File("repository.csv")
		val header = #["url", "mainBranch", "starCount", "forkCount", "commitCount", "branchCount", "releaseCount",
			"contributorCount", "openIssueCount", "closedIssueCount", "openPullRequestCount"]
		val processors = #[null, null, new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(),
			new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt()]
		val infos = new ArrayList<GithubProjectInformation>()
		if (file.exists) {
			val reader = new FileReader(file)
			val csvReader = new CsvBeanReader(reader, CsvPreference.STANDARD_PREFERENCE)
			var GithubProjectInformation info = null
			csvReader.getHeader(true)

			// TODO: this ugly code is caused by a Xtend bug (https://bugs.eclipse.org/bugs/show_bug.cgi?id=371011)
			while ((info = csvReader.read(typeof(GithubProjectInformation), header, processors)) != null) {
				infos += info
			}
			csvReader.close
			reader.close
		}
		infos += gatherRepositoryAddress("ruby", "Capybara new", 100, infos)
		val writer = new FileWriter(file)
		val csvWriter = new CsvBeanWriter(writer, CsvPreference.STANDARD_PREFERENCE)
		csvWriter.writeHeader(header)
		for (info : infos) {
			csvWriter.write(info, header)
		}
		csvWriter.close
		writer.close
	}

	def static gatherRepositoryAddress(String language, String keyword, int maxPageCount,
		List<GithubProjectInformation> infos) {
		gatherRepositoryAddress("https://github.com/search?l=" + language + "&q=" + keyword + "&ref=cmdform&type=Code",
			maxPageCount, infos)
	}

	def static <T> retry(Functions.Function0<T> func, int count) {
		for (i : 0 ..< count) {
			try {
				return func.apply
			} catch (Exception e) {
			}
		}
	}

	def static gatherRepositoryAddress(String firstPageUrl, int maxPageCount, List<GithubProjectInformation> infos) {
		val driver = new HtmlUnitDriver()
		val visitedUrls = infos.map[it.url].toSet
		var url = firstPageUrl
		var pageCount = 1
		while (url != null && pageCount <= maxPageCount) {
			System.out.print("page " + pageCount + " ")

			val searchResultUrl = url
			url = retry(
				[ |
					System.out.print(".")
					driver.get(searchResultUrl)
					val nextPageUrl = getNextPageUrl(driver)
					infos += scrapeProjectInformation(driver, visitedUrls)
					nextPageUrl
				], 10)

			System.out.println(" done")
			pageCount = pageCount + 1
			Thread::sleep(sleepTime)
		}

		driver.quit
		infos
	}

	def static scrapeProjectInformation(WebDriver driver, Set<String> visitedUrls) {
		val urlSuffixes = driver.findElements(By::xpath('//p[@class="title"]/a[1]')).map[it.text].toArray
		val projectInfos = new ArrayList<GithubProjectInformation>()

		for (urlSuffix : urlSuffixes) {
			val url = "https://github.com/" + urlSuffix
			if (!visitedUrls.contains(url)) {
				visitedUrls += url
				projectInfos += new GithubProjectPageScraper(driver, url).getInformation
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