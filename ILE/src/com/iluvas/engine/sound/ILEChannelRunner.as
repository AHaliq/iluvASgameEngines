package com.iluvas.engine.sound 
{
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * This class will run the code for ILCSoundChannel when they need to fade thier sound objects
	 * on a frame by frame basis. This class will initially run its own ENTER_FRAME listener, but
	 * if informed to stop it will, by this phase ILESound will be running its frame by frame
	 * function, which is being run by ILECore on a frame by frame basis
	 * @author iluvAS
	 */
	internal final class ILEChannelRunner 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Contains a list of all channel objects that need frame by frame code execution */
		private static var channelVec:Vector.<ILCSoundChannel> = new Vector.<ILCSoundChannel>();
		/** The captured reference of stage being used for the event listener before core is in charge */
		private static var stageCapture:Stage;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * This function is called by ILESound when the developer wishes to use the sound engine
		 * prior to ILECore being initialized
		 * @param	stageRef
		 */
		internal static function initEnterFrame(stageRef:Stage):void
		{
			stageRef.addEventListener(Event.ENTER_FRAME, codeLoop);
			stageCapture = stageRef;
		}
		
		/**
		 * This function will be called by ILESound when passing over responsibility to run the
		 * frame by frame code to ILECore
		 */
		internal static function stopEnterFrame():void
		{
			stageCapture.removeEventListener(Event.ENTER_FRAME, codeLoop);
		}
		
		/**
		 * The event listener that runs on every frame, this will only be valid if initiated
		 * and before ILECore is initialized
		 * @param	e
		 */
		private static function codeLoop(e:Event):void
		{
			algo();
		}
		
		/**
		 * This is the frame by frame code
		 */
		internal static function algo():void
		{
			for (var i:String in channelVec)
			{
				channelVec[i].volumeAlgo();
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Used by sound channels to declare they want their function to start running
		 * @param	obj
		 */
		internal static function startRunning(obj:ILCSoundChannel):void
		{
			if (channelVec.indexOf(obj) == -1)
			{
				channelVec.push(obj);
			}
		}
		
		/**
		 * Used by sound channels to remove themselves from the running list
		 * @param	obj
		 */
		internal static function stopRunning(obj:ILCSoundChannel):void
		{
			var index:int = channelVec.indexOf(obj);
			if (index > 0)
			{
				channelVec.splice(index, 1);
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// ADD REMOVE CHANNELS
		//-------------------------------------------------------------------------------------------------------------
	}

}