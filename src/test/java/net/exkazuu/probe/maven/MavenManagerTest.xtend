package net.exkazuu.probe.maven

import net.exkazuu.probe.git.GitManager
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

	@Test
	def void get() {
		val matcher = MavenManager.pitPattern.matcher(">> Generated 4 mutations Killed 4 (100%)")
		assertThat(matcher.matches, is(true))
		assertThat(matcher.group(1), is("4"))
		assertThat(matcher.group(2), is("4"))
		assertThat(matcher.group(3), is("100"))
	}
}
