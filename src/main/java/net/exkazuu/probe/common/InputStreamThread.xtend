package net.exkazuu.probe.common

import java.io.BufferedReader
import java.io.InputStream
import java.io.InputStreamReader
import java.util.ArrayList
import java.util.List

class InputStreamThread extends Thread {
	val BufferedReader br
	val List<String> list = new ArrayList<String>
	public var boolean stopped = false

	new(InputStream is) {
		br = new BufferedReader(new InputStreamReader(is))
	}

	override void run() {
		var line = new String
		while (!stopped && (line = br.readLine) != null) {
			list.add(line)
		}
		br.close
	}

	def List<String> getStringList() {
		return list
	}
}
