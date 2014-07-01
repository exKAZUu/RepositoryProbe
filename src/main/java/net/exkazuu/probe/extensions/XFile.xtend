package net.exkazuu.probe.extensions

import java.io.File

class XFile {
	def static getAbsolutePathUsingSlash(File file) {
		file.absolutePath.replace(File.separatorChar, '/')
	}
}
