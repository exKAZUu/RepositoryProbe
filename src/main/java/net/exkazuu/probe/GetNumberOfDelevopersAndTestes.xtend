package net.exkazuu.probe

import java.io.File
import java.io.FileWriter
import java.io.PrintWriter
import java.util.HashSet
import net.exkazuu.probe.file.FileManager
import net.exkazuu.probe.git.GitManager

/**
 * A class for counting the number of developers and testers.
 * Counting the unique number of the name appeared in commit logs.
 * "Testers" is defined as the names appeared in the test code.
 * 
 * @author Ryohei Takasawa
 */


class GetNumberOfDelevopersAndTestes {
	def static void main(String[] args) {
		val gm = new GitManager("C:\\Study")
		val fm = new FileManager("C:\\Study")
		val outputFile = new File("C:\\Study\\number.txt")
		val pw = new PrintWriter(new FileWriter(outputFile))

		for (dir : fm.dirList) {
			val repoPath = dir.toString
			if (repoPath.endsWith(".txt")) {
			} else {
				gm.reset(repoPath)
				val fileList = fm.getSourceCodeAbsolutePath(repoPath)
				val developerNames = new HashSet<String>
				val testerNames = new HashSet<String>
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
