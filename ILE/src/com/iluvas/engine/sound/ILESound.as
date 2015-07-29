package com.iluvas.engine.sound 
{
	import flash.display.Stage;
	/**
	 * This class manages sound groups and is used as a centralized access point to control
	 * playback and access properties of anything regarding sounds.
	 * @usage Be sure to call initializeBeforeEngine() if the sound engine will be used before
	 * ILECore's initialization, you however won't have to handle the passing of the responsibility
	 * as that is done by ILECore when it gets initialized.
	 * @author iluvAS
	 */
	public final class ILESound 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** This is the base groupID used in event manager for sound object inform groups */
		internal static const GID:int = 20;
		
		/** This vector contains all the declared sound groups */
		private static var groupArr:Vector.<ILBSoundGroup> = new Vector.<ILBSoundGroup>();
		
		/** This variable is the master volume over all sound channels */
		private static var _masterVol:Number = 1;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Use this function to add a sound group to the sound engine
		 * @param	obj		Instance of sound group
		 */
		public static function declareSoundGroup(obj:ILBSoundGroup):void
		{
			if (groupArr.indexOf(obj) == -1 && groupArr.length < 10)
			{
				obj.updateGroupIndex(groupArr.length, true);
				groupArr.push(obj);
			}
		}
		
		/**
		 * Use this function to remove a sound group from memory. All active playing sounds that
		 * belong to the group will be terminated immediately.
		 * @param	index	Index of the sound group in the ILESound vector
		 */
		public static function removeSoundGroup(index:int):void
		{
			if (index >= 0 && index < groupArr.length)
			{
				groupArr[index].dispose();
				groupArr.splice(index, 1);
				// remove group
				
				for (var i:int = index; i < groupArr.length; i++)
				{
					groupArr[i].updateGroupIndex(i);
				}
				// update indexes
			}
		}
		
		/**
		 * This function is called from a sound channel that wishes to remove its reference from a
		 * sound group as it has completed its task
		 * @param	groupIndex
		 * @param	trackIndex
		 * @param	obj
		 */
		internal static function informChannelRemoval(groupIndex:int, trackIndex:int, obj:ILCSoundChannel):void
		{
			groupArr[groupIndex].removeChannelReference(trackIndex, obj);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// SOUND GROUP MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Use this function to narrow down and play a specific sound
		 * @param	groupIndex	element of the sound group in the vector
		 * @param	trackIndex	element of the track in the sound group's sound vector
		 * @param	repeat		if true, when the sound has finished playing, it will repeat
		 * @param	fadeStep	the volume transition to fade in the sound
		 * 						(set as 1 to immediately play sound at max volume)
		 * @param	focusPlay	if true, all other sounds currently playing in the same sound group will fade out
		 * 						according to fadeStep
		 */
		public static function play(groupIndex:uint, trackIndex:uint, repeat:Boolean = false, fadeStep:Number = 1,
		focusPlay:Boolean = false):void
		{
			groupArr[groupIndex].play(trackIndex, repeat, fadeStep, focusPlay);
		}
		
		/**
		 * Stop sounds
		 * @param	group		element of sound group to stop, if -1, all sounds will be stopped
		 * @param	track		element of sound in group to stop, if -1 all sound in group will be stopped
		 * @param	fadeStep	the volume transition to fade out the sound
		 * 						(set as 1 to immediately stop the sound completely)
		 */
		public static function stop(group:int = -1, track:int = -1, fadeStep:Number = 1):void
		{
			if (group <= -1 || group >= groupArr.length)
			{
				for (var i:String in groupArr)
				{
					stopSpecificGroup(int(i), fadeStep);
				}
			}else
			{
				groupArr[group].stop(track, fadeStep);
			}
		}
		
		/**
		 * This function will stop all tracks of a specific group
		 * @param	group
		 * @param	fadeStep
		 */
		private static function stopSpecificGroup(group:int, fadeStep:Number):void
		{
			groupArr[group].stop( -1, fadeStep);
		}
		
		/**
		 * Control specific or all sound volumes
		 * @param	vol			The volume level (0 to 1)
		 * @param	group		element of sound group, if -1, you will be assigning the master volume
		 * @param	track		which track to be set this volume, if -1 you will be assigning the group's master
		 * 						volume
		 */
		public static function setVolume(vol:Number, group:int = -1, track:int = -1):void
		{
			if (group <= -1 || group >= groupArr.length)
			{
				_masterVol = vol;
				// assign volume to master
				
				for (var i:String in groupArr)
				{
					groupArr[i].updateMasterORgroupVolume();
				}
				// inform groups to update new master volume
			}else
			{
				groupArr[group].setVolume(vol, track);
				// pass volume information to designated group
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// SOUND CONTROL
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * This function serves as a wrapper to run channel runner's frame by frame code to be
		 * called by ILECore when responsibility has passed to it.
		 */
		public static function algo():void
		{
			ILEChannelRunner.algo();
		}
		
		/**
		 * This function has to be called if ILESound is used before ILECore initialization
		 * @param	stageRef
		 */
		public static function initializeBeforeEngine(stageRef:Stage):void
		{
			ILEChannelRunner.initEnterFrame(stageRef);
		}
		
		/**
		 * This function is meant to be called by ILECore to disable ENTER_FRAME event as it will
		 * be run by ILECore instead
		 */
		public static function passResponsibilityToCore():void
		{
			ILEChannelRunner.stopEnterFrame();
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// RUNNER MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * This function is used internally by sound group to easily access the master volume
		 */
		internal static function get masterVolume():Number
		{
			return _masterVol;
		}
		
		/**
		 * This function is used to get the volume level of any component in the sound engine,
		 * Master volume, group master volume, or specific track volumes
		 * @param	group
		 * @param	track
		 */
		public static function getVolume(group:int = -1, track:int = -1):void
		{
			if (group < 0 || group >= groupArr.length)
			{
				return _masterVol;
			}
			return groupArr[group].getVolume(track);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// GETTERS
		//-------------------------------------------------------------------------------------------------------------
		
	}

}