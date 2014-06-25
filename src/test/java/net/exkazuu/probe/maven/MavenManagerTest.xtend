package net.exkazuu.probe.maven

import net.exkazuu.probe.git.GitManager
import net.exkazuu.probe.maven.MavenManager
import org.junit.Test

import static org.hamcrest.Matchers.*
import static org.junit.Assert.*

class MavenManagerTest {
	val gm = new GitManager("DirectoryForTest")
	val mm = new MavenManager("DirectoryForTest")

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
