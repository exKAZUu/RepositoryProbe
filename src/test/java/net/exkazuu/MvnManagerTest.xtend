package net.exkazuu

import static org.junit.Assert.*;
import org.junit.Test;

class MvnManagerTest {
	@Test
	def testCommonsAts() {
		val gm = new GitManager
		gm.clone("git://github.com/after-the-sunrise/commons-ats.git", "commons-ats")
		val mm = new MvnManager
		mm.test("commons-ats")
	}
}
