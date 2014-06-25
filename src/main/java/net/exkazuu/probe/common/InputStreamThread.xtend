package net.exkazuu.probe.common

import java.io.BufferedReader
import java.io.InputStream
import java.io.InputStreamReader
import java.util.ArrayList
import java.util.List

class InputStreamThread extends Thread {
	BufferedReader br
	List<String> list = new ArrayList<String>

	new(InputStream is) {
		br = new BufferedReader(new InputStreamReader(is))
	}

	override void run() {
		var line = new String
		while ((line = br.readLine) != null) {
			list.add(line)
		}
	}

	def List<String> getStringList() {
		return list
	}
}
