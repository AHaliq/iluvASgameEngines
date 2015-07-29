package com.iluvas.engine.data 
{
	import com.iluvas.engine.event.ILEEventManager;
	import flash.net.SharedObject;
	/**
	 * This class manages, creates and handles abstraction of multiple shared object instances.
	 * All shared object instances in this class is paired with an identifier; a string to tell
	 * between shared objects. Shared objects are created automatically on save if they do not
	 * exist, otherwise this class will simply fetch the object if it already exists.
	 * 
	 * The data in the shared objects are also managed in a similar manner. A string called
	 * name / dataName is paired with any data to be stored in the shared object.
	 * 
	 * When saving and loading data, it is encouraged to first get the shared object's index
	 * using getSharedObjectIndex function and use that value to identify the shared object
	 * rather than using the identifier directly. This way you'll be able to skip the for
	 * loop checking from occuring and directly access the shared object, optimizing your game.
	 * 
	 * EVENT MESSAGES:
	 * 0|X|Y   - X = 0 created a new shared object X = 1 loaded existing shared object, Y = identifier
	 * 1|X|Y|Z - X = 0 created new data, X = 1 overwrite data,Y = dataName, Z = identifier
	 * @author iluvAS
	 */
	public final class ILEData 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		private static const GID:int = 30;
		
		/** This vector contains all the loaded shared object indentifiers */
		private static var idenVec:Vector.<String> = new Vector.<String>();
		/** This vector contains all the loaded shared object */
		private static var sobjVec:Vector.<SharedObject> = new Vector.<SharedObject>();
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Use this function to save data
		 * @param	identifier		The identifier of the shared object
		 * @param	dataName		The name paired for the data to store
		 * @param	data			The data to store itself
		 * @param	sobjIndex		The index of the shared object in the vector
		 */
		public static function saveData(identifier:String, dataName:String, data:*, sobjIndex:int = -1):void
		{
			var id:String;
			var so:SharedObject;
			if (sobjIndex >= 0 && sobjIndex < sobjVec.length)
			{
				so = sobjVec[sobjIndex];
				id = idenVec[sobjIndex];
			}else
			{
				so = getSharedObject(identifier);
				id = idenVec[getSharedObjectIndex(identifier)];
			}
			// get shared object
			
			if (so.data.dataGroup == undefined)
			{
				so.data.dataGroup = [ { name:dataName, obj:data } ];
				// initialize dataGroup if blank
				
				ILEEventManager.inform(GID, "1|0|" + dataName + "|" + id);
			}else
			{
				var dataIndex:int = getDataGroupIndex(so.data.dataGroup, dataName);
				if (dataIndex == -1)
				{
					so.data.dataGroup.push( { name:dataName, obj:data } );
					// push new set of data
					ILEEventManager.inform(GID, "1|0|" + dataName + "|" + id);
				}else
				{
					Object(so.data.dataGroup[dataIndex]).obj = data;
					// overwrite existing data
					ILEEventManager.inform(GID, "1|1|" + dataName + "|" + id);
				}
			}
			so.flush();
		}
		
		/**
		 * Use this function to get data from a shared object, if data does not exist, this
		 * function will return null
		 * @param	identifier
		 * @param	dataName
		 * @param	sobjIndex
		 * @return
		 */
		public static function loadData(identifier:String, dataName:String, sobjIndex:int = -1):*
		{
			var so:SharedObject;
			if (sobjIndex >= 0 && sobjIndex < sobjVec.length)
			{
				so = sobjVec[sobjIndex];
			}else
			{
				so = getSharedObject(identifier);
			}
			// get shared object
			
			if (so.data.dataGroup != undefined)
			{
				var dataIndex:int = getDataGroupIndex(so.data.dataGroup, dataName);
				// get data index
				
				if (dataIndex != -1)
				{
					return Object(so.data.dataGroup[dataIndex]).obj;
					// fetch data if existing
				}
			}
			return null;
		}
		
		/**
		 * Use this function to erase all of the data stored in the shared object completely
		 * @param	identifier
		 * @param	sobjIndex
		 */
		public static function deleteData(identifier:String, sobjIndex:int = -1):void
		{
			var so:SharedObject;
			if (sobjIndex >= 0 && sobjIndex < sobjVec.length)
			{
				so = sobjVec[sobjIndex];
			}else
			{
				so = getSharedObject(identifier);
			}
			// get shared object
			
			so.clear();
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// DATA GET AND SET
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Returns the index of the shared object in the vector
		 * @param	identifier
		 * @return
		 */
		public static function getSharedObjectIndex(identifier:String):int
		{
			return idenVec.indexOf(identifier);
		}
		
		/**
		 * Use this function if you want to force this class to load a shared object. Do note that
		 * using saveData / loadData / deleteData by identifiers will automatically load a shared
		 * object as well.
		 * @param	identifier
		 */
		public static function loadSharedObject(identifier:String):void
		{
			getSharedObject(identifier);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// SHARED OBJECT MANAGEMENT
		//-------------------------------------------------------------------------------------------------------------
		
		/**
		 * Creates or returns a shared object
		 * @param	identifier
		 * @return
		 */
		private static function getSharedObject(identifier:String):SharedObject
		{
			var index:int = getSharedObjectIndex(identifier);
			if (index == -1)
			{
				ILEEventManager.inform(GID, "0|0|" + identifier);
				var so:SharedObject = SharedObject.getLocal(identifier);
				idenVec.push(identifier);
				sobjVec.push(so);
				return so;
			}
			ILEEventManager.inform(GID, "0|1|" + identifier);
			return sobjVec[index];
		}
		
		/**
		 * Returns the index of the data stored in the shared object based on the paired dataName
		 * @param	dataGroup
		 * @param	dataName
		 * @return
		 */
		private static function getDataGroupIndex(dataGroup:Array, dataName:String):int
		{
			for (var i:String in dataGroup)
			{
				if (Object(dataGroup[i]).name == dataName)
				{
					return int(i);
				}
			}
			return -1;
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// UTILITY FUNCTIONS
		//-------------------------------------------------------------------------------------------------------------
		
	}

}