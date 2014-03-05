package net.exkazuu.scraper

import java.util.regex.Pattern
import net.exkazuu.utils.Idioms
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement
import org.openqa.selenium.htmlunit.HtmlUnitDriver

class GithubProjectInformation {
	@Property String url
	@Property String mainBranch
	@Property int starCount
	@Property int forkCount
	@Property int commitCount
	@Property int branchCount
	@Property int releaseCount
	@Property int contributorCount
	@Property int openIssueCount
	@Property int closedIssueCount
	@Property int openPullRequestCount
}

/**
 * A class for scraping project information from GitHub pages.
 * Note that this class assume that you don't login GitHub. 
 * 
 * @author Kazunori Sakamoto
 */
class GithubProjectPageScraper {
	val static integerPattern = Pattern.compile("[^\\d]*(\\d+).*");
	var WebDriver driver
	val String topUrl

	new(String userName, String projectName) {
		this(new HtmlUnitDriver(true), "https://github.com/" + userName + "/" + projectName)
	}

	new(String url) {
		this(new HtmlUnitDriver(true), url)
	}

	new(WebDriver driver, String userName, String projectName) {
		this(driver, "https://github.com/" + userName + "/" + projectName)
	}

	new(WebDriver driver, String url) {
		this.driver = driver
		this.topUrl = if(url.endsWith("/")) url.substring(0, url.length - 1) else url
		driver.get(this.topUrl)
	}

	private def moveTopPage() {
		if (driver.currentUrl != topUrl) {
			driver.get(topUrl)
		}
	}

	private def moveIssuePage() {
		val issueUrl = topUrl + "/issues"
		if (driver.currentUrl != issueUrl) {
			driver.get(issueUrl)
		}
	}

	private def extractInteger(WebElement e) {
		val text = e.text.replace(",", "")
		val match = integerPattern.matcher(text)
		if (match.find()) {
			Integer.parseInt(match.group(1))
		} else {
			throw new Exception("Failed to extract an integer from \"" + text + "\".")
		}
	}

	private def getSocialCountElements() {
		moveTopPage()
		driver.findElements(By.className("social-count"))
	}

	private def getIssueAndPullRequestElements() {
		moveTopPage()
		driver.findElements(By.className("counter"))
	}

	private def getOpenCloseButtonElements() {
		moveIssuePage()
		driver.findElement(By.className("button-group")).findElements(By.className("minibutton"))
	}

	private def getNumElements() {
		moveTopPage()
		driver.findElements(By.className("num"))
	}

	def getInformation() {
		val info = new GithubProjectInformation()
		info.url = topUrl
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
		info
	}

	def getMainBranchName() {
		moveTopPage()
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
}
