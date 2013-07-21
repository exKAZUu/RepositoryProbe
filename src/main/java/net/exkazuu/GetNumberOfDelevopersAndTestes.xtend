package net.exkazuu

import java.util.HashSet
import java.io.File
import java.io.FileWriter
import java.io.PrintWriter

class GetNumberOfDelevopersAndTestes {
	def static void main(String[] args) {
		val gm = new GitManager("C:\\Study")
		val fm = new FileManager("C:\\Study")
		val outputFile = new File("C:\\Study\\number.txt")
		val pw = new PrintWriter(new FileWriter(outputFile))

<<<<<<< HEAD
=======
		val developerNames = new HashSet<String>
		val testerNames = new HashSet<String>

>>>>>>> eadeb4c6e82e004821a2a58f64c1a47eda549aed
		for (dir : fm.dirList) {
			val repoPath = dir.toString
			if (repoPath.endsWith(".txt")) {
			} else {
				gm.reset(repoPath)
				val fileList = fm.getSourceCodeAbsolutePath(repoPath)
<<<<<<< HEAD
				val developerNames = new HashSet<String>
				val testerNames = new HashSet<String>
=======
>>>>>>> eadeb4c6e82e004821a2a58f64c1a47eda549aed
				for (file : fileList) {
					val names = gm.getAuthorNames(file)
					developerNames += names
					if (file.toString.contains("\\test\\")) {
						testerNames += names
					}
				}
				val repoName = repoPath.substring(repoPath.lastIndexOf('\\') + 1, repoPath.length)
				System::out.println(repoName + "," + developerNames.size + "," + testerNames.size)
				pw.println(repoName + "," + developerNames.size + "," + testerNames.size)
				pw.flush
			}
		}
		pw.close
	}
}
