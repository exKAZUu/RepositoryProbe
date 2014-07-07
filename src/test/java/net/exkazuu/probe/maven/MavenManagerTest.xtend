package net.exkazuu.probe.maven

import org.junit.Test

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*
import net.exkazuu.probe.git.OldGitManager

class MavenManagerTest {
	val gm = new OldGitManager("DirectoryForTest")
	val mm = new OldMavenManager("DirectoryForTest")

	@Test
	def void commonsAts() {
		gm.clone("https://github.com/after-the-sunrise/commons-ats.git", "commons-ats")
		mm.test("commons-ats")

		assertThat(mm.delete("commons-ats"), is(true))
	}

	@Test
	def void getTestMethodRelativePath() {
		gm.clone("https://github.com/gumfum/TestSample", "TestSample")
		mm.test("TestSample")

		val list = mm.getTestMethodRelativePath("DirectoryForTest/TestSample", "TestSample")

		for (str : list) {
			System.out.println(str)
		}

		mm.delete("TestSample")
		assertThat(list.size, is(11))
	}
}
