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
	
	def String getAuthorName(String path) {
		val relativePath = path.substring(0, path.lastIndexOf('\\'))
		val methodName = path.substring(path.lastIndexOf('\\')+1, path.length)
		
		val command = "git blame " + relativePath
		val p = rt.exec(command)
		val result = p.readInputStreamIgnoringErrors
		
		for(str : result) {
			System::out.println(str)
		}
		
		return "Ryohei Takasawa"
	}
	
}
