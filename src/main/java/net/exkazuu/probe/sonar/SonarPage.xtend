package net.exkazuu.probe.sonar

import java.util.List
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement

import static extension net.exkazuu.probe.extensions.XWebElement.*
import net.exkazuu.probe.github.GithubRepositoryInfo

class SonarPage {
	var WebDriver driver
	
	new(WebDriver driver) {
		this.driver = driver
	}

	def updateInformation(GithubRepositoryInfo info) {
		val newinfo = info
		
		newinfo.loc = loc
		newinfo.lines = lines
		newinfo.statements = statements
		newinfo.files = files
		newinfo.directories = directories
		newinfo.classes = classes
		newinfo.packages = packages
		newinfo.functions = functions
		newinfo.accessors = accessors
		newinfo.publicDocumentedAPIDensity = publicDocumentedAPIDensity
		newinfo.publicAPI = publicAPI
		newinfo.publicUndocumentedAPI = publicUndocumentedAPI
		newinfo.commentLinesDensity = commentLinesDensity
		newinfo.commentLines = commentLines
		newinfo.duplicatedLinesDensity = duplicatedLinesDensity
		newinfo.duplicatedLines = duplicatedLines
		newinfo.duplicatedBlocks = duplicatedBlocks
		newinfo.duplicatedFiles = duplicatedFiles
		newinfo.functionComplexity = functionComplexity
		newinfo.classComplexity = classComplexity
		newinfo.fileComplexity = fileComplexity
		newinfo.complexity = complexity
		newinfo.violations = violations
		newinfo.technicalDebt = technicalDebt
		newinfo.blockerViolations = blockerViolations
		newinfo.criticalViolations = criticalViolations
		newinfo.majorViolations = majorViolations
		newinfo.minorViolations = minorViolations
		newinfo.infoViolations = infoViolations
		newinfo.packageTangleIndex = packageTangleIndex
		newinfo.packageCycles = packageCycles
		newinfo.packageFeedbackEdges = packageFeedbackEdges
		newinfo.packageTangles = packageTangles
		newinfo.coverage = coverage
		newinfo.lineCoverage = lineCoverage
		newinfo.branchCoverage = branchCoverage
		newinfo.testSuccessDensity = testSuccessDensity
		newinfo.testFailures = testFailures
		newinfo.testErrors = testErrors
		newinfo.tests = tests
		newinfo.testExecutionTime = testExecutionTime
		
		newinfo
	}
	
	private def getElementsById(String id) {
		val elements = driver.findElements(By.xpath('//span[@id="' + id + '"]'))
		elements
	}
	
	private def convertFirstElementToInteger(List<WebElement> elements) {
		if(elements.size > 0) {
			elements.get(0).extractInteger
		} else {
			-1
		}
	}
	
	private def convertFirstElementToDecimal(List<WebElement> elements) {
		if(elements.size > 0) {
			Double.parseDouble(elements.get(0).text)
		} else {
			-1.0
		}
	}
	
	private def convertFirstPercentageElementToDecimal(List<WebElement> elements) {
		if(elements.size > 0) {
			val text = elements.get(0).text
			Double.parseDouble(elements.get(0).text.substring(0, text.length-1))
		} else {
			-1.0
		}
	}	
	
	private def getIntegerValueOfElementById(String id) {
		val elements = getElementsById(id)
		convertFirstElementToInteger(elements)
	}
	
	private def getDecimalValueOfElementById(String id) {
		val elements = getElementsById(id)
		convertFirstElementToDecimal(elements)
	}
	
	private def getPercentageDecimalValueOfElementById(String id) {
		val elements = getElementsById(id)
		convertFirstPercentageElementToDecimal(elements)
	}
	
	
	private def getLoc() {
		getIntegerValueOfElementById("m_ncloc")
	}
	
	private def getLines() {
		getIntegerValueOfElementById("m_lines")
	}
	
	private def getStatements() {
		getIntegerValueOfElementById("m_statements")
	}

	private def getFiles() {
		getIntegerValueOfElementById("m_files")
	}
	
	private def getDirectories() {
		getIntegerValueOfElementById("m_directories")
	}
	
	private def getClasses() {
		getIntegerValueOfElementById("m_classes")
	}
	
	/**
	 * existing in 4.0.0
	 */
	private def getPackages() {
		getIntegerValueOfElementById("m_packeages")
	}
	
