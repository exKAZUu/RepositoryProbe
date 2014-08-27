package net.exkazuu.probe

import java.io.File
import java.util.List
import net.exkazuu.probe.git.GitManager
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import net.exkazuu.probe.maven.MutantOperator
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
		infos.forEach [ info, i |
			if (info.killedMutantCountWithXMutator >= 0) {
				System.out.println(i + ": " + info.url)
				val userDir = new File(mvnDir.path, info.userName)
				val projectDir = new File(userDir.path, info.projectName)
				userDir.mkdirs()
				System.out.print("Clone and checkout ... ")
				new GitManager(projectDir).cloneAndCheckout(info.url, info.mainBranch, "origin/" + info.mainBranch)
				System.out.println("done")
				execitePIT(info, projectDir)
			}
		]
		GithubRepositoryInfo.write(csvFile, infos)
	}

	def void execitePIT(GithubRepositoryInfo info, File projectDir) {
		System.out.print("Execute PIT ")
		val pit = new PitManager(new MavenManager(projectDir))
		for (operator : MutantOperator.values) {
			val ret = pit.execute(operator)
			if (ret != null) {
				info.set("generatedMutantCountWith" + operator.name, ret.get(0))
				info.set("killedMutantCountWith" + operator.name, ret.get(1))
				info.set("killedMutantPercentageWith" + operator.name, ret.get(2))
				System.out.print(".")
			} else {
				System.out.print("F")
				if (operator == MutantOperator.DEFAULTS) {
					System.out.println()
					return
				}
			}
		}
		System.out.println()
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
