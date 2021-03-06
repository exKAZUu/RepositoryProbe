package net.exkazuu.probe.common

import com.google.common.io.Files
import java.io.File
import java.io.FileReader
import java.nio.charset.Charset
import java.util.ArrayList
import net.exkazuu.probe.github.GithubRepositoryInfo
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.prefs.CsvPreference

class TestCaseGenerator {
	val static header = #["url", "mainBranch", "latestCommitSha", "starCount", "forkCount", "commitCount", "branchCount",
		"releaseCount", "contributorCount", "openIssueCount", "closedIssueCount", "openPullRequestCount",
		"searchResultCount"]
	val static processors = #[null, null, null, new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(),
		new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt(), new ParseInt()]

	def static loadExistingInfos(File file) {
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

	def static createCSharpTestCase(GithubRepositoryInfo info) '''
		[TestCase(@"«info.url».git",
			@"«info.latestCommitSha»", «info.starCount»)]
	'''

	def static void main(String[] args) {
		#["java", "csharp", "javascript", "python", "php", "lua"].forEach [
			val code = loadExistingInfos(new File(it + ".csv")).map [
				createCSharpTestCase(it).toString.trim
			].join("\n")
			Files.write(code, new File(it + ".txt"), Charset.defaultCharset())
		]
	}
}
