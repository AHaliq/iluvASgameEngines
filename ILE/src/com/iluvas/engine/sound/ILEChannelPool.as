package com.iluvas.engine.sound 
{
	/**
	 * This class serves as a factory / object pool for sound channel objects used by sound groups
	 * @author iluvAS
	 */
	internal final class ILEChannelPool 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** This vector contains vacant sound channel objects */
		private static var spareChannel:Vector.<ILCSoundChannel> = new Vector.<ILCSoundChannel>();
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Sound groups will use this function to obtain a channel object
		 * @return
		 */
		internal static function getChannel():ILCSoundChannel
		{
			if (spareChannel.length > 0)
			{
				return spareChannel.shift();
			}
			// gives a spare channel if any
			
			return new ILCSoundChannel();
			// creates a new channel if none
		}
		
		/**
		 * After use sound groups will return the channels through this function
		 * @param	obj
		 */
		internal static function returnChannel(obj:ILCSoundChannel):void
		{
			spareChannel.push(obj);
		}
	}

}