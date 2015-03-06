package net.exkazuu.probe.github

import org.junit.After
import org.junit.Test

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*
import org.openqa.selenium.phantomjs.PhantomJSDriver
import org.openqa.selenium.phantomjs.PhantomJSDriverService
import org.openqa.selenium.remote.DesiredCapabilities
import org.junit.Before
import org.openqa.selenium.OutputType
import java.io.File
import org.openqa.selenium.TakesScreenshot
import org.apache.commons.io.FileUtils

class GithubProjectPageScraperTest {
	var PhantomJSDriver driver

	@Before
	def void before() {
		val caps = new DesiredCapabilities
		caps.setCapability(
			PhantomJSDriverService.PHANTOMJS_EXECUTABLE_PATH_PROPERTY,
			"C:/Program Files/phantomjs-2.0.0-windows/bin/phantomjs.exe"
		)
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
