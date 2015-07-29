package com.fw5.engine 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * Centralized reference for root sprite and game canvas's dimensions
	 * Warehouse for functions to be run on every frame
	 * @author Haliq
	 */
	public class Core 
	{
		
		/* VARIABLES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** The game canvas's width */
		private static var _WDT:uint;
		/** The game canvas's height*/
		private static var _HGT:uint;
		/** Flag that determines if game is locked */
		internal static var _gameLockDown:Boolean = false;
		
		/** Reference to root sprite */
		private static var _container:Sprite;
		/** Vector of algo functions to be called on every frame */
		private static var algoLibrary:Vector.<Function> = new Vector.<Function>();
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Declare the root container for the application to run on
		 * Starts the frame by frame event listener
		 * Keep centralized location to retrieve game canvas's width and height
		 * @param	container
		 * @param	WDT			the width reference value
		 * @param	HGT			the height reference value
		 */
		public static function start(container:Sprite, WDT:uint = 0, HGT:uint = 0):void
		{
			if (_container != null) _container.removeEventListener(Event.ENTER_FRAME, codeLoop);
			_container = container;
			if (algoLibrary.length != 0) _container.addEventListener(Event.ENTER_FRAME, codeLoop);
			
			_WDT = WDT == 0 ? _container.stage != null ? _container.stage.stageWidth : 0 : WDT;
			_HGT = HGT == 0 ? _container.stage != null ? _container.stage.stageHeight : 0 : HGT;
		}
		
		/**
		 * Declare a function to be called on every frame
		 * @param	f
		 */
		public static function addAlgo(f:Function):void
		{
			if (algoLibrary.length == 0) _container.addEventListener(Event.ENTER_FRAME, codeLoop);
			algoLibrary.push(f);
		}
		
		/**
		 * Stop calling the declared function on every frame
		 * @param	f
		 */
		public static function removeAlgo(f:Function):void
		{
			algoLibrary.splice(algoLibrary.indexOf(f), 1);
			if (algoLibrary.length == 0) _container.removeEventListener(Event.ENTER_FRAME, codeLoop);
		}
		
		/* PUBLIC CALLS */
		//-----------------------------------------------------------------------------------------
		
		private static function codeLoop(e:flash.events.Event):void
		{
			for (var i:int = algoLibrary.length - 1; i >= 0; i--) algoLibrary[i]();
		}
		
		/* EVENT METHODS */
		//-----------------------------------------------------------------------------------------
		
		/** Reference to stage */
		public static function get stage():Stage { return container.stage; }
		/** Reference to root sprite */
		public static function get container():Sprite { return _container; }
		/** The game canvas's width */
		public static function get WDT():uint { return _WDT; }
		/** The game canvas's height */
		public static function get HGT():uint { return _HGT; }
		/** Status if the game has been locked */
		public static function get gameLockDown():Boolean  { return _gameLockDown; }
		/** The stage mouse X value */
		public static function get mouseX():Number { return _container.stage.mouseX; }
		/** The stage mouse Y value */
		public static function get mouseY():Number { return _container.stage.mouseY; }
		
		/* GETTERS */
		//-----------------------------------------------------------------------------------------
		
	}

}