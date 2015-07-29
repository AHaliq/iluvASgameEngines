package com.iluvas.engine.adapter 
{
	import com.iluvas.engine.event.ILEEventManager;
	/**
	 * This class hosts and manages all adapter instances. Every adapter instance has its own
	 * adapterID. This id is used in conjuction with the event groupID to differentiate each
	 * adapter types. The group ID of its child adapter is the adapterID + GID value. Look into
	 * the adapter's documentation for more information on its event messages.
	 * 
	 * EVENT MESSAGES:
	 * 0|X : adapter added with adapterID X
	 * 1|X : adapter replaced with adapter ID X
	 * 2|X : adapter removed with adapter ID X
	 * @author iluvAS
	 */
	public final class ILEAdapterManager 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** This is the base groupID value used when interacting with ILEEventManager */
		internal static const GID:int = 10;
		
		/** This vector contains a list of adapterIDs active */
		private static var adapterIDVec:Vector.<int> = new Vector.<int>();
		/** This vector contains the paired adapter object for the adapterID */
		private static var adapterVec:Vector.<ILBAdapter> = new Vector.<ILBAdapter>();
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Use this function to add a new adapter into the list with the paired adapter ID
		 * If an adapter already exists with that ID, that adapter will be replaced
		 * @param	obj
		 */
		public static function declareAdapter(obj:ILBAdapter):void
		{
			var index:int = adapterIDVec.indexOf(obj.AGID);
			// get adapter element
			
			if (index == -1)
			{
				adapterIDVec.push(obj.AGID);
				adapterVec.push(obj);
				// if adapter does not exist add into vector
				
				ILEEventManager.inform(GID, "0|" + obj.AGID);
			}else
			{
				adapterVec[index].dnit();
				adapterIDVec.splice(index, 1, obj);
				// if adapter exist replace with new adapter
				
				ILEEventManager.inform(GID, "1|" + obj.AGID);
			}
			
			obj.init();
			// initialize new adapter
		}
		
		/**
		 * Specifically remove an adapter based on its adapterID
		 * @param	adapterID
		 */
		public static function removeAdapter(adapterID:int):void
		{
			var index:int = adapterIDVec.indexOf(adapterID);
			// get adapter element
			
			if (index != -1)
			{
				adapterVec[index].dnit();
				adapterIDVec.splice(index, 1);
				adapterVec.splice(index, 1);
				// if adapter exist remove it
				
				ILEEventManager.inform(GID, "2|" + adapterID);
			}
		}
		
		/**
		 * Use this function to get reference of the adapter currently
		 * in used for the specified adapterID
		 * @param	adapterID
		 * @return
		 */
		public static function getAdapter(adapterID:int):ILBAdapter
		{
			var index:int = adapterIDVec.indexOf(adapterID);
			// get adapter element
			
			if (index != -1)
			{
				return adapterVec[index];
			}
			return null;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// ADAPTER MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
	}

}