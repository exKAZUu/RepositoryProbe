package net.exkazuu.probe

import java.io.File
import java.util.Map
import net.exkazuu.probe.github.GithubRepositoryInfo
import net.exkazuu.probe.maven.MavenManager
import net.exkazuu.probe.maven.PitManager
import org.eclipse.jgit.api.Git

/**
 * A class for measuring mutation scores by executing PIT.
 * 
 * @author Kazunori Sakamoto
 */
class PitExecutor {
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
			Git.cloneRepository().setURI(url).setDirectory(userDir).call();
			val projectDir = new File(userDir.path, info.projectName)
			val ret = new PitManager(new MavenManager(projectDir)).execute
			info.generatedMutantCount = ret.get(0)
			info.killedMutantCount = ret.get(1)
			info.killedMutantPercentage = ret.get(2)
		]
		GithubRepositoryInfo.write(csvFile, infos.values)
	}

	def static void main(String[] args) {
		if (args.length != 1) {
			System.out.println("Please specify one argument indicating a csv file for loading and saving results.")
			System.exit(-1)
		}

		val csvFile = new File(args.get(0))
		val executor = new PitExecutor(csvFile, new File("repos"))
		executor.run()
	}
}
