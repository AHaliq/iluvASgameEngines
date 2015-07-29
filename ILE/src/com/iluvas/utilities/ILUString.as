package com.iluvas.utilities 
{
	/**
	 * ...
	 * @author iluvAS
	 */
	public final class ILUString 
	{
		
		/**
		 * This function formats a number to the specified length
		 * i.e. num = 2, len = 4, will return 0002
		 * @param	num		number to operate on
		 * @param	len		required length
		 * @return			formatted number
		 */
		public static function formatNumber(num:int, len:int):String
		{
			var str:String = num.toString();
			// convert number to string
			
			if (str.length < len)
			{
				var addOnLength:int = len - str.length;
				// find missing required length
				
				var addOnStr:String = "0";
				while (addOnStr.length < addOnLength) addOnStr += "0";
				// generate add on string
				
				str = addOnStr + str;
				// append string
			}
			
			return str;
		}
		
	}

}