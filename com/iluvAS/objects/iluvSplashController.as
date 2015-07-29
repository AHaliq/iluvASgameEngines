package iluvAS.objects 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import iluvAS.iluvEngine;
	import iluvAS.iluvGameProperties;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvSplashController extends iluvObj 
	{
		private var mc:MovieClip;
		private var nP:String;
		private var tl:String;
		private var clickURL:String;
		private var hitTest:Sprite = new Sprite();
		
		private var enableCount:int = 0;
		
		public function iluvSplashController(splashMc:MovieClip, url:String, nextPageLabel:String, stWdt:Number, stHgt:Number, tranLabel:String, scale:Number = 1, position:String = "mid") 
		{
			mc = splashMc;
			nP = nextPageLabel;
			tl = tranLabel;
			clickURL = url;
			mc.width *= scale;
			mc.height *= scale;
			if (position == "mid")
			{
				mc.x = stWdt / 2;
				mc.y = stHgt / 2;
			}else
			{
				mc.x = (stWdt - mc.width) / 2;
				mc.y = (stHgt - mc.height) / 2;
			}
			addChild(mc);
			mc.stop();
			
			hitTest.graphics.beginFill(0x000000, 0);
			hitTest.graphics.drawRect(0, 0, stWdt, stHgt);
			addChild(hitTest);
		}
		
		public override function init():void
		{
			if (enableCount > 0)
			{
				this.buttonMode = true;
				initListeners();
			}
			mc.play();
			enableCount++;
		}
		
		public override function algo():void
		{
			if (mc.currentFrame == mc.totalFrames)
			{
				iluvEngine.transitionToPage(nP, tl, 0.05); 
				mc.gotoAndStop(1);
			}
		}
		
		public override function initListeners():void
		{
			hitTest.addEventListener(MouseEvent.CLICK, splashGotoSite);
		}
		
		public override function removeListeners():void
		{
			hitTest.removeEventListener(MouseEvent.CLICK, splashGotoSite);
		}
		
		private function splashGotoSite(e:MouseEvent):void
		{
			iluvGameProperties.gotoSite(clickURL);
		}
		
	}

}