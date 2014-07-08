package net.exkazuu.probe.git

import com.google.common.base.Preconditions
import java.io.File
import java.util.HashSet
import java.util.List

import static extension net.exkazuu.probe.extensions.XProcess.*

class OldGitManager {
	String root

	new(String root) {
		this.root = root

		val file = new File(root)
		if (!file.exists) {
			file.mkdir
		}
	}

	def List<String> clone(String address, String name) {
		System::out.println(name + " cloning...")
		val command = "git clone " + address + " " + root + "/" + name
		System.out.println(command)
		val p = Runtime.runtime.exec(command)
		val result = p.readAllOutputsIgnoringErrors()

		return result
	}

	def List<String> clone(String address) {
		Preconditions.checkArgument(address.endsWith(".git") || address.startsWith("http"))
		val startIndex = address.lastIndexOf('/') + 1
		val endIndex = address.lastIndexOf('.')
		val repoName = address.substring(startIndex, if(startIndex < endIndex) endIndex else address.length)
		val result = clone(address, repoName)

		return result
	}

	def List<String> reset(String path) {
		val command = "git reset"
		val p = Runtime.runtime.exec(command, null, new File(path))
		val result = p.readAllOutputsIgnoringErrors()

		return result
	}

	def String getGitBlameResult(String filePath, String methodName) {
		val dirPath = filePath.substring(0, filePath.lastIndexOf('/'))
		val command = "git blame master " + filePath

		val p = Runtime.runtime.exec(command, null, new File(dirPath))
		val result = p.readAllOutputsIgnoringErrors()

		var lineResult = new String()
		for (str : result) {
			if (str.contains(methodName)) {
				lineResult = str
			}
		}

		return lineResult
	}

	def String getAuthorName(String filePath, String methodName) {
		val dirPath = filePath.substring(0, filePath.lastIndexOf('/'))
		val command = "git blame master " + filePath

		val p = Runtime.runtime.exec(command, null, new File(dirPath))
		val result = p.readAllOutputsIgnoringErrors()

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
		val dirPath = filePath.substring(0, filePath.lastIndexOf('/'))
		val command = "git blame master " + filePath.substring(dirPath.length + 1)

		val p = Runtime.runtime.exec(command, null, new File(dirPath))
		val result = p.readAllOutputsIgnoringErrors()
		val authorNames = new HashSet<String>

		for (line : result) {
			val systemResult = line.substring(line.indexOf('(') + 1, line.indexOf(')'))
			var list = systemResult.split(' ').map[it.trim].filter[!it.nullOrEmpty]
			authorNames += list.take(list.size - 4).join(' ')
		}

		return authorNames
	}
}
