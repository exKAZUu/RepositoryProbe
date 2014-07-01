package net.exkazuu.probe.extensions

import org.openqa.selenium.WebElement

import static extension net.exkazuu.probe.extensions.XString.*

class XWebElement {
	def static extractInteger(WebElement e) {
		e.text.parseIntegerRobustly()
	}

	def static extractInteger(WebElement e, int valueWhenFailing) {
		e.text.parseIntegerRobustly(valueWhenFailing)
	}
}
