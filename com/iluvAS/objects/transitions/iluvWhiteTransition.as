package iluvAS.objects.transitions 
{
	import iluvAS.objects.iluvObj;
	import iluvAS.objects.iluvTransition;
	
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvWhiteTransition extends iluvTransition 
	{
		
		public function iluvWhiteTransition() { }
		
		public override function setTransitionValue(val:Number):void
		{
			graphics.clear();
			if (val < 0.5)
			{
				// FADE IN
				graphics.beginFill(0xFFFFFF, val * 2);
			}else
			{
				// FADE OUT
				graphics.beginFill(0xFFFFFF, 1 - ((val - 0.5) * 2));
			}
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		}
	}

}