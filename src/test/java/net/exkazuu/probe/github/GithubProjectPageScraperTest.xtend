package net.exkazuu.probe.github

import java.util.ArrayList
import org.junit.After
import org.junit.Before
import org.junit.Test
import org.openqa.selenium.WebDriver
import org.openqa.selenium.phantomjs.PhantomJSDriver
import org.openqa.selenium.phantomjs.PhantomJSDriverService
import org.openqa.selenium.remote.DesiredCapabilities

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*

class GithubProjectPageScraperTest {
	var WebDriver driver

	@Before
	def void before() {
		val caps = new DesiredCapabilities
		val cliArgsCap = new ArrayList<String>();
		cliArgsCap.add("--web-security=false");
		cliArgsCap.add("--ssl-protocol=any");
		cliArgsCap.add("--ignore-ssl-errors=true");
		caps.setCapability(PhantomJSDriverService.PHANTOMJS_CLI_ARGS, cliArgsCap);
		driver = new PhantomJSDriver(caps)
	}

	@After
	def void after() {
		driver.quit()
	}

	@Test
	def void retrieveRepositoryAllInformation() {
		val scraper = new GithubRepositoryPage(driver, "gumfum", "SampleMavenProject", new CodeSearchQuery("class"))
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
		assertThat(scraper.closedIssueCount, equalTo(1))

		assertThat(scraper.searchResultCount, greaterThanOrEqualTo(2))
	}
}
