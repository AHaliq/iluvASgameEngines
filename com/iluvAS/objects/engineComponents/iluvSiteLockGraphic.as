package iluvAS.objects.engineComponents 
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import iluvAS.iluvEngine;
	import iluvAS.iluvGameProperties;
	import iluvAS.objects.iluvObj;
	
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvSiteLockGraphic extends iluvObj 
	{
		private var tf:TextField = new TextField();
		
		public function iluvSiteLockGraphic(stWdt:Number, stHgt:Number) 
		{
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(0, 0, stWdt, stHgt);
			// draw white background
			
			tf.defaultTextFormat = new TextFormat(null, 15, null, null, null, null, null, null, "center");
			tf.multiline = true;
			tf.selectable = false;
			tf.antiAliasType = "advanced";
			tf.width = stWdt;
			tf.height = stHgt;
			addChild(tf);
			// setup tf
			
			tf.htmlText = "<font color = '#FF0000'> ! This game is site locked to the following sites ! </font>";
			var str:String = new String();
			for (var i:String in iluvGameProperties.ALLOWED_SITES)
			{
				str += iluvGameProperties.ALLOWED_SITES[i];
				if (int(i) + 1 < iluvGameProperties.ALLOWED_SITES.length) str += " | ";
			}
			tf.htmlText += str;
			// setup text
			
			//this.buttonMode = true;
			//this.addEventListener(MouseEvent.CLICK, siteLockFailGotoDev);
			// iluvASGames click event
		}
		
		private function siteLockFailGotoDev(e:MouseEvent):void
		{
			iluvGameProperties.gotoSite("http://"+iluvGameProperties.ALLOWED_SITES[0]);
		}
		
	}

}