package net.exkazuu.probe

import java.io.BufferedWriter
import java.io.File
import java.io.FileInputStream
import java.io.FileWriter
import java.io.PrintWriter
import java.util.HashSet
import java.util.Properties
import net.exkazuu.probe.git.GitManager
import net.exkazuu.probe.maven.MavenManager
import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.support.ui.ExpectedConditions
import org.openqa.selenium.support.ui.WebDriverWait

class RepositoryInfo {
	@Property String owner;
	@Property String name;

	new(String user, String name) {
		this.owner = user;
		this.name = name;
	}
}

class SearchReposUsingMaven {

	def static nextPage(WebDriver driver) {
		val nextPageButton = driver.findElements(By::className("next_page"));
		if (nextPageButton.size > 0) {
			nextPageButton.get(0).click()
			true
		}
	}

	def static main(String[] args) {

		// Load user and pass from property file
		val userAndPass = new Properties()
		userAndPass.load(new FileInputStream(".properties"))
		val user = userAndPass.getProperty("name")
		val pass = userAndPass.getProperty("pass")

		val file = new File("C:\\Study\\output.txt")
		val pw = new PrintWriter(new BufferedWriter(new FileWriter(file)))

		var repoStrings = gatherRepositories(user, pass, 1)

		// git clone and maven test
		val gm = new GitManager("C:\\Study")
		val mm = new MavenManager("C:\\Study")

		repoStrings.forEach [
			val strs = it.split("/")
			val author = strs.get(0)
			val name = strs.get(1)
			val addr = "git://github.com/" + author + "/" + name + ".git"
			val listc = gm.clone(addr, name)
			for (str : listc) {
				System::out.println(str)
			}
			val listt = mm.test(name)
			for (str : listt) {
				System::out.println(str)
				if (str.contains("SUCCESSFUL")) {
					pw.println(name)
					pw.println(addr)
				}
			}
		]

		pw.close()
	}

	def static gatherRepositories(String user, String pass, int maxCount) {
		val driver = new ChromeDriver()

		// Using Java and existing pom.xml
		val url = "https://github.com/search?l=java&q=pom.xml&ref=cmdform&type=Code"
		driver.get(url)

		val repoStrings = new HashSet<String>()

		(0 .. maxCount).forEach [
			val service = new RepositoryService
			service.client.setCredentials(user, pass)
			val elems = driver.findElements(By::xpath('//p[@class="title"]/a[1]'))
			for (elem : elems) {
				repoStrings += elem.text
			}
			nextPage(driver)
			new WebDriverWait(driver, 20).until(
				ExpectedConditions::invisibilityOfElementLocated(
					By::className('context-loader')
				)
			)
			Thread::sleep(15 * 1000)
		]
		driver.close
		repoStrings
	}

}
