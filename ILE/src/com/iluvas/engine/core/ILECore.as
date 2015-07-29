package com.iluvas.engine.core 
{
	import com.iluvas.engine.core.componentBuilders.ILBGameProperties;
	import com.iluvas.engine.core.initialBuilders.preloader.ILBPreloader;
	import flash.events.Event;
	/**
	 * ...
	 * @author iluvAS
	 */
	public final class ILECore 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Reference to concrete gameProperties object */
		private static var gameProperties:ILBGameProperties;
		
		//-------------------------------------------------------------------------------------------------------------
		// COMPONENT OBJECTS
		//-------------------------------------------------------------------------------------------------------------
		
		/** Flag to determine if this class has been initialized */
		private static var coreInitialized:Boolean = false;
		/** Flag to determine if siteLock status has been checked */
		private static var siteLockCheckCompleted:Boolean = false;
		/** Flag to determine if game is in lockdown */
		private static var lockState:Boolean = false;
		/** Reference to the first runnable object to be integrated after ILERunnableIterator's initialization */
		private static var firstRunnableHolder:ILCRunnable;
		
		//-------------------------------------------------------------------------------------------------------------
		// CONTROL VARIABLES
		//-------------------------------------------------------------------------------------------------------------
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function ILECore() 
		{
			//TODO copy ILEContent
			//TODO copy ILECore
			//TODO complete gamebuilder
			//TODO make ILEContent
			//TODO make ILBRunnableIterator
			//TODO make ILBTransition
			//TODO make sitelock graphic class
			//TODO make sitelock check function + auto define template transition + transition to sitelock
			//TODO sort out framework for statistics component and execute it
			//TODO sort out framework for API component and execute it
			//TODO start doing API components
			//TODO start doing runnable components
		}
		
		/**
		 * This function wiill integrate the graphicContainer from the preloader into the engine
		 * using the initWithRunnable function
		 * @param	obj
		 */
		public static function initWithPreloader(obj:ILBPreloader):void
		{
			if (!coreInitialized)
			{
				initWithRunnable(obj.graphicContainer);
				obj.stage.removeChild(obj);
			}
		}
		
		/**
		 * This function will capture the obj reference to be integrated later into the engine, it
		 * will also initialize the content layering system into the stage
		 * @param	obj
		 */
		public static function initWithRunnable(obj:ILCRunnable):void
		{
			if (!coreInitialized)
			{
				//TODO ILEContent.init(obj.stage);
				
				obj.parent.removeChild(obj);
				//TODO ILEContent.contentLayer.addChild(obj);
				firstRunnableHolder = obj;
				// integrate into system
				
				//TODO ILEContent.overallContainer.stage.addEventListener(Event.ENTER_FRAME, coreCodeLoop);
				coreInitialized = true;
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// INIT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * This function will run all codes in the framework and runnable objects that require to
		 * be called on every frame
		 * @param	e
		 */
		private static function coreCodeLoop(e:Event):void
		{
			
		}
		
		private static function attemptSiteLockCheck():void
		{
			
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE
		//-------------------------------------------------------------------------------------------------------------
		
		public static function declareGameProperties(obj:ILBGameProperties):void
		{
			gameProperties = obj;
			//TODO gameProperties.updateDomain(ILEContent.overallContainer.stage);
			
			attemptSiteLockCheck();
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// COMPONENT DECLARATION
		//-------------------------------------------------------------------------------------------------------------
		
		public static function get GP():ILBGameProperties
		{
			return gameProperties;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// GETTERS
		//-------------------------------------------------------------------------------------------------------------
	}

}