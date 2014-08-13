package net.exkazuu.probe.maven

import com.google.common.collect.Lists
import java.io.File

import static extension net.exkazuu.probe.extensions.XProcess.*

class XMutatorManager {
	val File directory

	new(File directory) {
		this.directory = directory
		directory.mkdirs()
	}

	def execute(String... args) {
		val prefix = "XMutator/XMutator.exe -c "
		val command = prefix + args.join(' ') + ' ' + directory.absolutePath
		val proc = Runtime.runtime.exec(command, null, directory)
		val ret = proc.readAllOutputsAndErrors()
		val vals = ret.get(0).get(0).trim.split(",").map [
			Integer.parseInt(it)
		]
		Lists.newArrayList(vals)
	}
}
