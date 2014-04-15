package net.exkazuu.scraper

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
		"searchResultCount"]
	val static processors = #[null, null, null, new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(),
		new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt()]

	@Property String url
	@Property String mainBranch
	@Property String latestCommitSha
	@Property int starCount
	@Property int forkCount
	@Property int commitCount
	@Property int branchCount
	@Property int releaseCount
	@Property int contributorCount
	@Property int openPullRequestCount
	@Property int openIssueCount
	@Property int closedIssueCount
	@Property int searchResultCount

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
