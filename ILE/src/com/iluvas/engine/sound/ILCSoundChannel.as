package com.iluvas.engine.sound 
{
	import com.iluvas.engine.event.ILEEventManager;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * This class is used to manage playing a sound object. It will also manage sound repeat,
	 * volume control, playback control. This object is managed by code and not needed to be
	 * created and managed manually.
	 * 
	 * EVENT MESSAGES:
	 * 2|X		- track completed successfully, if X = 0, sound will repeat, X = 1 sound ends
	 * @author iluvAS
	 */
	internal final class ILCSoundChannel 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** The sound channel this class manages */
		private var channel:SoundChannel;
		private var transform:SoundTransform = new SoundTransform(1, 0);
		
		/** The index of the group this object is currently managing */
		private var groupIndex:int;
		/** The index of the track in the group this object is currently managing */
		private var trackIndex:int;
		
		/** The current sound being managed */
		private var soundCapture:Sound;
		/** This flag shows if the sound will be repeating */
		private var repeatFlag:Boolean;
		
		/** Master volume multiplied by sound group master volume */
		private var MXGVolume:Number;
		/** Track volume */
		private var trackVolume:Number;
		/** This channel's private volume level */
		private var channelVolume:Number;
		
		/** 0 - Not active, 1 - fading in, 2 - fading out */
		private var fadeMethod:uint;
		/** The current fadeStep value used */
		private var fadeCapture:Number;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * This function will stop playing the sound and reset all key variables and running
		 * objects. Following that it will remove its reference from the sound object and
		 * return itself to the ILEChannelPool
		 * @param	sound channel will not return itself to pool if true
		 */
		internal function stopAndDispose(dontDispose:Boolean = false):void
		{
			if (fadeMethod != 0)
			{
				ILEChannelRunner.stopRunning(this);
				fadeMethod = 0;
			}
			// stop running volume algo if it is
			
			if (channel != null)
			{
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, detectEnd);
			}
			// stop listening to sound end event if sound is playing
			
			if(!dontDispose) ILEChannelPool.returnChannel(this);
			// return back to channel pool
		}
		
		/**
		 * This function is used by this object to remove itself from sound group
		 */
		private function informParentPreDispose():void
		{
			ILESound.informChannelRemoval(groupIndex, trackIndex, this);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// OBJECT MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Use this function to pass a sound for this object to manage. This object will start
		 * playing the sound after processing this function
		 * @param	gId				The group index of the sound
		 * @param	tId				The track index of the sound
		 * @param	snd				Sound Object
		 * @param	masterXgroupVol	Master Volume multiplied by Sound Group master volume
		 * @param	trackVol		Track Volume for the sound object as defined in the sound group
		 * @param	fadeStep		1- immediately plays sound at max volume, > 0 && < 1 slowly fades in sound
		 * @param	repeat			True - repeats sound after complete
		 */
		internal function initializeAndPlay(gId:int, tId:int, snd:Sound, masterXgroupVol:Number, trackVol:Number, fadeStep:Number = 1, repeat:Boolean = false):void
		{
			groupIndex = gId;
			trackIndex = tId;
			repeatFlag = repeat;
			soundCapture = snd;
			MXGVolume = masterXgroupVol;
			trackVolume = trackVol;
			fadeCapture = fadeStep;
			// capture variables
			
			if (fadeStep >= 1 || fadeStep <= 0)
			{
				fadeCapture = 1;
				channelVolume = 1;
				// play at max volume
			}else
			{
				channelVolume = 0;
				fadeMethod = 1;
				ILEChannelRunner.startRunning(this);
				// fade in
			}
			// apply initial volume levels
			
			channel = soundCapture.play();
			updateVolume();
			// play the sound
			
			channel.addEventListener(Event.SOUND_COMPLETE, detectEnd);
			// add listener to detect sound complete
		}
		
		/**
		 * The event handlers function; this function will repeat the sound if requested or
		 * terminate and dispose this objects management over the current sound
		 * @param	e
		 */
		private function detectEnd(e:Event):void
		{
			ILEEventManager.inform(ILESound.GID + groupIndex, "2|" + (repeatFlag ? "0" : "1"));
			if (repeatFlag)
			{
				playSound();
			}else
			{
				informParentPreDispose();
				stopAndDispose();
			}
		}
		
		/**
		 * Use this function to gradually reduce the volume of the sound playing before stop
		 * @param	fadeStep
		 */
		internal function fadeStop(fadeStep:Number):void
		{
			fadeCapture = fadeStep;
			fadeMethod = 2;
			ILEChannelRunner.startRunning(this);
		}
		
		/**
		 * Reinitialize the channel by playing the current captured sound object
		 */
		private function playSound():void
		{
			channel = soundCapture.play();
			channel.soundTransform = transform;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// PLAYBACK CONTROL
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Fades in the channel volume according to fadeMethod. It will also automatically remove
		 * itself from the running list when the volume has reached the desired level
		 */
		internal function volumeAlgo():void
		{
			var toDispose:Boolean = false;
			if (fadeMethod == 1)
			{
				if (channelVolume < 1)
				{
					channelVolume += fadeCapture;
					if (channelVolume >= 1)
					{
						channelVolume = 1;
						fadeMethod = 0;
					}
				}
				// fade in algorithm
			}else if(fadeMethod == 2)
			{
				if (channelVolume > 0)
				{
					channelVolume -= fadeCapture;
					if (channelVolume <= 0)
					{
						channelVolume = 0;
						fadeMethod = 0;
						toDispose = true;
					}
				}
				// fade out algorithm
			}
			
			updateVolume();
			// apply volume changes
			
			if (fadeMethod == 0)
			{
				ILEChannelRunner.stopRunning(this);
			}
			// stop running volume algo
			
			if (toDispose)
			{
				informParentPreDispose();
				stopAndDispose();
			}
			// dispose sound channel if it is a fade out
		}
		
		/**
		 * Reassign the track's volume
		 */
		internal function setTrackVolume(vol:Number):void
		{
			trackVolume = vol;
			updateVolume();
		}
		
		/**
		 * Reassign the master times group volume
		 */
		internal function setMXGVolume(vol:Number):void
		{
			MXGVolume = vol;
			updateVolume();
		}
		
		/**
		 * Apply the volume changes based on MXGVolume, trackVolume and channelVolume
		 */
		private function updateVolume():void
		{
			transform.volume = MXGVolume * trackVolume * channelVolume;
			channel.soundTransform = transform;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// VOLUME CONTROL
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * This function is called to update the group index when a group is removed in the main
		 * engine.
		 * @param	gId
		 */
		internal function updateGroupIndex(gId:int):void
		{
			groupIndex = gId;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// INDEX CONTROL
		//-------------------------------------------------------------------------------------------------------------
	}

}