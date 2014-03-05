package net.exkazuu.scraper

import org.junit.After
import org.junit.Test
import org.openqa.selenium.htmlunit.HtmlUnitDriver

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*

class GithubProjectPageScraperTest {

	val driver = new HtmlUnitDriver()

	@After
	def void after() {
		driver.quit()
	}

	@Test
	def void retrieveInformation() {
	val scraper = new GithubProjectPageScraper(driver, "libgit2", "libgit2")
		assertThat(scraper.starCount, greaterThanOrEqualTo(4203))
		assertThat(scraper.forkCount, greaterThanOrEqualTo(924))

		assertThat(scraper.commitCount, greaterThanOrEqualTo(6300))
		assertThat(scraper.branchCount, greaterThanOrEqualTo(77))
		assertThat(scraper.releaseCount, greaterThanOrEqualTo(15))
		assertThat(scraper.contributorCount, greaterThanOrEqualTo(165))

		assertThat(scraper.openIssueCount, greaterThanOrEqualTo(0))
		assertThat(scraper.closedIssueCount, greaterThanOrEqualTo(2043))
		assertThat(scraper.openPullRequestCount, greaterThanOrEqualTo(0))

		assertThat(scraper.mainBranchName, is("development"))
	}

	@Test
	def void retrieveAbbreviatedBranchName() {
	val scraper = new GithubProjectPageScraper(driver, "absessive", "CurrencyTracker")
		assertThat(scraper.starCount, greaterThanOrEqualTo(1))
		assertThat(scraper.forkCount, greaterThanOrEqualTo(0))

		assertThat(scraper.commitCount, greaterThanOrEqualTo(8))
		assertThat(scraper.branchCount, greaterThanOrEqualTo(3))
		assertThat(scraper.releaseCount, greaterThanOrEqualTo(0))
		assertThat(scraper.contributorCount, greaterThanOrEqualTo(1))

		assertThat(scraper.openIssueCount, greaterThanOrEqualTo(0))
		assertThat(scraper.closedIssueCount, greaterThanOrEqualTo(0))
		assertThat(scraper.openPullRequestCount, greaterThanOrEqualTo(0))

		assertThat(scraper.mainBranchName, is("multi-row-select/save"))
	}
}
