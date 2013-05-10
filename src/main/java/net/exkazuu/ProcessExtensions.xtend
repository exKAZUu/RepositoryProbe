package net.exkazuu

class ProcessExtensions {
	def static readInputStreamIgnoringErrors(Process p) {
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
