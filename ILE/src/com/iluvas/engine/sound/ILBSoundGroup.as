package com.iluvas.engine.sound 
{
	import com.iluvas.engine.event.ILEEventManager;
	import flash.media.Sound;
	/**
	 * This class manages a specific group of sounds. This group in turn is managed by the sound
	 * engine. The reason to put a sound into a group is due to focus play and focus stop.
	 * Focus play will stop every other instance of sound objects, except the one it is meant to
	 * play. Sounds in other sound groups however are unaffect and wont stop or play resulting
	 * from this command.
	 * @usage To use this class, declare a list of sounds to be used in the group using the
	 * appropriate functions. You cant remove sounds on runtime. Best approach to this is to
	 * extend this class and in the concrete class declare all the sound objects
	 * 
	 * EVENT MESSAGE:
	 * 0|X|Y|Z	- initiated play for track X at Z fadeStep; Y amount of ch is playing that track
	 * 1|X|Y|Z	- initiated stop for track X at Z fadeStep; Y amount of ch are affected
	 * @author iluvAS
	 */
	public class ILBSoundGroup 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** This is the index this sound group is in */
		private var groupIndex:int;
		/** This variable is the master volume over all sound channels playing sounds managed by this group */
		private var groupVolume:Number = 1;
		
		/** List of sound objects managed by this group */
		private var soundVec:Vector.<Sound> = new Vector.<Sound>();
		/** List of flags, if true only one instance of that sound can be played at a time; no multiples */
		private var singleVec:Vector.<Boolean> = new Vector.<Boolean>();
		/** This is the volume multiplier for each defined sound object */
		private var volVec:Vector.<Number> = new Vector.<Number>();
		/** This vector contains a list of vector of sound channels managing the sound parallel to
		 * this vector */
		private var channelVec:Vector.<Vector.<ILCSoundChannel>> = new Vector.<Vector.<ILCSoundChannel>>();
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Declare a sound to manage paired with its track volume
		 * @param	sound
		 * @param	singlePlay		true - if play is called when the sound is already playing, the sound will restart
		 * 							false- a new soundchannel will play the same sound is the one already playing
		 * @param	trackVolume
		 */
		protected final function declareSound(sound:Sound, singlePlay:Boolean = false, trackVolume:Number = 1):void
		{
			soundVec.push(sound);
			singleVec.push(singlePlay);
			channelVec.push(new Vector.<ILCSoundChannel>());
			if (trackVolume <= 0 || trackVolume > 1)
			{
				volVec.push(1);
			}else
			{
				volVec.push(trackVolume);
			}
		}
		
		/**
		 * This function is cascaded from a sound channel to ILESound and called onto the group
		 * the sound channel is currently being used in. This will remove this object's reference
		 * to the sound channel as the sound channel has completed its task.
		 * @param	trackIndex
		 * @param	obj
		 */
		internal final function removeChannelReference(trackIndex:int, obj:ILCSoundChannel):void
		{
			if (trackIndex >= 0 && trackIndex < channelVec.length)
			{
				var index:int = channelVec[trackIndex].indexOf(obj);
				if (index >= 0)
				{
					channelVec[trackIndex].splice(index, 1);
				}
			}
		}
		
		/**
		 * Stops all active sound references and release them to sound channel in preperation to
		 * dispose this object
		 */
		internal final function dispose():void
		{
			for (var i:String in channelVec)
			{
				for (var j:String in channelVec[i])
				{
					ILCSoundChannel(channelVec[i][j]).stopAndDispose();
				}
			}
			channelVec = new Vector.<Vector.<ILCSoundChannel>>();
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// OBJECT MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Play a specific track based on the parameters
		 * @param	track		
		 * @param	repeat		
		 * @param	fadeStep	
		 * @param	focusPlay	
		 */
		internal final function play(track:uint, repeat:Boolean = false, fadeStep:Number = 1,
		focusPlay:Boolean = false):void
		{
			if (focusPlay)
			{
				stop( -1, fadeStep);
			}
			// stop all tracks if focus play
			
			var ch:ILCSoundChannel;
			if (channelVec[track].length == 0 || !singleVec[track])
			{
				ch = ILEChannelPool.getChannel();
				channelVec[track].push(ch);
				// get new channel if multiple plays are allowed or no sound of it is playing
			}else
			{
				ch = channelVec[track][0];
				ch.stopAndDispose(true);
				// restart sound if its already playing and if its single play only
			}
			
			ch.initializeAndPlay(groupIndex, track, soundVec[track], ILESound.masterVolume * groupVolume,
			volVec[track], fadeStep, repeat);
			// initialize channel
			
			ILEEventManager.inform(ILESound.GID + groupIndex, "0|" + track + "|" + channelVec[track].length + "|" + fadeStep);
		}
		
		/**
		 * This function will stop all tracks if track is -1, otherwise will specifically stop a single track
		 * @param	track
		 * @param	fadeStep
		 */
		internal final function stop(track:int = -1, fadeStep:Number = 1):void
		{
			if (track <= -1 || track >= channelVec.length)
			{
				for (var i:String in channelVec)
				{
					stopSpecificTracks(int(i), fadeStep);
				}
			}else
			{
				stopSpecificTracks(track, fadeStep);
			}
		}
		
		/**
		 * This function will stop all channels that are playing a specific track
		 * @param	track
		 * @param	fadeStep
		 */
		private final function stopSpecificTracks(track:int, fadeStep:Number = 1):void
		{
			ILEEventManager.inform(ILESound.GID + groupIndex, "1|" + track + "|" + channelVec[track].length + "|" + fadeStep);
			for (var i:String in channelVec[track])
			{
				if (fadeStep == 1)
				{
					ILCSoundChannel(channelVec[track][i]).stopAndDispose();
				}else
				{
					ILCSoundChannel(channelVec[track][i]).fadeStop(fadeStep);
				}
			}
		}
		
		/**
		 * Sets the volume level of the whole sound group, or specifically at a track
		 * @param	vol
		 * @param	track
		 */
		internal final function setVolume(vol:Number, track:int = -1):void
		{
			if (track <= -1 || track >= soundVec.length)
			{
				groupVolume = vol;
				// assign to group volume
				
				updateMasterORgroupVolume();
				// update all ch with master * group
			}else
			{
				volVec[track] = vol;
				// assign to track volume
				
				for (var i:String in channelVec[track])
				{
					ILCSoundChannel(channelVec[track][i]).setTrackVolume(vol);
				}
				// update all ch of that track with track volume
			}
		}
		
		/**
		 * Updates all active sound channels with current master volume * group volume
		 */
		internal final function updateMasterORgroupVolume():void
		{
			for (var i:String in channelVec)
			{
				for (var j:String in channelVec[i])
				{
					ILCSoundChannel(channelVec[i][j]).setMXGVolume(ILESound.masterVolume * groupVolume);
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// SOUND CONTROL
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * This function will be called to update the group index when a group gets removed in the
		 * main engine. This function will cascade down to all active sound channels in the group.
		 * @param	gId
		 * @param	dontUpdateCh	if true, wont update the channels of the new groupID should
		 * 							only be used by ILESound on initializing
		 */
		internal final function updateGroupIndex(gId:int, dontUpdateCh:Boolean = false):void
		{
			groupIndex = gId;
			if (!dontUpdateCh)
			{
				for (var i:String in channelVec)
				{
					for (var j:String in channelVec)
					{
						ILCSoundChannel(channelVec[i][j]).updateGroupIndex(gId);
					}
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// INDEX CONTROL
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Returns the volume of a specified track or the group master volume if index is out of bounds
		 * @param	track
		 */
		internal final function getVolume(track:int = -1):void
		{
			if (track < 0 || track >= volVec.length)
			{
				return groupVolume;
			}
			return volVec[track];
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// GETTERS
		//-------------------------------------------------------------------------------------------------------------
	}

}