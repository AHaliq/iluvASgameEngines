package com.iluvas.engine.core.initialBuilders.preloader 
{
	import com.iluvas.engine.core.componentBuilders.ILBGameProperties;
	import flash.display.MovieClip;
	
	/**
	 * This class is meant to be used as an abstract class for any preloader instance.
	 * With this implementation the following tasks will be handled by the abstract class
	 * 1. Detect loading completion
	 * 2. Managing event handlers
	 * 3. Functions to load game builder class
	 * @usage The cconcrete class extending this class will have to override the following
	 * functions:
		 * 1. updateProgress	- Update the variable captureProgress to ease to actualProgress
		 * 2. frameByFrameCode	- Graphical animation code to display captureProgress value
		 * (MAKE SURE TO ADDCHILD OR DRAW GRAPHICS INTO graphicContainer and not into this object
		 * itself)
	 * The concrete class will also have to define the following variables:
		 * 1. autoPlay
		 * 2. gameBuilderStr
		 * 3. gameProperties (if you intend to get domain status in preloader)
	 * Do note, in declaring the gameBuilderStr it is reccomended to write the class name above
	 * the assignment as such:
		 * <class>
		 * gameBuilderStr = "<class>";
	 * @author iluvAS
	 */
	public class ILBPreloader extends MovieClip 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** This is a container that will hold all preloader's graphic assets */
		private var _graphicContainer:ILCGraphicContainer;
		
		/** This component handles the event handling and returns the actualProgress value */
		private var loader:ILCLoader;
		
		/** This component manages the calls to complete the loading and moving on to the next phase */
		private var executor:ILCExecutor;
		
		/** Reference to the preloader declared gameProperties object */
		private var captureProperties:ILBGameProperties;
		
		//-------------------------------------------------------------------------------------------------------------
		// COMPLEX OBJECTS
		//-------------------------------------------------------------------------------------------------------------
		
		/** The event id value used for preloader informs */
		internal static const GID:int = 1;
		
		/** The usable progress value */
		protected var captureProgress:Number = 0;
		
		/** If true, this class will automatically advance to complete procedure 
		 * If false, concrete class will have to call manualPlay() to move on*/
		protected var autoPlay:Boolean = false;
		
		/** Name of concrete class of gameBuilder in a string */
		protected var gameBuilderStr:String;
		
		//-------------------------------------------------------------------------------------------------------------
		// VALUES AND FLAGS
		//-------------------------------------------------------------------------------------------------------------
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Constructing this object will initialize its components and display objects
		 */
		public function ILBPreloader()
		{
			_graphicContainer = new ILCGraphicContainer(this);
			loader = new ILCLoader(this);
			executor = new ILCExecutor(this);
			// initialize complex object components
			
			addChild(_graphicContainer);
			// add graphicContainer to displayList
		}
		
		/**
		 * The frame by frame code to be run
		 */
		internal final function algo():void
		{
			updateProgress();
			frameByFrameCode();
			// call placeholder functions
			
			if (executor.checkLoadComplete(captureProgress))
			{
				executor.checkAndExecuteNextPhase();
			}
			// call executor load completes
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * This function should contain code to manage the advancement of the loading
		 * Already inside is a template that eases to the actual value
		 */
		public function updateProgress():void
		{
			captureProgress += (actualProgress - captureProgress) / 2;
			if (captureProgress >= 0.99)
			{
				captureProgress = 1;
			}
		}
		
		/**
		 * This function should contain code for the graphical animation code to display progress
		 * Already inside is a template that simply fills a rectangle at the top left of the screen
		 */
		public function frameByFrameCode():void
		{
			const loaderWdt:int = 150;
			const loaderHgt:int = 15;
			const boarder:int = 2.5;
			const xPos:int = 0;
			const yPos:int = 0;
			const baseCol:uint = 0xEEEEEE;
			const fillCol:uint = 0x000000;
			
			_graphicContainer.graphics.clear();
			_graphicContainer.graphics.beginFill(baseCol);
			_graphicContainer.graphics.drawRect(xPos, yPos, loaderWdt, loaderHgt);
			_graphicContainer.graphics.beginFill(fillCol);
			_graphicContainer.graphics.drawRect(xPos + boarder, yPos + boarder,
			(loaderWdt - (boarder * 2)) * captureProgress, loaderHgt - (boarder * 2));
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// OVERRIDABLE FUNCTIONS
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Use this function to send input denoting preloader is ready to move on when game is loaded
		 */
		public final function manualPlay():void
		{
			executor.manualPlay(captureProgress);
		}
		
		/**
		 * Use this function to define the game properties that was declared in the concrete if any
		 */
		public final function declareGameProperties(obj:ILBGameProperties):void
		{
			captureProperties = obj;
			obj.updateDomain(stage);
		}
		
		/**
		 * This function is used by executor to terminate and remove references in preparation to
		 * advance to the next phase
		 */
		internal final function prepareLoadComplete():void
		{
			loader.prepareLoadComplete();
		}
		
		/**
		 * This function is called by executor to terminate the enter_frame event
		 */
		internal final function removeEnterFrame():void
		{
			loader.removeEnterFrame();
		}
		//-------------------------------------------------------------------------------------------------------------
		// CONCRETE CONTROLS
		//-------------------------------------------------------------------------------------------------------------
		
		public function get actualProgress():Number
		{
			return loader.actualProgress;
		}
		
		public function get graphicContainer():ILCGraphicContainer
		{
			return _graphicContainer;
		}
		
		internal function get _autoPlay():Boolean
		{
			return autoPlay;
		}
		
		internal function get _gameBuilderStr():String
		{
			return gameBuilderStr;
		}
		
		internal function get _gameProperties():ILBGameProperties
		{
			return captureProperties;
		}
		//-------------------------------------------------------------------------------------------------------------
		// GETTERS
		//-------------------------------------------------------------------------------------------------------------
	}

}