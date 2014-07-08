package net.exkazuu.probe.git

import java.io.File
import java.util.HashSet
import net.exkazuu.probe.file.FileManager
import net.exkazuu.probe.maven.OldMavenManager
import org.junit.Test

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*

class GitManagerTest {

	val gm = new OldGitManager("DirectoryForTest")
	val mm = new OldMavenManager("DirectoryForTest")
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
		val address = "https://github.com/gumfum/TestSample"
		val list = gm.clone(address)

		val str = address.substring(address.lastIndexOf('/') + 1, address.length)
		System.out.println(str)
		for (s : list) {
			System.out.println(s)
		}
	}

	@Test
	def void getAuthorNamesTestSample() {
		gm.clone("https://github.com/gumfum/TestSample")
		val fileList = fm.getSourceCodeAbsolutePath("DirectoryForTest/TestSample")

		val result = new HashSet<String>()
		for (file : fileList) {
			result += gm.getAuthorNames(file)
		}

		for (name : result) {
			System.out.println(name)
		}
	}

	@Test
	def void getAuthorNamesFromTestSample() {
		gm.clone("https://github.com/gumfum/TestSample")
		val fileList = fm.getSourceCodeAbsolutePath("DirectoryForTest/TestSample")

		val result = new HashSet<String>()
		for (file : fileList) {
			for (name : gm.getAuthorNames(file)) {
				result += name
			}
		}
		for (name : result) {
			System.out.println(name)
		}
		assertThat(result.size, is(2))
	}

	@Test
	def void getAuthorNamesTestSampleFile() {
		gm.clone("https://github.com/gumfum/TestSample")

		for (name : gm.getAuthorNames("DirectoryForTest/TestSample/src/main/Plus.java")) {
			System.out.println(name)
		}
	}

	@Test
	def void cloneShallowly() {
		val gitMan = new GitManager(new File("DirectoryForTest"))
		System.out.println(gitMan.directoryPath)
		val res = gitMan.cloneShallowly("https://github.com/gumfum/SampleMavenProject", "gumfum/SampleMavenProject", 1)
		res.forEach [
			System.out.println(it)
		]
	}
}
