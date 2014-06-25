package net.exkazuu.probe.file

import java.io.File
import java.io.FileReader
import java.util.ArrayList
import java.util.List

import static extension com.google.common.io.CharStreams.*
import static extension net.exkazuu.probe.common.FileExtensions.*

class FileManager {
	String root

	new(String root) {
		this.root = root
	}

	def getDirList() {
		return new File(root).listFiles
	}

	def List<String> getSourceCodeAbsolutePath(String absolutePath) {
		val result = new ArrayList<String>
		val file = new File(absolutePath)

		if (file.isFile) {
			if (file.getName.endsWith(".java")) {
				result += file.absolutePathUsingSlash
			}
		} else {
			val files = file.listFiles
			for (f : files) {
				result += getSourceCodeAbsolutePath(f.absolutePathUsingSlash)
			}
		}

		return result
	}

	def List<String> getSourceCodeAbsolutePath(String path, String name) {
		val result = new ArrayList<String>
		val file = new File(path)

		if (file.isFile) {
			if (file.getName.endsWith(".java")) {
				result += file.absolutePathUsingSlash
			}
		} else {
			val files = file.listFiles
			for (f : files) {
				result += getSourceCodeAbsolutePath(f.absolutePathUsingSlash, name)
			}
		}

		return result
	}

	def getSourceCodeLOC(String absolutePath) {
		new FileReader(absolutePath).readLines().size
	}
}
