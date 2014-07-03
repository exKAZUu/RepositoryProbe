package net.exkazuu.probe.maven

import java.util.List
import org.openqa.selenium.By
import org.openqa.selenium.WebDriver
import org.openqa.selenium.WebElement

import static extension net.exkazuu.probe.extensions.XWebElement.*

class SonarPage {
	var WebDriver driver

	def getInformation() {
		val info = new SonarInfo()
		info.loc = loc
		info.lines = lines
		info.statements = statements
		info.files = files
		info.directories = directories
		info.classes = classes
		info.packages = packages
		info.functions = functions
		info.accessors = accessors
		info.publicDocumentedAPIDensity = publicDocumentedAPIDensity
		info.publicAPI = publicAPI
		info.publicUndocumtnedAPI = publicUndocumentedAPI
		info.commentLinesDensity = commentLinesDensity
		info.commentLines = commentLines
		info.duplicatedLinesDensity = duplicatedLinesDensity
		info.duplicatedLines = duplicatedLines
		info.duplicatedBlocks = duplicatedBlocks
		info.duplicatedFiles = duplicatedFiles
		info.functionComplexity = functionComplexity
		info.classComplexity = classComplexity
		info.fileComplexity = fileComplexity
		info.complexity = complexity
		info.violations = violations
		info.technicalDebt = technicalDebt
		info.blockerViolations = blockerViolations
		info.criticalViolations = criticalViolations
		info.majorViolations = majorViolations
		info.minorViolations = minorViolations
		info.infoViolations = infoViolations
		info.packageTangleIndex = packageTangleIndex
		info.packageCycles = packageCycles
		info.packageFeedbackEdges = packageFeedbackEdges
		info.packageTangles = packageTangles
		info.coverage = coverage
		info.lineCoverage = lineCoverage
		info.branchCoverage = branchCoverage
		info.testSuccessDensity = testSuccessDensity
		info.testFailures = testFailures
		info.testErrors = testErrors
		info.tests = tests
		info.testExecutionTime = testExecutionTime
	}
	
	private def getElementsById(String id) {
		val elements = driver.findElements(By.xpath('//span[@id=' + id + ']'))
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
	
	private def getIntegerValueOfElementById(String id) {
		val elements = getElementsById(id)
		convertFirstElementToInteger(elements)
	}
	
	private def getDecimalValueOfElementById(String id) {
		val elements = getElementsById(id)
		convertFirstElementToDecimal(elements)
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
	 * 4.0.0
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
	 * 4.0.0
	 */
	private def getPublicDocumentedAPIDensity() {
		getDecimalValueOfElementById("m_public_documented_api_density")
	}
	
	/**
	 * 4.0.0
	 */
	private def getPublicAPI() {
		getIntegerValueOfElementById("m_public_api")
	}
	
	/**
	 * 4.0.0
	 */
	private def getPublicUndocumentedAPI() {
		getIntegerValueOfElementById("m_public_undocumented_API")
	}
	
	/**
	 * 4.0.0
	 */
	private def getCommentLinesDensity() {
		getDecimalValueOfElementById("m_commnet_lines_density")
	}
	
	/**
	 * 4.0.0
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
		getDecimalValueOfElementById("m_package_tangle_index")
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
		getDecimalValueOfElementById("m_coverage")
	}
	
	private def getLineCoverage() {
		getDecimalValueOfElementById("m_line_coverage")
	}
	
	private def getBranchCoverage() {
		getDecimalValueOfElementById("m_branch_coverage")
	}
	
	private def getTestSuccessDensity() {
		getDecimalValueOfElementById("m_test_success_density")
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
