package iluvAS.objects 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvObj extends Sprite 
	{
		
		public function iluvObj() { }
		
		//The function to call when the object cycle begins
		public function init():void
		{
			initListeners();
		}
		
		//The function to run consistently when the page is active
		public function algo():void { }
		
		//The function to call when the object cycle to listen to events
		public function initListeners():void { }
		
		//The function to call when the object cycle ends
		public function removeListeners():void { }
		
	}

}