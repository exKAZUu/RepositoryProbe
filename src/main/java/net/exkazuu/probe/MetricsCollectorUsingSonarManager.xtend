package net.exkazuu.probe

import java.io.File
import net.exkazuu.probe.git.GitManager
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import org.openqa.selenium.chrome.ChromeDriver
import net.exkazuu.probe.sonar.OldSonarManager

class MetricsCollectorUsingSonarManager {
	def static void main(String[] args) {
		val dataFile = new File("pom.csv")
		val infos = GithubRepositoryInfo.readList(dataFile)
		val driver = new ChromeDriver
		infos.forEach [
			System.out.println(it.url)
			val targetUrl = it.url
			val workDir = targetUrl.replace("https://github.com/", "DirectoryForTest/")
			val gitMan = new GitManager(new File(workDir))
			gitMan.cloneAndCheckout(targetUrl, it.mainBranch, it.mainBranch)
			val mvnMan = new MavenManager(new File(workDir))
			val sonarMan = new OldSonarManager(mvnMan, driver)
			sonarMan.execute(it)
			GithubRepositoryInfo.write(dataFile, infos)
		]
		driver.quit
	}
}
