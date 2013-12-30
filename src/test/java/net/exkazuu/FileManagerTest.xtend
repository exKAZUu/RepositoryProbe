package net.exkazuu

import org.junit.Test
import static org.junit.Assert.*
import java.util.ArrayList
import java.util.HashSet

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
	def void testCouneTestCode() {
		val gm = new GitManager("C:\\DirectoryForTest")
		gm.clone("https://github.com/gumfum/TestSample", "TestSample")
		val fm = new FileManager("C:\\DirectoryForTest")
		val result = fm.getSourceCodeAbsolutePath("C:\\DirectoryForTest\\TestSample", "TestSample")

		val testFilePath = new ArrayList<String>
		for (path : result) {
			if (path.contains("\\test\\")) {
				testFilePath += path
			}
		}

		assertEquals(testFilePath.size, 4)
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
