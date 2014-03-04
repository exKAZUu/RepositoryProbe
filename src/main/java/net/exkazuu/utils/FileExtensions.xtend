package net.exkazuu.utils

import java.io.File

class FileExtensions {
	def static getAbsolutePathUsingSlash(File file) {
		file.absolutePath.replace(File.separatorChar, '/')
	}
}
