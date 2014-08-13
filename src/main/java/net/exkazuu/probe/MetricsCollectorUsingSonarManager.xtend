package net.exkazuu.probe

import java.io.File
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import net.exkazuu.probe.sonar.SonarManager
import org.openqa.selenium.chrome.ChromeDriver
import net.exkazuu.probe.git.GitManager

class MetricsCollectorUsingSonarManager {
	def static void main(String[] args) {
		val driver = new ChromeDriver
		val targetUrl = "https://github.com/EnterpriseQualityCoding/FizzBuzzEnterpriseEdition"
		val gitMan = new GitManager(new File("DirectoryForTest/EnterpriseQualityCoding/FizzBuzzEnterpriseEdition/"))

		gitMan.cloneAndCheckout(targetUrl, "master", "master")

		val infos = GithubRepositoryInfo.readMap(new File("pom.csv"))
		val info = infos.get(targetUrl)

		val mvnMan = new MavenManager(new File("DirectoryForTest/EnterpriseQualityCoding/FizzBuzzEnterpriseEdition/"))
		val sonarManager = new SonarManager(mvnMan, driver)
		val updatedInfo = sonarManager.execute(info)

		System.out.println("Star                : " + updatedInfo.starCount)
		System.out.println("Fork                : " + updatedInfo.forkCount)
		System.out.println("Lines of Code       : " + updatedInfo.loc)
		System.out.println("Files               : " + updatedInfo.files)
		System.out.println("Issues              : " + updatedInfo.violations)
		System.out.println("Unit Tests Coverage : " + updatedInfo.coverage)
		System.out.println("Unit Test Success   : " + updatedInfo.testSuccessDensity)

		driver.quit
	}

}
