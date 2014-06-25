package net.exkazuu.probe.common

import java.io.File

class FileExtensions {
	def static getAbsolutePathUsingSlash(File file) {
		file.absolutePath.replace(File.separatorChar, '/')
	}
}
