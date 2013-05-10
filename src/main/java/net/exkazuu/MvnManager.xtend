package net.exkazuu

import java.io.File
import java.util.List

class MvnManager {
	Runtime rt
	
	new() {
		this.rt = Runtime::getRuntime
	}
	
	def readAllInputStream(Process p) {
		val ist = new InputStreamThread(p.getInputStream)
		ist.start
		p.waitFor
		ist.join
		
		return ist.getStringList
	}
	
	def List<String> test(String name) {
		val command = "cmd /c mvn test"
		val path = "C:\\Study\\" + name	
		val p = rt.exec(command, null, new File(path))
		val result = readAllInputStream(p)
		System::out.println(name + " testing...")
		
		clean(path)
		
		return result
	}
	
	def void clean(String path) {
		val file = new File(path)
		
		if(file.isFile) {
			file.delete
		} else {
			val files = file.listFiles
			for(f : files) {
				clean(f.getAbsolutePath)
			}
		}
	}
}