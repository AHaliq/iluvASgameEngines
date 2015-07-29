package com.fw5.engine 
{
	import flash.events.Event;
	import flash.media.SoundChannel;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	/**
	 * Keeps references of important information with regards to playback of the sound. Also
	 * manages fading algorithms and intelligently returns itself to management and return
	 * of resources to itself
	 * @author Haliq
	 */
	internal final class SoundWrap 
	{
		/* VARIABLEs */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** Lowest possible fading level*/
		private static const MIN_FADE:Number = 0.001;
		
		/** Index of sound in engine that this object is currently managing */
		public var sInd:int = -1;
		/** Flag to determine if sound repeats */
		private var rep:Boolean = false;
		/** Volume for the sound */
		private var sVol:Number = 1;
		/** Fade interval */
		private var fStep:Number = 1;
		/* DECLARED INFORMATION */
		//-----------------------------------------------------------------------------------------
		
		/** Gain level used in fading */
		private var gain:Number = 1;
		/** Flag determine if currently fading */
		private var fIn:Boolean = false;
		/** Flag determine if fade is completed */
		private var fComplete:Boolean = false;
		/** Flag determine if fade is in progress */
		private var fInProg:Boolean = false;
		/* REGISTERS */
		//-----------------------------------------------------------------------------------------
		
		private var ch:SoundChannel = new SoundChannel();
		private var trs:SoundTransform = new SoundTransform();
		private var pRef:SoundGroup;
		private var sRef:Sound;
		/* OBJECTS AND REFERENCES */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Initialize wrapper with sound and start it
		 * @param	sndRef		Reference to sound object
		 * @param	sIndex		Index in engine
		 * @param	soundVol	Initial volume for sound
		 * @param	fadeStep	Fade In interval step
		 * @param	repeat		TRUE - repeats on sound end
		 * @param	parentRef	reference to group that is currently managing the wrapper
		 */
		public function init(sndRef:Sound, sIndex:int, soundVol:Number, fadeStep:Number, repeat:Boolean, parentRef:SoundGroup):void
		{
			sRef = sndRef;
			pRef = parentRef;
			rep = repeat;
			fStep = fadeStep;
			if (fStep > 1) fStep = 1;
			else if (fStep < MIN_FADE) fStep = MIN_FADE;
			gain = fStep;
			sVol = soundVol;
			sInd = sIndex;
			// store information
			
			if (gain < 1)
			{
				fInProg = true;
				fIn = true;
				Core.addAlgo(algo);
			}
			// setup fade in if any
			
			ch = sRef.play();
			updateVol();
			ch.addEventListener(Event.SOUND_COMPLETE, endOfSound);
			// start playback
		}
		
		/**
		 * Restart values and stops playback
		 */
		public function dnit():void
		{
			sVol = 1;
			if (fInProg)
			{
				fInProg = false;
				fComplete = false;
				Core.removeAlgo(algo);
			}
			
			ch.stop();
			ch.removeEventListener(Event.SOUND_COMPLETE, endOfSound);
			pRef.removeWrap(this);
		}
		
		/**
		 * Carries out fading algorithm, this function is declared to core whenever
		 * necessary
		 */
		public function algo():void
		{
			if (fIn)
			{
				if (gain < 1) gain += fStep;
				if (gain >= 1)
				{
					fComplete = true;
					gain = 1;
				}
			}else
			{
				if (gain > 0) gain -= fStep;
				if (gain <= 0)
				{
					fComplete = true;
					gain = 0;
				}
			}
			// fade algorithm
			
			updateVol();
			if (fComplete)
			{
				fInProg = false;
				fComplete = false;
				Core.removeAlgo(algo);
			}
			// detect fade completed
		}
		
		/* CORE */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Initiate fade out procedure
		 * @param	fadeStep
		 */
		public function fadeOut(fadeStep:Number):void
		{
			fStep = (fadeStep > MIN_FADE) ? fadeStep : MIN_FADE;
			fInProg = true;
			fIn = false;
			Core.addAlgo(algo);
		}
		
		/**
		 * Declare volume for the sound that this object manages
		 * @param	v
		 */
		public function setVolume(v:Number):void
		{
			sVol = v;
			updateVol();
		}
		
		/**
		 * Calculate the final volume for the object and apply to channel
		 */
		public function updateVol():void
		{
			var finVol:Number = SoundCore.globalVol * pRef.groupVol * sVol * gain;
			trs.volume = finVol;
			ch.soundTransform = trs;
		}
		
		/* VOLUME METHODS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Event method that gets called on sound's end
		 * @param	e
		 */
		private function endOfSound(e:Event):void
		{
			ch.removeEventListener(Event.SOUND_COMPLETE, endOfSound);
			if (rep)
			{
				ch = sRef.play();
				updateVol();
				ch.addEventListener(Event.SOUND_COMPLETE, endOfSound);
			}else
			{
				dnit();
			}
		}
		
	}

}