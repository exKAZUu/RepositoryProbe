package net.exkazuu

import org.eclipse.egit.github.core.service.RepositoryService
import org.openqa.selenium.chrome.ChromeDriver
import org.openqa.selenium.By
import java.util.ArrayList
import org.openqa.selenium.WebDriver
import org.openqa.selenium.support.ui.WebDriverWait
import org.openqa.selenium.support.ui.ExpectedConditions
import org.openqa.selenium.support.ui.Select
import java.util.HashSet
import com.google.common.io.Files
import java.nio.charset.Charset
import java.io.File
import java.util.Properties
import java.io.FileInputStream
import org.openqa.selenium.support.ui.SystemClock
import java.io.FileWriter
import java.io.BufferedWriter
import java.io.PrintWriter
import java.lang.Runtime

class RepositoryInfo {
	@Property String owner;
	@Property String name;

	new(String user, String name) {
		this.owner = user;
		this.name = name;
	}
}


class NewMain {

	def static nextPage(WebDriver driver) {
		val nextPageButton = driver.findElements(By::className("next_page"));
		if (nextPageButton.size > 0) {
			nextPageButton.get(0).click()
			true
		}
	}

	def static main(String[] args) {
		// For "git clone", "mvn test", and "Thread.sleep(300000)"
		GitManager gm = GitManager.getInstance
		val rt = Runtime::getRuntime
		
		// Load user and pass from property file
		val userAndPass = new Properties
		userAndPass.load(new FileInputStream(".properties"))
		val user = userAndPass.getProperty("name")
		val pass = userAndPass.getProperty("pass")
		
		val driver = new ChromeDriver
		
		// Using Java and existing pom.xml
		val url = "https://github.com/search?l=java&q=pom.xml&ref=cmdform&type=Code"
		driver.get(url)
		
		var hasNext = false
		
		val file = new File("C:\\Study\\output.txt")
		val pw = new PrintWriter(new BufferedWriter(new FileWriter(file)))	

		var repoStrings = new HashSet<String>
		var count = 0;
		val sc = new SystemClock		
		do {
			val service = new RepositoryService
			service.client.setCredentials(user, pass)
			
			val elems = driver.findElements(By::xpath('//p[@class="title"]/a[1]'))
			for(elem : elems) {
				repoStrings += elem.text
			}
			hasNext = nextPage(driver)
			
			new WebDriverWait(driver, 20).until(
				ExpectedConditions::invisibilityOfElementLocated(
					By::className('context-loader')
				)
			)
			
			val tm = sc.laterBy(15000)
			
			while(sc.now < tm) {
				
			}
			count = count + 1;
		} while(count < 100)
		driver.close
	
		for(repoString : repoStrings) {
			val strs = repoString.split("/")
			val author = strs.get(0)
			val name = strs.get(1)
			val addr = "git://github.com/" + author + "/" + name + ".git"
			pw.println(name)
			pw.println(addr)
			System::out.println(name)
			System::out.println(addr)
		}
		
		pw.close			
	}
	

}
