package net.exkazuu.probe.github

import org.junit.After
import org.junit.Test
import org.openqa.selenium.firefox.FirefoxDriver

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*

class GithubProjectPageScraperTest {

	val driver = new FirefoxDriver()

	@After
	def void after() {
		driver.quit()
	}

	@Test
	def void retrieveInformation() {
		val scraper = new GithubRepositoryPage(driver, "libgit2", "libgit2", new CodeSearchQuery("user"))
		assertThat(scraper.starCount, greaterThanOrEqualTo(4203))
		assertThat(scraper.forkCount, greaterThanOrEqualTo(924))

		assertThat(scraper.commitCount, greaterThanOrEqualTo(6300))
		assertThat(scraper.branchCount, greaterThanOrEqualTo(77))
		assertThat(scraper.releaseCount, greaterThanOrEqualTo(15))
		assertThat(scraper.contributorCount, greaterThanOrEqualTo(165))

		assertThat(scraper.mainBranchName, is("master"))

		assertThat(scraper.openPullRequestCount, greaterThanOrEqualTo(0))
		assertThat(scraper.closedPullRequestCount, greaterThanOrEqualTo(1420))
		assertThat(scraper.openIssueCount, greaterThanOrEqualTo(0))
		assertThat(scraper.closedIssueCount, greaterThanOrEqualTo(2043))

		assertThat(scraper.searchResultCount, greaterThanOrEqualTo(81))
	}

	@Test
	def void retrieveAbbreviatedBranchName() {
		val scraper = new GithubRepositoryPage(driver, "absessive", "CurrencyTracker", new CodeSearchQuery("user"))
		assertThat(scraper.starCount, greaterThanOrEqualTo(1))
		assertThat(scraper.forkCount, greaterThanOrEqualTo(0))

		assertThat(scraper.commitCount, greaterThanOrEqualTo(8))
		assertThat(scraper.branchCount, greaterThanOrEqualTo(3))
		assertThat(scraper.releaseCount, greaterThanOrEqualTo(0))
		assertThat(scraper.contributorCount, greaterThanOrEqualTo(1))

		assertThat(scraper.mainBranchName, is("multi-row-select/save"))

		assertThat(scraper.openPullRequestCount, greaterThanOrEqualTo(0))
		assertThat(scraper.closedIssueCount, greaterThanOrEqualTo(0))
		assertThat(scraper.openIssueCount, greaterThanOrEqualTo(0))
		assertThat(scraper.closedIssueCount, greaterThanOrEqualTo(0))

		assertThat(scraper.searchResultCount, greaterThanOrEqualTo(591))
	}

	@Test
	def void retrieveRepositoryAllInformation() {
		val scraper = new GithubRepositoryPage(driver, "gumfum", "SampleMavenProject", new CodeSearchQuery(""))
		assertThat(scraper.watchCount, equalTo(1))
		assertThat(scraper.starCount, equalTo(0))
		assertThat(scraper.forkCount, equalTo(0))
		
		assertThat(scraper.commitCount, equalTo(4))
		assertThat(scraper.branchCount, equalTo(2))
		assertThat(scraper.releaseCount, equalTo(0))
		assertThat(scraper.contributorCount, equalTo(1))
		
		assertThat(scraper.mainBranchName, is("master"))
		
		assertThat(scraper.openPullRequestCount, equalTo(0))
		assertThat(scraper.closedPullRequestCount, equalTo(1))
		assertThat(scraper.openIssueCount, equalTo(1))
		assertThat(scraper.closedIssueCount, equalTo(2))
	}
}
