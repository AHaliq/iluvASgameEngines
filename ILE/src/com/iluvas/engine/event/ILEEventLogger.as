package com.iluvas.engine.event 
{
	import com.iluvas.utilities.ILUString;
	/**
	 * This class intercepts and watches over all inform calls from ILEEventManager. Messages will
	 * be traced out if active is true, groupID of message exists in groupWatch, or groupWatch is
	 * empty and groupID does not exist in groupFilter.
	 * @author iluvAS
	 */
	public final class ILEEventLogger 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		//TODO smart filter (only output GIDs with receivers)
		/** TRUE: will output log messages, FALSE: will ignore messages */
		internal static var active:Boolean = true;
		/** Contains a list of groupIDs to ignore */
		internal static var groupFilter:Vector.<int> = new Vector.<int>();
		/** Contains a list of groupIDs that only these will be logged */
		internal static var groupWatch:Vector.<int> = new Vector.<int>();
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * This function is strictly to be called by ILEEventManager to inform of new messages
		 * @param	groupID		groupID message is for
		 * @param	msg			message intercepted
		 */
		internal static function receive(groupID:int, msg:String):void
		{
			if (groupWatch.length > 0)
			{
				if (groupWatch.indexOf(groupID) != -1)
				{
					displayMessage(groupID, msg);
					// display message if groupID belongs in watch list
				}
				// specified watch list exists
			}else if (groupFilter.indexOf(groupID) == -1)
			{
				displayMessage(groupID, msg);
				// watch list does not exist and groupID is not filtered
			}
		}
		
		/**
		 * This function is called to format and display the messages intercepted
		 * @param	groupID		groupID message is for
		 * @param	msg			message intercepted
		 */
		private static function displayMessage(groupID:int, msg:String):void
		{
			trace("[" + ILUString.formatNumber(groupID, 3) + "]: " + msg);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// MESSAGE MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Adds a groupID to the watch list if it doesn't already exist to begin with
		 * @param	groupID
		 */
		public static function addToWatchList(groupID:int):void
		{
			if (groupWatch.indexOf(groupID) == -1)
			{
				groupWatch.push(groupID);
			}
		}
		
		/**
		 * Adds a groupID to the filter list if it doesn't already exist to begin with
		 * @param	groupID
		 */
		public static function addToFilterList(groupID:int):void
		{
			if (groupFilter.indexOf(groupID) == -1)
			{
				groupFilter.push(groupID);
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// GROUP RESTRICTION MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
	}

}