package com.iluvas.engine.core 
{
	import flash.display.Sprite;
	
	/**
	 * If an object is to be part of the game's content that has frame by frame code, it will have
	 * to extend this class. It will also have to override the init(), dnit() and algo() functions
	 * and be declared into ILECore, or nested into another declared runnable objected
	 * @author iluvAS
	 */
	public class ILCRunnable extends Sprite 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// PROPERTIES
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Contains a list of all the nested ILCRunnables */
		private var children:Vector.<ILCRunnable> = new Vector.<ILCRunnable>();
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/** Function that is called when this object is just added to display list */
		public function init():void { }
		/** Function that is called when this object is removed from the display list */
		public function dnit():void { }
		/** Function that is called on every frame when in display list*/
		public function algo():void { }
		
		/**
		 * Nests a runnable object within this runnable object
		 */
		public final function addRunnableChild(obj:ILCRunnable):void
		{
			var index:int = children.indexOf(obj);
			if (index == -1)
			{
				children.push(obj);
				addChild(obj);
			}
		}
		
		/**
		 * Removes a nested runnable
		 */
		public final function removeRunnableChild(obj:ILCRunnable):void
		{
			var index:int = children.indexOf(obj);
			if (index >= 0)
			{
				children.splice(index, 1);
				removeChild(obj);
			}
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// PERSONAL
		//-------------------------------------------------------------------------------------------------------------
		
		/** TO BE CALLED BE ILECore OR IT PARENTS ONLY */
		public final function engineInit():void
		{
			init();
			for (var i:String in children) children[i].engineInit();
		}
		
		/** TO BE CALLED BE ILECore OR IT PARENTS ONLY */
		public final function engineDnit():void
		{
			dnit();
			for (var i:String in children) children[i].engineDnit();
		}
		
		/** TO BE CALLED BE ILECore OR IT PARENTS ONLY */
		public final function engineAlgo():void
		{
			algo();
			for (var i:String in children) children[i].engineAlgo();
		}
		
		//-------------------------------------------------------------------------------------------------------------
		// ENGINE CALLS
		//-------------------------------------------------------------------------------------------------------------
		
	}

}