package com.fw5.engine 
{
	import com.fw5.engine.concrete.LockedRunnable;
	/**
	 * This game provides a centralized location to maintain version and distribution controls
	 * specifically game locks. All future locking algorithms should be placed here. Making any
	 * lock calls on lock success will immediately put the game in lockdown, no futhur transitions
	 * can be made and the game will be stuck on a screen displaying the locked message
	 * @author iluvAS
	 */
	public final class Security 
	{
		/* PROPERTIES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		private static const SITE_LOCK_MSG:String = "Thanks for making this game viral but this version is locked to : ";
		private static const DEF_HEADER:String = "<font color='#ffcc22'> ---- </font><font color='#FA9615'>ILUVAS GAMES</font><font color='#ffcc22'> ---- </font>";
		private static const DEF_MSGCLR:String = "FCBF6D";
		private static const DEF_LISTCLR:String = "DDDDDD";
		
		/* MESSAGE CONSTANTS */
		//-----------------------------------------------------------------------------------------
		
		/** A string used to differentiate multiple implementations in one swf */
		public static var verID:String = "default";
		
		/** The domain this swf is currently being played from */
		private static var _currentDomain:String;
		
		/** List of domains allowed to run this swf */
		private static var _allowedDoms:Vector.<String> = new Vector.<String>();
		
		/** Blocked graphics runnable object */
		private static var blockRunnable:LockedRunnable;
		
		/* VERSION CONTROL VARS */
		//-----------------------------------------------------------------------------------------
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Run this function at any time in the game to check and lock if game is hosted illegally
		 */
		public static function runSiteLockCheck():void
		{
			_currentDomain = (Core.container.stage.root.loaderInfo.url.split("://")[1] as String).split("/")[0];
			if (_currentDomain == "")
			{
				_currentDomain = "local";
			}
			// get domain
			
			if (_allowedDoms.length != 0 && _allowedDoms.indexOf(currentDomain) == -1)
			{
				initLockRunnable(SITE_LOCK_MSG, true);
			}
			// site lock algorithm
		}
		
		/**
		 * Run this function to lock a game due to the host blocking outgoing URLs
		 */
		public static function runUrlBlockCheck():void
		{
			//TODO: PLACEHOLDER FOR FUTURE USE
		}
		
		/**
		 * Run this function to lock a game for any reason provided in the msg parameter
		 * @param	msg
		 */
		public static function setCustomLock(msg:String):void
		{
			initLockRunnable(msg);
		}
		
		/* LOCKING ALGORITHMS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Add urls that this game can be hosted on, if no domains exists in this vector, it
		 * can be played on all
		 * @param	...urls
		 */
		public static function addAllowedDomains(...urls):void
		{
			for (var i:String in urls)
			{
				_allowedDoms.push(urls[i] as String);
			}
		}
		
		/**
		 * Prepares and locks the game to the locked screen
		 * @param	msg
		 */
		private static function initLockRunnable(msg:String, showDomList:Boolean = false):void
		{
			if (blockRunnable == null) blockRunnable = new LockedRunnable(0x000000);
			blockRunnable.declareText(generateHtmlText(msg, showDomList));
			
			State.goToRunnable(blockRunnable);
			Core._gameLockDown = true;
		}
		
		/**
		 * Generate the htmlText to display on the lock screen based on the parameters
		 * @param	msg				Text of message
		 * @param	showDomList		TRUE - shows domain list
		 * @return
		 */
		private static function generateHtmlText(msg:String, showDomList:Boolean = false):String
		{
			var htmlString:String = DEF_HEADER + "<br><br><font color='#" + DEF_MSGCLR + "'>" + msg + "</font><br>";
			if (showDomList)
			{
				for (var i:int = _allowedDoms.length - 1; i >= 0; i--)
				{
					htmlString += "<br><font color='#" + DEF_LISTCLR +"'><A HREF='http://" + allowedDoms[i] + "' target='_blank'><U>" +allowedDoms[i] + "</U></A></font>";
				}
			}
			return htmlString;
		}
		
		/* UTILS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Get the vector of all URLS this swf is locked to
		 */
		public static function get allowedDoms():Vector.<String> 
		{
			return _allowedDoms;
		}
		
		/**
		 * Get the current domain this swf is hosted on
		 */
		public static function get currentDomain():String 
		{
			return _currentDomain;
		}
		
		/* GETTERS */
		//-----------------------------------------------------------------------------------------
		
	}

}