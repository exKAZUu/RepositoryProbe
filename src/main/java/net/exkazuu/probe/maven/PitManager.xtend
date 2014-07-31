package net.exkazuu.probe.maven

import java.util.EnumSet
import java.util.List
import java.util.regex.Pattern

import static extension net.exkazuu.probe.extensions.XProcess.*

enum MutantOperator {

	// Default mutators
	INVERT_NEGS,
	RETURN_VALS,
	INLINE_CONSTS,
	MATH,
	VOID_METHOD_CALLS,
	NEGATE_CONDITIONALS,
	CONDITIONALS_BOUNDARY,
	INCREMENTS,

	// Optional mutators
	REMOVE_INCREMENTS,
	NON_VOID_METHOD_CALLS,
	CONSTRUCTOR_CALLS,
	REMOVE_CONDITIONALS_EQ_IF,
	REMOVE_CONDITIONALS_EQ_ELSE,
	REMOVE_CONDITIONALS_ORD_IF,
	REMOVE_CONDITIONALS_ORD_ELSE,
	REMOVE_CONDITIONALS,

	// Experimental mutators
	EXPERIMENTAL_MEMBER_VARIABLE,
	EXPERIMENTAL_SWITCH,
	REMOVE_SWITCH,

	// Pre-set mutators
	DEFAULTS,
	STRONGER,
	ALL
}

class PitManager {
	val MavenManager mvnMan
	public static val Pattern pitPattern = Pattern.compile('''>> Generated (\d+) mutations Killed (\d+) \((\d+)%\)''')

	new(MavenManager mvnMan) {
		this.mvnMan = mvnMan
	}

	def List<Integer> execute() {
		execute(EnumSet.of(MutantOperator.DEFAULTS))
	}

	def List<Integer> execute(MutantOperator operators) {
		execute(EnumSet.of(operators))
	}

	def List<Integer> execute(EnumSet<MutantOperator> operators) {
		val proc = mvnMan.execute("test", "-e", "org.pitest:pitest-maven:1.0.0:mutationCoverage", "-DtargetClasses=*",
			"-DexcludedClasses=org.pitest.*,sun.*,com.sun.*", "-Dmutators=" + operators.join(','))
		val ret = proc.readAllOutputsIgnoringErrors()
		val matcher = ret.map [
			pitPattern.matcher(it)
		].findFirst [
			it.matches
		]
		if (matcher != null) {
			(1 .. 3).map[Integer.parseInt(matcher.group(it))].toList
		}
	}
}
