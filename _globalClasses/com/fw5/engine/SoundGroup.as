package com.fw5.engine 
{
	/**
	 * Manages groups of wrapper objects
	 * @author Haliq
	 */
	internal final class SoundGroup 
	{
		/* VARIABLES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** group volume */
		private var _groupVol:Number = 1;
		/** vector of wrapper under its management */
		private var wrapRef:Vector.<SoundWrap> = new Vector.<SoundWrap>();
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Start a group with an initial volume
		 * @param	initVol
		 */
		public function SoundGroup(initVol:Number = 1) 
		{
			groupVol = initVol;
		}
		
		/**
		 * Declare a wrapper under its management
		 * @param	wrap
		 */
		public function addWrap(wrap:SoundWrap):void
		{
			wrapRef.push(wrap);
		}
		
		/**
		 * Remove a wrapper and return it to engine to be reused
		 * @param	wrap
		 */
		public function removeWrap(wrap:SoundWrap):void
		{
			wrapRef.splice(wrapRef.indexOf(wrap), 1);
			SoundCore.returnWrap(wrap);
		}
		
		/**
		 * Stop instance(s) of sounds
		 * @param	sIndex		Index of sound to be stopped (-1 stops all)
		 * @param	fadeStep	Fade out level (between 0 to 1) (1 stops immediately)
		 */
		public function stopAllInstances(sIndex:int = -1, fadeStep:Number = 1):void
		{
			for (var i:int = wrapRef.length - 1; i >= 0; i--)
			{
				if (wrapRef[i].sInd == sIndex || sIndex == -1)
				{
					if (fadeStep > 0 && fadeStep < 1) wrapRef[i].fadeOut(fadeStep);
					else wrapRef[i].dnit();
				}
			}
		}
		
		/* WRAPPER CONTROL */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Define volume
		 * @param	vol		Desired volume
		 * @param	sIndex	Index of sound to set volume on (-1 sets on whole group volume)
		 */
		public function setVol(vol:Number, sIndex:int = -1):void
		{
			if (sIndex == -1)
			{
				groupVol = vol;
			}else
			{
				for (var i:int = wrapRef.length - 1; i >= 0; i--)
				{
					if (wrapRef[i].sInd == sIndex || sIndex == -1)
					{
						wrapRef[i].setVolume(vol);
					}
				}
			}
		}
		
		/**
		 * Updates all wrappers volume through groupVol setter algorithm
		 */
		public function updateVol():void
		{
			groupVol = _groupVol;
		}
		
		/**
		 * Define a volume for the group and update wrappers
		 */
		public function set groupVol(vol:Number):void
		{
			_groupVol = vol;
			for (var i:int = wrapRef.length - 1; i >= 0; i--)
			{
				wrapRef[i].updateVol();
			}
		}
		
		/**
		 * Group volume
		 */
		public function get groupVol():Number
		{
			return _groupVol;
		}
		
		/* VOLUME CONTROL */
		//-----------------------------------------------------------------------------------------
		
	}

}