package net.exkazuu.probe

import java.io.File
import net.exkazuu.probe.git.GitManager

class GitTester {
	static def void main(String[] args) {
		val git = new GitManager(new File("repos/FizzBuzz"))
		val branchName = "origin/development"
		val url = "https://github.com/exKAZUu/FizzBuzz.git"
		git.cloneAndCheckout(url, "master", branchName)
	}
}
