package iluvAS.utils 
{
	/**
	 * ...
	 * @author iluvAS
	 */
	public class NumberUtility 
	{
		
		public static function getRandomNumber(from:int, to:int):int
		{
			return Math.ceil(Math.random() * (to - from + 1)) + from - 1;
		}
		
		public static function getKey(ascii:int):String
		{
			return (String.fromCharCode(ascii));
		}
		
		public static function getCode(key:String):int
		{
			return (key).charCodeAt(0);
		}
	}

}