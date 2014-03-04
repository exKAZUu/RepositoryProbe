package net.exkazuu.utils

class ProcessExtensions {
	def static readAllOutputsIgnoringErrors(Process p) {
		val ist = new InputStreamThread(p.inputStream)
		val est = new InputStreamThread(p.errorStream)
		ist.start
		est.start
		p.waitFor
		ist.join
		est.join

		return ist.getStringList
	}
}
