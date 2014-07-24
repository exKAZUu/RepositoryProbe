package net.exkazuu.probe.github

import net.exkazuu.probe.common.Idioms
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver

import static extension net.exkazuu.probe.extensions.XWebElement.*

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

	private def moveToReleasePage() {
		move(topUrl + "/releases")
	}

	private def moveToSearchPage(CodeSearchQuery query) {
		move(topUrl + query.queryUrlSuffix)
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
		Idioms.retry(
			[ |
				// from Top page
				info.mainBranch = getMainBranchName
				info.watchCount = getWatchCount
				info.starCount = getStarCount
				info.forkCount = getForkCount
				info.commitCount = getCommitCount
				info.branchCount = getBranchCount
				info.releaseCount = getReleaseCount
				info.contributorCount = getContributorCount
				info.openPullRequestCount = getOpenPullRequestCount
				info.openIssueCount = getOpenIssueCount
				info.latestCommitSha = getLatestCommitSha
				// moveToIssuePage
				info.closedIssueCount = getClosedIssueCount
				// moveToReleasePage
				info.latestTag = getLatestTag
				null
			], 30, 1000, null, true, false)
		info.closedPullRequestCount = getClosedPullRequestCount
		info.searchResultCount = getSearchResultCount
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

	def getLatestTag() {
		moveToReleasePage()
		val tags = driver.findElements(By.className("css-truncate-target"))
		if (tags.length > 0) {
			tags.head.text.trim
		} else {
			GithubRepositoryInfo.NONE
		}
	}

	def getLatestCommitSha() {
		moveToTopPage()
		val shaBlock = driver.findElement(By.className("sha-block")).getAttribute("href")
		shaBlock.substring(shaBlock.lastIndexOf('/') + 1)
	}

	def getWatchCount() {
		val elements = getSocialCountElements.toList
		if (elements.size > 2) {
			elements.get(0).extractInteger
		} else {
			-1
		}
	}

	def getStarCount() {
		val elements = getSocialCountElements.toList
		elements.get(elements.size - 2).extractInteger
	}

	def getForkCount() {
		moveToTopPage()
		val elements = getSocialCountElements.toList
		elements.get(elements.size - 1).extractInteger
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

	def getClosedPullRequestCount() {
		val closedPullRequestUrl = topUrl + "/pulls?direction=desc&page=1&sort=created&state=closed"
		move(closedPullRequestUrl)
		val pagenation = driver.findElements(By.className("pagination"))
		val pageCount = if (pagenation.size >= 1) {
				val links = driver.findElements(By.tagName("a"))
				val lastPageLink = links.get(links.size - 17)
				val pageCount = lastPageLink.extractInteger
				lastPageLink.click
				pageCount
			} else {
				1
			}
		val items = driver.findElements(By.className("list-group-item"))
		moveToTopPage()
		(pageCount - 1) * 20 + items.size
	}

	def getSearchResultCount() {
		queries.map [
			val elems = getCounterOfSearchResultElements(it)
			if (elems.length > 0) {
				elems.get(0).extractInteger
			} else {
				0
			}
		].fold(0, [l, r|l + r])
	}
}
