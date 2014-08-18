package net.exkazuu.probe

import java.io.File
import java.util.List
import net.exkazuu.probe.git.GitManager
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.XMutatorManager

/**
 * A class for measuring mutation scores by executing XMutator.
 * 
 * @author Kazunori Sakamoto
 */
class XMutatorExecutor {
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
		infos.take(20).forEach [ info, i |
			System.out.println(i + ": " + info.url)
			val userDir = new File(mvnDir.path, info.userName)
			val projectDir = new File(userDir.path, info.projectName)
			userDir.mkdirs()
			System.out.print("Clone and checkout ... ")
			new GitManager(projectDir).cloneAndCheckout(info.url, info.mainBranch, "origin/" + info.mainBranch)
			System.out.println("done")
			execiteXMutator(info, projectDir)
		]
		GithubRepositoryInfo.write(csvFile, infos)
	}

	def void execiteXMutator(GithubRepositoryInfo info, File projectDir) {
		System.out.print("Execute XMutator ... ")
		val xm = new XMutatorManager(projectDir)
		val ret = xm.execute()
		val vals = ret.key
		if (vals != null && vals.size >= 3) {
			info.killedMutantCountWithXMutator = vals.get(0)
			info.generatedMutantCountWithXMutator = vals.get(1)
			info.killedMutantPercentageWithXMutator = vals.get(2)
			System.out.println("successful " + vals)
		} else {
			System.out.println("failed")
			System.out.println(ret.value.take(1).join)
		}
	}

	def static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("Please specify one argument indicating a csv file for loading and saving results.")
			System.exit(-1)
		}

		val csvFile = new File(args.get(0))
		val executor = new XMutatorExecutor(csvFile, new File("repos"))
		executor.run()
	}
}
