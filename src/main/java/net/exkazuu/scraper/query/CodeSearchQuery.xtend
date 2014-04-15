package net.exkazuu.scraper.query

class CodeSearchQuery {
	String language
	String keyword

	new(String keyword) {
		this(keyword, null)
	}

	new(String keyword, String language) {
		this.keyword = if(keyword != null) keyword else ""
		this.language = if(language != null) language else ""
	}

	def getKeyword() {
		keyword
	}

	def getLanguage() {
		language
	}
}
