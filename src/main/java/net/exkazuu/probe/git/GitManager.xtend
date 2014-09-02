package net.exkazuu.probe.git

import java.io.File
import org.apache.commons.io.FileUtils
import org.eclipse.jgit.api.Git
import org.eclipse.jgit.api.ResetCommand
import org.eclipse.jgit.lib.RepositoryCache
import org.eclipse.jgit.util.FS

import static extension net.exkazuu.probe.extensions.XProcess.*

class GitManager {
	val File directory

	new(File directory) {
		this.directory = directory
	}

	def getDirectoryPath() {
		directory.absolutePath
	}

	def cloneAndCheckout(String url, String masterBranch, String branchName) {
		val gitDirectory = new File(directory, ".git");
		val files = directory.list()
		if (files != null && files.size <= 1) {
			FileUtils.deleteDirectory(directory)
			directory.mkdirs()
		}
		if (RepositoryCache.FileKey.isGitRepository(gitDirectory, FS.DETECTED)) {

			// Already cloned. Just need to open a repository here.
			val git = Git.open(gitDirectory)
			git.reset.setMode(ResetCommand.ResetType.HARD).call()
			git.checkout.setName(masterBranch).call()
			//git.pull.call()
			git.checkout.setName(branchName).call()
		} else {
			val git = Git.cloneRepository.setURI(url).setDirectory(directory).call();
			git.checkout.setName(branchName).call()
		}
	}

	/**
	 * Shallow clone by executing the original Git directly.
	 */
	def cloneShallowly(String url, String userAndRepoName, int depth) {
		val command = "git clone " + url + " " + directory + "/" + userAndRepoName + " --depth " + depth
		val p = Runtime.runtime.exec(command)
		p.readAllOutputsIgnoringErrors
	}
}
