package iluvAS 
{
	import flash.net.SharedObject;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvSaveData 
	{
		private static var labelArr:Array = new Array();
		private static var objArr:Array = new Array();
		
		public static function createOrLoad(label:String):void
		{
			var so:SharedObject = SharedObject.getLocal(label);
			labelArr.push(label);
			objArr.push(so);
		}
		
		public static function getSo(label:String):SharedObject
		{
			var i:int = labelArr.indexOf(label);
			if (i > -1) return objArr[i];
			return null;
		}
		
		public static function clearData(label:String):void
		{
			var i:int = labelArr.indexOf(label);
			objArr[i].clear();
		}
		
	}

}