package com.fw5.engine.concrete 
{
	import com.fw5.engine.abstracts.Runnable;
	import com.fw5.engine.Core;
	import com.fw5.engine.State;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	/**
	 * Create a concrete out of this class, override init, dnit and algo if necessary, in the
	 * Main Class, above class definition, write out this: [Frame(factoryClass="<concrete loader>")]
	 * where <concrete loader> is the name of the concrete class that extends this class.
	 * @author Haliq
	 */
	public class Preloader extends Runnable 
	{
		// VARIABLES
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** Captured WDT for Core restart */
		private var bufferWDT:Number;
		/** Captured HGT for Core restart */
		private var bufferHGT:Number;
		
		/** total bytes to be loaded */
		private var _total:Number = 0;
		/** total bytes loaded */
		private var _loaded:Number = 0;
		
		/** TRUE will automatically call main.as on load complete */
		private var autoStart:Boolean;
		/** Determines the class name of the main / builder */
		private var builderStr:String;
		
		// METHODS
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * During this object's lifecycle it will assume to be the main container hence WDT and HGT
		 * has to be defined for Core. (see engine.Core.as for more info) After game has loaded
		 * it will transfer container reference to Main.as by default.
		 * @param	auto		TRUE will invoke mainString class after loading
		 * @param	mainString	The class name of the class to invoke after loading
		 * @param	WDT			WDT to define to Core
		 * @param	HGT			HGT to define to Core
		 */
		public function Preloader(auto:Boolean = false, mainString:String = "Main", WDT:uint = 0, HGT:uint = 0) 
		{
			builderStr = mainString;
			autoStart = auto;
			bufferWDT = WDT;
			bufferHGT = HGT;
			// capture parameters
			
			Core.start(this);
			iterInit();
			Core.addAlgo(iterAlgo);
			Core.addAlgo(trackProgress);
		}
		
		/** Placeholder for method to be called when it gets added to stage
		 * Override this method, do not call it, it will be handled by the framework */
		override protected function init():void 
		{
			graphics.clear();
			graphics.beginFill(0x333333);
			graphics.drawRect(0, 0, 104, 14);
			graphics.endFill();
		}
		
		/** Placeholder for method to be called when it gets removed from stage
		 * Override this method, do not call it, it will be handled by the framework */
		override protected function dnit():void 
		{
			graphics.clear();
			graphics.beginFill(0x333333);
			graphics.drawRect(0, 0, 104, 14);
			graphics.endFill();
			graphics.beginFill(0x666666);
			graphics.drawRect(2, 2, 100 * loaded / total, 10);
			graphics.endFill();
		}
		
		/** Placeholder for method to be called on every frame when on stage
		 * Override this method, do not call it, it will be handled by the framework */
		override protected function algo():void 
		{
			graphics.clear();
			graphics.beginFill(0x333333);
			graphics.drawRect(0, 0, 104, 14);
			graphics.endFill();
			graphics.beginFill(0x666666);
			graphics.drawRect(2, 2, 100, 10);
			graphics.endFill();
		}
		
		//KEY METHODS
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Concrete should call this method if auto is false. Call this method when user wants to
		 * proceed to the start of the application, i.e. on play or start button.
		 */
		protected function loadingComplete():void
		{
			if (_loaded == _total)
			{
				try
				{
					var builderClass:Class = getDefinitionByName(builderStr) as Class;
					var mainRef:Sprite = new builderClass();
					var parentCapture:DisplayObjectContainer = parent;
					
					parentCapture.removeChild(this);
					Core.start(mainRef, bufferWDT, bufferHGT);
					State.goToRunnable(this, -1, true);
					parentCapture.addChild(mainRef);
				}catch(e:Error)
				{
					trace("PRELOADER ERORR: class " + builderStr + " does not exist");
				}
			}
		}
		
		/**
		 * Recalculates the loading progress
		 */
		private function trackProgress():void
		{
			_total = Core.container.stage.loaderInfo.bytesTotal;
			_loaded = Core.container.stage.loaderInfo.bytesLoaded;
			if (_loaded == _total)
			{
				Core.removeAlgo(trackProgress);
				if (autoStart) loadingComplete();
			}
		}
		
		// PRIVATE METHODS
		//-----------------------------------------------------------------------------------------
		
		protected function get total():Number
		{
			return _total;
		}
		
		protected function get loaded():Number
		{
			return _loaded;
		}
		
		//GETTERS
		//-----------------------------------------------------------------------------------------
	}

}