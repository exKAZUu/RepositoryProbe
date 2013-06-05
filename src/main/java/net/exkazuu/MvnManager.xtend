package net.exkazuu

import java.io.File
import java.util.List
import static extension net.exkazuu.ProcessExtensions.*
import java.util.ArrayList
import java.io.FileReader
import java.io.BufferedReader

class MvnManager {
	Runtime rt
	String root
	
	new(String root) {
		this.rt = Runtime::getRuntime
		this.root = root
	}
	
	def List<String> test(String name) {
		val command = "cmd /c mvn test"
		val path = root + "\\" + name	
		val p = rt.exec(command, null, new File(path))
		val result = p.readInputStreamIgnoringErrors()
		System::out.println(name + " testing...")
		
		return result
	}
	
	def delete(String name) {
		val path = root + "\\" + name
		val dir = new File(path)
		System::out.println(name + " deleting...")
		clean(path)
		
		return !dir.exists
	}
	
	def void clean(String path) {
		val file = new File(path)
		
		if(file.isFile) {
			file.delete
		} else if(file.isDirectory) {
			val files = file.listFiles
			for(f : files) {
				clean(f.getAbsolutePath)
			}
			file.delete
		}
	}
	
	def List<String> searchTestMethod(String path) {
		val result = new ArrayList<String>		
		val file = new File(path)
		
		if(file.isFile) {
			val fr = new FileReader(file)
			val br = new BufferedReader(fr)
			
			var str = br.readLine
			while(str != null) {
				if(str.contains("@Test")) {
					str = br.readLine
					val strs = str.split(" ")	
				
					for(s : strs) {
						if(s.contains("()")) {
							val methodName = s.substring(0, s.length-2)
							result += file.getAbsolutePath + "\\" + methodName
						}
					}
				}
				
				str = br.readLine
			}
		} else {
			val files = file.listFiles
			for(f : files) {
				result += searchTestMethod(f.getAbsolutePath)
			}
		}
		
		return result
	}
	
	def List<String> getTestMethodRelativePath(String path, String name) {
		val result = new ArrayList<String>
		val file = new File(path)
		
		if(file.isFile) {
			val fr = new FileReader(file)
			val br = new BufferedReader(fr)
			
			var str = br.readLine
			while(str != null) {
				if(str.contains("@Test")) {
					str = br.readLine
					val strs = str.split(" ")
					
					for(s : strs) {
						if(s.contains("()")) {
							val methodName = s.substring(0, s.length-2)
							val absolutePath = file.getAbsolutePath + "\\" + methodName
							val home = root + "\\" + name
							result += absolutePath.substring(home.length+1, absolutePath.length)
						}
					}
				}
				str = br.readLine
			}
		} else {
			val files = file.listFiles
			for(f : files) {
				result += getTestMethodRelativePath(f.getAbsolutePath, name)
			}
		}
		
		return result		
	}
}