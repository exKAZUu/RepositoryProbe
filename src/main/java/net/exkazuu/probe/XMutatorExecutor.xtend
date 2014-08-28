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
	val int skipCount

	new(File csvFile, File mvnDir, int skipCount) {
		this.csvFile = csvFile
		this.infos = GithubRepositoryInfo.readList(csvFile)
		this.mvnDir = mvnDir
		this.skipCount = skipCount
		mvnDir.mkdirs()
	}

	def run() {
		infos.drop(skipCount).forEach [ info, i |
			try {
				if (info.killedMutantPercentageWithXMutator != -2) {
					System.out.println(i + ": " + info.url)
					val userDir = new File(mvnDir.path, info.userName)
					val projectDir = new File(userDir.path, info.projectName)
					userDir.mkdirs()
					System.out.print("Clone and checkout ... ")
					new GitManager(projectDir).cloneAndCheckout(info.url, info.mainBranch, "origin/" + info.mainBranch)
					System.out.println("done")
					execiteXMutator(info, projectDir)
					GithubRepositoryInfo.write(csvFile, infos)
					return
				}
			} catch (Exception e) {
				e.printStackTrace
			}
		]
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
			info.killedMutantCountWithXMutator = -2
			info.generatedMutantCountWithXMutator = -2
			info.killedMutantPercentageWithXMutator = -2
			System.out.println("failed")
		}
		System.out.println(ret.value.join("\n"))
	}

	def static void main(String[] args) {
		if (args.length <= 1) {
			System.out.println("Please specify two argument indicating a csv file and a skip count.")
			System.exit(-1)
		}

		val csvFile = new File(args.get(0))
		val skipCount = Integer.parseInt(args.get(1))
		val executor = new XMutatorExecutor(csvFile, new File("repos"), skipCount)
		executor.run()
	}
}
