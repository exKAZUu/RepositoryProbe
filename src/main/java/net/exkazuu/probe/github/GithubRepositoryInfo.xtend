package net.exkazuu.probe.github

import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.util.ArrayList
import org.supercsv.cellprocessor.ParseDouble
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.io.CsvBeanWriter
import org.supercsv.prefs.CsvPreference

class GithubRepositoryInfo {
	val public static sonarHeader = #["loc", "lines", "statemens", "files", "directories", "classes", "packages",
		"functions", "accessors", "publicDocumentedAPIDensity", "publicAPI", "publicUndocumentedAPI",
		"commentLinesDensity", "commentLines", "duplicatedLinesDensity", "duplicatedLines", "duplicatedBlocks",
		"duplicatedFiles", "functionComplexity", "classComplexity", "fileComplexity", "complexity", "violations",
		"technicalDebt", "blockerViolations", "criticalViolations", "majorViolations", "minorViolations",
		"infoViolations", "packageTangleIndex", "packageCycles", "packageFeedbackEdges", "packageTangles", "coverage",
		"lineCoverage", "branchCoverage", "testSuccessDensity", "testFailures", "testErrors", "tests",
		"testExecutionTime"]

	val static public sonarProcessors = (sonarHeader.subList(0, 9).map[new ParseInt()] +
		#[new ParseDouble(), new ParseInt(), new ParseInt(), new ParseDouble(), new ParseInt(), null] +
		sonarHeader.subList(15, 18).map[new ParseInt()] + sonarHeader.subList(18, 21).map[new ParseDouble()] +
		#[new ParseInt(), null] + sonarHeader.subList(24, 29).map[new ParseInt()] + #[new ParseDouble()] +
		sonarHeader.subList(30, 33).map[new ParseInt()] + sonarHeader.subList(33, 37).map[new ParseDouble()] +
		sonarHeader.subList(37, 40).map[new ParseInt()] + #[null]
		)

	val static header = (#["url", "mainBranch", "latestCommitSha", "watchCount", "starCount", "forkCount", "commitCount",
		"branchCount", "releaseCount", "contributorCount", "openIssueCount", "closedIssueCount", "openPullRequestCount",
		"closedPullRequestCount", "searchResultCount", "retrievedTime", "killedMutantCount", "generatedMutantCount",
		"killedMutantPercentage"] + sonarHeader).toList

	val static processors = ((#[null, null, null, null] + header.drop(4).map [
		new ParseInt()
	]) + sonarProcessors).toList

	//GitHub
	@Property String url = ""
	@Property String mainBranch = ""
	@Property String latestCommitSha = ""
	@Property String retrievedTime = ""
	@Property int watchCount = -1
	@Property int starCount = -1
	@Property int forkCount = -1
	@Property int commitCount = -1
	@Property int branchCount = -1
	@Property int releaseCount = -1
	@Property int contributorCount = -1
	@Property int openIssueCount = -1
	@Property int closedIssueCount = -1
	@Property int openPullRequestCount = -1
	@Property int closedPullRequestCount = -1
	@Property int searchResultCount = -1

	//PIT
	@Property int killedMutantCount = -1
	@Property int generatedMutantCount = -1
	@Property int killedMutantPercentage = -1 // TODO: Should the type be double?

	//Sonar
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

	def getUserAndProjectName() {
		url.substring("https://github.com/".length)
	}

	def getUserName() {
		userAndProjectName.split("/").get(0)
	}

	def getProjectName() {
		userAndProjectName.split("/").get(1)
	}
	
	def static write(File file, Iterable<GithubRepositoryInfo> infos) {
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
		val infos = new ArrayList<GithubRepositoryInfo>()
		if (file.exists) {
			val reader = new FileReader(file)
			val csvReader = new CsvBeanReader(reader, CsvPreference.STANDARD_PREFERENCE)
			var GithubRepositoryInfo info = null
			csvReader.getHeader(true)

			while ((info = csvReader.read(typeof(GithubRepositoryInfo), header, processors)) != null) {
				infos.add(info)
			}
			csvReader.close
			reader.close
		}
		infos
	}

	def static readMap(File file) {
		readList(file).toMap[it.url]
	}
}
