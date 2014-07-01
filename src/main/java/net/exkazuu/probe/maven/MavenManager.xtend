package net.exkazuu.probe.maven

import java.io.BufferedReader
import java.io.File
import java.io.FileReader
import java.util.ArrayList
import java.util.List

import static extension net.exkazuu.probe.extensions.XFile.*
import static extension net.exkazuu.probe.extensions.XProcess.*

class MavenManager {
	String root

	new(String root) {
		this.root = root
	}

	def getMavenCommand(String... args) {
		val prefix = if (System.getProperty("os.name").contains("Windows")) {
				"cmd /c mvn "
			} else {
				"mvn "
			}
		prefix + args.join(' ')
	}

	def List<String> test(String name) {
		val command = getMavenCommand("test")
		val path = root + "/" + name
		System::out.println(name + " testing...")
		val p = Runtime.runtime.exec(command, null, new File(path))
		val result = p.readAllOutputsIgnoringErrors()

		return result
	}

	def delete(String name) {
		val path = root + "/" + name
		val dir = new File(path)
		System::out.println(name + " deleting...")
		clean(dir)

		return !dir.exists
	}

	def void clean(File file) {
		if (file.isFile) {
			file.delete
		} else if (file.isDirectory) {
			val files = file.listFiles
			for (f : files) {
				clean(f)
			}
			file.delete
		}
	}

	def List<String> searchTestMethod(File file) {
		val result = new ArrayList<String>

		if (file.isFile) {
			val fr = new FileReader(file)
			val br = new BufferedReader(fr)

			var str = br.readLine
			while (str != null) {
				if (str.contains("@Test")) {
					str = br.readLine
					val strs = str.split(" ")

					for (s : strs) {
						if (s.contains("()")) {
							val methodName = s.substring(0, s.length - 2)
							result += file.absolutePathUsingSlash + "/" + methodName
						}
					}
				}

				str = br.readLine
			}
		} else {
			val files = file.listFiles
			for (f : files) {
				result += searchTestMethod(f)
			}
		}

		return result
	}

	def List<String> getTestMethodRelativePath(String path, String name) {
		val result = new ArrayList<String>
		val file = new File(path)

		if (file.isFile) {
			val fr = new FileReader(file)
			val br = new BufferedReader(fr)

			var str = br.readLine
			while (str != null) {
				if (str.contains("@Test")) {
					str = br.readLine
					val strs = str.split(" ")

					for (s : strs) {
						if (s.contains("()")) {
							val methodName = s.substring(0, s.length - 2)
							val absolutePath = file.absolutePathUsingSlash + "/" + methodName
							val absoluteHomePath = new File(root + "/" + name).absolutePathUsingSlash
							result += absolutePath.substring(absoluteHomePath.length + 1, absolutePath.length)
						}
					}
				}
				str = br.readLine
			}
		} else {
			val files = file.listFiles
			for (f : files) {
				result += getTestMethodRelativePath(f.absolutePathUsingSlash, name)
			}
		}

		return result
	}

	def getDirList() {
		val file = new File(root)
		return file.listFiles
	}

	def List<String> sonar(String name) {
		val command = getMavenCommand("sonar:sonar")
		val path = root + "/" + name
		System::out.println(name + " sonaring...")
		val p = Runtime.runtime.exec(command, null, new File(path))
		val result = p.readAllOutputsIgnoringErrors()

		return result
	}

	def List<String> pit(String name) {
		val command = getMavenCommand("org.pitest:pitest-maven:mutationCoverage")
		val path = root + "/" + name
		System::out.println(name + " mutating...")
		val p = Runtime.runtime.exec(command, null, new File(path))
		val result = p.readAllOutputsIgnoringErrors()

		return result
	}
}
