package com.iluvas.engine.core.initialBuilders.preloader 
{
	import com.iluvas.engine.core.ILCRunnable;
	/**
	 * ...
	 * @author iluvAS
	 */
	internal final class ILCGraphicContainer extends ILCRunnable
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Reference to the parent preloader */
		private var pRef:ILBPreloader;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Define the reference to the parent preloader
		 * @param	parentRef
		 */
		public function ILCGraphicContainer(parentRef:ILBPreloader) 
		{
			pRef = parentRef;
		}
		
		/**
		 * This function will be called by ILECore after preloader initialization to continue the
		 * preloader's animation even after event listeners from loader have been removed
		 */
		public override function algo():void
		{
			if (pRef != null) pRef.algo();
		}
		
	}

}