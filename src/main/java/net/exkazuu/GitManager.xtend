package net.exkazuu

import java.io.File

class GitManager {
	private static GitManager gm
	private Runtime rt
	
	new() {
		this.rt = Runtime::getRuntime
	}
	
	def static GitManager getInstance() {
		if (gm == null) {
			gm = new GitManager();
		}
		return gm
	}
	
	def void clone(String address, String name) {
		val command = "git clone " + address + " C:\\Study\\" + name
		
		val p = rt.exec(command)
		p.waitFor
		
		System::out.println(name + " cloned!")
	}
	
	def Boolean test(String name) {
		val command = "cmd /c mvn test"
		val path = "C:\\Study\\" + name
		
		val p = rt.exec(command, null, new File(path))
		p.waitFor
		
		return true;
	}
}

