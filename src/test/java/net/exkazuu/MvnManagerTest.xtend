package net.exkazuu

import org.junit.Test
import static org.junit.Assert.*

class MvnManagerTest {
	@Test
	def void testCommonsAts() {
		val gm = new GitManager("C:\\Study")
		gm.clone("git://github.com/after-the-sunrise/commons-ats.git", "commons-ats")
		val mm = new MvnManager("C:\\Study")
		mm.test("commons-ats")

		assertEquals(mm.delete("commons-ats"), true)
	}
	
	@Test
	def void testGetTestMethodRelativePath() {
		val gm = new GitManager("C:\\Study")
		gm.clone("https://github.com/gumfum/TestSample", "TestSample")
		val mm = new MvnManager("C:\\Study")
		mm.test("TestSample")
		
		val list = mm.getTestMethodRelativePath("C:\\Study\\TestSample", "TestSample")
		
		for(str : list) {
			System::out.println(str)
		}
		
		mm.delete("TestSample")
		assertEquals(list.size, 11)
	}
}
