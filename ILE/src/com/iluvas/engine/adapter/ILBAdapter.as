package com.iluvas.engine.adapter 
{
	import flash.display.Stage;
	
	/**
	 * This class serves as a framework for all adapters extending it.
	 * 
	 * @usage Extended classes MUST override dnit, init functions. It must also assign AGID to a proper value
	 * @author iluvAS
	 */
	public class ILBAdapter 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** This contins the adapter value assigned for the concrete adapter */
		internal var AGID:int;
		
		/** Reference of stage being used in this adapter */
		protected var stageRef:Stage;
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * On construct, a reference to stage must be given
		 * @param	stageParam
		 */
		public function ILBAdapter(stageParam:Stage)
		{
			stageRef = stageParam;
		}
		
		/**
		 * Override this function, and inside it write the codes to remove event listeners
		 */
		internal function dnit():void
		{
			
		}
		
		/**
		 * Override this function, and inside it write the codes to add event listeners
		 */
		internal function init():void
		{
			
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE FUNCTIONS
		//-------------------------------------------------------------------------------------------------------------
	}
	
	
}