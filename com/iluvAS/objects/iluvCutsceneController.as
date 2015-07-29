package iluvAS.objects 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import iluvAS.iluvEngine;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvCutsceneController extends iluvObj 
	{
		private var sk:Sprite;
		private var mc:MovieClip;
		private var nP:String;
		private var tl:String;
		private var clickURL:String;
		private var hitTest:Sprite = new Sprite();
		
		public function iluvCutsceneController(splashMc:MovieClip, skGraphic:Sprite, skipHeight:Number, nextPageLabel:String, stWdt:Number, stHgt:Number, tranLabel:String, scale:Number = 1, position:String = "mid") 
		{
			mc = splashMc;
			sk = skGraphic;
			nP = nextPageLabel;
			tl = tranLabel;
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
			
			hitTest.graphics.beginFill(0xFFFFFF, 0.125);
			hitTest.graphics.drawRect(0, stHgt - skipHeight, stWdt, skipHeight);
			hitTest.addChild(skGraphic);
			sk.x = stWdt - sk.width;
			sk.y = stHgt - sk.height;
			addChild(hitTest);
		}
		
		public override function init():void
		{
			mc.play();
			initListeners();
		}
		
		public override function algo():void
		{
			if (hitTest.hitTestPoint(mouseX, mouseY, true))
			{
				if (hitTest.alpha < 1) hitTest.alpha += 0.1;
			}else if (hitTest.alpha > 0) hitTest.alpha -= 0.1;
			if (mc.currentFrame == mc.totalFrames)
			{
				iluvEngine.transitionToPage(nP, tl, 0.05, true); 
				mc.stop();
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
			iluvEngine.transitionToPage(nP, tl, 0.05, true); 
		}
		
	}

}