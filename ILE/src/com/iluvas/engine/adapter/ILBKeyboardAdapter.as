package com.iluvas.engine.adapter 
{
	import com.iluvas.engine.event.ILEEventManager;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	/**
	 * This is an adapter builder for the keyboard. To customize which keys to listen to, you can
	 * specify it on construct by either defining a list of keycode or strings ("A", "B", "C").
	 * This list can be changed on runtime, either removing a key or adding new ones.
	 * 
	 * EVENT MESSAGES:
	 * 0|X : KEY_DOWN, keyCode X was pressed
	 * 1|X : KEY_UP, keyCode Y was released
	 * @author iluvAS
	 */
	public final class ILBKeyboardAdapter extends ILBAdapter 
	{
		
		/** Contains a list of all the keycodes to listen to */
		private var keyVec:Vector.<int> = new Vector.<int>();
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initialize the keyboard adapter with a stage reference and set up the list of keys
		 * Following all declarations, this object will automatically declare itself to adapter
		 * manager
		 * @param	stageParam
		 * @param	...keyCodes		You can pass in keyCodes or strings i.e. "A", "B", "C"
		 */
		public function ILBKeyboardAdapter(stageParam:Stage, ...keyCodes) 
		{
			super(stageParam);
			// capture stage reference
			
			addKeyCodes(keyCodes);
			
			AGID = 2;
			ILEAdapterManager.declareAdapter(this);
			// declare to adapter manager
		}
		
		/**
		 * Remove all event listeners
		 */
		internal override function dnit():void
		{
			stageRef.removeEventListener(KeyboardEvent.KEY_DOWN, kd);
			stageRef.removeEventListener(KeyboardEvent.KEY_UP, ku);
		}
		
		/**
		 * Start event listening
		 */
		internal override function init():void
		{
			stageRef.addEventListener(KeyboardEvent.KEY_DOWN, kd);
			stageRef.addEventListener(KeyboardEvent.KEY_UP, ku);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE FUNCTIONS
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Use this function to start listening to keys specified in the argument
		 * You can pass in keyCodes or strings i.e. "A", "B", "C"
		 * @param	...keyCodes
		 */
		public function addKeyCodes(...keyCodes):void
		{
			var realKeyCode:Array;
			// declare container for finalized list of keys to add
			
			if (keyCodes[0] is Array)
			{
				realKeyCode = keyCodes[0];
				// if argument passed was from constructor variable arg, take 2nd dim array
			}else
			{
				realKeyCode = keyCodes;
				// if argument passed was directly called, use argument itself
			}
			
			for (var i:String in realKeyCode)
			{
				if (realKeyCode[i] is String)
				{
					var convertedString:uint = String(realKeyCode[i]).charCodeAt(0);
					if (keyVec.indexOf(convertedString) == -1)
					{
						keyVec.push(convertedString);
					}
					// if element contains a string, use first character converted to keyCode
				}else
				{
					if (keyVec.indexOf(realKeyCode[i]) == -1)
					{
						keyVec.push(realKeyCode[i]);
					}
				}
				// if key does not exist, add to vector
			}
		}
		
		/**
		 * Use this function to stop listening to keys specified in argument
		 * @param	...keyCodes
		 */
		public function removeKeyCodes(...keyCodes):void
		{
			for (var i:String in keyCodes)
			{
				if (keyVec.indexOf(keyCodes[i]) != -1)
				{
					keyVec.splice(keyVec.indexOf(keyCodes[i]), 1);
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// KEY CODE MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		private function kd(e:KeyboardEvent):void
		{
			if (keyVec.indexOf(e.keyCode) != -1)
			{
				ILEEventManager.inform(ILEAdapterManager.GID + AGID, "0|" + e.keyCode);
			}
		}
		
		private function ku(e:KeyboardEvent):void
		{
			if (keyVec.indexOf(e.keyCode) != -1)
			{
				ILEEventManager.inform(ILEAdapterManager.GID + AGID, "1|" + e.keyCode);
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// EVENT LISTENER FUNCTIONS
		//-------------------------------------------------------------------------------------------------------------
	}

}