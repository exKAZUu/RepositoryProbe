package net.exkazuu.probe.extensions

import net.exkazuu.probe.common.InputStreamThread

class XProcess {
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
	
	def static readAllOutputsAndErrors(Process p) {
		val ist = new InputStreamThread(p.inputStream)
		val est = new InputStreamThread(p.errorStream)
		ist.start
		est.start
		p.waitFor
		ist.join
		est.join

		return #[ist.stringList, est.stringList]
	}
}
