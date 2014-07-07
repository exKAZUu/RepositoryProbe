package net.exkazuu.probe.git

import java.io.File
import org.eclipse.jgit.api.CreateBranchCommand
import org.eclipse.jgit.api.Git
import org.eclipse.jgit.lib.RepositoryCache
import org.eclipse.jgit.util.FS

class GitManager {
	val File directory

	new(File directory) {
		this.directory = directory
	}
	
	def cloneSpecifiedBranch(String url, String branchName) {
		if (RepositoryCache.FileKey.isGitRepository(directory, FS.DETECTED)) {
			// Already cloned. Just need to open a repository here.
		} else {
			val git = Git.cloneRepository().setURI(url).setDirectory(directory.parentFile).call();
			git.checkout().setCreateBranch(true).setName("branchName").setUpstreamMode(
				CreateBranchCommand.SetupUpstreamMode.TRACK).setStartPoint("origin/" + branchName).call()
		}
	}	
}