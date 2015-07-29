package com.iluvas.engine.core.initialBuilders 
{
	import com.iluvas.engine.core.componentBuilders.ILBGameProperties;
	import com.iluvas.engine.core.ILCRunnable;
	import com.iluvas.engine.core.initialBuilders.preloader.ILBPreloader;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class ILBGameBuilder 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * This function is to be used to build the objects and declare components. If a preloader
		 * is used in the game, this function will be called automatically, otherwise you would
		 * have to call it in the concrete class's constructor.
		 */ 
		public function build():void { }
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE
		//-------------------------------------------------------------------------------------------------------------
		
		public final function declareGameProperties(obj:ILBGameProperties):void
		{
			
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// COMPONENT DECLARATION
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * This function is used by ILEPreloader to declare itself.
		 * @param	obj
		 */
		public final function declarePreloader(obj:ILBPreloader):void
		{
			
		}
		
		/**
		 * If you wish to not use a preloader, use this function to declare your first runnable
		 * object in your concrete gameBuilder's constructor
		 * @param	obj
		 */
		public final function declareFirstRunnable(obj:ILCRunnable):void
		{
			
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// FIRST OBJECT INTEGRATION
		//-------------------------------------------------------------------------------------------------------------
	}

}