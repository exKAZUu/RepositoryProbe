package net.exkazuu.probe

import java.io.File
import net.exkazuu.probe.github.CodeSearchQuery
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.github.RepositorySearchQuery
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

class GithubRepositorySearchScraper extends GithubScraper {
	val RepositorySearchQuery repositorySearchQuery

	new(File csvFile, WebDriver driver, RepositorySearchQuery repositorySearchQuery, int maxPageCount,
		CodeSearchQuery... codeSearchQueries) {
		super(csvFile, driver, maxPageCount, codeSearchQueries)

		this.repositorySearchQuery = repositorySearchQuery
	}

	private def start() {
		gatherRepositoryAddress(repositorySearchQuery.queryUrl)
		GithubRepositoryInfo.write(csvFile, infos.values)
		driver.quit
	}

	override def getUrlsOrSuffixes() {
		driver.findElements(By.className("repolist-name")).map [
			it.findElement(By.tagName("a")).getAttribute("href")
		].toArray(#[""])
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
