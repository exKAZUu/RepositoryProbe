package net.exkazuu

import java.util.HashSet

class GetNumberOfDelevopersAndTestes {
	def static void main(String[] args) {
		val gm = new GitManager("C:\\Study")
		val mm = new MvnManager("C:\\Study")
		val fm = new FileManager("C:\\Study")

		val developerNames = new HashSet<String>
		val testerNames = new HashSet<String>

		for (dir : fm.dirList) {
			val repoName = dir.toString
			if (repoName.endsWith(".txt")) {
			} else {
				//TODO
			}
		}
	}
}
