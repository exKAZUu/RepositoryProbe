package net.exkazuu.probe.github

import com.google.common.base.Strings

class CodeSearchQuery {
	val String keyword
	var path = ""
	var language = ""
	var fileExtension = ""
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

	def setFileExtension(String fileExtension) {
		this.fileExtension = fileExtension
		this
	}

	def setSize(int minSize, int maxSize) {
		this.minSize = minSize
		this.maxSize = maxSize
		this
	}

	def getQueryUrl() {
		"https://github.com" + queryUrlSuffix
	}

	def getQueryUrlSuffix() {
		'''/search?q=«keyword»«pathQuery»«fileExtensionQuery»«sizeQuery»«languageQuery»&type=Code'''.toString
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

	private def getFileExtensionQuery() {
		if (Strings.isNullOrEmpty(fileExtension)) {
			""
		} else {
			'''+extension:«fileExtension»'''
		}
	}
}
