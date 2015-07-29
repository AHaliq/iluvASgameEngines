package iluvAS 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.text.Font;
	import iluvAS.objects.engineComponents.debug.iluvDebugLayer;
	import iluvAS.objects.engineComponents.iluvSiteLockGraphic;
	import iluvAS.objects.iluvObj;
	import iluvAS.objects.iluvTransition;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvEngine extends Sprite
	{
		public static var STAGE_REF:Stage;
		public static var overallContainer:Sprite = new Sprite();
		private static var contentLayer:Sprite = new Sprite();
		private static var transitionLayer:Sprite = new Sprite();
		private static var achievementLayer:Sprite = new Sprite();
		public static var debugLayer:iluvDebugLayer;
		// content
		
		private static var curPage:iluvObj = null;
		private static var pgArr:Array = new Array();
		private static var pgLbl:Array = new Array();
		// page variables
		
		private static var activeTransition:iluvTransition;
		private static var trArr:Array = new Array();
		private static var trLbl:Array = new Array();
		// tran variables
		
		public static var swfSite:String;
		
		public static function init(stageRef:Stage, rt:MovieClip):void
		{
			if (STAGE_REF == null)
			{
				STAGE_REF = stageRef;
				swfSite = String(STAGE_REF.root.loaderInfo.url.split("://")[1]).split("/")[0];
				// capture stage
				
				overallContainer.graphics.beginFill(0x000000, 0);
				overallContainer.graphics.drawRect(0, 0, STAGE_REF.stageWidth, STAGE_REF.stageHeight);
				// setup overall container base
				
				iluvAchievements.init(achievementLayer, STAGE_REF.stageWidth, STAGE_REF.stageHeight);
				if (iluvGameProperties.DEBUG) debugLayer = new iluvDebugLayer(STAGE_REF.stageWidth, STAGE_REF.stageHeight);
				overallContainer.addChild(contentLayer);
				overallContainer.addChild(transitionLayer);
				overallContainer.addChild(achievementLayer);
				if (iluvGameProperties.DEBUG) overallContainer.addChild(debugLayer);
				rt.addChild(overallContainer);
				// setup layers
				
				iluvContextMenu.initContext(overallContainer);
				// apply context menu
				
				STAGE_REF.addEventListener(Event.ENTER_FRAME, codeLoop);
				// run algo
			}
		}
		
		private static function codeLoop(e:Event):void
		{
			iluvSound.algo();
			iluvAchievements.algo();
			// run component algos
			
			if (curPage != null) curPage.algo();
			
			if (activeTransition != null)
			{
				activeTransition.algo();
				activeTransition.getDesPage().algo();
				if (activeTransition.getTranStatus())
				{
					curPage = activeTransition.getDesPage();
					transitionLayer.removeChild(activeTransition);
					if (activeTransition.getDestroyStatus())
					{
						destroyPageByObj(activeTransition.getInitCurrentPage());
					}
					activeTransition = null;
				}
			}// run transition algorithms
		}
		// core functions -----------------------------------------------------------------------//
		
		public static function initFirstPage(pg:iluvObj, label:String):void
		{
			if(pgArr.length == 0)
			{
				curPage = pg;
				pgArr.push(pg);
				pgLbl.push(label);
				contentLayer.addChild(curPage);
				// ADD FIRST PAGE
				
				var runnable:Boolean = !iluvGameProperties.RUN_SITE_LOCK;
				if (iluvGameProperties.RUN_SITE_LOCK)
				{
					for (var i:String in iluvGameProperties.ALLOWED_SITES)
					{
						if (swfSite == iluvGameProperties.ALLOWED_SITES[i])
						{
							runnable = true;
							break;
						}
					}
				}// SITE LOCK CHECK
				
				if (!runnable)
				{
					declareNewPage(new iluvSiteLockGraphic(STAGE_REF.stageWidth, STAGE_REF.stageHeight), "siteLockFail");
					declareNewTran(new iluvTransition(), "siteLockTran");
					transitionToPage("siteLockFail", "siteLockTran", 0.05, true, true);
					iluvGameProperties.SITE_LOCK_FAIL = true;
					// SHOW SITE LOCK FAIL PAGE
				}
			}
		}
		
		public static function declareNewPage(pg:iluvObj, label:String):void
		{
			pgArr.push(pg);
			pgLbl.push(label);
		}
		
		public static function destroyPageByLabel(label:String):void
		{
			var i:int = pgLbl.indexOf(label);
			if (i > -1) destroyPageByEle(i);
		}
		
		public static function destroyPageByObj(pg:iluvObj):void
		{
			var i:int = pgArr.indexOf(pg);
			if (i > -1) destroyPageByEle(i);
		}
		
		public static function destroyPageByEle(i:int):void
		{
			if (i >= 0 && i < pgArr.length)
			{
				pgArr[i].removeListeners();
				pgArr.splice(i, 1);
				pgLbl.splice(i, 1);
			}
		}
		
		public static function getPage(label:String):iluvObj
		{
			var i:int = pgLbl.indexOf(label);
			return i == -1 ? null : pgArr[i];
		}
		// paging functions ---------------------------------------------------------------------//
		
		public static function declareNewTran(tr:iluvTransition, label:String):void
		{
			tr.initContentLayer(contentLayer);
			trArr.push(tr);
			trLbl.push(label);
		}
		
		public static function getTran(label:String):iluvTransition
		{
			var i:int = trLbl.indexOf(label);
			return i == -1 ? null : trArr[i];
		}
		
		public static function transitionToPage(desLabel:String, transitionLabel:String, step:Number = 0.05, disposeOnComplete:Boolean = false, siteBypass:Boolean = false):void
		{
			if (activeTransition == null)
			{
				var tr:iluvTransition;
				if (getPage(desLabel) != null && getTran(transitionLabel) != null) tr = getTran(transitionLabel);
				if (tr != null && (!iluvGameProperties.SITE_LOCK_FAIL || siteBypass))
				{
					activeTransition = tr;
					activeTransition.initTransition(curPage, getPage(desLabel), disposeOnComplete, step);
					transitionLayer.addChild(activeTransition);
				}
			}
		}
		// transition functions -----------------------------------------------------------------//
		
	}

}