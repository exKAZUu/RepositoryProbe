package net.exkazuu.probe.sonar

import org.supercsv.cellprocessor.ParseDouble
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.cellprocessor.ift.CellProcessor

class SonarInfo {
	public static val header = #["loc", "lines", "statemens", "files", "directories", "classes", "packages", "functions",
		"accessors", "publicDocumentedAPIDensity", "publicAPI", "publicUndocumentedAPI", "commentLinesDensity",
		"commentLines", "duplicatedLinesDensity", "duplicatedLines", "duplicatedBlocks", "duplicatedFiles",
		"functionComplexity", "classComplexity", "fileComplexity", "complexity", "violations", "technicalDebt",
		"blockerViolations", "criticalViolations", "majorViolations", "minorViolations", "infoViolations",
		"packageTangleIndex", "packageCycles", "packageFeedbackEdges", "packageTangles", "coverage", "lineCoverage",
		"branchCoverage", "testSuccessDensity", "testFailures", "testErrors", "tests", "testExecutionTime"]

	public static val processors = (header.subList(0, 9).map[new ParseInt() as CellProcessor] +
		#[new ParseDouble(), new ParseInt(), new ParseInt(), new ParseDouble(), new ParseInt(), null] +
		header.subList(15, 18).map[new ParseInt()] + header.subList(18, 21).map[new ParseDouble()] +
		#[new ParseInt(), null] + header.subList(24, 29).map[new ParseInt()] + #[new ParseDouble()] +
		header.subList(30, 33).map[new ParseInt()] + header.subList(33, 37).map[new ParseDouble()] +
		header.subList(37, 40).map[new ParseInt()] + #[null]
		).toList

	@Property int loc = -1
	@Property int lines = -1
	@Property int statements = -1
	@Property int files = -1
	@Property int directories
	@Property int classes = -1
	@Property int packages = -1
	@Property int functions = -1
	@Property int accessors = -1
	@Property double publicDocumentedAPIDensity = -1
	@Property int publicAPI = -1
	@Property int publicUndocumentedAPI = -1
	@Property double commentLinesDensity = -1
	@Property int commentLines = -1
	@Property String duplicatedLinesDensity = ""
	@Property int duplicatedLines = -1
	@Property int duplicatedBlocks = -1
	@Property int duplicatedFiles = -1
	@Property double functionComplexity = -1
	@Property double classComplexity = -1
	@Property double fileComplexity = -1
	@Property double complexity = -1
	@Property int violations = -1
	@Property String technicalDebt = ""
	@Property int blockerViolations = -1
	@Property int criticalViolations = -1
	@Property int majorViolations = -1
	@Property int minorViolations = -1
	@Property int infoViolations = -1
	@Property double packageTangleIndex = -1
	@Property int packageCycles = -1
	@Property int packageFeedbackEdges = -1
	@Property int packageTangles = -1
	@Property double coverage = -1
	@Property double lineCoverage = -1
	@Property double branchCoverage = -1
	@Property double testSuccessDensity = -1
	@Property int testFailures = -1
	@Property int testErrors = -1
	@Property int tests = -1
	@Property String testExecutionTime = ""
}
