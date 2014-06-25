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
import org.openqa.selenium.chrome.ChromeDriver

class GetRepositoryInformation {
	def static void main(String[] args) {
		val properties = new Properties
		properties.load(new FileInputStream(".properties"))
		val user = properties.getProperty("name")
		val pass = properties.getProperty("pass")

		val driver = new ChromeDriver
		val minSize = 10000
		val maxSize = 10004

		val sonarTags = new HashSet<String>
		sonarTags.add("m_ncloc")
		sonarTags.add("m_lines")
		sonarTags.add("m_statements")
		sonarTags.add("m_files")
		sonarTags.add("m_classes")
		sonarTags.add("m_packages")
		sonarTags.add("m_functions")
		sonarTags.add("m_accessors")
		sonarTags.add("m_public_documented_api_density")
		sonarTags.add("m_public_api")
		sonarTags.add("m_public_undocumented_api")
		sonarTags.add("m_comment_lines_density")
		sonarTags.add("m_comment_lines")
		sonarTags.add("m_duplicated_lines_density")
		sonarTags.add("m_duplicated_lines")
		sonarTags.add("m_duplicated_blocks")
		sonarTags.add("m_duplicated_files")
		sonarTags.add("m_function_complexity")
		sonarTags.add("m_class_complexity")
		sonarTags.add("m_file_complexity")
		sonarTags.add("m_complexity")
		sonarTags.add("m_violations")
		sonarTags.add("m_violations_density")
		sonarTags.add("m_blocker_violations")
		sonarTags.add("m_critical_violations")
		sonarTags.add("m_major_violations")
		sonarTags.add("m_minor_violations")
		sonarTags.add("m_info_violations")
		sonarTags.add("m_package_tangle_index")
		sonarTags.add("m_package_cycles")
		sonarTags.add("m_package_feedback_edges")
		sonarTags.add("m_package_tangles")
		sonarTags.add("m_coverage")
		sonarTags.add("m_line_coverage")
		sonarTags.add("m_branch_coverage")
		sonarTags.add("m_test_success_density")
		sonarTags.add("m_test_failures")
		sonarTags.add("m_test_errors")
		sonarTags.add("m_tests")
		sonarTags.add("m_test_execution_time")

		/* prepare sonar */
		driver.get("http://localhost:9000/sessions/login")

		driver.findElements(By.xpath('//input[@id="login"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@id="password"]')).get(0).sendKeys("admin")
		driver.findElements(By.xpath('//input[@type="submit"]')).get(0).click()

		(minSize .. maxSize).forEach [
			/* preparation */
			val dirPath = "C:\\Study\\Repos" + it
			/* generating addresses */
			val service = new RepositoryService
			service.client.setCredentials(user, pass)
			val url = "https://github.com/search?q=maven+extension%3Axml+path%3Apom.xml+size%3A" + it + ".." + it +
				"&type=Code&ref=searchresults"
			driver.get(url)
			val addressBook = new HashSet<String>
			val elems = driver.findElements(By.xpath('//p[@class="title"]/a[1]'))
			for (elem : elems) {
				val address = "https://github.com/" + elem.text + ".git"
				addressBook.add(address)
			}
			/* clone */
			val gm = new GitManager(dirPath)
			val addressFile = new File(dirPath + "\\address.txt")
			val printWriter1 = new PrintWriter(new BufferedWriter(new FileWriter(addressFile)))
			for (address : addressBook) {
				gm.clone(address)
				printWriter1.println(address)
			}
			printWriter1.close
			Thread.sleep(20 * 1000)
			/* sonar */
			val resultFile = new File(dirPath + "\\result.txt")
			val printWriter2 = new PrintWriter(new BufferedWriter(new FileWriter(resultFile)))
			printWriter2.print("name,")
			for (tag : sonarTags) {
				printWriter2.print(tag + ",")
			}
			printWriter2.println("")
			val mm = new MavenManager(dirPath)
			for (address : addressBook) {
				val name = address.substring(address.lastIndexOf('/') + 1, address.lastIndexOf('.'))
				mm.test(name)
				mm.sonar(name)
				driver.get("http://localhost:9000/")
				val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
				if (repos.size != 0) {
					printWriter2.print(name + ",")
					System.out.println("OK")
					repos.get(0).click
					for (tag : sonarTags) {
						val id = '//span[@id="' + tag + '"]'
						val value = driver.findElements(By.xpath(id))
						if (value.size != 0) {
							printWriter2.print(value.get(0).text)
						}
						printWriter2.print(",")
					}
					printWriter2.println("")
					val deleteURL = driver.currentUrl.replace("dashboard/index", "project/deletion")
					driver.get(deleteURL)
					driver.findElement(By.xpath('//input[@id="delete_resource"]')).click
					driver.switchTo.alert.accept
				} else {
					System.out.println("NG")
				}
			}
			printWriter2.close
		]

		driver.quit
	}
}
