package com.iluvas.engine.core.initialBuilders.preloader 
{
	import com.iluvas.engine.core.initialBuilders.ILBGameBuilder;
	import com.iluvas.engine.event.ILCReceiver;
	import com.iluvas.utilities.ILUOOP;
	import flash.utils.getDefinitionByName;
	/**
	 * This class is a component of preloader. Its responsibilities are to execute the phase
	 * advancement from preloader controlled to ILECore controlled, and in this process
	 * invoking the defined game builder via gameBuilderStr.
	 * @author iluvAS
	 */
	internal final class ILCExecutor extends ILCReceiver
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/* Reference to the parent object */
		private var pRef:ILBPreloader;
		
		/** The captured value from receiver of the total percentage of the swf loaded */
		private var loadProgress:Number = 0;
		
		/** This variable is the falg that determines if the swf has been fully loaded */
		private var loadingComplete:Boolean = false;
		
		/** This flag will denote if the preloader is ready to move on to the next phase */
		private var advancePreloader:Boolean = false;
		
		/** This flag will denote if the preloader is still executing its own frame code */
		private var inControl:Boolean = true;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Define the reference to the parent preloader
		 * @param	parentRef
		 */
		public function ILCExecutor(parentRef:ILBPreloader) 
		{
			super(ILBPreloader.GID);
			pRef = parentRef;
		}
		
		public override function receive(groupID:int, msg:String):void
		{
			if (groupID == ILBPreloader.GID)
			{
				loadProgress = Number(msg.split("|")[1]);
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// RECEIVER OVERRIDES
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Used by preloader to check load completion and also to carry out prepareLoadComplete
		 * functions throughout the preloader object
		 * @param	captureProgress
		 * @return
		 */
		internal function checkLoadComplete(captureProgress:Number):Boolean
		{
			if (!loadingComplete && captureProgress == loadProgress && pRef.currentFrame == pRef.totalFrames)
			{
				prepareLoadComplete();
			}
			return loadingComplete;
		}
		
		/**
		 * This function is called to check if the preloader is ready to move on to the next phase
		 * after the checking is done, this function will also carry out the process of advancement
		 */
		internal function checkAndExecuteNextPhase():void
		{
			if (inControl && loadingComplete && advancePreloader)
			{
				inControl = false;
				
				try
				{
					var gameBuilderClass:Class = getDefinitionByName(pRef._gameBuilderStr) as Class;
					// attempt to get class definition
					
					if (ILUOOP.checkIfExtendsOrIs(gameBuilderClass, ILBGameBuilder))
					{
						var gameBuilderObject:ILBGameBuilder = new gameBuilderClass();
						if (pRef._gameProperties != null)
						{
							gameBuilderObject.declareGameProperties(pRef._gameProperties);
						}
						gameBuilderObject.declarePreloader(pRef);
						gameBuilderObject.build();
						// pass references
						
						pRef.removeEnterFrame();
						// terminate enter frame events
					}else
					{
						trace("3:[PRELOADER ERROR]: Class is not of type ILBGameBuilder");
					}
					
				}catch (e:ArgumentError)
				{
					trace("3:[PRELOADER ERROR]: Either the class is not defined or AS3 package search error");
				}
			}
		}
		
		/**
		 * Removes all references in preparation to move to the next phase
		 */
		private function prepareLoadComplete():void
		{
			loadingComplete = true;
			advancePreloader = pRef._autoPlay;
			leaveGroup(ILBPreloader.GID);
			pRef.prepareLoadComplete();
		}
		
		/**
		 * Function call cascade from concrete class to preloader to executor to move on to next
		 * phase when autoPlay is false
		 */
		internal function manualPlay(captureProgress:Number):void
		{
			if (loadingComplete && captureProgress == loadProgress && pRef.currentFrame == pRef.totalFrames)
			{
				advancePreloader = true;
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE FUNCTIONS
		//-------------------------------------------------------------------------------------------------------------
		
	}

}