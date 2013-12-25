package net.exkazuu

import java.util.Properties
import java.io.FileInputStream
import org.openqa.selenium.chrome.ChromeDriver
import java.sql.Timestamp
import org.eclipse.egit.github.core.service.RepositoryService
import java.util.HashSet
import org.openqa.selenium.By
import java.io.File
import java.io.FileWriter
import java.io.PrintWriter
import java.io.BufferedWriter

class GetRepositoryInformation {
	def static void main(String[] args) {
		val properties = new Properties
		properties.load(new FileInputStream(".properties"))
		val user = properties.getProperty("user")
		val pass = properties.getProperty("pass")

		val driver = new ChromeDriver
		val minSize = 8798
		val maxSize = 8800
		
		val sonarTags = new HashSet<String>()
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

		(minSize .. maxSize).forEach [
			val dirPath = "C:\\Study\\Repos" + it
			
			/* correct address */
			val service = new RepositoryService
			service.client.setCredentials(user, pass)
			val url = "https://github.com/search?q=maven+extension%3Axml+path%3A%2Fpom.xml+size%3A" + it + ".." + it +
				"&type=Code&ref=searchresults"
			driver.get(url)
			val addressBook = new HashSet<String>
			val elems = driver.findElements(By.xpath('//p[@class="title"]/a[1]'))
			for (elem : elems) {
				val address = "https://github.com/" + elem.text + ".git"
				addressBook.add(address)
			}
			
			/* clone repositories */
			val gm = new GitManager(dirPath)
			addressBook.forEach [
				/* clone */
				gm.clone(it)
			]
			
			/* output addresses */
			val addressFile = new File(dirPath + "\\address.txt")
			val printWriter = new PrintWriter(new BufferedWriter(new FileWriter(addressFile)))
			addressBook.forEach [
				printWriter.println(it)
			]
			printWriter.close
			
			/* sonar */
			val mm = new MvnManager(dirPath)
			driver.get("localhost:9000")
			addressBook.forEach [
				val name = it.substring(it.lastIndexOf('/') + 1, it.lastIndexOf('.'))
				mm.test(name)
				mm.sonar(name)
				
				val value = driver.findElements(By.xpath('//p[@class="data"]/a[1]'))
				value.forEach[
					System.out.println(it.text)
				]
			]
			Thread.sleep(15 * 1000)
		]

		driver.close
	}
}
