package net.exkazuu.scraper

import java.util.regex.Pattern
import org.openqa.selenium.WebElement

class ScraperUtil {
	val static integerPattern = Pattern.compile("[^\\d]*(\\d+).*");

	def static extractInteger(WebElement e) {
		val text = e.text.replace(",", "")
		val match = integerPattern.matcher(text)
		if (match.find()) {
			Integer.parseInt(match.group(1))
		} else {
			throw new Exception("Failed to extract an integer from \"" + text + "\".")
		}
	}

	def static extractInteger(WebElement e, int valueWhenFailing) {
		val text = e.text.replace(",", "")
		val match = integerPattern.matcher(text)
		if (match.find()) {
			Integer.parseInt(match.group(1))
		} else {
			valueWhenFailing
		}
	}
}
