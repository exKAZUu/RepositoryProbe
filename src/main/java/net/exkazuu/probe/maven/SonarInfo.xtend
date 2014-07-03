package net.exkazuu.probe.maven

import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.util.ArrayList
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.io.CsvBeanWriter
import org.supercsv.prefs.CsvPreference

class SonarInfo {
	val static header = #["loc", "lines", "statemens", "files", "directories", "classes", "packages", "functions",
		"accessors", "public_documented_api_density", "public_api", "m_public_undocumented_api",
		"comment_lines_density", "comment_lines", "duplicated_lines_density", "duplicated_lines", "duplicated_blocks",
		"duplicated_files", "function_complexity", "class_complexity", "file_complexity", "complexity", "violations",
		"technical_debt", "blocker_violations", "critical_violations", "major_violations",
		"minor_violations", "info_violations", "package_tangle_index", "package_cycles", "package_feedback_edges",
		"package_tangles", "coverage", "line_coverage", "branch_coverage", "test_success_density", "test_failures",
		"test_errors", "tests", "test_execution_time"]
	val static processors = (#[null, null, null] + header.drop(3).map [
		new ParseInt()
	])

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
	@Property int publicUndocumtnedAPI = -1
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

	def static write(File file, Iterable<SonarInfo> infos) {
		val writer = new FileWriter(file)
		val csvWriter = new CsvBeanWriter(writer, CsvPreference.STANDARD_PREFERENCE)
		csvWriter.writeHeader(header)
		for (info : infos) {
			csvWriter.write(info, header)
		}
		csvWriter.close
		writer.close
	}

	def static readList(File file) {
		val infos = new ArrayList<SonarInfo>()
		if (file.exists) {
			val reader = new FileReader(file)
			val csvReader = new CsvBeanReader(reader, CsvPreference.STANDARD_PREFERENCE)
			var SonarInfo info = null
			csvReader.getHeader(true)

			while ((info = csvReader.read(typeof(SonarInfo), header, processors)) != null) {
				infos.add(info)
			}
			csvReader.close
			reader.close
		}
		infos
	}
}
