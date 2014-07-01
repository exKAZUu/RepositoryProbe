package net.exkazuu.probe.github

import com.google.common.base.Strings

class CodeSearchQuery {
	val String keyword
	var path = ""
	var language = ""
	var minSize = -1
	var maxSize = -1

	new(String keyword) {
		this.keyword = keyword
	}

	def setPath(String path) {
		this.path = path
		this
	}

	def setLanguage(String language) {
		this.language = language
		this
	}

	def setSize(int minSize, int maxSize) {
		this.minSize = minSize
		this.maxSize = maxSize
		this
	}

	def getQueryUrl() {
		constructQueryUrl().toString.trim
	}

	private def getLanguageQuery() {
		if (Strings.isNullOrEmpty(language)) {
			""
		} else {
			'''&l=«language»'''
		}
	}

	private def getPathQuery() {
		if (Strings.isNullOrEmpty(path)) {
			""
		} else {
			'''+path:«path»'''
		}
	}

	private def getSizeQuery() {
		if (minSize < 0 || maxSize < 0) {
			""
		} else {
			'''+size:«minSize»..«maxSize»'''
		}
	}

	private def constructQueryUrl() '''
		https://github.com/search?q=«keyword»«pathQuery»«sizeQuery»«languageQuery»&type=Code
	'''
}
