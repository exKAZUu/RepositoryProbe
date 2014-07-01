package net.exkazuu.probe.github

class RepositorySearchQuery {
	String language

	new(String language) {
		this.language = if(language != null) language else "Java"
	}

	def getLanguage() {
		language
	}

	def getQueryUrl() {
		'''https://github.com/search?l=«language»&o=desc&q=stars%3A%3E1&ref=searchresults&s=stars&type=Repositories'''.
			toString
	}
}
