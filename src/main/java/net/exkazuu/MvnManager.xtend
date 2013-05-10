package net.exkazuu

import java.io.File
import java.util.List
import static extension net.exkazuu.ProcessExtensions.*

class MvnManager {
	
	Runtime rt
	
	new() {
		this.rt = Runtime::getRuntime
	}
	
	def List<String> test(String name) {
		val command = "cmd /c mvn test"
		val path = "C:\\Study\\" + name	
		val p = rt.exec(command, null, new File(path))
		val result = p.readInputStreamIgnoringErrors()
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