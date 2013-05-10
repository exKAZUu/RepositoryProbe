package net.exkazuu

import java.util.List
import static extension net.exkazuu.ProcessExtensions.*

class GitManager {
	Runtime rt

	new() {
		this.rt = Runtime::getRuntime
	}

	def List<String> clone(String address, String name) {
		val command = "git clone " + address + " C:\\Study\\" + name
		val p = rt.exec(command)
		val result = p.readInputStreamIgnoringErrors()
		System::out.println(name + " cloning...")

		return result
	}
}
