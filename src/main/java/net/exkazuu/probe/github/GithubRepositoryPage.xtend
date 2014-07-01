package net.exkazuu.probe.github

import net.exkazuu.probe.common.Idioms
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver

import static extension net.exkazuu.probe.common.WebElementExtensions.*
import org.openqa.selenium.JavascriptExecutor

/**
 * A class for scraping project information from GitHub pages.
 * Note that this class assume that you don't login GitHub. 
 * 
 * @author Kazunori Sakamoto
 */
class GithubRepositoryPage {
	var WebDriver driver
	val String topUrl
	val CodeSearchQuery[] queries

	new(WebDriver driver, String url, CodeSearchQuery... queries) {
		this.driver = driver
		this.topUrl = if(url.endsWith("/")) url.substring(0, url.length - 1) else url
		this.queries = queries
		driver.get(this.topUrl)
	}

	new(WebDriver driver, String userName, String projectName, CodeSearchQuery... queries) {
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

	private def moveToSearchPage(CodeSearchQuery query) {
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

	def getCounterOfSearchResultElements(CodeSearchQuery query) {
		moveToSearchPage(query)
		driver.findElements(By.className("counter"))
	}

	def getInformation() {
		val info = new GithubRepositoryInfo()
		info.url = getUrl
		info.mainBranch = getMainBranchName
		info.starCount = getStarCount
		info.forkCount = getForkCount
		info.commitCount = getCommitCount
		info.branchCount = getBranchCount
		info.releaseCount = getReleaseCount
		info.contributorCount = getContributorCount
		info.openPullRequestCount = getOpenPullRequestCount
		info.openIssueCount = getOpenIssueCount
		info.closedIssueCount = getClosedIssueCount
		info.searchResultCount = getSearchResultCount
		info.latestCommitSha = getLatestCommitSha
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

	def getLatestCommitSha() {
		moveToTopPage()
		val shaBlock = driver.findElement(By.className("sha-block")).getAttribute("href")
		shaBlock.substring(shaBlock.lastIndexOf('/') + 1)
	}

	def getStarCount() {
		getSocialCountElements.get(0).extractInteger
	}

	def getForkCount() {
		getSocialCountElements.get(1).extractInteger
	}

	def getCommitCount() {
		getNumElements.get(0).extractInteger
	}

	def getBranchCount() {
		getNumElements.get(1).extractInteger
	}

	def getReleaseCount() {
		getNumElements.get(2).extractInteger
	}

	def getContributorCount() {
		val src = driver.pageSource
		val element = driver.findElement(By.tagName("html"))
		val d = driver as JavascriptExecutor
		val contents = d.executeScript("return arguments[0].innerHTML;", element) as String;
		Idioms.retry([|getNumElements.get(3).extractInteger], 10,
			[ e, i, max |
				if (i == max) {
					throw e
				}
				Thread.sleep(500)
			])
	}

	def getOpenIssueCount() {
		val elems = getIssueAndPullRequestElements
		if (elems.length > 1) {
			elems.get(0).extractInteger
		} else {
			0
		}
	}

	def getOpenPullRequestCount() {
		val elems = getIssueAndPullRequestElements
		if (elems.length > 1) {
			elems.get(1).extractInteger
		} else {
			elems.get(0).extractInteger
		}
	}

	def getClosedIssueCount() {
		val elems = getIssueAndPullRequestElements
		if (elems.length > 1) {
			getOpenCloseButtonElements.get(1).extractInteger
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
