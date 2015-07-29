package com.fw5.engine 
{
	import com.fw5.engine.abstracts.Runnable;
	import com.fw5.engine.abstracts.Transition;
	import flash.display.Sprite;
	/**
	 * Centralized management for core display object containers and manages runnables transition
	 * from one to another, hence managing game states.
	 * @author Haliq
	 */
	public final class State 
	{
		/* VARIABLES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** Sprite that holds all content (runnables) */
		private static var cSpr:Sprite = new Sprite();
		/** Sprite that holds active transitions */
		private static var tSpr:Sprite = new Sprite();
		/** Sprite that holds overlay items */
		public static var ovSpr:Sprite = new Sprite();
		// SPRITES CONTAINERS ---------------------------------------------------------------------
		
		/** Reference to currently active runnable */
		private static var cRun:Runnable = null;
		/** Reference to destination runnable after transition */
		private static var dRun:Runnable = null;
		// RUNNABLE REFERENCES --------------------------------------------------------------------
		
		/** Index of transition to be used */
		private static var tIndex:int = -1;
		/** Flag to determine if cRun has swapped with dRun */
		private static var tHasSwapped:Boolean = false;
		/** Flag to determine if transition is in progress */
		private static var tInProgress:Boolean = false;
		/** Vector of declared transition objects */
		private static var trnVec:Vector.<Transition> = new Vector.<Transition>();
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Declare a transition object so that it could be used when calling goToRunnable
		 * @param	transition
		 * @return	index the transition object is stored in
		 */
		public static function declareTransition(transition:Transition):int
		{
			trnVec.push(transition);
			return trnVec.length - 1;
		}
		
		/**
		 * Changes the state from the current runnable (if any) to the parameter runnable
		 * @param	runnable	The destination runnable to swap to
		 * @param	transition	The index of the transition, -1 will perform an instant swap
		 * @param	dontInit	TRUE will not call the init of the destination runnable
		 */
		public static function goToRunnable(runnable:Runnable, transition:int = -1, dontInit:Boolean = false):void
		{
			if (cSpr.parent == null)
			{
				Core.container.addChild(cSpr);
				Core.container.addChild(tSpr);
				Core.container.addChild(ovSpr);
			}
			// if state sprite is uninitialized, init it
			
			if (!tInProgress && !Core.gameLockDown)
			{
				dRun = runnable;
				tIndex = transition >= 0 && transition < trnVec.length ? transition : -1;
				// store transition and destination runnable
				
				if (transition < 0) swapRunnables(dontInit);
				else
				{
					tSpr.addChild(trnVec[tIndex]);
					trnVec[tIndex].init();
					tInProgress = true;
					Core.addAlgo(algo);
				}
				// initiate transition
			}
		}
		
		/* PUBLIC CALLS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Method that performs transition animation management
		 */
		private static function algo():void
		{
			trnVec[tIndex].algo();
			// run algo
			
			if (trnVec[tIndex].swap && !tHasSwapped)
			{
				swapRunnables();
				tHasSwapped = true;
				// set flag
			}else if (trnVec[tIndex].complete)
			{
				trnVec[tIndex].resetFlags();
				trnVec[tIndex].dnit();
				tSpr.removeChild(trnVec[tIndex]);
				tHasSwapped = false;
				tInProgress = false;
				Core.removeAlgo(algo);
			}
			// reset on complete
		}
		
		/* PRIVATE UTILS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Swaps current runnable to flagged destination runnable
		 * @param	dontInit	TRUE will not call nested init of the destination runnable
		 */
		private static function swapRunnables(dontInit:Boolean = false):void
		{
			if (cRun != null)
			{
				Core.removeAlgo(cRun.iterAlgo);
				cRun.iterDnit();
				cSpr.removeChild(cRun);
				cRun = null;
			}
			// dnit current
			
			cRun = dRun;
			cSpr.addChild(cRun);
			if (!dontInit)
			{
				cRun.iterInit();
				Core.addAlgo(cRun.iterAlgo);
			}
			// init destination
		}
	}

}