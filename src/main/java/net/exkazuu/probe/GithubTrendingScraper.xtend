package net.exkazuu.probe

import java.util.HashSet
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.github.GithubRepositoryPage
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.firefox.FirefoxDriver

/**
 * A class for scraping trending information from GitHub pages.
 * 
 * @author Kazunori Sakamoto
 */
class GithubTrendingScraper {
	var WebDriver driver
	val durations = #["daily", "weekly", "monthly"]

	new(WebDriver driver) {
		this.driver = driver
	}

	def start(String[] languages) {
		languages.forEach [ language |
			System.out.println("-------------------" + language + "-------------------")
			val set = new HashSet<String>()
			durations.map [ duration |
				driver.get("https://github.com/trending?l=" + language + "&since=" + duration)
				driver.findElements(By.className("repository-name")).map [
					it.getAttribute("href")
				].toArray(#[""]).map [
					new GithubRepositoryPage(driver, it).information
				]
			].flatten.filter [
				!set.contains(it.url)
			].forEach [
				set.add(it.url)
				val code = createCSharpTestCase(it)
				System.out.print(code)
			]
		]
	}

	def createCSharpTestCase(GithubRepositoryInfo info) '''
		[TestCase(@"«info.url».git",
			@"«info.latestCommitSha»")]		// Star: «info.starCount»
	'''

	def static void main(String[] args) {
		val scraper = new GithubTrendingScraper(new FirefoxDriver())
		scraper.start(#["python", "java", "csharp", "php", "javascript", "lua"])
	}
}
