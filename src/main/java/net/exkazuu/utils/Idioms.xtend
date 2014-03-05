package net.exkazuu.utils

class Idioms {
	def static <T> retry(Functions.Function0<T> func, int count) {
		retry(func, count, null, false, false)
	}

	def static <T> retry(Functions.Function0<T> func, int count, T valueWhenFailing) {
		retry(func, count, valueWhenFailing, false, false)
	}

	def static <T> retry(Functions.Function0<T> func, int count, T valueWhenFailing, boolean verbosely) {
		retry(func, count, valueWhenFailing, verbosely, false)
	}

	def static <T> retry(Functions.Function0<T> func, int count, T valueWhenFailing, boolean verbosely,
		boolean showingAllErrors) {
		for (i : 1 .. count) {
			try {
				return func.apply
			} catch (Exception e) {
				if (verbosely && (showingAllErrors || i == count)) {
					e.printStackTrace
				}
			}
		}
	}

	def static <T> retry(Functions.Function0<T> func, int count,
		Procedures.Procedure3<Exception, Integer, Integer> failHandler) {
		retry(func, count, null, failHandler)
	}

	def static <T> retry(Functions.Function0<T> func, int count, T valueWhenFailing,
		Procedures.Procedure3<Exception, Integer, Integer> failHandler) {
		for (i : 1 .. count) {
			try {
				return func.apply
			} catch (Exception e) {
				failHandler.apply(e, i, count)
			}
		}
		valueWhenFailing
	}
}
