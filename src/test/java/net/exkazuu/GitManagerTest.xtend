package net.exkazuu

import org.junit.Test
import static org.junit.Assert.*
import java.util.HashSet
import java.io.File
import java.io.FileWriter
import java.io.PrintWriter

class GitManagerTest {
	@Test
	def void testGetAuthorName() {
		val gm = new GitManager("C:\\DirectoryForTest")
		gm.clone("https://github.com/gumfum/TestSample", "TestSample")
		val mm = new MvnManager("C:\\DirectoryForTest")
		mm.test("TestSample")

		val list = mm.getTestMethodRelativePath("C:\\DirectoryForTest\\TestSample\\", "TestSample")

		for (str : list) {
			System::out.println(str)

			val filePath = "C:\\DirectoryForTest\\TestSample\\" + str.substring(0, str.lastIndexOf('\\'))
			val methodName = str.substring(str.lastIndexOf('\\') + 1, str.length)

			System::out.println(filePath)
			System::out.println(methodName)

			assertEquals(gm.getAuthorName(filePath, methodName), "Ryohei Takasawa ")
		}
	}

	@Test
	def void testCloneByAddress() {
		val gm = new GitManager("C:\\DirectoryForTest")
		val address = "https://github.com/ocwajbaum/jenkins"
		val list = gm.clone(address)

		val str = address.substring(address.lastIndexOf('/') + 1, address.length)
		System::out.println(str)
		for (s : list) {
			System::out.println(s)
		}
	}

	@Test
	def void testGetAuthorNamesXwiki() {
		val gm = new GitManager("C:\\DirectoryForTest")
		val address = "https://github.com/xwiki/xwiki-commons"
		val cloneResult = gm.clone(address)
		val fm = new FileManager("C:\\DirectoryForTest")
		val fileList = fm.getSourceCodeAbsolutePath("C:\\DirectoryForTest\\xwiki-commons")

		val result = new HashSet<String>()
		for (file : fileList) {
			result += gm.getAuthorNames(file)
		}

		for (name : result) {
			System::out.println(name)
		}
	}

	@Test
	def void testGetAuthorNamesZanataServer() {
		val gm = new GitManager("C:\\DirectoryForTest")
		val address = "https://github.com/zanata/zanata-server"
		val cloneResult = gm.clone(address)
		val fm = new FileManager("C:\\DirectoryForTest")
		val fileList = fm.getSourceCodeAbsolutePath("C:\\DirectoryForTest\\zanata-server")

		val result = new HashSet<String>()
		for (file : fileList) {
			for (name : gm.getAuthorNames(file)) {
				result += name
			}
		}
		for (name : result) {
			System::out.println(name)
		}
		assertEquals(result.size, 16)
	}

	@Test
	def void testGetAuthorNamesZanataServerFile() {
		val gm = new GitManager("C:\\DirectoryForTest")
		val address = "https://github.com/zanata/zanata-server"
		val cloneResult = gm.clone(address)
		val fm = new FileManager("C:\\DirectoryForTest")

		for (name : gm.getAuthorNames(
			"C:\\DirectoryForTest\\zanata-server\\zanata-war\\src\\test\\java\\org\\zanata\\webtrans\\client\\presenter\\TranslationPresenterTest.java")) {
			System::out.println(name)
		}

	}
}
