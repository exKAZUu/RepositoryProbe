package net.exkazuu.probe.extensions

import java.util.List
import com.google.common.collect.Lists

class XCollection {
	def static <T> getOr(T[] array, int index, T defaultValue) {
		if (0 <= index && index < array.size)
			array.get(index)
		else
			defaultValue
	}

	def static <T> getOrNull(T[] array, int index) {
		if (0 <= index && index < array.size)
			array.get(index)
	}

	def static <T> getOr(List<T> array, int index, T defaultValue) {
		if (0 <= index && index < array.size)
			array.get(index)
		else
			defaultValue
	}

	def static <T> getOrNull(List<T> array, int index) {
		if (0 <= index && index < array.size)
			array.get(index)
	}
	
	def static <T> toArrayList(Iterable<T> elements) {
		Lists.newArrayList(elements)
	}
}
