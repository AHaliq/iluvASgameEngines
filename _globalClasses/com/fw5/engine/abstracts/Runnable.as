package com.fw5.engine.abstracts 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * This abstract serves as a placeholder for three essential methods
	 * for any interactive / runnable display object; init, dnit and algo.
	 * @author Haliq
	 */
	public class Runnable extends Sprite
	{
		/* VARIABLES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** Reference to singleton manager */
		private var manRef:Class = null;
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * If you want a singleton's public static init, dnit and algo to be called in place of
		 * this object's init, dnit and algo, give the singleton Class as parameter
		 * @param	singletonManager
		 */
		public function Runnable(singletonManager:Class = null)
		{
			if (singletonManager != null && singletonManager["init"] && singletonManager["dnit"] && singletonManager["algo"]) manRef = singletonManager;
		}
		
		/* CORE */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * This iterative algo will be called by the framework; do not make calls
		 */
		public final function iterAlgo():void
		{
			if (manRef != null) manRef["algo"]();
			else algo();
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Runnable) Runnable(child).iterAlgo();
			}
		}
		
		/**
		 * This iterative init will be called by the framework; do not make calls
		 */
		public final function iterInit():void
		{
			if (manRef != null) manRef["init"]();
			else init();
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Runnable) Runnable(child).iterInit();
			}
		}
		
		/**
		 * This iterative dnit will be called by the framework; do not make calls
		 */
		public final function iterDnit():void
		{
			for (var i:int = numChildren - 1; i >= 0; i--)
			{
				var child:DisplayObject = getChildAt(i);
				if (child is Runnable) Runnable(child).iterDnit();
			}
			if (manRef != null) manRef["dnit"]();
			else dnit();
		}
		
		/* ITERATIVE METHOD CALLS */
		//-----------------------------------------------------------------------------------------
		
		/** Placeholder for method to be called on every frame when on stage
		 * Override this method, do not call it, it will be handled by the framework */
		protected function algo():void { }
		
		/** Placeholder for method to be called when it gets added to stage
		 * Override this method, do not call it, it will be handled by the framework */
		protected function init():void { }
		
		/** Placeholder for method to be called when it gets removed from stage
		 * Override this method, do not call it, it will be handled by the framework */
		protected function dnit():void { }
		
		/* INDEPENDENT PLACEHOLDERS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Overridden addChild works like its super but also calls init
		 * if its child is a runnable and this object is already on stage
		 * @param	child
		 * @return
		 */
		public override function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild(child);
			if (stage != null && child is Runnable) Runnable(child).init();
			return child;
		}
		
		/**
		 * Overridden removeChild works like its super but also calls dnit
		 * if its child is a runnable and this object is already on stage
		 * @param	child
		 * @return
		 */
		public override function removeChild(child:DisplayObject):DisplayObject
		{
			if (stage != null && child is Runnable) Runnable(child).dnit();
			super.removeChild(child);
			return child;
		}
		
		/* OVERRIDE METHODS */
		//-----------------------------------------------------------------------------------------
		
	}

}