package net.exkazuu

import org.junit.Test
import static org.junit.Assert.*

class FileManagerTest {
	@Test
	def void testCountSourceCode() {
		val gm = new GitManager("C:\\DirectoryForTest")
		gm.clone("https://github.com/gumfum/TestSample", "TestSample")
		val fm = new FileManager("C:\\DirectoryForTest")
		val result = fm.getSourceCodeAbsolutePath("C:\\DirectoryForTest\\TestSample", "TestSample")

		assertEquals(result.length, 9)
	}

	@Test
	def void testCountLOC() {
		val gm = new GitManager("C:\\DirectoryForTest")
		gm.clone("https://github.com/gumfum/TestSample", "TestSample")
		val fm = new FileManager("C:\\DirectoryForTest")
		val result = fm.getSourceCodeLOC("C:\\DirectoryForTest\\TestSample\\src\\main\\IfDoWhile.java")

		assertEquals(result, 19)
	}
}
