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
	val int skipCount

	new(File csvFile, int skipCount, File mvnDir) {
		this.csvFile = csvFile
		this.skipCount = skipCount
		this.infos = GithubRepositoryInfo.readList(csvFile)
		this.mvnDir = mvnDir
		mvnDir.mkdirs()
	}

	def run() {
		infos.drop(skipCount).forEach [ info, i |
			try {
				if (info.killedMutantCountWithXMutator >= 0 && info.killedMutantCountWithDEFAULTS == -1) {
					System.out.println((i + skipCount + 1) + ": " + info.url)
					val userDir = new File(mvnDir.path, info.userName)
					val projectDir = new File(userDir.path, info.projectName)
					userDir.mkdirs()
					System.out.print("Clone and checkout ... ")
					new GitManager(projectDir).cloneAndCheckout(info.url, info.mainBranch, info.latestCommitSha)
					System.out.println("done")
					execitePIT(info, projectDir)
					GithubRepositoryInfo.write(csvFile, infos)
				}
			} catch (Exception e) {
				e.printStackTrace
			}
		]
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
					info.killedMutantCountWithDEFAULTS = -2
					info.generatedMutantCountWithDEFAULTS = -2
					info.killedMutantPercentageWithDEFAULTS = -2
					System.out.println()
					return
				}
			}
		}
		System.out.println()
	}

	def static void main(String[] args) {
		if (args.length <= 1) {
			System.out.println("Please specify two argument indicating a csv file and a skip count.")
			System.exit(-1)
		}

		val csvFile = new File(args.get(0))
		val skipCount = Integer.parseInt(args.get(1))
		val executor = new PitExecutor(csvFile, skipCount, new File("repos"))
		executor.run()
	}
}
