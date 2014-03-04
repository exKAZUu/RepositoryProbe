package net.exkazuu

import java.util.HashSet
import org.junit.Test

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*

class GitManagerTest {

	val gm = new GitManager("DirectoryForTest")
	val mm = new MavenManager("DirectoryForTest")
	val fm = new FileManager("DirectoryForTest")

	@Test
	def void getAuthorName() {
		gm.clone("https://github.com/gumfum/TestSample", "TestSample")
		mm.test("TestSample")

		val list = mm.getTestMethodRelativePath("DirectoryForTest/TestSample/", "TestSample")

		for (str : list) {
			System.out.println(str)

			val filePath = "DirectoryForTest/TestSample/" + str.substring(0, str.lastIndexOf('/'))
			val methodName = str.substring(str.lastIndexOf('/') + 1, str.length)

			System.out.println(filePath)
			System.out.println(methodName)

			val authors = gm.getAuthorNames(filePath)

			// TODO: Should remove branch in tests (How can we remove LAB-PC?)
			assertThat(authors, anyOf(contains("Ryohei Takasawa"), contains("LAB-PC")))
		}
	}

	@Test
	def void cloneByAddress() {
		val address = "https://github.com/ocwajbaum/jenkins"
		val list = gm.clone(address)

		val str = address.substring(address.lastIndexOf('/') + 1, address.length)
		System.out.println(str)
		for (s : list) {
			System.out.println(s)
		}
	}

	@Test
	def void getAuthorNamesXwiki() {
		gm.clone("https://github.com/xwiki/xwiki-commons")
		val fileList = fm.getSourceCodeAbsolutePath("DirectoryForTest/xwiki-commons")

		val result = new HashSet<String>()
		for (file : fileList) {
			result += gm.getAuthorNames(file)
		}

		for (name : result) {
			System.out.println(name)
		}
	}

	@Test
	def void getAuthorNamesZanataServer() {
		gm.clone("https://github.com/zanata/zanata-server")
		val fileList = fm.getSourceCodeAbsolutePath("DirectoryForTest/zanata-server")

		val result = new HashSet<String>()
		for (file : fileList) {
			for (name : gm.getAuthorNames(file)) {
				result += name
			}
		}
		for (name : result) {
			System.out.println(name)
		}
		assertThat(result.size, is(16))
	}

	@Test
	def void getAuthorNamesZanataServerFile() {
		gm.clone("https://github.com/zanata/zanata-server")

		for (name : gm.getAuthorNames(
			"DirectoryForTest/zanata-server/zanata-war/src/test/java/org/zanata/webtrans/client/presenter/TranslationPresenterTest.java")) {
			System.out.println(name)
		}

	}
}
