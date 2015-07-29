package iluvAS.objects.engineComponents.debug 
{
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author iluvAS
	 */
	public final class iluvDebugLayer extends Sprite 
	{
		private var perfTracker:iluvPerformanceTracker = new iluvPerformanceTracker();
		public function iluvDebugLayer(stWdt:Number, stHgt:Number) 
		{
			perfTracker.alpha = 0.8;
			addChild(perfTracker);
		}
		
	}

}