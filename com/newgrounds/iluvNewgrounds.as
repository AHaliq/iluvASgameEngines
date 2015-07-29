package newgrounds 
{
	import com.newgrounds.API;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvNewgrounds 
	{
		public static const adWdt:int = 310.8;
		public static const adHgt:int = 293.65;
		public static function init(rt:DisplayObject, id:String, encryp:String):void
		{
			API.connect(rt, id, encryp);
		}
		public static function unlockMedal(str:String):void
		{
			API.unlockMedal(str);
		}
		
	}

}