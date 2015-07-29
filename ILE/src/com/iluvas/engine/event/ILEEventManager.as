package com.iluvas.engine.event 
{
	/**
	 * This class serves as a messenger. It automatically creates a space for a group of recepients
	 * awaiting for specific messages when a message is sent for said group. If recepients already
	 * exists in said group, the message will be passed to the recepients through its receive
	 * function. (Recepients are ILCReceiver objects)
	 * 
	 * The first 50 (0 - 49) group IDs are reserved for the game engine's use. See comments on the
	 * declareReceiver() function for a list of the reserved numbers.
	 * --------------------------------------------------------------------------------------------
	 * @usage There are two ways to use this class, as an informer or a receiver. Uses are:
	 *			1. Call the inform function to send message(s) to recepient(s)
	 * 			2. Declare a ILCReceiver object to group(s) to receive messages
	 * 			3. Remove a ILCReceiver object from a specific group
	 * @author iluvAS
	 */
	public final class ILEEventManager 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** This vector contains a list of groupIDs active.*/
		private static var groupIDVec:Vector.<int> = new Vector.<int>();
		/** This vector contains vectors of receiver objects, parallel to the groupIDs*/
		private static var receiverVec:Vector.<Vector.<ILCReceiver>> = new Vector.<Vector.<ILCReceiver>>();
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Use this function to send msg to all awaiting receivers
		 * @param	groupID		designated groupID for incoming message
		 * @param	msg			message to be sent
		 */
		public static function inform(groupID:int, msg:String):void
		{
			if (ILEEventLogger.active)
			{
				ILEEventLogger.receive(groupID, msg);
			}
			// send message to ILEEventLogger
			
			var index:uint = getOrCreateGroup(groupID);
			// get index of group
			
			for (var i:String in receiverVec[index])
			{
				ILCReceiver(receiverVec[index][i]).receive(groupID, msg);
			}
			// send message to all receivers
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// INFORMATION MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Use this function to add a receiver to a group. First 50 groupIDs are restricted to engine components:
		 * 000	ILECore			001	ILBPreloader group	002	ILBGameBuilder
		 * 003	ILBGameProperties	004	ILBRunnableIterator	005	ILBTransition
		 * 006	ILBStatistics		007	ILBAPI
		 * 
		 * 01X	ILEAdapterManager	02X	ILESound		03X	ILEData
		 * @param	groupID		Group receiver wishes to join
		 * @param	obj			Reference to receiver object
		 */
		public static function declareReceiver(groupID:int, obj:ILCReceiver):void
		{
			var index:int = getOrCreateGroup(groupID);
			// get index of group
			
			if (receiverVec[index].indexOf(obj) == -1)
			{
				receiverVec[index].push(obj);
				// add receiver if it does not exist in group
			}
		}
		
		public static function removeReceiver(groupID:int, obj:ILCReceiver):void
		{
			if (checkGroupExist(groupID))
			{
				var index:int = getOrCreateGroup(groupID);
				// get index of group
				
				var receiverIndex:uint = receiverVec[index].indexOf(obj);
				// get index of receiver in group
				
				if (receiverIndex != -1)
				{
					receiverVec[index].splice(receiverIndex, 1);
					// remove receiver from group if it exists
				}
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// RECEIVER MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * This function will return the index the groupID exists in the vector.
		 * @param	id	groupID value
		 * @return		index of groupID
		 */
		private static function getOrCreateGroup(id:int):int
		{
			var index:int = groupIDVec.indexOf(id);
			// get index
			
			if (index == -1)
			{
				groupIDVec.push(id);
				receiverVec.push(new Vector.<ILCReceiver>());
				index = groupIDVec.length - 1;
				// create new group if group does not exist
			}
			
			return index;
		}
		
		/**
		 * Checks if the specified groupID already exists in the vector.
		 * @param	id	groupID to check
		 * @return		TRUE: group exists, FALSE: group does not exist
		 */
		private static function checkGroupExist(id:int):Boolean
		{
			return (groupIDVec.indexOf(id) != -1);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// PRIVATE UTILITIES
		//-------------------------------------------------------------------------------------------------------------
	}

}