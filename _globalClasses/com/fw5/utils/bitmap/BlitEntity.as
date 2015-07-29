package com.fw5.utils.bitmap 
{
	
	/**
	 * Objects of this class are to be registered to a BlitCanvas to represent a specific movieclip
	 * sequence data as stored in BlitCore. Use its X and Y property to choose where it should be
	 * printed on the canvas. Manipulate the C_ID value either externally or by overriding the algo
	 * method and performing operations there. The method will be called on every frame its registered
	 * BlitCanvas.
	 * @author Haliq
	 */
	public class BlitEntity 
	{
		/* PROPERTIES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** Movieclip ID as stored in BlitCore that this entity will represent*/
		public var M_ID:int;
		/** Clip ID this object is currently displaying */
		public var C_ID:int;
		/** X position value */
		public var x:Number = 0;
		/** Y position value */
		public var y:Number = 0;
		/** If true the registered canvas will print this entity */
		public var visible:Boolean = true;
		
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * You have to create the bli
		 * @param	mcID
		 * @param	cID
		 */
		public function BlitEntity(mcID:uint, cID:uint)
		{
			M_ID = mcID;
			C_ID = cID;
		}
		
		/**
		 * This method is a placeholder that will be called by its registered canvas on every frame
		 * By default this method contains an algorithm that loops from the first clip to the last
		 * and repeats. Override this method and implement your own algorithms when needed.
		 */
		public function algo():void
		{
			C_ID++;
			if (C_ID >= BlitCore.getTotalClips(M_ID)) C_ID = 0;
		}
		
	}
}