package iluvAS.objects 
{
	import flash.display.Sprite;
	import iluvAS.iluvContextMenu;
	
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvTransition extends iluvObj 
	{
		public var cP:iluvObj;
		public var dP:iluvObj;
		public var tD:Boolean;
		public var cL:Sprite;
		
		private var tmr:Number = 0;
		private var tStep:Number = 0.1;
		private var tranComplete:Boolean = false;
		
		private var colCap:uint;
		
		public function iluvTransition(col:uint = 0x000000)
		{
			colCap = col;
		}
		
		public function initTransition(curPg:iluvObj, desPg:iluvObj, doc:Boolean, step:Number = 0.1):void
		{
			iluvContextMenu.initContext(this);
			tranComplete = false;
			tmr = 0;
			cP = curPg;
			dP = desPg;
			tD = doc;
			tStep = step;
		}
		
		public function initContentLayer(contentLayer:Sprite):void { cL = contentLayer; }
		
		public override function algo():void
		{
			if (tmr >= 1) tmr = 1;
			setTransitionValue(tmr);
			if (tmr == 1)
			{
				tranComplete = true;
			}else tmr += tStep;
			if (tmr >= 0.5 && dP.stage == null)
			{
				cL.removeChild(cP);
				cL.addChild(dP);
				dP.init();
			}
		}
		
		// core functions -----------------------------------------------------------------------//
		
		public function getTranStatus():Boolean { return tranComplete; }
		public function getDestroyStatus():Boolean { return tD; }
		public function getInitCurrentPage():iluvObj { return cP; }
		public function getDesPage():iluvObj { return dP; }
		// getter functions ---------------------------------------------------------------------//
		
		public function setTransitionValue(val:Number):void
		{
			graphics.clear();
			if (val < 0.5)
			{
				// FADE IN
				graphics.beginFill(colCap, val * 2);
			}else
			{
				// FADE OUT
				graphics.beginFill(colCap, 1 - ((val - 0.5) * 2));
			}
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		}
		// default animation for transition progress --------------------------------------------//
		
	}

}