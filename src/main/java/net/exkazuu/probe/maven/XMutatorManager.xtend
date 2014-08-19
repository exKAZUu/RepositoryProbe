package net.exkazuu.probe.maven

import com.google.common.base.Strings
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
		val prefix = "XMutator/XMutator.exe -l 1000 -c "
		val command = prefix + args.join(' ') + " \"" + directory.absolutePath + '"'
		val proc = Runtime.runtime.exec(command)
		val ret = proc.readAllOutputsAndErrors()
		val vals = ret.get(0).join.trim.split(",").filter [
			!Strings.isNullOrEmpty(it)
			try {
				Integer.parseInt(it)
				true
			} catch (Exception e) {
				false
			}
		].map [
			Integer.parseInt(it)
		]
		Lists.newArrayList(vals) -> ret.get(1)
	}
}
