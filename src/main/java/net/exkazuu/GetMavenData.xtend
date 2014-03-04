package net.exkazuu

import java.io.BufferedWriter
import java.io.File
import java.io.FileWriter
import java.io.PrintWriter
import java.util.ArrayList
import org.openqa.selenium.By
import org.openqa.selenium.chrome.ChromeDriver

/*
 *	Script for Existing repositories
 */
class GetMavenData {
	def static void main(String[] args) {
		val driver = new ChromeDriver
		val sonarTags = new ArrayList<String>
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

		val minSize = 8798
		val maxSize = 8800
		(minSize .. maxSize).forEach [
			System.out.println(it)
			val dirPath = "C:\\Study\\Repos" + it
			val resultFile = new File(dirPath + "\\result.txt")
			val printWriter = new PrintWriter(new BufferedWriter(new FileWriter(resultFile)))
			printWriter.print("name,")
			sonarTags.forEach [
				printWriter.print(it + ",")
			]
			printWriter.println("")
			val fileManager = new FileManager(dirPath)
			val dirList = fileManager.dirList
			val mvnManager = new MavenManager(dirPath)
			dirList.forEach [
				val folderPath = it.toString
				if (!folderPath.contains(".txt")) {

					/* mvn test */
					val name = folderPath.substring(folderPath.lastIndexOf('\\') + 1)
					val testResult = mvnManager.test(name)
					val testResultFile = new File(dirPath + "\\" + name + "_test.txt")
					val testPrintWriter = new PrintWriter(new BufferedWriter(new FileWriter(testResultFile)))
					testResult.forEach [
						testPrintWriter.println(it)
					]
					testPrintWriter.close

					/* mvn sonar:sonar */
					val sonarResult = mvnManager.sonar(name)
					val sonarResultFile = new File(dirPath + "\\" + name + "_sonar.txt")
					val sonarPrintWriter = new PrintWriter(new BufferedWriter(new FileWriter(sonarResultFile)))
					sonarResult.forEach [
						sonarPrintWriter.println(it)
					]
					sonarPrintWriter.close

					/* login */
					driver.get("http://localhost:9000/sessions/login")
					Thread.sleep(10 * 1000)
					driver.findElements(By.xpath('//input[@id="login"]')).get(0).sendKeys("admin")
					driver.findElements(By.xpath('//input[@id="password"]')).get(0).sendKeys("admin")
					driver.findElements(By.xpath('//input[@type="submit"]')).get(0).click()
					Thread.sleep(10 * 1000)

					val repos = driver.findElements(By.xpath('//td[@class=" nowrap"]/a[1]'))
					if (repos.size != 0) {
						System.out.println("OK")

						/* output values */
						printWriter.print(name + ",")
						repos.get(0).click
						Thread.sleep(10 * 1000)
						sonarTags.forEach [
							printWriter.print("\"")
							val id = '//span[@id="' + it + '"]'
							val value = driver.findElements(By.xpath(id))
							if (value.size != 0) {
								printWriter.print(value.get(0).text)
							}
							printWriter.print("\",")
						]
						printWriter.println("")

						/* delete */
						val deleteURL = driver.currentUrl.replace("dashboard/index", "project/deletion")
						driver.get(deleteURL)
						Thread.sleep(10 * 1000)
						driver.findElement(By.xpath('//input[@id="delete_resource"]')).click
						Thread.sleep(10 * 1000)
						driver.switchTo.alert.accept
					} else {
						System.out.println("NG")
					}
					Thread.sleep(30 * 1000)
				}
			]
			printWriter.close
		]

		driver.quit
	}
}
