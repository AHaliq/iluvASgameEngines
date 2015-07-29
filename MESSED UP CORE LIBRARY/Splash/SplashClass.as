package Splash 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.*;
	/**
	 * ...
	 * @author Haliq
	 */
	public class SplashClass extends ILUVAS_SPLASH
	{
		private var thunderBox:Sprite = new Sprite();
		private var myXML:String;
		
		public function SplashClass(stWdt:Number, stHgt:Number)
		{
			buttonMode = true;
			x = stWdt / 2;
			y = stHgt / 2;
			addEventListener(MouseEvent.MOUSE_DOWN,gotoURL);
			myXML = "iluvas.newgrounds.com";
			
			thunderBox.graphics.beginFill(0xFFFFFF);
			thunderBox.graphics.drawRect( -stWdt / 2, -stHgt / 2, stWdt, stHgt);
			
			gotoAndPlay(5);
			bg.width = stWdt;
			bg.height = stHgt;
		}
		
		public function algo():Boolean
		{
			if (currentFrame == 25 || currentFrame == 29 || currentFrame == 33) this.addChild(thunderBox);
			if (currentFrame == 27 || currentFrame == 31 || currentFrame == 35) this.removeChild(thunderBox);
			if (currentFrame == 229) removeEventListener(MouseEvent.MOUSE_DOWN, gotoURL);
			if (currentFrame == 230)
			{
				stop();
				return true;
			}
			return false;
		}
		
		private function gotoURL(evt:MouseEvent):void
		{
			var url:String = "http://"+myXML;
			var request:URLRequest = new URLRequest(url);
			try {
				navigateToURL(request, '_blank');
			} catch (e:Error) {
				trace("Error occurred!");
			}
		}
	}
}