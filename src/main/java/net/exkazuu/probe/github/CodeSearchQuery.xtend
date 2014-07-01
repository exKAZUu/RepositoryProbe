package net.exkazuu.probe.github

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

	def getQueryUrl(int minSize, int maxSize) {
		constructQueryUrl(minSize, maxSize).toString.trim
	}

	private def constructQueryUrl(int minSize, int maxSize) '''
		https://github.com/search?l=«language»&q=«keyword»+size:«minSize»..«maxSize»&ref=cmdform&type=Code
	'''
}
