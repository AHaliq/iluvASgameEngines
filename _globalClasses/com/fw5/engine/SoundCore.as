package com.fw5.engine 
{
	import flash.media.Sound;
	/**
	 * Centralized class to manage all sound activities. Allows control of volume and manages
	 * sounds in groups.
	 * @author Haliq
	 */
	public final class SoundCore
	{
		/* VARIABLES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** Global volume on all sounds */
		private static var _globalVol:Number = 1;
		/** Vector of all sound instances declared and playable */
		private static var soundLib:Vector.<Sound> = new Vector.<Sound>();
		/** Vector of sound groups */
		private static var soundGrp:Vector.<SoundGroup> = new Vector.<SoundGroup>();
		/** Vector of wrappers available to be reused */
		private static var wrapVec:Vector.<SoundWrap> = new Vector.<SoundWrap>();
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Play a sound
		 * @param	sIndex		Index of sound to be played (given on declaration call)
		 * @param	initVol		Volume for this instance to begin with
		 * @param	gIndex		Index of group this play instance should be in
		 * @param	fadeStep	Fade in volume (between 0 and 1) (1 = no fading / full volume)
		 * @param	repeat		Sound will repeat itself when it ends
		 */
		public static function playSound(sIndex:int, initVol:Number = 1, gIndex:int = -1, fadeStep:Number = 1, repeat:Boolean = false):void
		{
			if (soundGrp.length == 0) soundGrp.push(new SoundGroup());
			// create default group
			var gInd:int = (gIndex >= 0 && gIndex < soundGrp.length) ? gIndex : 0;
			// find group to allocate
			
			if (sIndex >= 0 && sIndex < soundLib.length)
			{
				var w:SoundWrap = wrapVec.length == 0 ? new SoundWrap() : wrapVec.pop();
				w.init(soundLib[sIndex], sIndex, initVol * _globalVol * soundGrp[gInd].groupVol, fadeStep, repeat, soundGrp[gInd]);
				// create wrap
				
				soundGrp[gInd].addWrap(w);
			}
		}
		
		/**
		 * Stop sound(s)
		 * @param	sIndex		Index of the sound to be stopped (-1 will stop all sounds)
		 * @param	gIndex		Index of the group to be stopped (-1 wiil stop all groups)
		 * @param	fadeStep	Fade out volume (between 0 and 1) (1 = no fading / immediate stop)
		 */
		public static function stopSound(sIndex:int = -1, gIndex:int = -1, fadeStep:Number = 1):void
		{
			if (gIndex >= 0 && gIndex < soundGrp.length)
			{
				if (sIndex >= 0 && sIndex < soundLib.length) soundGrp[gIndex].stopAllInstances(sIndex, fadeStep);
				else soundGrp[gIndex].stopAllInstances( -1, fadeStep);
				// stop within group boundaries
			}else
			{
				for (var i:int = soundGrp.length - 1; i >= 0; i--)
				{
					if (sIndex >= 0 && sIndex < soundLib.length) soundGrp[i].stopAllInstances(sIndex, fadeStep);
					else soundGrp[i].stopAllInstances(-1, fadeStep);
				}
				// stop for all groups
			}
		}
		
		/**
		 * Change the volume of all or a group or type of sound
		 * @param	vol			volume desired
		 * @param	gIndex		index of group to alter (-1 alters global volume)
		 * @param	sIndex		index of sound to alter (-1 alters group volume)
		 */
		public static function setVolume(vol:Number, gIndex:int = -1, sIndex:int = -1):void
		{
			var i:int;
			var v:Number = vol;
			if (v < 0) v = 0;
			else if (v > 1) v = 1;
			// limit volume range
			
			if (gIndex == -1 && sIndex == -1)
			{
				_globalVol = v;
				for (i = soundGrp.length - 1; i >= 0; i--)
				{
					soundGrp[i].updateVol();
				}
				// set global volume
			} else if (gIndex >= 0 && gIndex < soundGrp.length)
			{
				if (sIndex >= 0 && sIndex < soundLib.length) soundGrp[gIndex].setVol(v, sIndex);
				else soundGrp[gIndex].groupVol = v;
				// set sound volume for group else group volume
			}else if (sIndex >= 0 && sIndex < soundLib.length)
			{
				for (i = soundGrp.length - 1; i >= 0; i--)
				{
					soundGrp[i].setVol(v, sIndex);
				}
				// set sound volume for all groups
			}
		}
		
		/* SOUND CONTROL */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Declare a sound to be used in the engine
		 * @param	snd
		 * @return
		 */
		public static function declareSound(snd:Sound):int
		{
			soundLib.push(snd);
			return soundLib.length - 1;
		}
		
		/**
		 * Declare a new group to manage sounds
		 * @param	initVol
		 * @return
		 */
		public static function makeGroup(initVol:Number = 1):int
		{
			soundGrp.push(new SoundGroup(initVol));
			return soundGrp.length - 1;
		}
		
		/**
		 * Pass a wrapper to be reused
		 * @param	wrap
		 */
		internal static function returnWrap(wrap:SoundWrap):void
		{
			wrapVec.push(wrap);
		}
		
		/**
		 * Global volume of whole engine
		 */
		public static function get globalVol():Number
		{
			return _globalVol;
		}
		
		/* UTIL METHIODS */
		//-----------------------------------------------------------------------------------------
		
	}

}