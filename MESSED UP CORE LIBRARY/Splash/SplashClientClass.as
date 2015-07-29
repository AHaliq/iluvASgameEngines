package Splash 
{
	import flash.events.MouseEvent;
	import flash.net.*;
	/**
	 * ...
	 * @author Haliq
	 */
	public class SplashClientClass extends SPONSOR_SPLASH
	{
		private var myXML:String;
		
		public function SplashClientClass(stWdt:Number, stHgt:Number) 
		{
			buttonMode = true;
			x = stWdt / 2;
			y = stHgt / 2;
			graphics.beginFill(0x000000, 0);
			graphics.drawRect( -x, -y, stWdt, stHgt);
			addEventListener(MouseEvent.MOUSE_DOWN,gotoURL);
			myXML = "iluvas.newgrounds.com";
		}
		
		public function algo():Boolean
		{
			if (currentFrame == totalFrames)
			{
				stop();
				removeEventListener(MouseEvent.MOUSE_DOWN, gotoURL);
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