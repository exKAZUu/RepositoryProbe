package net.exkazuu.probe

import java.io.File
import java.util.List
import net.exkazuu.probe.git.GitManager
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import net.exkazuu.probe.sonar.SonarManager
import org.openqa.selenium.phantomjs.PhantomJSDriver
import org.openqa.selenium.phantomjs.PhantomJSDriverService
import org.openqa.selenium.remote.DesiredCapabilities

/**
 * A class for measuring metrics by execution SonarQube.
 * 
 * @author Ryohei Takasawa
 */
class SonarExecutor2 {
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
		val caps = new DesiredCapabilities
		caps.setCapability(
			PhantomJSDriverService.PHANTOMJS_EXECUTABLE_PATH_PROPERTY,
			"C:/Program Files/phantomjs-1.9.7-windows/phantomjs.exe"
		)

		val driver = new PhantomJSDriver(caps)
		val sonar = new SonarManager(driver)
		infos.drop(skipCount).forEach [ info, i |
			try {
				if (info.killedMutantCountWithXMutator >= 0 && info.loc == -1) {
					System.out.println((i + skipCount + 1) + ": " + info.url)
					val userDir = new File(mvnDir.path, info.userName)
					val projectDir = new File(userDir.path, info.projectName)
					userDir.mkdirs()
					System.out.print("Clone repository ... ")
					new GitManager(projectDir).cloneAndCheckout(info.url, info.mainBranch, info.latestCommitSha)
					System.out.println("done")
					System.out.print("Execute sonar ... ")
					sonar.execute(new MavenManager(projectDir), info)
					System.out.println("done")
					GithubRepositoryInfo.write(csvFile, infos)
				}
			} catch (Exception e) {
			}
		]
		driver.close
	}

	def static void main(String[] args) {
		if (args.length <= 1) {
			System.out.println("Please specify two argument indicating a csv file and a skip count.")
			System.exit(-1)
		}

		val csvFile = new File(args.get(0))
		val skipCount = Integer.parseInt(args.get(1))
		val executor = new SonarExecutor2(csvFile, skipCount, new File("repos"))
		executor.run()
	}
}
