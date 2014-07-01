package net.exkazuu.probe

import com.jcabi.github.Coordinates
import com.jcabi.github.RtGithub
import java.io.IOException

class ClosedPullRequestCounter {

	def static void main(String[] args) throws IOException {
		val github = new RtGithub()
		val repo = github.repos.get(new Coordinates.Simple("jcabi/jcabi-github"))
		
		repo.pulls.iterate.forEach [
			System.out.println(it.number)
		]
	}
}
