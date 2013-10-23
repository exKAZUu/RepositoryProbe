package net.exkazuu

import org.junit.Test
import static org.junit.Assert.*

class MvnManagerTest {
	@Test
	def void testCommonsAts() {
		val gm = new GitManager("C:\\DirectoryForTest")
		val message = gm.clone("https://github.com/after-the-sunrise/commons-ats.git", "commons-ats")
		for (line : message) {
			System.out.println(line)
		}
		val mm = new MvnManager("C:\\DirectoryForTest")
		mm.test("commons-ats")

		assertEquals(mm.delete("commons-ats"), true)
	}

	@Test
	def void testGetTestMethodRelativePath() {
		val gm = new GitManager("C:\\DirectoryForTest")
		val message = gm.clone("https://github.com/gumfum/TestSample", "TestSample")
		for (line : message) {
			System.out.println(line)
		}

		val mm = new MvnManager("C:\\DirectoryForTest")
		mm.test("TestSample")

		val list = mm.getTestMethodRelativePath("C:\\DirectoryForTest\\TestSample", "TestSample")

		for (str : list) {
			System::out.println(str)
		}

		mm.delete("TestSample")
		assertEquals(list.size, 11)
	}
}
