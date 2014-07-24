package net.exkazuu.probe.maven

import java.util.EnumSet
import java.util.List
import java.util.regex.Pattern

import static extension net.exkazuu.probe.extensions.XProcess.*

enum MutantOperator {
	CONDITIONALS_BOUNDARY,
	NEGATE_CONDITIONALS,
	REMOVE_CONDITIONALS,
	MATH,
	INCREMENTS,
	INVERT_NEGS,
	INLINE_CONSTS,
	RETURN_VALS,
	VOIDMETHODCALLS,
	NONVOIDMETHOD_CALLS,
	CONSTRUCTOR_CALLS,
	EXPERIMENTALINLINECONSTS,
	EXPERIMENTALMEMBERVARIABLE,
	EXPERIMENTAL_SWITCH
}

class PitManager {
	val MavenManager mvnMan
	public static val Pattern pitPattern = Pattern.compile('''>> Generated (\d+) mutations Killed (\d+) \((\d+)%\)''')

	new(MavenManager mvnMan) {
		this.mvnMan = mvnMan
	}

	def List<Integer> execute() {
		execute(
			EnumSet.of(MutantOperator.CONDITIONALS_BOUNDARY, MutantOperator.NEGATE_CONDITIONALS, MutantOperator.MATH,
				MutantOperator.INCREMENTS, MutantOperator.INVERT_NEGS, MutantOperator.RETURN_VALS,
				MutantOperator.VOIDMETHODCALLS))
	}

	def List<Integer> execute(EnumSet<MutantOperator> operators) {
		val proc = mvnMan.execute("-e", "org.pitest:pitest-maven:1.0.0:mutationCoverage",
			"-Dmutators=" + operators.join(','))
		val matcher = proc.readAllOutputsIgnoringErrors().map [
			pitPattern.matcher(it)
		].findFirst [
			it.matches
		]
		return (1 .. 3).map[Integer.parseInt(matcher.group(it))].toList
	}
}
