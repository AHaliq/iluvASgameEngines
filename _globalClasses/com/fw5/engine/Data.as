package com.fw5.engine 
{
	import flash.net.SharedObject;
	/**
	 * This class manages and creates multiple abstract shared object instances. Each SO is paired
	 * with an identifier. SO are created / loaded automatically on function calls if they do not
	 * exist in memory.
	 * 
	 * Managing the data is also done in this class, each SO is simply a hashmap of identifier and
	 * wildcard type variable pairs. Do note it is better to call the functions using the index
	 * parameter if the SO is already loaded, this way the class can avoid a loop search reducing
	 * CPU overhead.
	 * @author iluvAS
	 */
	public final class Data 
	{
		/* VARIABLES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** This vector contains all the loaded shared object identifiers */
		private static var idenVec:Vector.<String> = new Vector.<String>();
		/** This vector contains all the loaded shared object */
		private static var sobjVec:Vector.<SharedObject> = new Vector.<SharedObject>();
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Use this function to save data. If the shared object does not exist in the class
		 * leave the index to -1 and the SO will be loaded. If you know the index of the
		 * object, its best to use the index although it will still work when left to -1,
		 * performance will be slightly faster with a valid index provided.
		 * @param	iden	Identifier of the SO
		 * @param	dName	Identifier for the data to be stored in the SO
		 * @param	data	The data to be saved
		 * @param	index	Index of the SO if any
		 */
		public static function saveData(iden:String, dName:String, data:Object, index:int = -1):void
		{
			var so:SharedObject = getSObyIndexOrIden(iden, index);
			// get SO
			
			if (so.data.dataGroup == undefined)
			{
				so.data.dataGroup = [ { name:dName, obj:data } ];
				// construct hash map if undefined
			}else
			{
				var dataIndex:int = getDataGroupIndex(so.data.dataGroup, dName);
				if (dataIndex == -1)
				{
					so.data.dataGroup.push( { name:dName, obj:data } );
					// push new set of data
				}else
				{
					(so.data.dataGroup[dataIndex] as Object).obj = data;
					// overwrite existing data
				}
			}
			so.flush();
		}
		
		/**
		 * Use this function to get data from a shared object, if data does not exist, this
		 * will return null
		 * @param	iden	Identifier of the SO
		 * @param	dName	Identifier for the data to be stored in the SO
		 * @param	index	Index of the SO if any
		 * @return
		 */
		public static function loadData(iden:String, dName:String, index:int = -1):Object
		{
			var so:SharedObject = getSObyIndexOrIden(iden, index);
			// get SO
			
			if (so.data.dataGroup != undefined)
			{
				var dataIndex:int = getDataGroupIndex(so.data.dataGroup, dName);
				// get data index
				
				if (dataIndex != -1)
				{
					return (so.data.dataGroup[dataIndex] as Object).obj;
				}
				// fetch data if it exists
			}
			return null;
		}
		
		/**
		 * Use this function to erase all of the data stored in the shared object completely
		 * @param	iden
		 * @param	index
		 */
		public static function deleteData(iden:String, index:int = -1):void
		{
			var so:SharedObject = getSObyIndexOrIden(iden, index);
			so.clear();
		}
		
		/* DATA CONTROL */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Returns the shared object based on the identifier or index parameters
		 * @param	iden
		 * @param	index
		 * @return
		 */
		private static function getSObyIndexOrIden(iden:String, index:int):SharedObject
		{
			if (index >= 0 && index < sobjVec.length)
			{
				return sobjVec[index];
				// grab SO with direct index access
			}
			return getSharedObject(iden);
			// get SO using identifier
		}
		
		/**
		 * Returns the index of the shared object in the vector
		 * @param	identifier
		 * @return
		 */
		private static function getSharedObjectIndex(identifier:String):int
		{
			return idenVec.indexOf(identifier);
		}
		
		/**
		 * Creates / Loads or returns a shared object
		 * @param	iden
		 * @return
		 */
		private static function getSharedObject(iden:String):SharedObject
		{
			var index:int = getSharedObjectIndex(iden);
			if (index == -1)
			{
				var so:SharedObject = SharedObject.getLocal(iden);
				idenVec.push(iden);
				sobjVec.push(so);
				return so;
				// load or generate shared object
			}
			return sobjVec[index];
			// pass reference to loaded shared object
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
				if ((dataGroup[i] as Object).name == dataName)
				{
					return (i as int);
				}
			}
			return -1;
		}
		
		/* PRIVATE METHODS */
		//-----------------------------------------------------------------------------------------
		
	}

}