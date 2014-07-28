package net.exkazuu.probe

import java.io.File
import net.exkazuu.probe.github.CodeSearchQuery
import net.exkazuu.probe.github.GithubRepositoryInfo
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

import static extension net.exkazuu.probe.extensions.XWebElement.*

/**
 * An concrete class for scraping GitHub projects using a code search query
 * (e.g. https://github.com/search?q=test&type=Code).
 * 
 * @author Kazunori Sakamoto
 */
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

	private def run() {
		var size = minSizeForSearching
		while (0 <= size && size < maxSizeForSearching) {
			val maxSize = findGoodMaxSize(size)
			System.out.println("Range: " + size + " .. " + maxSize)
			val lastCount = infos.size
			scrapeRepositories(projectQuery.setSize(size, maxSize).queryUrl)
			if (lastCount != infos.size) {
				GithubRepositoryInfo.write(csvFile, infos.values)
			}
			size = maxSize + 1
		}
		driver.quit
	}

	private def findGoodMaxSize(int size) {
		var range = 1
		System.out.print("Find a range (" + size + "): ")
		do {
			System.out.print(size + range - 1 + ", ")
			openSearchResultPage(projectQuery.setSize(size, size + range - 1).queryUrl)
			range = range * 2
		} while (resultCount <= maxPageCount * 10)
		System.out.println()
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
		val query = new CodeSearchQuery("project").setPath("pom.xml")
		val scraper = new GithubCodeSearchScraper(csvFile, driver, query, 8000, 1000 * 1000 * 1000, 10)
		scraper.run()
	}
}
