package iluvAS.objects 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import iluvAS.iluvContextMenu;
	
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvPreloader extends iluvObj 
	{
		public var GAME_WDT:Number;
		public var GAME_HGT:Number;
		public var userInputReady:Boolean;
		public var autoPlay:Boolean;
		
		public var desProg:Number = 0;
		public var curProg:Number = 0;
		
		public function iluvPreloader(wdt:Number, hgt:Number) 
		{
			super();
			iluvContextMenu.initContext(this);
			GAME_WDT = wdt;
			GAME_HGT = hgt;
		}
		
		public function update(progress:Number):void
		{
			desProg = progress;
		}
		
		public override function algo():void
		{
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, GAME_WDT, GAME_HGT);
			
			graphics.beginFill(0xAAAAAA);
			graphics.drawRect(GAME_WDT / 5 * 2, (GAME_HGT - 15) / 2, GAME_WDT / 5, 15);
			
			curProg += (desProg - curProg) / 3;
			graphics.beginFill(0x000000);
			graphics.drawRect(GAME_WDT / 5 * 2, (GAME_HGT - 15) / 2, GAME_WDT / 5 * curProg, 15);
			// default animation for preloader progress
		}
		
		public override function initListeners():void
		{
			this.buttonMode = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN, iluvTranClick);
		}
		
		public override function removeListeners():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, iluvTranClick);
		}
		
		private function iluvTranClick(e:MouseEvent):void
		{
			if (Math.round(curProg * 100) == 100 && desProg == 1) userInputReady = true;
		}
		
		// core functions -----------------------------------------------------------------------//
		
		public function getUserReady():Boolean { return userInputReady; }
		
		public function getAutoPlay():Boolean { return autoPlay; }
		
	}

}