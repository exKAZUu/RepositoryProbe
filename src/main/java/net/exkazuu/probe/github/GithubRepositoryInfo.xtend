package net.exkazuu.probe.github

import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.util.ArrayList
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.io.CsvBeanWriter
import org.supercsv.prefs.CsvPreference

class GithubRepositoryInfo {
	val static header = #["url", "mainBranch", "latestCommitSha", "starCount", "forkCount", "commitCount", "branchCount",
		"releaseCount", "contributorCount", "openIssueCount", "closedIssueCount", "openPullRequestCount",
		"closedPullRequestCount", "searchResultCount", "killedMutantCount", "generatedMutantCount",
		"killedMutantPercentage"]
	val static processors = (#[null, null, null] + header.drop(3).map [
		new ParseInt()
	])

	@Property String url = ""
	@Property String mainBranch = ""
	@Property String latestCommitSha = ""
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
	@Property int killedMutantCount = -1
	@Property int generatedMutantCount = -1
	@Property int killedMutantPercentage = -1 // TODO: Should the type be double?

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
