package net.exkazuu.probe.maven

import java.io.PrintStream
import java.util.EnumSet
import java.util.List
import java.util.regex.Pattern

enum MutantOperator {

	// Pre-set mutators
	DEFAULTS,
	STRONGER,
	ALL,

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
	REMOVE_SWITCH
}

class PitManager {
	val MavenManager mvnMan
	static val Pattern pitPattern = Pattern.compile('''>> Generated (\d+) mutations Killed (\d+) \((\d+)%\)''')
	static val stdoutLogStream = new PrintStream("pit_stdout.log")
	static val stderrLogStream = new PrintStream("pit_stderr.log")

	new(MavenManager mvnMan) {
		this.mvnMan = mvnMan
	}

	def List<Integer> execute() {
		execute(EnumSet.of(MutantOperator.DEFAULTS))
	}

	def List<Integer> execute(MutantOperator operator) {
		execute(EnumSet.of(operator))
	}

	def List<Integer> execute(EnumSet<MutantOperator> operators) {
		val ret = mvnMan.execute("test", "-e", "org.pitest:pitest-maven:1.0.0:mutationCoverage", "-DtargetClasses=*",
			"-DexcludedClasses=org.pitest.*,sun.*,com.sun.*,java.*", "-Dmutators=" + operators.join(','))
		ret.get(0).forEach [
			stdoutLogStream.println(it)
		]
		ret.get(1).forEach [
			stderrLogStream.println(it)
		]
		val matcher = ret.get(0).map [
			pitPattern.matcher(it)
		].findFirst [
			it.matches
		]
		if (matcher != null) {
			(1 .. 3).map[Integer.parseInt(matcher.group(it))].toList
		}
	}
}
