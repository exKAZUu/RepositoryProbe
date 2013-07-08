package net.exkazuu

import java.io.File
import java.util.List
import java.util.ArrayList
import java.io.FileReader
import java.io.LineNumberReader

class FileManager {
	String root

	new(String root) {
		this.root = root
	}

	def getDirList() {
		return new File(root).listFiles
	}

	def List<String> getSourceCodeAbsolutePath(String path, String name) {
		val result = new ArrayList<String>
		val file = new File(path)

		if (file.isFile) {
			if (file.getName.endsWith(".java")) {
				result += file.getAbsolutePath
			}
		} else {
			val files = file.listFiles
			for (f : files) {
				result += getSourceCodeAbsolutePath(f.getAbsolutePath, name)
			}
		}

		return result
	}

	def int getSourceCodeLOC(String absolutePath) {
		val reader = new LineNumberReader(new FileReader(absolutePath))

		while (null != reader.readLine) {
		}

		val result = reader.getLineNumber
		reader.close

		return result
	}
}
