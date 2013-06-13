package net.exkazuu

import org.junit.Test
import static org.junit.Assert.*

class GitManagerTest {
	@Test
	def void testGetAuthorName() {
		val gm = new GitManager("C:\\Study")
		gm.clone("https://github.com/gumfum/TestSample", "TestSample")
		val mm = new MvnManager("C:\\Study")
		mm.test("TestSample")
		
		val list = mm.getTestMethodRelativePath("C:\\Study\\TestSample", "TestSample")
		
		for(str : list) {
			System::out.println(str)
			assertEquals(gm.getAuthorName(str), "Ryohei Takasawa")
		}
	}
	
	@Test
	def void testCloneByAddress() {
		val gm = new GitManager("C:\\Study")
		val address = "https://github.com/ocwajbaum/jenkins"
		val list = gm.clone(address)
		
		val str = address.substring(address.lastIndexOf('/')+1, address.length)
		System::out.println(str)
		for (s : list) {
			System::out.println()
		}
		
	}
}