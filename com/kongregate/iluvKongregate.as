package kongregate 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvKongregate 
	{
		private static var cRef:MovieClip;
		private static var kong:*;
		
		public static function init(conRef:MovieClip):void
		{
			cRef = conRef;
			
			// Pull the API path from the FlashVars
			var paramObj:Object = LoaderInfo(conRef.root.loaderInfo).parameters;
			
			// The API path. The "shadow" API will load if testing locally. 
			var apiPath:String = paramObj.kongregate_api_path || 
			"http://www.kongregate.com/flash/API_AS3_Local.swf";
			
			// Allow the API access to this SWF
			Security.allowDomain(apiPath);
			
			var request:URLRequest = new URLRequest(apiPath);
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
			loader.load(request);
			MovieClip(cRef).parent.addChild(loader);
		}
		
		public static function submitStat(nme:String, val:Number):void
		{
			kong.stats.submit(nme, val);
		}
		
		// This function is called when loading is complete
		private static function loadComplete(event:Event):void
		{
			// Save Kongregate API reference
			kong = event.target.content;
			
			// Connect to the back-end
			kong.services.connect();
			
			Security.allowDomain(kong.loaderInfo.url);
			
			// You can now access the API via:
			// kongregate.services
			// kongregate.user
			// kongregate.scores
			// kongregate.stats
			// etc...
		}
		
	}

}