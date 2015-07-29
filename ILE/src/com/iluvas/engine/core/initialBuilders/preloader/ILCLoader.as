package com.iluvas.engine.core.initialBuilders.preloader 
{
	import com.iluvas.engine.event.ILEEventManager;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	/**
	 * This class is used to make a component of the preloader object. The purpose of the loader is
	 * to carry out all event handlers, prominently the load progress event.
	 * EVENT MESSAGES:
	 * 0|X		- load progress at X%
	 * 1		- IO Error encountered
	 * @author iluvAS
	 */
	internal final class ILCLoader 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/* Reference to the parent object */
		private var pRef:ILBPreloader;
		
		/** This value spanning from 0 to 1 shows how much of the swf has been loaded */
		internal var actualProgress:Number = 0;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Define the reference to the parent preloader to initiate the loading algorithms
		 * @param	parentRef
		 */
		public function ILCLoader(parentRef:ILBPreloader) 
		{
			pRef = parentRef;
			pRef.loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			pRef.loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			pRef.addEventListener(Event.ENTER_FRAME, checkFrame);
		}
		
		/**
		 * This function is called by preloader after when it's ease progress has met the actual
		 * progress value and the swf has been loaded 100%
		 */
		internal function prepareLoadComplete():void
		{
			pRef.loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			pRef.loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
		}
		
		/**
		 * This function is called by preloader after informed from executor that its ready to move
		 * to the next phase
		 */
		internal function removeEnterFrame():void
		{
			pRef.loaderInfo.removeEventListener(Event.ENTER_FRAME, checkFrame);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE
		//-------------------------------------------------------------------------------------------------------------
		
		private function ioError(e:IOErrorEvent):void
		{
			ILEEventManager.inform(ILBPreloader.GID, "1");
		}
		
		private function progress(e:ProgressEvent):void
		{
			actualProgress = e.bytesLoaded / e.bytesTotal;
			ILEEventManager.inform(ILBPreloader.GID, "0|" + actualProgress);
		}
		
		private function checkFrame(e:Event):void
		{
			pRef.algo();
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// EVENT HANDLERS
		//-------------------------------------------------------------------------------------------------------------
		
	}

}