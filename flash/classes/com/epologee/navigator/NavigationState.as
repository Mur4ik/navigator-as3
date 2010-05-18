package com.epologee.navigator {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class NavigationState {
		private static const DELIMITER : String = "/";
		//
		private var _path : String;

		public function NavigationState(inPath : String = "") {
			path = inPath.toLowerCase().replace(/\s+/g, "-");
		}

		public function set path(inPath : String) : void {
			_path = "/" + inPath + "/";
			_path = _path.replace(new RegExp("\/+", "g"), "/");
		}

		public function get path() : String {
			return _path;
		}

		public function set segments(inSegments : Array) : void {
			path = inSegments.join(DELIMITER);
		}

		public function get segments() : Array {
			var s : Array = _path.split(DELIMITER);
			
			// pop emtpy string off the back.
			if (!s[s.length - 1]) s.pop();
			
			// shift empty string off the start.
			if (!s[0]) s.shift();
			
			return s;
		}

		/**
		 * @return whether the path of the foreign state is contained by this state's path
		 * @example:
		 * 
		 * 	a = new State("/bubble/gum/");
		 * 	b = new State("/bubble/");
		 * 	
		 * 	a.containsState(b) will return true.
		 * 	b.containsState(a) will return false.
		 * 	
		 */
		public function containsState(inForeignState : NavigationState) : Boolean {
			var foreignSegments : Array = inForeignState.segments;
			var nativeSegments : Array = segments;
			
			if (foreignSegments.length > nativeSegments.length) {
				// foreign segment length too big
				return false;
			}
			
			// check to see if the overlapping segments match.
			// since the foreign segment count has to be smaller than the native,
			// the foreign count is used to limit the loop:
			var leni : int = foreignSegments.length;
			for (var i : int = 0;i < leni;i++) {
				var foreignSegment : String = foreignSegments[i];
				var nativeSegment : String = nativeSegments[i];

				if (foreignSegment != nativeSegment) {
					// native [" + nativeSegment + "] does not match foreign [" + foreignSegment + "]
					return false;
				} else {
					// native  [" + nativeSegment + "] matches foreign [" + foreignSegment + "]
				}
			}
			
			return true;
		}

		public function equals(inState : NavigationState) : Boolean {
			var sub : NavigationState = subtract(inState);
			if (!sub) return false;
			
			return sub.segments.length == 0;
		}

		/**
		 * Subtracts the path of the operand from the current state and returns it as a new state instance.
		 * @example "/portfolio/editorial/84/3" - "/portfolio/" = "/editorial/84/3"
		 */
		public function subtract(inOperand : NavigationState) : NavigationState {
			if (!containsState(inOperand)) return null;
			var s : String = path.substring(inOperand.path.length);
			return new NavigationState(s);
		}

		public function add(inTrailingState : NavigationState) : NavigationState {
			return new NavigationState(path + DELIMITER + inTrailingState.path);
		}

		public function toString() : String {
			return "path: " + path;
		}
	}
}
