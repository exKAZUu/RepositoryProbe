package net.exkazuu.probe.extensions

import java.util.regex.Pattern

class XString {
	val static integerPattern = Pattern.compile("[^\\d]*(\\d+).*");

	def static parseIntegerRobustly(String text) {
		if (text != null) {
			val cleanedText = text.replace(",", "")
			val match = integerPattern.matcher(cleanedText)
			if (match.find()) {
				return Integer.parseInt(match.group(1))
			}
		}
		throw new Exception("Failed to extract an integer from \"" + text + "\".")
	}

	def static parseIntegerRobustly(String text, int valueWhenFailing) {
		if (text != null) {
			val cleanedText = text.replace(",", "")
			val match = integerPattern.matcher(cleanedText)
			if (match.find()) {
				return Integer.parseInt(match.group(1))
			}
		}
		valueWhenFailing
	}
}
