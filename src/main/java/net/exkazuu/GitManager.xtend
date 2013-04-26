package net.exkazuu

import java.io.File
import java.util.List

class GitManager {
	private Runtime rt
	
	new() {
		this.rt = Runtime::getRuntime
	}
	
	def readAllInputStream(Process p) {
		val ist = new InputStreamThread(p.getInputStream)
		ist.start
		p.waitFor
		ist.join
		ist.getStringList
	}
	
	def List<String> clone(String address, String name) {
		val command = "git clone " + address + " C:\\Study\\" + name
		
		val p = rt.exec(command)
		val result = readAllInputStream(p)		
		System::out.println(name + " cloned!")
		return result
	}
	
	def List<String> test(String name) {
		val command = "cmd /c mvn test"
		val path = "C:\\Study\\" + name
		
		val p = rt.exec(command, null, new File(path))
		val result = readAllInputStream(p)		
		System::out.println(name + " tested!")
		return result
	}
}

