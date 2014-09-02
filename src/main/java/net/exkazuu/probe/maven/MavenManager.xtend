package net.exkazuu.probe.maven

import java.io.File
import java.io.PrintStream

class MavenManager {
	val File directory
	static val isWindows = System.getProperty("os.name").contains("Windows")

	new(File directory) {
		this.directory = directory
		directory.mkdirs()
	}

	def start(String... args) {
		val prefix = if (isWindows) {
				"cmd /c mvn "
			} else {
				"mvn "
			}
		val command = prefix + args.join(' ')

		Runtime.runtime.exec(command, null, directory)
	}
}
