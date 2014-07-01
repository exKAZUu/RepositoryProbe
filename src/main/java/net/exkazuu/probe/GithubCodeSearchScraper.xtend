package net.exkazuu.probe

import java.io.File
import net.exkazuu.probe.github.CodeSearchQuery
import net.exkazuu.probe.github.GithubRepositoryInfo
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

import static extension net.exkazuu.probe.extensions.XWebElement.*

class GithubCodeSearchScraper extends GithubScraper {

	val CodeSearchQuery projectQuery
	val int minSizeForSearching
	val int maxSizeForSearching

	new(File csvFile, WebDriver driver, CodeSearchQuery projectQuery, int minSize, int maxSize, int maxPageCount,
		CodeSearchQuery... codeSearchQueries) {
		super(csvFile, driver, maxPageCount, codeSearchQueries)

		this.projectQuery = projectQuery
		this.minSizeForSearching = minSize
		this.maxSizeForSearching = maxSize
	}

	private def start() {
		var size = minSizeForSearching
		while (0 <= size && size < maxSizeForSearching) {
			val maxSize = findGoodMaxSize(size)
			System.out.println("Range: " + size + " .. " + maxSize)
			val lastCount = infos.size
			gatherRepositoryAddress(projectQuery.getQueryUrl(size, maxSize))
			if (lastCount != infos.size) {
				GithubRepositoryInfo.write(csvFile, infos.values)
			}
			size = maxSize + 1
		}
		driver.quit
	}

	private def findGoodMaxSize(int size) {
		var range = 1
		do {
			openSearchResultPage(projectQuery.getQueryUrl(size, size + range - 1))
			range = range * 2
		} while (resultCount <= maxPageCount * 10)
		range = range / 4
		if(range > 0) size + range - 1 else size
	}

	private def getResultCount() {
		driver.findElement(By.className("menu")).findElements(By.tagName("li")).get(1).extractInteger(0)
	}

	override def getUrlsOrSuffixes() {
		driver.findElements(By.xpath('//p[@class="title"]/a[1]')).map [
			it.text
		].toArray(#[""])
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
