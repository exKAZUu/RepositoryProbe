package net.exkazuu.probe

import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.io.PrintWriter
import net.exkazuu.probe.maven.MavenManager

/**
 * A class for recording the result of "mvn test".
 * 
 * @author Ryohei Takasawa
 */
class SearchTestedRepos {
	def static void main(String[] args) {
		val mm = new MavenManager("C:\\Study")
		val list = mm.getDirList()
		val file = new File("C:\\Study\\testResult.txt")
		val pw = new PrintWriter(new BufferedWriter(new FileWriter(file)))

		for (dir : list) {
			val dirPath = dir.toString
			val dirName = dirPath.substring(dirPath.lastIndexOf('\\') + 1, dirPath.length)

			if (dirName.contains(".txt")) {
			} else {
				val result = mm.test(dirName)
				var testsAreSkipped = false
				var run = 0;
				var failures = 0;
				var errors = 0;
				var skipped = 0;
				for (str : result) {
					if (str.contains("Tests are skipped.")) {
						testsAreSkipped = true
					}
					if (str.contains("Tests run") && str.contains("Time elapsed")) {
						try {
							val line = str.split(' ')
							val r = line.get(2)
							run = run + Integer::valueOf(r.substring(0, r.length - 1))
							val f = line.get(4)
							failures = failures + Integer::valueOf(f.substring(0, f.length - 1))
							val e = line.get(6)
							errors = errors + Integer::valueOf(e.substring(0, e.length - 1))
							val s = line.get(8)
							skipped = skipped + Integer::valueOf(s.substring(0, s.length - 1))
						} catch (Exception e) {
							System::out.println(e)
							System::out.println(str)
						}
					}
				}

				if (testsAreSkipped) {
					System::out.println(dirName)
					System::out.println("Tests are skipped.")
				} else {
					System::out.println(dirName)
					System::out.println(
						"Tests run: " + run + " ,Failures: " + failures + " ,Errors: " + errors + " ,Skipped: " +
							skipped)
				}
			}
		}
		System::out.println(list.length)
	}
}
