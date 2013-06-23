package net.exkazuu

import java.io.BufferedReader
import java.io.BufferedWriter
import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.io.PrintWriter
import java.util.HashSet

class GetNumberOfTesters {
	def static void main(String[] args) {
		val gm = new GitManager("C:\\Study")
		val mm = new MvnManager("C:\\Study")
		val inputFile = new File("C:\\Study\\testedRepos.txt")
		val br = new BufferedReader(new FileReader(inputFile))

		val outputFile = new File("C:\\Study\\numberOfTester.txt")
		val pw = new PrintWriter(new BufferedWriter(new FileWriter(outputFile)))

		var repoName = br.readLine()
		while (repoName != null) {
			val dir = "C:\\Study\\" + repoName
			val list = mm.getTestMethodRelativePath(dir, repoName)
			val names = new HashSet<String>()
			var notCommittedYet = false

			for (str : list) {
				val filePath = dir + "\\" + str.substring(0, str.lastIndexOf('\\'))
				val methodName = str.substring(str.lastIndexOf('\\') + 1, str.length - 1)

				val authorName = gm.getAuthorName(filePath, methodName)
				if (authorName == "Not Committed Yet ") {
					notCommittedYet = true;
				}
				names += authorName
			}

			val result = repoName + "," + names.size + "," + notCommittedYet.toString
			pw.println(result)
			repoName = br.readLine()
		}
		pw.close
	}
}
