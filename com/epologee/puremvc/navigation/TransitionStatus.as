package com.epologee.puremvc.navigation {

	/**
	 * @author Eric-Paul Lecluse (c) epologee.com
	 */
	public class TransitionStatus {
		public static const UNINITIALIZED : int = -2;
		public static const INITIALIZED : int = -1;
		public static const HIDDEN : int = 1;
		public static const APPEARING : int = 2;
		public static const SHOWN : int = 3;
		public static const DISAPPEARING : int = 4;
		
		public static function toString(inStatus:int):String {
			switch (inStatus) {
				case UNINITIALIZED:
					return "UNINITIALIZED";
				case INITIALIZED:
					return "INITIALIZED";
				case HIDDEN:
					return "HIDDEN";
				case APPEARING:
					return "APPEARING";
				case SHOWN:
					return "SHOWN";
				case DISAPPEARING:
					return "DISAPPEARING";
			}
			
			return "UNKNOWN";
		}
	}
}
