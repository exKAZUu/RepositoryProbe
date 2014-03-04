package net.exkazuu.scraper

import java.util.regex.Pattern
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement

/**
 * A class for scraping project information from GitHub pages.
 * Note that this class assume that you don't login GitHub. 
 * 
 * @author Kazunori Sakamoto
 */
class GithubProjectPageScraper {
	val static integerPattern = Pattern.compile("[^\\d]*(\\d+).*");
	val WebDriver driver
	val String topUrl

	new(WebDriver driver, String userName, String projectName) {
		this(driver, "https://github.com/" + userName + "/" + projectName)
	}

	new(WebDriver driver, String url) {
		this.driver = driver
		this.topUrl = if (url.endsWith("/")) url.substring(url.length - 1) else url
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
			-1
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

	def getMainBranchName() {
		moveTopPage()
		driver.findElements(By.className("js-select-button")).last.text
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
		numElements.get(3).extractInteger
	}

	def getOpenIssueCount() {
		issueAndPullRequestElements.get(0).extractInteger
	}

	def getOpenPullRequestCount() {
		issueAndPullRequestElements.get(1).extractInteger
	}

	def getClosedIssueCount() {
		openCloseButtonElements.get(1).extractInteger
	}
}
