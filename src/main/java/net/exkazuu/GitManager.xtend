package net.exkazuu

import java.io.File
import java.util.List

import static extension net.exkazuu.ProcessExtensions.*
import java.util.HashSet
import java.util.ArrayList

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
		val repoName = address.substring(address.lastIndexOf('/') + 1, address.length)
		val result = clone(address, repoName)

		return result
	}

	def String getGitBlameResult(String filePath, String methodName) {
		val dirPath = filePath.substring(0, filePath.lastIndexOf('\\'))
		val command = "git blame master " + filePath

		val p = rt.exec(command, null, new File(dirPath))
		val result = p.readInputStreamIgnoringErrors()

		var lineResult = new String()
		for (str : result) {
			if (str.contains(methodName)) {
				lineResult = str
			}
		}

		return lineResult
	}

	@Deprecated
	def String getAuthorName(String filePath, String methodName) {
		val dirPath = filePath.substring(0, filePath.lastIndexOf('\\'))
		val command = "git blame master " + filePath

		val p = rt.exec(command, null, new File(dirPath))
		val result = p.readInputStreamIgnoringErrors()

		var lineResult = new String()
		for (str : result) {
			if (str.contains(methodName)) {
				lineResult = str
			}
		}

		val systemResult = lineResult.substring(lineResult.indexOf('(') + 1, lineResult.indexOf(')'))
		val split = systemResult.split(' ')
		var size = split.size
		for (str : split) {
			if (str.trim == "") {
				size = size - 1
			}
		}
		var pos = 0
		var authorName = new String()
		while (pos < size - 4) {
			authorName = authorName + split.get(pos) + " "
			pos = pos + 1
		}

		return authorName.trim
	}

	def HashSet<String> getAuthorNames(String filePath) {
		val dirPath = filePath.substring(0, filePath.lastIndexOf('\\'))
		val command = "git blame master " + filePath

		val p = rt.exec(command, null, new File(dirPath))
		val result = p.readInputStreamIgnoringErrors()
		val authorNames = new HashSet<String>

		for (line : result) {
			val systemResult = line.substring(line.indexOf('(') + 1, line.indexOf(')'))
			val split = systemResult.split(' ')
			var list = new ArrayList<String>
			for (str : split) {
				list += str.trim
			}

			list.removeAll("")
			var pos = 0
			var authorName = new String()
			while (pos < list.size - 4) {
				authorName = authorName + split.get(pos) + " "
				pos = pos + 1
			}

			authorNames += authorName.trim
		}

		return authorNames
	}
}
