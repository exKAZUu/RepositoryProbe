package net.exkazuu.probe.maven

import java.util.List
import java.util.regex.Pattern

import static extension net.exkazuu.probe.extensions.XProcess.*

class PitManager {
	val MavenManager mvnMan
	public static val Pattern pitPattern = Pattern.compile('''>> Generated (\d+) mutations Killed (\d+) \((\d+)%\)''')

	new(MavenManager mvnMan) {
		this.mvnMan = mvnMan
	}

	def List<Integer> execute() {
		val proc = mvnMan.execute("org.pitest:pitest-maven:mutationCoverage")
		val matcher = proc.readAllOutputsIgnoringErrors().map [
			pitPattern.matcher(it)
		].findFirst [
			it.matches
		]
		return (1 .. 3).map[Integer.parseInt(matcher.group(it))].toList
	}
}
