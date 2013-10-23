package net.exkazuu

import java.io.File

import static extension net.exkazuu.ProcessExtensions.*
import java.util.List

class RuntimeManager {
	Runtime runtime
	String rootDirAbsPath

	new(String rootDirAbsPath) {
		this.runtime = Runtime.getRuntime
		this.rootDirAbsPath = rootDirAbsPath

		val rootDirectory = new File(rootDirAbsPath)
		if (!rootDirectory.exists) {
			rootDirectory.mkdir
		}
	}

	def List<String> execute(String command) {
		return runtime.exec(command).readInputStreamIgnoringErrors
	}

	def List<String> execute(String command, String workDirAbsPath) {
		return runtime.exec(command, null, new File(workDirAbsPath)).readInputStreamIgnoringErrors
	}
	
	def String getAbsPath(String relativePath) {
		return rootDirAbsPath + "\\" + relativePath
	}
}
