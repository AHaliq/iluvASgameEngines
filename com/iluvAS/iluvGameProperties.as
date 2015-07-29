package iluvAS 
{
	import flash.display.Sprite;
	import flash.external.ExternalInterface;
	import flash.net.navigateToURL;
	import flash.net.sendToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvGameProperties 
	{
		public static var WDT_CONST:uint;
		public static var HGT_CONST:uint;
		
		public static var DEVELOPER_SITE:String = "http://www.facebook.com/pages/IluvAS-Games/168908353173809";
		public static var SPONSOR_SITE:String = "http://www.yepi.com";
		public static var SPSR_MENU_MG:String = "http://www.yepi.com/?utm_source=dud&utm_medium=moreMain&utm_campaign=game";
		public static var SPSR_MENU_LOGO:String = "http://www.yepi.com/?utm_source=dud&utm_medium=logoMain&utm_campaign=game";
		public static var SPSR_GAME_LOGO:String = "http://www.yepi.com/?utm_source=dud&utm_medium=LogoGame&utm_campaign=game";
		public static var SPSR_GAME_OVER:String = "http://www.yepi.com/?utm_source=dud&utm_medium=gameOver&utm_campaign=game";
		
		public static var VERSION:String = "0";
		public static var DEBUG:Boolean;
		
		public static var SITE_LOCK_FAIL:Boolean;
		public static var RUN_SITE_LOCK:Boolean;
		public static var ALLOWED_SITES:Array = new Array();
		
		private static var blockURLGraphic:Sprite;
		public static var blocked:Boolean = false;
		
		public static function gotoSite(url:String):void
		{
			try
			{
				navigateToURL(new URLRequest(url));
			}catch (e:Error)
			{
				blockURL();
			}
		}
		
		public static function blockCheck():void
		{
			var allowNetworking:Object;
			try
			{
				//sendToURL(new URLRequest(SPONSOR_SITE));
				allowNetworking = ExternalInterface.call(SPONSOR_SITE);
			}catch (e:Error)
			{
				blockURL();
			}
		}
		
		public static function blockURL():void
		{
			blocked = true;
			blockURLGraphic = new Sprite();
			blockURLGraphic.graphics.beginFill(0xFFFFFF);
			blockURLGraphic.graphics.drawRect(0, 0, 550, 600);
			var tf:TextField = new TextField();
			tf.multiline = true;
			tf.defaultTextFormat = new TextFormat(null, 34, null, null, null, null, null, null, TextFormatAlign.CENTER);
			tf.width = 550;
			tf.height = 600;
			tf.selectable = true;
			tf.text = "\n\n\n\nThis website is blocking outgoing links\nplay the full game on www.yepi.com";
			blockURLGraphic.addChild(tf);
			iluvEngine.overallContainer.addChild(blockURLGraphic);
		}
	}

}