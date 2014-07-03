package net.exkazuu.probe

import java.io.File
import net.exkazuu.probe.github.GithubRepositoryInfo
import java.util.Map
import org.eclipse.jgit.api.Git
import org.eclipse.jgit.api.CreateBranchCommand
import net.exkazuu.probe.maven.MavenManager
import net.exkazuu.probe.sonar.SonarManager
import org.openqa.selenium.firefox.FirefoxDriver

/**
 * A class for measuring metrics by execution SonarQube.
 * 
 * @author Ryohei Takasawa
 */
class SonarExecutor {
	protected val File csvFile
	protected val Map<String, GithubRepositoryInfo> infos
	val File mvnDir

	new(File csvFile, File mvnDir) {
		this.csvFile = csvFile
		this.infos = GithubRepositoryInfo.readMap(csvFile)
		this.mvnDir = mvnDir
		mvnDir.mkdirs()
	}

	def run() {
		infos.forEach [ url, info |
			val userDir = new File(mvnDir.path, info.userName)
			userDir.mkdir()
			val git = Git.cloneRepository().setURI(url).setDirectory(userDir).call()
			git.checkout().setCreateBranch(true).setName("branchName").setUpstreamMode(
				CreateBranchCommand.SetupUpstreamMode.TRACK).setStartPoint("origin/" + info.mainBranch).call();
			val projectDir = new File(userDir.path, info.projectName)
			val ret = new SonarManager(new MavenManager(projectDir), new FirefoxDriver()).execute
			info.loc = ret.loc
			info.lines = ret.lines
			info.statements = ret.statements
			info.files = ret.files
			info.directories = ret.directories
			info.classes = ret.classes
			info.packages = ret.packages
			info.functions = ret.functions
			info.accessors = ret.accessors
			info.publicDocumentedAPIDensity = ret.publicDocumentedAPIDensity
			info.publicAPI = ret.publicAPI
			info.publicUndocumtnedAPI = ret.publicUndocumentedAPI
			info.commentLinesDensity = ret.commentLinesDensity
			info.commentLines = ret.commentLines
			info.duplicatedLinesDensity = ret.duplicatedLinesDensity
			info.duplicatedLines = ret.duplicatedLines
			info.duplicatedBlocks = ret.duplicatedBlocks
			info.duplicatedFiles = ret.duplicatedFiles
			info.functionComplexity = ret.functionComplexity
			info.classComplexity = ret.classComplexity
			info.fileComplexity = ret.fileComplexity
			info.complexity = ret.complexity
			info.violations = ret.violations
			info.technicalDebt = ret.technicalDebt
			info.blockerViolations = ret.blockerViolations
			info.criticalViolations = ret.criticalViolations
			info.majorViolations = ret.majorViolations
			info.minorViolations = ret.minorViolations
			info.infoViolations = ret.infoViolations
			info.packageTangleIndex = ret.packageTangleIndex
			info.packageCycles = ret.packageCycles
			info.packageFeedbackEdges = ret.packageFeedbackEdges
			info.packageTangles = ret.packageTangles
			info.coverage = ret.coverage
			info.lineCoverage = ret.lineCoverage
			info.branchCoverage = ret.branchCoverage
			info.testSuccessDensity = ret.testSuccessDensity
			info.testFailures = ret.testFailures
			info.testErrors = ret.testErrors
			info.tests = ret.tests
			info.testExecutionTime = ret.testExecutionTime
		]
		GithubRepositoryInfo.write(csvFile, infos.values)
	}

	def static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("Please specify one argument indicating a csv file for loading and saving results.")
			System.exit(-1)
		}

		val csvFile = new File(args.get(0))
		val executor = new SonarExecutor(csvFile, new File("repos"))
		executor.run()
	}
}
