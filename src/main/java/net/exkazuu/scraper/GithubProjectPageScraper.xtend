package net.exkazuu.scraper

import net.exkazuu.utils.Idioms
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver

import static extension net.exkazuu.scraper.ScraperUtil.*

class SearchQuery {
	String language
	String keyword

	new(String keyword) {
		this(keyword, null)
	}

	new(String keyword, String language) {
		this.keyword = if (keyword != null) keyword else ""
		this.language = if (language != null) language else ""
	}

	def getKeyword() {
		keyword
	}

	def getLanguage() {
		language
	}
}

class GithubProjectInformation {
	@Property String url
	@Property String mainBranch
	@Property int starCount
	@Property int forkCount
	@Property int commitCount
	@Property int branchCount
	@Property int releaseCount
	@Property int contributorCount
	@Property int openPullRequestCount
	@Property int openIssueCount
	@Property int closedIssueCount
	@Property int searchResultCount
}

/**
 * A class for scraping project information from GitHub pages.
 * Note that this class assume that you don't login GitHub. 
 * 
 * @author Kazunori Sakamoto
 */
class GithubProjectPageScraper {
	var WebDriver driver
	val String topUrl
	val SearchQuery[] queries

	new(WebDriver driver, String url, SearchQuery... queries) {
		this.driver = driver
		this.topUrl = if (url.endsWith("/")) url.substring(0, url.length - 1) else url
		this.queries = queries
		driver.get(this.topUrl)
	}

	new(WebDriver driver, String userName, String projectName, SearchQuery... queries) {
		this(driver, "https://github.com/" + userName + "/" + projectName, queries)
	}

	private def move(String url) {
		if (driver.currentUrl != url) {
			driver.get(url)
		}
	}

	private def moveToTopPage() {
		move(topUrl)
	}

	private def moveToIssuePage() {
		move(topUrl + "/issues")
	}

	private def moveToSearchPage(SearchQuery query) {
		move(topUrl + "/search?ref=cmdform&l=" + query.language + "&q=" + query.keyword)
	}

	private def getSocialCountElements() {
		moveToTopPage()
		driver.findElements(By.className("social-count"))
	}

	private def getIssueAndPullRequestElements() {
		moveToTopPage()
		driver.findElements(By.className("counter"))
	}

	private def getOpenCloseButtonElements() {
		moveToIssuePage()
		driver.findElement(By.className("button-group")).findElements(By.className("minibutton"))
	}

	private def getNumElements() {
		moveToTopPage()
		driver.findElements(By.className("num"))
	}

	def getCounterOfSearchResultElements(SearchQuery query) {
		moveToSearchPage(query)
		driver.findElements(By.className("counter"))
	}

	def getInformation() {
		val info = new GithubProjectInformation()
		info.url = url
		info.mainBranch = mainBranchName
		info.starCount = starCount
		info.forkCount = forkCount
		info.commitCount = commitCount
		info.branchCount = branchCount
		info.releaseCount = releaseCount
		info.contributorCount = contributorCount
		info.openPullRequestCount = openPullRequestCount
		info.openIssueCount = openIssueCount
		info.closedIssueCount = closedIssueCount
		info.searchResultCount = searchResultCount
		info
	}

	def getUrl() {
		topUrl
	}

	def getMainBranchName() {
		moveToTopPage()
		val selected = driver.findElements(By.className("selected"))
		val candidates = selected.filter[it.getAttribute("class") == "select-menu-item js-navigation-item selected"]
		val url = candidates.last.findElement(By.tagName("a")).getAttribute("href")
		url.split('/').drop(6).join('/')
	}

	def getStarCount() {
		socialCountElements.get(0).extractInteger
	}

	def getForkCount() {
		socialCountElements.get(1).extractInteger
	}

	def getCommitCount() {
		numElements.get(0).extractInteger
	}

	def getBranchCount() {
		numElements.get(1).extractInteger
	}

	def getReleaseCount() {
		numElements.get(2).extractInteger
	}

	def getContributorCount() {
		Idioms.retry([|numElements.get(3).extractInteger], 10,
			[ e, i, max |
				if (i == max) {
					throw e
				}
				Thread.sleep(500)
			])
	}

	def getOpenIssueCount() {
		val elems = issueAndPullRequestElements
		if (elems.length > 1) {
			elems.get(0).extractInteger
		} else {
			0
		}
	}

	def getOpenPullRequestCount() {
		val elems = issueAndPullRequestElements
		if (elems.length > 1) {
			elems.get(1).extractInteger
		} else {
			elems.get(0).extractInteger
		}
	}

	def getClosedIssueCount() {
		val elems = issueAndPullRequestElements
		if (elems.length > 1) {
			openCloseButtonElements.get(1).extractInteger
		} else {
			0
		}
	}

	def getSearchResultCount() {
		queries.map [
			val elems = getCounterOfSearchResultElements(it)
			if (elems.length > 2) {
				elems.get(2).extractInteger
			} else {
				0
			}
		].fold(0, [l, r|l + r])
	}
}
