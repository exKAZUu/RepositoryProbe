package net.exkazuu.probe

import java.io.File
import net.exkazuu.probe.git.GitManager
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import net.exkazuu.probe.sonar.SonarManager
import org.openqa.selenium.chrome.ChromeDriver

class MetricsCollectorUsingSonarManager {
	def static void main(String[] args) {
		val dataFile = new File("pom.csv")
		val infos = GithubRepositoryInfo.readList(dataFile)
		val driver = new ChromeDriver
		val sonarMan = new SonarManager(driver, new File("SonarQube"))
		infos.forEach [
			System.out.println(it.url)
			val targetUrl = it.url
			val workDir = targetUrl.replace("https://github.com/", "DirectoryForTest/")
			val gitMan = new GitManager(new File(workDir))
			gitMan.cloneAndCheckout(targetUrl, it.mainBranch, it.mainBranch)
			val mvnMan = new MavenManager(new File(workDir))
			sonarMan.execute(mvnMan, it)
			GithubRepositoryInfo.write(dataFile, infos)
		]
		driver.quit
	}
}
