package net.exkazuu.probe.file

import org.junit.Before
import org.junit.Test

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*
import net.exkazuu.probe.git.OldGitManager

class FileManagerTest {
	val gm = new OldGitManager("DirectoryForTest")
	val fm = new FileManager("DirectoryForTest")

	@Before
	def void before() {
		gm.clone("https://github.com/gumfum/TestSample", "TestSample")
	}

	@Test
	def void countSourceCode() {
		val result = fm.getSourceCodeAbsolutePath("DirectoryForTest/TestSample", "TestSample")

		assertThat(result.length, is(9))
	}

	@Test
	def void countTestCode() {
		val result = fm.getSourceCodeAbsolutePath("DirectoryForTest/TestSample", "TestSample")
		assertThat(result.filter[it.contains("/test/")].size, is(4))
	}

	@Test
	def void countLoc() {
		val result = fm.getSourceCodeLOC("DirectoryForTest/TestSample/src/main/IfDoWhile.java")
		assertThat(result, is(19))
	}
}
