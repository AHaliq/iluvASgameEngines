package com.fw5.utils.bitmap 
{
	import com.fw5.engine.Core;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * This class is a centralized holding ground for bitmapData and its relevant information that will be used to print onto BlitCanvas.
	 * It also has an algorithm to profile bitmapData in the background. This engine does not allow using TransformMatrix of color, alpha, etc.
	 * It is recommended that if you would like to print out versions of the clip with color / alpha it is best that you define your procedure
	 * function to the desired alpha / color values. This engine is intended to capture bitmapData copies of different states of a movieclip
	 * to be printed onto a blitCanvas and not a tool for everything bitmapData related methods. Filters however can be applied onto a blitCanvas
	 * rather than individual bitmapData
	 * @author Haliq
	 */
	public final class BlitCore 
	{
		/* PROPERTIES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** Parallel array of bitmap data */
		private static var bDataVec:Vector.<Vector.<BitmapData>> = new Vector.<Vector.<BitmapData>>();
		/** Array of source movieclip */
		private static var mcVec:Vector.<MovieClip> = new Vector.<MovieClip>();
		/** Array of procedure functions for each movieclip */
		private static var funcVec:Vector.<Function> = new Vector.<Function>();
		/** Array of booleans that define if the registration point shifts throughout profiling */
		private static var updateRegVec:Vector.<Boolean> = new Vector.<Boolean>();
		/** Registration point for each bitmapData
		 * if paired updateRegVec is FALSE only [mcID][0] has a value which all clips use*/
		private static var regCoord:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>();
		/** Array of flags that determine if a MC's set is completed */
		private static var completeVec:Vector.<Boolean> = new Vector.<Boolean>();
		
		/* ITEM DATA */
		//-----------------------------------------------------------------------------------------
		
		/** Profiling algorithm will only generate btimap data when less than this value of bitmaps were created in one frame */
		public static var PROFILE_LIMIT:uint = 7;
		/** Variable that keeps track how many bitmap data was created in a frame*/
		private static var profileCount:int = 0;
		/** Iteration type; 0 - Full profiling, 1 - Object Profiling */
		private static var iType:uint = 0;
		/** Working movieclip ID */
		private static var wMCID:int = 0;
		/** Working clip ID */
		private static var wCID:int = 0;
		/** TRUE - background process of caching MCs to bitmapData is active */
		private static var active:Boolean = false;
		
		/* ITERATION VARIABLES */
		//-----------------------------------------------------------------------------------------
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Register a movieclip for profiling so that it can be used on bitmapCanvas. !! IT IS IMPORTANT TO GIVE A PROPER PROCEDURE FUNCTION TO AVOID ERRORS !!
		 * @param	sourceMc	Movieclip to be blit
		 * @param	clips		Total amount of clips / frames / states the movieclip can be in
		 * @param	procedure	A function w arguments (obj:Movieclip, clip:uint) this function should define the state of the movieclip based on the clip value as you would want it. For example:
			 * obj.gotoAndStop(clip); OR obj.rotation = clip; etc.
			 * You can also make complex algorithm for example to capture each rotation for every frame. However it is up to you to have a cipher to retrieve the bitmapData based on the clip value.
		 * @param 	movingReg	TRUE if the argument function will end up, scaling / rotating / animate or perform anything that moves the registration point coordinate relative to the top left of the movieclip
		 * @return
		 */
		public static function registerMC(sourceMc:MovieClip, clips:uint, procedure:Function, movingReg:Boolean = false):int
		{
			sourceMc.stop();
			// stop movieclip
			
			bDataVec.push(new Vector.<BitmapData>(clips));
			mcVec.push(sourceMc);
			funcVec.push(procedure);
			updateRegVec.push(movingReg);
			completeVec.push(false);
			regCoord.push(new Vector.<Point>(movingReg ? clips : 1));
			
			return completeVec.length - 1;
		}
		
		/**
		 * Register a movieclip via a template to profile each frame of its animation
		 * @param	sourceMc
		 * @param	movingReg
		 * @return
		 */
		public static function registerMCasFrameLoop(sourceMc:MovieClip, movingReg:Boolean = false):int
		{
			return registerMC(sourceMc, sourceMc.totalFrames, frameLoopProcedure, movingReg);
		}
		
		/**
		 * A template procedure function used to loop through each frame of a movieclip to blit it
		 * @param	obj
		 * @param	clip
		 */
		private static function frameLoopProcedure(obj:MovieClip, clip:uint):void
		{
			obj.gotoAndStop(clip + 1);
		}
		
		/**
		 * Algorithm that is called by core to perform background profiling.
		 */
		private static function profileAlgorithm():void
		{
			while (profileCount < PROFILE_LIMIT && wCID != -1)
			{
				createBitmapData(wMCID, wCID);
				advanceWorkingID();
			}
			// generate bitmapData for clip and move to next
			
			if (wCID == -1) stopProfiling();
			// stop profiling upon completion
			
			profileCount = 0;
			// reset profile count on every frame
		}
		
		/**
		 * Initiates background profiling. It will automatically disable profiling when the criteria
		 * for completion is met
		 * @param	full
		 */
		public static function startProfiling(full:Boolean = true):void
		{
			iType = full ? 0 : 1;
			if (!active) advanceWorkingID();
			if (wCID != -1)
			{
				if (!active) Core.addAlgo(profileAlgorithm);
				active = true;
			}
		}
		
		/**
		 * Stops background profiling
		 */
		public static function stopProfiling():void
		{
			if (active)
			{
				active = false;
				Core.removeAlgo(profileAlgorithm);
			}
		}
		
		/* CORE METHODS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Moves on to next available working ID to generate a bitmapData of.
		 * It will set wCID to -1 if the MC set is completed and itype is 1
		 * It will set wCID and wMCID to -1 if all btiampData is completed and itype is 0
		 */
		private static function advanceWorkingID():void
		{
			var findAgain:Boolean = false;
			var typeOneComplete:Boolean = false;
			do
			{
				findAgain = false;
				wMCID = (iType == 0) ? completeVec.indexOf(false) : wMCID;
				
				if (wMCID == -1)
				{
					wCID = -1;
					break;
					// if all MC is completed, set all working IDs to -1 and exit
				}
				
				wCID = bDataVec[wMCID].indexOf(null);
				// capture current MC's and find any incomplete
				
				if (wCID == -1)
				{
					completeVec[wMCID] = true;
					if (iType == 0) findAgain = true;
					else typeOneComplete = true;
					// if all for that MC is completed:
					// 0 : mark it as complete and search for next MC
					// 1 : profiling is complete for this MC set
				}
			}while (findAgain);
		}
		
		/**
		 * Used internally in this class to create bitmapData for each clip of each movieclip either
		 * through an interrupt call or through profiling
		 * @param	mcID
		 * @param	clipID
		 */
		private static function createBitmapData(mcID:uint, clipID:uint):void
		{
			funcVec[mcID](mcVec[mcID], clipID);
			var bmd:BitmapData = new BitmapData(mcVec[mcID].width, mcVec[mcID].height, true, 0x00000000);
			var transMatrix:Matrix = new Matrix();
			// prepare objects
			
			if (updateRegVec[mcID])
			{
				regCoord[mcID][clipID] = getAnchorPoint(mcVec[mcID]);
				transMatrix.translate(regCoord[mcID][clipID].x, regCoord[mcID][clipID].y);
			}else
			{
				if (regCoord[mcID][0] == null) regCoord[mcID][0] = getAnchorPoint(mcVec[mcID]);
				transMatrix.translate(regCoord[mcID][0].x, regCoord[mcID][0].y);
			}
			// setup translation and registration points
			
			bmd.draw(mcVec[mcID], transMatrix);
			bDataVec[mcID][clipID] = bmd;
			// generate bitmapData
			
			profileCount++;
			// keep track how many BMDs are made per frame
		}
		
		/**
		 * Finds out the registration point value of a movieclip
		 * @param	mc
		 * @return
		 */
		private static function getAnchorPoint(mc:MovieClip):Point
		{
			if (Core.container != null)
			{
				Core.container.addChild(mc);
				var rect:Rectangle = mc.getRect(mc);
				var pt:Point = new Point( -1 * rect.x, -1 * rect.y);
				Core.container.removeChild(mc);
				return pt;
			}else
			{
				Error("Core has to be started prior to the use of this method");
			}
			return new Point();
		}
		
		/* SUB METHODS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Used by blitCanvas to retrieve bitmapData to print
		 * @param	mcID
		 * @param	cID
		 * @return
		 */
		internal static function getBitmapData(mcID:uint, cID:uint):BitmapData
		{
			if (bDataVec[mcID][cID] == null) createBitmapData(mcID, cID);
			return bDataVec[mcID][cID];
		}
		
		/**
		 * Used by blitCanvas to get the registration point coordinates
		 * @param	mcID
		 * @param	cID
		 * @return
		 */
		internal static function getRegCoord(mcID:uint, cID:uint):Point
		{
			return regCoord[mcID][updateRegVec[mcID] ? cID : 0];
		}
		
		/**
		 * Returns the total amount of clips registered to the movieclip ID
		 * @param	mcID
		 * @return
		 */
		public static function getTotalClips(mcID:uint):uint
		{
			return bDataVec[mcID].length;
		}
		
		/* INTERNAL GETTERS */
		//-----------------------------------------------------------------------------------------
		
	}

}