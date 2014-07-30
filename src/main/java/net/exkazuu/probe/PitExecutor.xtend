package net.exkazuu.probe

import java.io.File
import java.util.List
import net.exkazuu.probe.git.GitManager
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import net.exkazuu.probe.maven.PitManager

/**
 * A class for measuring mutation scores by executing PIT.
 * 
 * @author Kazunori Sakamoto
 */
class PitExecutor {
	protected val File csvFile
	protected val List<GithubRepositoryInfo> infos
	val File mvnDir

	new(File csvFile, File mvnDir) {
		this.csvFile = csvFile
		this.infos = GithubRepositoryInfo.readList(csvFile)
		this.mvnDir = mvnDir
		mvnDir.mkdirs()
	}

	def run() {
		infos.sortInplaceBy[it.starCount].reverse.take(20).forEach [ info, i |
			System.out.println(i + ": " + info.url)
			val userDir = new File(mvnDir.path, info.userName)
			val projectDir = new File(userDir.path, info.projectName)
			userDir.mkdirs()
			System.out.print("Clone and checkout ... ")
			new GitManager(projectDir).cloneAndCheckout(info.url, info.mainBranch, "origin/" + info.mainBranch)
			System.out.println("done")
			System.out.print("Execute PIT ... ")
			val ret = new PitManager(new MavenManager(projectDir)).execute
			if (ret != null) {
				System.out.println("successful")
				info.generatedMutantCount = ret.get(0)
				info.killedMutantCount = ret.get(1)
				info.killedMutantPercentage = ret.get(2)
			} else {
				System.out.println("failed")
			}
		]
		GithubRepositoryInfo.write(csvFile, infos)
	}

	def static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("Please specify one argument indicating a csv file for loading and saving results.")
			System.exit(-1)
		}

		val csvFile = new File(args.get(0))
		val executor = new PitExecutor(csvFile, new File("repos"))
		executor.run()
	}
}
