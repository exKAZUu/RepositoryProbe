package net.exkazuu.probe.maven

import java.io.File

import static extension net.exkazuu.probe.extensions.XProcess.*

class MavenManager {
	val File directory
	static val isWindows = System.getProperty("os.name").contains("Windows")

	new(File directory) {
		this.directory = directory
		directory.mkdirs()
	}

	def execute(String... args) {
		val prefix = if (isWindows) {
				"cmd /c mvn "
			} else {
				"mvn "
			}
		val command = prefix + args.join(' ')
		val result = Runtime.runtime.exec(command, null, directory).readAllOutputsIgnoringErrors
		
		result
	}
}
