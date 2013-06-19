package net.exkazuu

import java.util.List
import static extension net.exkazuu.ProcessExtensions.*
import java.io.File

class GitManager {
	Runtime rt
	String root

	new(String root) {
		this.rt = Runtime::getRuntime
		this.root = root
	}

	def List<String> clone(String address, String name) {
		System::out.println(name + " cloning...")
		val command = "git clone " + address + " " + root + "\\" + name
		val p = rt.exec(command)
		val result = p.readInputStreamIgnoringErrors()

		return result
	}
	
	def List<String> clone(String address) {
		val repoName = address.substring(address.lastIndexOf('/')+1, address.length)
		val result = clone(address, repoName)
		
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
