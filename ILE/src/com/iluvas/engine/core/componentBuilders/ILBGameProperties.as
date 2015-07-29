package com.iluvas.engine.core.componentBuilders 
{
	import flash.display.Stage;
	/**
	 * This is an abstract class for matters regarding implementation IDs, site locks and game
	 * resolution. All of these values will have to be defined in the concrete class
	 * @usage After defining all the inherited properties, either declare gameProperties from a
	 * preloader object or directly into a game builder so that its reference will be kept in
	 * ILECore, to enable a global static access to the concrete object.
	 * @author iluvAS
	 */
	public class ILBGameProperties 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The width of the game */
		public var gameWdt:Number = 800;
		/** The height of the game */
		public var gameHgt:Number = 600;
		
		/** List of domains that are paired with implementation */
		public var implementationDomain:Vector.<String> = new Vector.<String>();
		/** List of IDs that are known as implementation, when the game's domain exists in
		 * implementationDomain, its implementation will be the one parallel here */
		public var implementationPair:Vector.<String> = new Vector.<String>();
		/** The implementation the swf will be if theres no match in the implementaitonDomain */
		public var defaultImplementation:String = "";
		/** The current active imeplementation */
		private var _currentImplementation:String = "";
		
		/** The domains this swf is allowed to run on, if none, all is allowed */
		public var allowedDomains:Vector.<String> = new Vector.<String>();
		/** The current domain this swf is on */
		private var _currentDomain:String = "";
		/** TRUE- this game has to be locked */
		private var _gameLockDown:Boolean = false;
		/** TRUE- the swf has completed domain check */
		private var domainFound:Boolean = false;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * This function is called to run site lock check and get the implementation based on
		 * parameters defined by the concrete class
		 * @param	stageRef
		 */
		public final function updateDomain(stageRef:Stage):void
		{
			if (!domainFound)
			{
				_currentDomain = String(stageRef.root.loaderInfo.url.split("://")[1]).split("/")[0];
				if (_currentDomain == "")
				{
					_currentDomain = "local";
				}
				// get domain
				
				var index:int;
				
				if (allowedDomains.length != 0)
				{
					index = allowedDomains.indexOf(_currentDomain);
					if (index == -1)
					{
						_gameLockDown = true;
					}
				}
				// site lock check
				
				index = implementationDomain.indexOf(_currentDomain);
				if (index >= 0)
				{
					_currentImplementation = implementationPair[index];
				}else
				{
					_currentImplementation = defaultImplementation;
				}
				// get implementation
				
				domainFound = true;
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE
		//-------------------------------------------------------------------------------------------------------------
		
		public final function get currentDomain():String
		{
			return _currentDomain;
		}
		
		public final function get gameLockDown():Boolean
		{
			return _gameLockDown;
		}
		
		public final function get currentImplementation():String
		{
			return _currentImplementation;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// GETTERS
		//-------------------------------------------------------------------------------------------------------------
	}

}