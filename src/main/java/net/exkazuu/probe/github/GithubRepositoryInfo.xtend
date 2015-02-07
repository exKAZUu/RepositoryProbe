package net.exkazuu.probe.github

import com.google.common.base.Strings
import java.io.File
import java.io.FileReader
import java.io.FileWriter
import java.lang.reflect.Method
import java.util.ArrayList
import org.apache.commons.lang.StringUtils
import org.eclipse.xtend.lib.annotations.Accessors
import org.supercsv.cellprocessor.ParseDouble
import org.supercsv.cellprocessor.ParseInt
import org.supercsv.io.CsvBeanReader
import org.supercsv.io.CsvBeanWriter
import org.supercsv.prefs.CsvPreference

import static extension net.exkazuu.probe.extensions.XCollection.*

class GithubRepositoryInfo {
	val public static NONE = "-"

	static val methodNames = typeof(GithubRepositoryInfo).methods.map[it.name].toSet
	static val availableGetters = typeof(GithubRepositoryInfo).methods.filter [
		it.name.length > 3 && it.name.startsWith("get") && methodNames.contains("set" + it.name.substring(3))
	].filter [
		it.returnType == typeof(int) || it.returnType == typeof(double) || it.returnType == typeof(String)
	].sortBy [
		it.order
	].toArray(#[] as Method[])

	val static header = availableGetters.map[it.propertyName].toArrayList

	val static processors = availableGetters.map [
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
		this.class.getMethod("set" + StringUtils.capitalise(propertyName), typeof(int)).invoke(this, obj)
	}

	// GitHub
	@Accessors String url = ""
	@Accessors String mainBranch = ""
	@Accessors String latestTag = ""
	@Accessors String latestCommitSha = ""
	@Accessors String retrievedTime = ""
	@Accessors int watchCount = -1
	@Accessors int starCount = -1
	@Accessors int forkCount = -1
	@Accessors int commitCount = -1
	@Accessors int branchCount = -1
	@Accessors int releaseCount = -1
	@Accessors int contributorCount = -1
	@Accessors int openIssueCount = -1
	@Accessors int closedIssueCount = -1
	@Accessors int openPullRequestCount = -1
	@Accessors int closedPullRequestCount = -1
	@Accessors int searchResultCount = -1

	// XMutator
	@Accessors int killedMutantCountWithXMutator = -1
	@Accessors int generatedMutantCountWithXMutator = -1
	@Accessors int killedMutantPercentageWithXMutator = -1

	// PIT (INVERT_NEGS)
	@Accessors int killedMutantCountWithINVERT_NEGS = -1
	@Accessors int generatedMutantCountWithINVERT_NEGS = -1
	@Accessors int killedMutantPercentageWithINVERT_NEGS = -1

	// PIT (RETURN_VALS)
	@Accessors int killedMutantCountWithRETURN_VALS = -1
	@Accessors int generatedMutantCountWithRETURN_VALS = -1
	@Accessors int killedMutantPercentageWithRETURN_VALS = -1

	// PIT (INLINE_CONSTS)
	@Accessors int killedMutantCountWithINLINE_CONSTS = -1
	@Accessors int generatedMutantCountWithINLINE_CONSTS = -1
	@Accessors int killedMutantPercentageWithINLINE_CONSTS = -1

	// PIT (MATH)
	@Accessors int killedMutantCountWithMATH = -1
	@Accessors int generatedMutantCountWithMATH = -1
	@Accessors int killedMutantPercentageWithMATH = -1

	// PIT (VOID_METHOD_CALLS)
	@Accessors int killedMutantCountWithVOID_METHOD_CALLS = -1
	@Accessors int generatedMutantCountWithVOID_METHOD_CALLS = -1
	@Accessors int killedMutantPercentageWithVOID_METHOD_CALLS = -1

	// PIT (NEGATE_CONDITIONALS)
	@Accessors int killedMutantCountWithNEGATE_CONDITIONALS = -1
	@Accessors int generatedMutantCountWithNEGATE_CONDITIONALS = -1
	@Accessors int killedMutantPercentageWithNEGATE_CONDITIONALS = -1

	// PIT (CONDITIONALS_BOUNDARY)
	@Accessors int killedMutantCountWithCONDITIONALS_BOUNDARY = -1
	@Accessors int generatedMutantCountWithCONDITIONALS_BOUNDARY = -1
	@Accessors int killedMutantPercentageWithCONDITIONALS_BOUNDARY = -1

	// PIT (INCREMENTS)
	@Accessors int killedMutantCountWithINCREMENTS = -1
	@Accessors int generatedMutantCountWithINCREMENTS = -1
	@Accessors int killedMutantPercentageWithINCREMENTS = -1

	// PIT (REMOVE_INCREMENTS)
	@Accessors int killedMutantCountWithREMOVE_INCREMENTS = -1
	@Accessors int generatedMutantCountWithREMOVE_INCREMENTS = -1
	@Accessors int killedMutantPercentageWithREMOVE_INCREMENTS = -1

	// PIT (NON_VOID_METHOD_CALLS)
	@Accessors int killedMutantCountWithNON_VOID_METHOD_CALLS = -1
	@Accessors int generatedMutantCountWithNON_VOID_METHOD_CALLS = -1
	@Accessors int killedMutantPercentageWithNON_VOID_METHOD_CALLS = -1

	// PIT (CONSTRUCTOR_CALLS)
	@Accessors int killedMutantCountWithCONSTRUCTOR_CALLS = -1
	@Accessors int generatedMutantCountWithCONSTRUCTOR_CALLS = -1
	@Accessors int killedMutantPercentageWithCONSTRUCTOR_CALLS = -1

	// PIT (REMOVE_CONDITIONALS_EQ_IF)
	@Accessors int killedMutantCountWithREMOVE_CONDITIONALS_EQ_IF = -1
	@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS_EQ_IF = -1
	@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS_EQ_IF = -1

	// PIT (REMOVE_CONDITIONALS_EQ_ELSE)
	@Accessors int killedMutantCountWithREMOVE_CONDITIONALS_EQ_ELSE = -1
	@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS_EQ_ELSE = -1
	@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS_EQ_ELSE = -1

	// PIT (REMOVE_CONDITIONALS_ORD_IF)
	@Accessors int killedMutantCountWithREMOVE_CONDITIONALS_ORD_IF = -1
	@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS_ORD_IF = -1
	@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS_ORD_IF = -1

	// PIT (REMOVE_CONDITIONALS_ORD_ELSE)
	@Accessors int killedMutantCountWithREMOVE_CONDITIONALS_ORD_ELSE = -1
	@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS_ORD_ELSE = -1
	@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS_ORD_ELSE = -1

	// PIT (REMOVE_CONDITIONALS)
	@Accessors int killedMutantCountWithREMOVE_CONDITIONALS = -1
	@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS = -1
	@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS = -1

	// PIT (EXPERIMENTAL_MEMBER_VARIABLE)
	@Accessors int killedMutantCountWithEXPERIMENTAL_MEMBER_VARIABLE = -1
	@Accessors int generatedMutantCountWithEXPERIMENTAL_MEMBER_VARIABLE = -1
	@Accessors int killedMutantPercentageWithEXPERIMENTAL_MEMBER_VARIABLE = -1

	// PIT (EXPERIMENTAL_SWITCH)
	@Accessors int killedMutantCountWithEXPERIMENTAL_SWITCH = -1
	@Accessors int generatedMutantCountWithEXPERIMENTAL_SWITCH = -1
	@Accessors int killedMutantPercentageWithEXPERIMENTAL_SWITCH = -1

	// PIT (REMOVE_SWITCH)
	@Accessors int killedMutantCountWithREMOVE_SWITCH = -1
	@Accessors int generatedMutantCountWithREMOVE_SWITCH = -1
	@Accessors int killedMutantPercentageWithREMOVE_SWITCH = -1

	// PIT (DEFAULTS)
	@Accessors int killedMutantCountWithDEFAULTS = -1
	@Accessors int generatedMutantCountWithDEFAULTS = -1
	@Accessors int killedMutantPercentageWithDEFAULTS = -1

	// PIT (STRONGER)
	@Accessors int killedMutantCountWithSTRONGER = -1
	@Accessors int generatedMutantCountWithSTRONGER = -1
	@Accessors int killedMutantPercentageWithSTRONGER = -1

	// PIT (ALL)
	@Accessors int killedMutantCountWithALL = -1
	@Accessors int generatedMutantCountWithALL = -1
	@Accessors int killedMutantPercentageWithALL = -1

	//Sonar
	@Accessors int loc = -1
	@Accessors int lines = -1
	@Accessors int statements = -1
	@Accessors int files = -1
	@Accessors int directories = -1
	@Accessors int classes = -1
	@Accessors int packages = -1
	@Accessors int functions = -1
	@Accessors int accessors = -1
	@Accessors double publicDocumentedAPIDensity = -1 // 9
	@Accessors int publicAPI = -1
	@Accessors int publicUndocumentedAPI = -1
	@Accessors double commentLinesDensity = -1
	@Accessors int commentLines = -1
	@Accessors String duplicatedLinesDensity = ""
	@Accessors int duplicatedLines = -1 // 15-
	@Accessors int duplicatedBlocks = -1
	@Accessors int duplicatedFiles = -1
	@Accessors double functionComplexity = -1 // 18-
	@Accessors double classComplexity = -1
	@Accessors double fileComplexity = -1
	@Accessors double complexity = -1
	@Accessors int violations = -1 // 22
	@Accessors String technicalDebt = ""
	@Accessors int blockerViolations = -1 // 24
	@Accessors int criticalViolations = -1
	@Accessors int majorViolations = -1
	@Accessors int minorViolations = -1
	@Accessors int infoViolations = -1
	@Accessors double packageTangleIndex = -1 // 29
	@Accessors int packageCycles = -1 // 30-
	@Accessors int packageFeedbackEdges = -1
	@Accessors int packageTangles = -1
	@Accessors double coverage = -1 // 33-
	@Accessors double lineCoverage = -1
	@Accessors double branchCoverage = -1
	@Accessors double testSuccessDensity = -1
	@Accessors int testFailures = -1 // 37-
	@Accessors int testErrors = -1
	@Accessors int tests = -1
	@Accessors String testExecutionTime = "" // 40

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
				@Accessors String url = ""
				@Accessors String mainBranch = ""
				@Accessors String latestTag = ""
				@Accessors String latestCommitSha = ""
				@Accessors String retrievedTime = ""
				@Accessors int watchCount = -1
				@Accessors int starCount = -1
				@Accessors int forkCount = -1
				@Accessors int commitCount = -1
				@Accessors int branchCount = -1
				@Accessors int releaseCount = -1
				@Accessors int contributorCount = -1
				@Accessors int openIssueCount = -1
				@Accessors int closedIssueCount = -1
				@Accessors int openPullRequestCount = -1
				@Accessors int closedPullRequestCount = -1
				@Accessors int searchResultCount = -1
				
				// XMutator
				@Accessors int killedMutantCountWithXMutator = -1
				@Accessors int generatedMutantCountWithXMutator = -1
				@Accessors int killedMutantPercentageWithXMutator = -1
				
				// PIT (INVERT_NEGS)
				@Accessors int killedMutantCountWithINVERT_NEGS = -1
				@Accessors int generatedMutantCountWithINVERT_NEGS = -1
				@Accessors int killedMutantPercentageWithINVERT_NEGS = -1
				
				// PIT (RETURN_VALS)
				@Accessors int killedMutantCountWithRETURN_VALS = -1
				@Accessors int generatedMutantCountWithRETURN_VALS = -1
				@Accessors int killedMutantPercentageWithRETURN_VALS = -1
				
				// PIT (INLINE_CONSTS)
				@Accessors int killedMutantCountWithINLINE_CONSTS = -1
				@Accessors int generatedMutantCountWithINLINE_CONSTS = -1
				@Accessors int killedMutantPercentageWithINLINE_CONSTS = -1
				
				// PIT (MATH)
				@Accessors int killedMutantCountWithMATH = -1
				@Accessors int generatedMutantCountWithMATH = -1
				@Accessors int killedMutantPercentageWithMATH = -1
				
				// PIT (VOID_METHOD_CALLS)
				@Accessors int killedMutantCountWithVOID_METHOD_CALLS = -1
				@Accessors int generatedMutantCountWithVOID_METHOD_CALLS = -1
				@Accessors int killedMutantPercentageWithVOID_METHOD_CALLS = -1
				
				// PIT (NEGATE_CONDITIONALS)
				@Accessors int killedMutantCountWithNEGATE_CONDITIONALS = -1
				@Accessors int generatedMutantCountWithNEGATE_CONDITIONALS = -1
				@Accessors int killedMutantPercentageWithNEGATE_CONDITIONALS = -1
				
				// PIT (CONDITIONALS_BOUNDARY)
				@Accessors int killedMutantCountWithCONDITIONALS_BOUNDARY = -1
				@Accessors int generatedMutantCountWithCONDITIONALS_BOUNDARY = -1
				@Accessors int killedMutantPercentageWithCONDITIONALS_BOUNDARY = -1
				
				// PIT (INCREMENTS)
				@Accessors int killedMutantCountWithINCREMENTS = -1
				@Accessors int generatedMutantCountWithINCREMENTS = -1
				@Accessors int killedMutantPercentageWithINCREMENTS = -1
				
				// PIT (REMOVE_INCREMENTS)
				@Accessors int killedMutantCountWithREMOVE_INCREMENTS = -1
				@Accessors int generatedMutantCountWithREMOVE_INCREMENTS = -1
				@Accessors int killedMutantPercentageWithREMOVE_INCREMENTS = -1
				
				// PIT (NON_VOID_METHOD_CALLS)
				@Accessors int killedMutantCountWithNON_VOID_METHOD_CALLS = -1
				@Accessors int generatedMutantCountWithNON_VOID_METHOD_CALLS = -1
				@Accessors int killedMutantPercentageWithNON_VOID_METHOD_CALLS = -1
				
				// PIT (CONSTRUCTOR_CALLS)
				@Accessors int killedMutantCountWithCONSTRUCTOR_CALLS = -1
				@Accessors int generatedMutantCountWithCONSTRUCTOR_CALLS = -1
				@Accessors int killedMutantPercentageWithCONSTRUCTOR_CALLS = -1
				
				// PIT (REMOVE_CONDITIONALS_EQ_IF)
				@Accessors int killedMutantCountWithREMOVE_CONDITIONALS_EQ_IF = -1
				@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS_EQ_IF = -1
				@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS_EQ_IF = -1
				
				// PIT (REMOVE_CONDITIONALS_EQ_ELSE)
				@Accessors int killedMutantCountWithREMOVE_CONDITIONALS_EQ_ELSE = -1
				@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS_EQ_ELSE = -1
				@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS_EQ_ELSE = -1
				
				// PIT (REMOVE_CONDITIONALS_ORD_IF)
				@Accessors int killedMutantCountWithREMOVE_CONDITIONALS_ORD_IF = -1
				@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS_ORD_IF = -1
				@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS_ORD_IF = -1
				
				// PIT (REMOVE_CONDITIONALS_ORD_ELSE)
				@Accessors int killedMutantCountWithREMOVE_CONDITIONALS_ORD_ELSE = -1
				@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS_ORD_ELSE = -1
				@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS_ORD_ELSE = -1
				
				// PIT (REMOVE_CONDITIONALS)
				@Accessors int killedMutantCountWithREMOVE_CONDITIONALS = -1
				@Accessors int generatedMutantCountWithREMOVE_CONDITIONALS = -1
				@Accessors int killedMutantPercentageWithREMOVE_CONDITIONALS = -1
				
				// PIT (EXPERIMENTAL_MEMBER_VARIABLE)
				@Accessors int killedMutantCountWithEXPERIMENTAL_MEMBER_VARIABLE = -1
				@Accessors int generatedMutantCountWithEXPERIMENTAL_MEMBER_VARIABLE = -1
				@Accessors int killedMutantPercentageWithEXPERIMENTAL_MEMBER_VARIABLE = -1
				
				// PIT (EXPERIMENTAL_SWITCH)
				@Accessors int killedMutantCountWithEXPERIMENTAL_SWITCH = -1
				@Accessors int generatedMutantCountWithEXPERIMENTAL_SWITCH = -1
				@Accessors int killedMutantPercentageWithEXPERIMENTAL_SWITCH = -1
				
				// PIT (REMOVE_SWITCH)
				@Accessors int killedMutantCountWithREMOVE_SWITCH = -1
				@Accessors int generatedMutantCountWithREMOVE_SWITCH = -1
				@Accessors int killedMutantPercentageWithREMOVE_SWITCH = -1
				
				// PIT (DEFAULTS)
				@Accessors int killedMutantCountWithDEFAULTS = -1
				@Accessors int generatedMutantCountWithDEFAULTS = -1
				@Accessors int killedMutantPercentageWithDEFAULTS = -1
				
				// PIT (STRONGER)
				@Accessors int killedMutantCountWithSTRONGER = -1
				@Accessors int generatedMutantCountWithSTRONGER = -1
				@Accessors int killedMutantPercentageWithSTRONGER = -1
				
				// PIT (ALL)
				@Accessors int killedMutantCountWithALL = -1
				@Accessors int generatedMutantCountWithALL = -1
				@Accessors int killedMutantPercentageWithALL = -1
				
				//Sonar
				@Accessors int loc = -1
				@Accessors int lines = -1
				@Accessors int statements = -1
				@Accessors int files = -1
				@Accessors int directories = -1
				@Accessors int classes = -1
				@Accessors int packages = -1
				@Accessors int functions = -1
				@Accessors int accessors = -1
				@Accessors double publicDocumentedAPIDensity = -1 // 9
				@Accessors int publicAPI = -1
				@Accessors int publicUndocumentedAPI = -1
				@Accessors double commentLinesDensity = -1
				@Accessors int commentLines = -1
				@Accessors String duplicatedLinesDensity = ""
				@Accessors int duplicatedLines = -1 // 15-
				@Accessors int duplicatedBlocks = -1
				@Accessors int duplicatedFiles = -1
				@Accessors double functionComplexity = -1 // 18-
				@Accessors double classComplexity = -1
				@Accessors double fileComplexity = -1
				@Accessors double complexity = -1
				@Accessors int violations = -1 // 22
				@Accessors String technicalDebt = ""
				@Accessors int blockerViolations = -1 // 24
				@Accessors int criticalViolations = -1
				@Accessors int majorViolations = -1
				@Accessors int minorViolations = -1
				@Accessors int infoViolations = -1
				@Accessors double packageTangleIndex = -1 // 29
				@Accessors int packageCycles = -1 // 30-
				@Accessors int packageFeedbackEdges = -1
				@Accessors int packageTangles = -1
				@Accessors double coverage = -1 // 33-
				@Accessors double lineCoverage = -1
				@Accessors double branchCoverage = -1
				@Accessors double testSuccessDensity = -1
				@Accessors int testFailures = -1 // 37-
				@Accessors int testErrors = -1
				@Accessors int tests = -1
				@Accessors String testExecutionTime = "" // 40
			'''
		}
		propertyDeclaration.indexOf(" " + method.propertyName + " ")
	}
}