	private def getFunctions() {
		getIntegerValueOfElementById("m_functions")
	}
	
	private def getAccessors() {
		getIntegerValueOfElementById("m_accessors")
	}
	
	/**
	 * existing in 4.0.0
	 */
	private def getPublicDocumentedAPIDensity() {
		getDecimalValueOfElementById("m_public_documented_api_density")
	}
	
	/**
	 * existing in 4.0.0
	 */
	private def getPublicAPI() {
		getIntegerValueOfElementById("m_public_api")
	}
	
	/**
	 * existing in 4.0.0
	 */
	private def getPublicUndocumentedAPI() {
		getIntegerValueOfElementById("m_public_undocumented_API")
	}
	
	/**
	 * existing in 4.0.0
	 */
	private def getCommentLinesDensity() {
		getDecimalValueOfElementById("m_commnet_lines_density")
	}
	
	/**
	 * existing in 4.0.0
	 */
	private def getCommentLines() {
		getIntegerValueOfElementById("m_comment_lines")
	}
	
	//TODO: trim '%'
	private def getDuplicatedLinesDensity() {
		val elements = getElementsById("m_duplicated_lines_density")
		if(elements.size > 0) {
			elements.get(0).text
		} else {
			null
		}
	}
	
	private def getDuplicatedLines() {
		getIntegerValueOfElementById("m_duplicated_lines")
	}
	
	private def getDuplicatedBlocks() {
		getIntegerValueOfElementById("m_duplicated_blocks")
	}
	
	private def getDuplicatedFiles() {
		getIntegerValueOfElementById("m_duplicated_files")
	}
	
	private def getFunctionComplexity() {
		getDecimalValueOfElementById("m_function_complexity")
	}
	
	private def getClassComplexity() {
		getDecimalValueOfElementById("m_class_complexity")
	}
	
	private def getFileComplexity() {
		getDecimalValueOfElementById("m_file_complexity")	
	}
	
	private def getComplexity() {
		getDecimalValueOfElementById("m_complexity")
	}
	
	private def getViolations() {
		getIntegerValueOfElementById("m_violations")
	}
	
	//TODO: convert string to time value (hour?)
	private def getTechnicalDebt() {
		val elements = getElementsById("m_sqale_index")
		if(elements.size > 0) {
			elements.get(0).text
		} else {
			null
		}		
	}
	
	private def getBlockerViolations() {
		getIntegerValueOfElementById("m_blocker_violations")
	}
	
	private def getCriticalViolations() {
		getIntegerValueOfElementById("m_critical_violations")
	}
	
	private def getMajorViolations() {
		getIntegerValueOfElementById("m_major_violations")
	}
	
	private def getMinorViolations() {
		getIntegerValueOfElementById("m_minor_violations")
	}
	
	private def getInfoViolations() {
		getIntegerValueOfElementById("m_info_violations")
	}
	
	private def getPackageTangleIndex() {
		getPercentageDecimalValueOfElementById("m_package_tangle_index")
	}
	
	def getPackageCycles() {
		getIntegerValueOfElementById("m_package_cycles")
	}
	
	private def getPackageFeedbackEdges() {
		getIntegerValueOfElementById("m_package_feedback_edges")
	}
	
	private def getPackageTangles() {
		getIntegerValueOfElementById("m_package_tabgles")
	}
	
	private def getCoverage() {
		getPercentageDecimalValueOfElementById("m_coverage")
	}
	
	private def getLineCoverage() {
		getPercentageDecimalValueOfElementById("m_line_coverage")
	}
	
	private def getBranchCoverage() {
		getPercentageDecimalValueOfElementById("m_branch_coverage")
	}
	
	private def getTestSuccessDensity() {
		getPercentageDecimalValueOfElementById("m_test_success_density")
	}
	
	private def getTestFailures() {
		getIntegerValueOfElementById("m_test_failures")
	}
	
	private def getTestErrors() {
		getIntegerValueOfElementById("m_test_errors")
	}
	
	private def getTests() {
		getIntegerValueOfElementById("m_tests")
	}
	
	//TODO: convert string to time value (sec?)
	private def getTestExecutionTime() {
		val elements = getElementsById("m_test_execution_time")
		if(elements.size > 0) {
			elements.get(0).text
		} else {
			null
		}
	}
}
