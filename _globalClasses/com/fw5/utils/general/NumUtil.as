package com.fw5.utils.general
{
	
	public final class NumUtil
	{
		/**
		 * Returns a boolean to determine if a value is within range value of its destination
		 * @param	val
		 * @param	des
		 * @param	range
		 * @return
		 */
		public static function valIsNear(val:Number, des:Number, range:Number = 1):Boolean
		{
			return ((val < (des + range)) && (val > (des - range)));
		}
		
	}
	
}