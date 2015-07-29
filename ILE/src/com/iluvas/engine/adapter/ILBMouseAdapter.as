package com.iluvas.engine.adapter 
{
	import com.iluvas.engine.event.ILEEventManager;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * This is an adapter builder for the mouse. To customize which events to listen to or not,
	 * set the flags appropriately by filling in the flag arguments. You can choose to modify
	 * these flags on runtime.
	 * 
	 * The flags are as follows
	 * [MOUSE_DOWN, MOUSE_UP, MOUSE_MOVE, MOUSE_LEAVE, DOUBLE_CLICK, MOUSE_WHEEL]
	 * 
	 * EVENT MESSAGES:
	 * <0, 1, 2, 4>|X|Y : <Event parallel to flags> occured at mouse position X and Y
	 * 3 : MOUSE_LEAVE event
	 * 5|X : MOUSE_WHEEL event with delta value x
	 * @author iluvAS
	 */
	public final class ILBMouseAdapter extends ILBAdapter 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** This variable contains the list of flags on the active event listeners used */
		private var flagArr:Vector.<Boolean> = new Vector.<Boolean>();
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Initialize the mouse adapter with a stage reference and set up the listener flags.
		 * Following all declarations, this object will automatically declare itself to adapter
		 * manager
		 * @param	stageParam
		 */
		public function ILBMouseAdapter(stageParam:Stage, mouseDownFlag:Boolean = false, mouseUpFlag:Boolean = false,
		mouseMoveFlag:Boolean = false, mouseLeaveFlag:Boolean = false, doubleClickFlag:Boolean = false,
		mouseWheelFlag:Boolean = false) 
		{
			super(stageParam);
			// capture stage reference
			
			stageRef.mouseChildren = false;
			flagArr.push(mouseDownFlag, mouseUpFlag, mouseMoveFlag, mouseLeaveFlag, doubleClickFlag, mouseWheelFlag);
			updateDoubleClickState();
			// capture flags
			
			AGID = 1;
			ILEAdapterManager.declareAdapter(this);
			// declare to adapter manager
		}
		
		/**
		 * Use this function to update the flags and reinitialize the event listeners
		 */
		public function updateFlags(mouseDownFlag:Boolean = false, mouseUpFlag:Boolean = false,
		mouseMoveFlag:Boolean = false, mouseLeaveFlag:Boolean = false, doubleClickFlag:Boolean = false,
		mouseWheelFlag:Boolean = false):void
		{
			dnit();
			flagArr = new Vector.<Boolean>();
			flagArr.push(mouseDownFlag, mouseUpFlag, mouseMoveFlag, mouseLeaveFlag, doubleClickFlag, mouseWheelFlag);
			updateDoubleClickState();
			init();
		}
		
		/**
		 * Enables the whole swf to accept double click inputs
		 */
		private function updateDoubleClickState():void
		{
			stageRef.doubleClickEnabled = flagArr[4];
		}
		
		/**
		 * Remove all event listeners
		 */
		internal override function dnit():void
		{
			if (flagArr[0]) stageRef.removeEventListener(MouseEvent.MOUSE_DOWN, md);
			if (flagArr[1]) stageRef.removeEventListener(MouseEvent.MOUSE_UP, mu);
			if (flagArr[2]) stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, mm);
			if (flagArr[3]) stageRef.removeEventListener(Event.MOUSE_LEAVE, ml);
			if (flagArr[4]) stageRef.removeEventListener(MouseEvent.DOUBLE_CLICK, dc);
			if (flagArr[5]) stageRef.removeEventListener(MouseEvent.MOUSE_WHEEL, mw);
		}
		
		/**
		 * Start event listening
		 */
		internal override function init():void
		{
			if (flagArr[0]) stageRef.addEventListener(MouseEvent.MOUSE_DOWN, md);
			if (flagArr[1]) stageRef.addEventListener(MouseEvent.MOUSE_UP, mu);
			if (flagArr[2]) stageRef.addEventListener(MouseEvent.MOUSE_MOVE, mm);
			if (flagArr[3]) stageRef.addEventListener(Event.MOUSE_LEAVE, ml);
			if (flagArr[4]) stageRef.addEventListener(MouseEvent.DOUBLE_CLICK, dc);
			if (flagArr[5]) stageRef.addEventListener(MouseEvent.MOUSE_WHEEL, mw);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// CORE FUNCTIONS AND FLAG CONTROL
		//-------------------------------------------------------------------------------------------------------------
		
		private function md(e:MouseEvent):void
		{
			ILEEventManager.inform(ILEAdapterManager.GID + AGID, "0|" + e.stageX + "|" + e.stageY);
		}
		
		private function mu(e:MouseEvent):void
		{
			ILEEventManager.inform(ILEAdapterManager.GID + AGID, "1|" + e.stageX + "|" + e.stageY);
		}
		
		private function mm(e:MouseEvent):void
		{
			ILEEventManager.inform(ILEAdapterManager.GID + AGID, "2|" + e.stageX + "|" + e.stageY);
		}
		
		private function ml(e:Event):void
		{
			ILEEventManager.inform(ILEAdapterManager.GID + AGID, "3");
		}
		
		private function dc(e:MouseEvent):void
		{
			ILEEventManager.inform(ILEAdapterManager.GID + AGID, "4|" + e.stageX + "|" + e.stageY);
		}
		
		private function mw(e:MouseEvent):void
		{
			ILEEventManager.inform(ILEAdapterManager.GID + AGID, "5|" + e.delta);
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// EVENT LISTENER FUNCTIONS
		//-------------------------------------------------------------------------------------------------------------
	}

}