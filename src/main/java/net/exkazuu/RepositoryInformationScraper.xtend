package net.exkazuu

import java.util.ArrayList
import java.util.HashSet
import net.exkazuu.scraper.GithubProjectInformation
import net.exkazuu.scraper.GithubProjectPageScraper
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

class RepositoryInformationScraper {
	val static sleepTime = 15 * 1000

	def static void main(String[] args) {
		gatherRepositoryAddress(100)
	}

	def static getNextPageUrl(WebDriver driver) {
		val nextPageButton = driver.findElements(By::className("next_page"))
		if (nextPageButton.size > 0) {
			nextPageButton.get(0).getAttribute("href")
		} else {
			null
		}
	}

	def static gatherRepositoryAddress(int maxPageCount) {
		val driver = new FirefoxDriver()
		val accessedUrls = new HashSet<String>()
		val projectInfos = new ArrayList<GithubProjectInformation>()
		var nextPageUrl = "https://github.com/search?l=java&q=pom.xml&ref=cmdform&type=Code"
		var pageCount = 0

		while (nextPageUrl != null && pageCount < maxPageCount) {
			driver.get(nextPageUrl)

			val urlSuffixes = driver.findElements(By::xpath('//p[@class="title"]/a[1]')).map[it.text].toArray
			nextPageUrl = getNextPageUrl(driver)

			for (urlSuffix : urlSuffixes) {
				val url = "https://github.com/" + urlSuffix
				if (!accessedUrls.contains(url)) {
					accessedUrls += url
					projectInfos += new GithubProjectPageScraper(driver, url).information
				}
			}

			pageCount = pageCount + 1
			Thread::sleep(sleepTime)
		}

		driver.close
		projectInfos
	}
}
