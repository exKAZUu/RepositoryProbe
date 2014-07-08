package net.exkazuu.probe.git

import java.io.File
import org.eclipse.jgit.api.CreateBranchCommand
import org.eclipse.jgit.api.Git
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

	def cloneSpecifiedBranch(String url, String branchName) {
		if (RepositoryCache.FileKey.isGitRepository(directory, FS.DETECTED)) {
			// Already cloned. Just need to open a repository here.
			Git.open(directory).checkout().setName(branchName).setUpstreamMode(
				CreateBranchCommand.SetupUpstreamMode.TRACK).setStartPoint("origin/" + branchName).call()
		} else {
			val git = Git.cloneRepository().setURI(url).setDirectory(directory.parentFile).call();
			git.checkout().setCreateBranch(true).setName(branchName).setUpstreamMode(
				CreateBranchCommand.SetupUpstreamMode.TRACK).setStartPoint("origin/" + branchName).call()
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
