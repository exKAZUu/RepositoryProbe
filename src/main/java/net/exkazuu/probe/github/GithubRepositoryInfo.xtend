package net.exkazuu.probe.github

import com.google.common.base.Strings
import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.lang.reflect.Method
import java.util.ArrayList
import org.apache.commons.lang.StringUtils
import org.supercsv.cellprocessor.ParseDouble
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.io.CsvBeanWriter
import org.supercsv.prefs.CsvPreference

import static extension net.exkazuu.probe.extensions.XCollection.*

class GithubRepositoryInfo {
	val public static NONE = "-"

	static val methodNames = typeof(GithubRepositoryInfo).methods.map[it.name].toSet
	static val availableMethods = typeof(GithubRepositoryInfo).methods.filter [
		it.name.length > 3 && it.name.startsWith("get") && methodNames.contains("set" + it.name.substring(3))
	].filter [
		it.returnType == typeof(int) || it.returnType == typeof(double) || it.returnType == typeof(String)
	].sortBy [
		it.order
	].toArray(#[] as Method[])

	val static header = availableMethods.map[it.propertyName].toArrayList

	val static processors = availableMethods.map [
		if (it.returnType == typeof(int)) {
			new ParseInt()
		} else if (it.returnType == typeof(double)) {
			new ParseDouble()
		} else {
			null
		}
	].toArrayList

	def get(String propertyName) {
		this.class.getMethod("get" + StringUtils.capitalise(propertyName)).invoke(this)
	}

	def set(String propertyName, Object obj) {
		this.class.getMethod("set" + StringUtils.capitalise(propertyName)).invoke(this, obj)
	}

	// GitHub
	@Property String url = ""
	@Property String mainBranch = ""
	@Property String latestTag = ""
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

	// PIT (INVERT_NEGS)
	@Property int killedMutantCountWithINVERT_NEGS = -1
	@Property int generatedMutantCountWithINVERT_NEGS = -1
	@Property int killedMutantPercentageWithINVERT_NEGS = -1

	// PIT (RETURN_VALS)
	@Property int killedMutantCountWithRETURN_VALS = -1
	@Property int generatedMutantCountWithRETURN_VALS = -1
	@Property int killedMutantPercentageWithRETURN_VALS = -1

	// PIT (INLINE_CONSTS)
	@Property int killedMutantCountWithINLINE_CONSTS = -1
	@Property int generatedMutantCountWithINLINE_CONSTS = -1
	@Property int killedMutantPercentageWithINLINE_CONSTS = -1

	// PIT (MATH)
	@Property int killedMutantCountWithMATH = -1
	@Property int generatedMutantCountWithMATH = -1
	@Property int killedMutantPercentageWithMATH = -1

	// PIT (VOID_METHOD_CALLS)
	@Property int killedMutantCountWithVOID_METHOD_CALLS = -1
	@Property int generatedMutantCountWithVOID_METHOD_CALLS = -1
	@Property int killedMutantPercentageWithVOID_METHOD_CALLS = -1

	// PIT (NEGATE_CONDITIONALS)
	@Property int killedMutantCountWithNEGATE_CONDITIONALS = -1
	@Property int generatedMutantCountWithNEGATE_CONDITIONALS = -1
	@Property int killedMutantPercentageWithNEGATE_CONDITIONALS = -1

	// PIT (CONDITIONALS_BOUNDARY)
	@Property int killedMutantCountWithCONDITIONALS_BOUNDARY = -1
	@Property int generatedMutantCountWithCONDITIONALS_BOUNDARY = -1
	@Property int killedMutantPercentageWithCONDITIONALS_BOUNDARY = -1

	// PIT (INCREMENTS)
	@Property int killedMutantCountWithINCREMENTS = -1
	@Property int generatedMutantCountWithINCREMENTS = -1
	@Property int killedMutantPercentageWithINCREMENTS = -1

	// PIT (REMOVE_INCREMENTS)
	@Property int killedMutantCountWithREMOVE_INCREMENTS = -1
	@Property int generatedMutantCountWithREMOVE_INCREMENTS = -1
	@Property int killedMutantPercentageWithREMOVE_INCREMENTS = -1

	// PIT (NON_VOID_METHOD_CALLS)
	@Property int killedMutantCountWithNON_VOID_METHOD_CALLS = -1
	@Property int generatedMutantCountWithNON_VOID_METHOD_CALLS = -1
	@Property int killedMutantPercentageWithNON_VOID_METHOD_CALLS = -1

	// PIT (CONSTRUCTOR_CALLS)
	@Property int killedMutantCountWithCONSTRUCTOR_CALLS = -1
	@Property int generatedMutantCountWithCONSTRUCTOR_CALLS = -1
	@Property int killedMutantPercentageWithCONSTRUCTOR_CALLS = -1

	// PIT (REMOVE_CONDITIONALS_EQ_IF)
	@Property int killedMutantCountWithREMOVE_CONDITIONALS_EQ_IF = -1
	@Property int generatedMutantCountWithREMOVE_CONDITIONALS_EQ_IF = -1
	@Property int killedMutantPercentageWithREMOVE_CONDITIONALS_EQ_IF = -1

	// PIT (REMOVE_CONDITIONALS_EQ_ELSE)
	@Property int killedMutantCountWithREMOVE_CONDITIONALS_EQ_ELSE = -1
	@Property int generatedMutantCountWithREMOVE_CONDITIONALS_EQ_ELSE = -1
	@Property int killedMutantPercentageWithREMOVE_CONDITIONALS_EQ_ELSE = -1

	// PIT (REMOVE_CONDITIONALS_ORD_IF)
	@Property int killedMutantCountWithREMOVE_CONDITIONALS_ORD_IF = -1
	@Property int generatedMutantCountWithREMOVE_CONDITIONALS_ORD_IF = -1
	@Property int killedMutantPercentageWithREMOVE_CONDITIONALS_ORD_IF = -1

	// PIT (REMOVE_CONDITIONALS_ORD_ELSE)
	@Property int killedMutantCountWithREMOVE_CONDITIONALS_ORD_ELSE = -1
	@Property int generatedMutantCountWithREMOVE_CONDITIONALS_ORD_ELSE = -1
	@Property int killedMutantPercentageWithREMOVE_CONDITIONALS_ORD_ELSE = -1

	// PIT (REMOVE_CONDITIONALS)
	@Property int killedMutantCountWithREMOVE_CONDITIONALS = -1
	@Property int generatedMutantCountWithREMOVE_CONDITIONALS = -1
	@Property int killedMutantPercentageWithREMOVE_CONDITIONALS = -1

	// PIT (EXPERIMENTAL_MEMBER_VARIABLE)
	@Property int killedMutantCountWithEXPERIMENTAL_MEMBER_VARIABLE = -1
	@Property int generatedMutantCountWithEXPERIMENTAL_MEMBER_VARIABLE = -1
	@Property int killedMutantPercentageWithEXPERIMENTAL_MEMBER_VARIABLE = -1

	// PIT (EXPERIMENTAL_SWITCH)
	@Property int killedMutantCountWithEXPERIMENTAL_SWITCH = -1
	@Property int generatedMutantCountWithEXPERIMENTAL_SWITCH = -1
	@Property int killedMutantPercentageWithEXPERIMENTAL_SWITCH = -1

	// PIT (REMOVE_SWITCH)
	@Property int killedMutantCountWithREMOVE_SWITCH = -1
	@Property int generatedMutantCountWithREMOVE_SWITCH = -1
	@Property int killedMutantPercentageWithREMOVE_SWITCH = -1

	// PIT (DEFAULTS)
	@Property int killedMutantCountWithDEFAULTS = -1
	@Property int generatedMutantCountWithDEFAULTS = -1
	@Property int killedMutantPercentageWithDEFAULTS = -1

	// PIT (STRONGER)
	@Property int killedMutantCountWithSTRONGER = -1
	@Property int generatedMutantCountWithSTRONGER = -1
	@Property int killedMutantPercentageWithSTRONGER = -1

	// PIT (ALL)
	@Property int killedMutantCountWithALL = -1
	@Property int generatedMutantCountWithALL = -1
	@Property int killedMutantPercentageWithALL = -1

	//Sonar
	@Property int loc = -1
	@Property int lines = -1
	@Property int statements = -1
	@Property int files = -1
	@Property int directories = -1
	@Property int classes = -1
	@Property int packages = -1
	@Property int functions = -1
	@Property int accessors = -1
	@Property double publicDocumentedAPIDensity = -1 // 9
	@Property int publicAPI = -1
	@Property int publicUndocumentedAPI = -1
	@Property double commentLinesDensity = -1
	@Property int commentLines = -1
	@Property String duplicatedLinesDensity = ""
	@Property int duplicatedLines = -1 // 15-
	@Property int duplicatedBlocks = -1
	@Property int duplicatedFiles = -1
	@Property double functionComplexity = -1 // 18-
	@Property double classComplexity = -1
	@Property double fileComplexity = -1
	@Property double complexity = -1
	@Property int violations = -1 // 22
	@Property String technicalDebt = ""
	@Property int blockerViolations = -1 // 24
	@Property int criticalViolations = -1
	@Property int majorViolations = -1
	@Property int minorViolations = -1
	@Property int infoViolations = -1
	@Property double packageTangleIndex = -1 // 29
	@Property int packageCycles = -1 // 30-
	@Property int packageFeedbackEdges = -1
	@Property int packageTangles = -1
	@Property double coverage = -1 // 33-
	@Property double lineCoverage = -1
	@Property double branchCoverage = -1
	@Property double testSuccessDensity = -1
	@Property int testFailures = -1 // 37-
	@Property int testErrors = -1
	@Property int tests = -1
	@Property String testExecutionTime = "" // 40

	def isScrapedFromGitHub() {
		!(Strings.isNullOrEmpty(url) || Strings.isNullOrEmpty(mainBranch) || Strings.isNullOrEmpty(latestTag) ||
			Strings.isNullOrEmpty(latestCommitSha) || Strings.isNullOrEmpty(retrievedTime) || watchCount == -1 ||
			starCount == -1 || forkCount == -1 || commitCount == -1 || branchCount == -1 || releaseCount == -1 ||
			contributorCount == -1 || openIssueCount == -1 || closedIssueCount == -1 || openPullRequestCount == -1 ||
			closedPullRequestCount == -1 || searchResultCount == -1)
	}

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

	static var propertyDeclaration = ""

	static def getPropertyName(Method method) {
		method.name.substring(3, 4).toLowerCase + method.name.substring(4)
	}

	static def getOrder(Method method) {
		if (Strings.isNullOrEmpty(propertyDeclaration)) {
			propertyDeclaration = '''
				// GitHub
				@Property String url = ""
				@Property String mainBranch = ""
				@Property String latestTag = ""
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
				
				// PIT (INVERT_NEGS)
				@Property int killedMutantCountWithINVERT_NEGS = -1
				@Property int generatedMutantCountWithINVERT_NEGS = -1
				@Property int killedMutantPercentageWithINVERT_NEGS = -1
				
				// PIT (RETURN_VALS)
				@Property int killedMutantCountWithRETURN_VALS = -1
				@Property int generatedMutantCountWithRETURN_VALS = -1
				@Property int killedMutantPercentageWithRETURN_VALS = -1
				
				// PIT (INLINE_CONSTS)
				@Property int killedMutantCountWithINLINE_CONSTS = -1
				@Property int generatedMutantCountWithINLINE_CONSTS = -1
				@Property int killedMutantPercentageWithINLINE_CONSTS = -1
				
				// PIT (MATH)
				@Property int killedMutantCountWithMATH = -1
				@Property int generatedMutantCountWithMATH = -1
				@Property int killedMutantPercentageWithMATH = -1
				
				// PIT (VOID_METHOD_CALLS)
				@Property int killedMutantCountWithVOID_METHOD_CALLS = -1
				@Property int generatedMutantCountWithVOID_METHOD_CALLS = -1
				@Property int killedMutantPercentageWithVOID_METHOD_CALLS = -1
				
				// PIT (NEGATE_CONDITIONALS)
				@Property int killedMutantCountWithNEGATE_CONDITIONALS = -1
				@Property int generatedMutantCountWithNEGATE_CONDITIONALS = -1
				@Property int killedMutantPercentageWithNEGATE_CONDITIONALS = -1
				
				// PIT (CONDITIONALS_BOUNDARY)
				@Property int killedMutantCountWithCONDITIONALS_BOUNDARY = -1
				@Property int generatedMutantCountWithCONDITIONALS_BOUNDARY = -1
				@Property int killedMutantPercentageWithCONDITIONALS_BOUNDARY = -1
				
				// PIT (INCREMENTS)
				@Property int killedMutantCountWithINCREMENTS = -1
				@Property int generatedMutantCountWithINCREMENTS = -1
				@Property int killedMutantPercentageWithINCREMENTS = -1
				
				// PIT (REMOVE_INCREMENTS)
				@Property int killedMutantCountWithREMOVE_INCREMENTS = -1
				@Property int generatedMutantCountWithREMOVE_INCREMENTS = -1
				@Property int killedMutantPercentageWithREMOVE_INCREMENTS = -1
				
				// PIT (NON_VOID_METHOD_CALLS)
				@Property int killedMutantCountWithNON_VOID_METHOD_CALLS = -1
				@Property int generatedMutantCountWithNON_VOID_METHOD_CALLS = -1
				@Property int killedMutantPercentageWithNON_VOID_METHOD_CALLS = -1
				
				// PIT (CONSTRUCTOR_CALLS)
				@Property int killedMutantCountWithCONSTRUCTOR_CALLS = -1
				@Property int generatedMutantCountWithCONSTRUCTOR_CALLS = -1
				@Property int killedMutantPercentageWithCONSTRUCTOR_CALLS = -1
				
				// PIT (REMOVE_CONDITIONALS_EQ_IF)
				@Property int killedMutantCountWithREMOVE_CONDITIONALS_EQ_IF = -1
				@Property int generatedMutantCountWithREMOVE_CONDITIONALS_EQ_IF = -1
				@Property int killedMutantPercentageWithREMOVE_CONDITIONALS_EQ_IF = -1
				
				// PIT (REMOVE_CONDITIONALS_EQ_ELSE)
				@Property int killedMutantCountWithREMOVE_CONDITIONALS_EQ_ELSE = -1
				@Property int generatedMutantCountWithREMOVE_CONDITIONALS_EQ_ELSE = -1
				@Property int killedMutantPercentageWithREMOVE_CONDITIONALS_EQ_ELSE = -1
				
				// PIT (REMOVE_CONDITIONALS_ORD_IF)
				@Property int killedMutantCountWithREMOVE_CONDITIONALS_ORD_IF = -1
				@Property int generatedMutantCountWithREMOVE_CONDITIONALS_ORD_IF = -1
				@Property int killedMutantPercentageWithREMOVE_CONDITIONALS_ORD_IF = -1
				
				// PIT (REMOVE_CONDITIONALS_ORD_ELSE)
				@Property int killedMutantCountWithREMOVE_CONDITIONALS_ORD_ELSE = -1
				@Property int generatedMutantCountWithREMOVE_CONDITIONALS_ORD_ELSE = -1
				@Property int killedMutantPercentageWithREMOVE_CONDITIONALS_ORD_ELSE = -1
				
				// PIT (REMOVE_CONDITIONALS)
				@Property int killedMutantCountWithREMOVE_CONDITIONALS = -1
				@Property int generatedMutantCountWithREMOVE_CONDITIONALS = -1
				@Property int killedMutantPercentageWithREMOVE_CONDITIONALS = -1
				
				// PIT (EXPERIMENTAL_MEMBER_VARIABLE)
				@Property int killedMutantCountWithEXPERIMENTAL_MEMBER_VARIABLE = -1
				@Property int generatedMutantCountWithEXPERIMENTAL_MEMBER_VARIABLE = -1
				@Property int killedMutantPercentageWithEXPERIMENTAL_MEMBER_VARIABLE = -1
				
				// PIT (EXPERIMENTAL_SWITCH)
				@Property int killedMutantCountWithEXPERIMENTAL_SWITCH = -1
				@Property int generatedMutantCountWithEXPERIMENTAL_SWITCH = -1
				@Property int killedMutantPercentageWithEXPERIMENTAL_SWITCH = -1
				
				// PIT (REMOVE_SWITCH)
				@Property int killedMutantCountWithREMOVE_SWITCH = -1
				@Property int generatedMutantCountWithREMOVE_SWITCH = -1
				@Property int killedMutantPercentageWithREMOVE_SWITCH = -1
				
				// PIT (DEFAULTS)
				@Property int killedMutantCountWithDEFAULTS = -1
				@Property int generatedMutantCountWithDEFAULTS = -1
				@Property int killedMutantPercentageWithDEFAULTS = -1
				
				// PIT (STRONGER)
				@Property int killedMutantCountWithSTRONGER = -1
				@Property int generatedMutantCountWithSTRONGER = -1
				@Property int killedMutantPercentageWithSTRONGER = -1
				
				// PIT (ALL)
				@Property int killedMutantCountWithALL = -1
				@Property int generatedMutantCountWithALL = -1
				@Property int killedMutantPercentageWithALL = -1
				
				//Sonar
				@Property int loc = -1
				@Property int lines = -1
				@Property int statements = -1
				@Property int files = -1
				@Property int directories = -1
				@Property int classes = -1
				@Property int packages = -1
				@Property int functions = -1
				@Property int accessors = -1
				@Property double publicDocumentedAPIDensity = -1 // 9
				@Property int publicAPI = -1
				@Property int publicUndocumentedAPI = -1
				@Property double commentLinesDensity = -1
				@Property int commentLines = -1
				@Property String duplicatedLinesDensity = ""
				@Property int duplicatedLines = -1 // 15-
				@Property int duplicatedBlocks = -1
				@Property int duplicatedFiles = -1
				@Property double functionComplexity = -1 // 18-
				@Property double classComplexity = -1
				@Property double fileComplexity = -1
				@Property double complexity = -1
				@Property int violations = -1 // 22
				@Property String technicalDebt = ""
				@Property int blockerViolations = -1 // 24
				@Property int criticalViolations = -1
				@Property int majorViolations = -1
				@Property int minorViolations = -1
				@Property int infoViolations = -1
				@Property double packageTangleIndex = -1 // 29
				@Property int packageCycles = -1 // 30-
				@Property int packageFeedbackEdges = -1
				@Property int packageTangles = -1
				@Property double coverage = -1 // 33-
				@Property double lineCoverage = -1
				@Property double branchCoverage = -1
				@Property double testSuccessDensity = -1
				@Property int testFailures = -1 // 37-
				@Property int testErrors = -1
				@Property int tests = -1
				@Property String testExecutionTime = "" // 40
			'''
		}
		propertyDeclaration.indexOf(" " + method.propertyName + " ")
	}
}
