package net.exkazuu

import java.util.List
import static extension net.exkazuu.ProcessExtensions.*

class GitManager {
	Runtime rt
	String root

	new(String root) {
		this.rt = Runtime::getRuntime
		this.root = root
	}

	def List<String> clone(String address, String name) {
		val command = "git clone " + address + " " + root + "\\" + name
		val p = rt.exec(command)
		val result = p.readInputStreamIgnoringErrors()
		System::out.println(name + " cloning...")

		return result
	}
}
