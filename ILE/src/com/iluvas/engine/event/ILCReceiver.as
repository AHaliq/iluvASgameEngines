package com.iluvas.engine.event 
{
	/**
	 * Use this class to receive messages from event manager. You can either extend this class and
	 * use the concrete class as a 'message processor & executor' component, or simply use it to
	 * inform other objects when a message has been received. Simply make sure that this object
	 * is used by its function calls. Do not poll to check if messages have been received.
	 * 
	 * @usage
	 * 1. Define one or multiple groupIDs in the constructor. Remove or add new groupIDs
	 * 2. whenever necessary. Override the receive function and process the message based on the
	 * expected message format.
	 * 
	 * @author iluvAS
	 */
	public class ILCReceiver 
	{
		
		/**
		 * @param	...groupIDs		List of groupIDs you wish to add this object to
		 */
		public function ILCReceiver(...groupIDs) 
		{
			for (var i:String in groupIDs)
			{
				ILEEventManager.declareReceiver(groupIDs[i], this);
			}
		}
		
		/**
		 * Join to another group if needed after construct
		 * @param	groupID			Desired groupID
		 */
		public final function joinNewGroup(groupID:int):void
		{
			ILEEventManager.declareReceiver(groupID, this);
		}
		
		/**
		 * Leave a group if needed
		 * @param	groupID			Desired groupID
		 */
		public final function leaveGroup(groupID:int):void
		{
			ILEEventManager.removeReceiver(groupID, this);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// GROUP PARTICIPATION MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Override this function and process the incoming message however necessary
		 * @param	groupID			The groupID this message is intended for
		 * @param	msg				Message sent to receiver
		 */
		public function receive(groupID:int, msg:String):void
		{
			
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// DATA PROCESSING
		//-------------------------------------------------------------------------------------------------------------
		
	}

}