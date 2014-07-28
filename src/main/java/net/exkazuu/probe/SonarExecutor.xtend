package net.exkazuu.probe

import java.io.File
import java.util.Map
import net.exkazuu.probe.git.GitManager
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import net.exkazuu.probe.sonar.SonarManager
import org.openqa.selenium.htmlunit.HtmlUnitDriver

/**
 * A class for measuring metrics by execution SonarQube.
 * 
 * @author Ryohei Takasawa
 */
class SonarExecutor {
	protected val File csvFile
	protected val Map<String, GithubRepositoryInfo> infos
	val File mvnDir

	new(File csvFile, File mvnDir) {
		this.csvFile = csvFile
		this.infos = GithubRepositoryInfo.readMap(csvFile)
		this.mvnDir = mvnDir
		mvnDir.mkdirs()
	}

	def run() {
		infos.forEach [ url, info |
			val userDir = new File(mvnDir.path, info.userName)
			val projectDir = new File(userDir.path, info.projectName)
			userDir.mkdirs()
			new GitManager(projectDir).cloneAndCheckout(url, info.mainBranch, "origin/" + info.mainBranch)
			new SonarManager(new MavenManager(projectDir), new HtmlUnitDriver()).execute(info)
		]
		GithubRepositoryInfo.write(csvFile, infos.values)
	}

	def static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("Please specify one argument indicating a csv file for loading and saving results.")
			System.exit(-1)
		}

		val csvFile = new File(args.get(0))
		val executor = new SonarExecutor(csvFile, new File("repos"))
		executor.run()
	}
}
