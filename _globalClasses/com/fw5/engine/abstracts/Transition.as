package com.fw5.engine.abstracts 
{
	import flash.display.Sprite;
	
	/**
	 * This abstract serves as a placeholder for init, dnit and algo along with 2 other properties
	 * The concrete will have to define when to set swap and complete to true and sync it to their
	 * animation.
	 * @author Haliq
	 */
	public class Transition extends Sprite 
	{
		/* VARIABLES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** TRUE - informs state to swap current to destination runnable */
		protected var _swap:Boolean = false;
		/** TRUE - informs state to call dnit() */
		protected var _complete:Boolean = false;
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Is called when transition begins. If you were to composition a runnable, in here is
		 * where you would call its iterInit();.
		 */
		public function init():void { }
		
		/**
		 * Is called when transition ends. If you were to composition a runnable, in here is
		 * where you would call its iterDnit();.
		 */
		public function dnit():void { }
		
		/**
		 * Is called when transition in progress. If you were to composition a runnable, in here is
		 * where you would call its iterAlgo();.
		 */
		public function algo():void { }
		
		/* KEY METHODS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * This method will be and should only be called by State engine
		 */
		public function resetFlags():void
		{
			_swap = false;
			_complete = false;
		}
		
		public function get swap():Boolean { return _swap; }
		
		public function get complete():Boolean { return _complete; }
		
		/* FLAG CONTROL */
		//-----------------------------------------------------------------------------------------
		
	}

}