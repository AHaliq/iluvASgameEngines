package com.fw5.utils.bitmap 
{
	import com.fw5.engine.Core;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * This is a blank slate that can print out bitmapData captured from the BlitCore class.
	 * @author Haliq
	 */
	public final class BlitCanvas extends Sprite
	{
		/* PROPERTIES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/** Array of entities under this object's management */
		private var entityVec:Vector.<BlitEntity> = new Vector.<BlitEntity>();
		/** This canvas will call its child entitie's algo */
		public var enabled:Boolean = true;
		/** True will delete all graphics prior to rendering on a new frame*/
		public var frameErase:Boolean = false;
		
		// VIRTUAL OBJECT VARIABLES
		// ------------------------------------------------------------ //
		
		private var filterAutoVec:Vector.<Point> = new Vector.<Point>();
		
		private var algoAdded:Boolean = false;
		
		/** Bitmap data used to render the graphics*/
		private var bitmapDat:BitmapData;
		/** Bitmap object used to display the rendered graphics */
		private var bitmap:Bitmap;
		/** the canvas's width value */
		private var cWDT:uint;
		/** the canvas's height value */
		private var cHGT:uint;
		/** a rectangle object that is reused by this object throughout its lifecycle in its algorithms */
		private var rectPrinter:Rectangle = new Rectangle(0, 0, 0, 0);
		/** a point object that is reused by this object throughout its lifecycle in its algorithms */
		private var pointPrinter:Point = new Point(0, 0);
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Construct this object with a width and height value
		 * @param	wdt
		 * @param	hgt
		 */
		public function BlitCanvas(wdt:Number, hgt:Number)
		{
			bitmapDat = new BitmapData(wdt, hgt, true, 0x00000000);
			bitmap = new Bitmap(bitmapDat, PixelSnapping.NEVER, true);
			cWDT = wdt;
			cHGT = hgt;
			addChild(bitmap);
		}
		
		/**
		 * Ensure that you know what the mcID and cID of the clip you intend to print is.
		 * You can find out what the mcID is by the return value you get when you register your MC to BlitCore
		 * @param	mcID	MovieClip ID
		 * @param	cID		Clip ID
		 * @param	xPos	X position of registration point of clip to print to
		 * @param	yPos	Y position of registration point of clip to print to
		 */
		public function directPrint(mcID:uint, cID:uint, xPos:Number, yPos:Number):void
		{
			var bmd:BitmapData = BlitCore.getBitmapData(mcID, cID);
			var regPt:Point = BlitCore.getRegCoord(mcID, cID);
			
			rectPrinter.width = bmd.width;
			rectPrinter.height = bmd.height;
			pointPrinter.x = xPos - regPt.x;
			pointPrinter.y = yPos - regPt.y;
			bitmapDat.copyPixels(bmd, rectPrinter, pointPrinter, null, null, true);
		}
		
		/**
		 * Erase a portion or the whole canvas. 0 wdt and hgt values will erase the whole canvas.
		 * @param	xCoord		Left boundary to start erase
		 * @param	yCoord		Top boundary to start erase
		 * @param	wdt			X distance from left boundary to erase
		 * @param	hgt			Y distance from top boundary to erase
		 */
		public function erase(xCoord:Number = 0, yCoord:Number = 0, wdt:Number = 0, hgt:Number = 0):void
		{
			if (wdt == 0 && hgt == 0)
			{
				rectPrinter.width = cWDT;
				rectPrinter.height = cHGT;
				bitmapDat.fillRect(rectPrinter, 0x0000000000);
			}else
			{
				rectPrinter.x = xCoord;
				rectPrinter.y = yCoord;
				rectPrinter.width = wdt;
				rectPrinter.height = hgt;
				bitmapDat.fillRect(rectPrinter, 0x0000000000);
				rectPrinter.x = 0;
				rectPrinter.y = 0;
			}
		}
		
		/**
		 * Call this method to apply a filter onto the canvas. A filter as defined in BlitFilterCore
		 * @param	filterID
		 * @param	multiplicity
		 */
		public function applyFilter(filterID:uint, multiplicity:uint = 1):void
		{
			pointPrinter.x = 0;
			pointPrinter.y = 0;
			for (var i:int = 0; i < multiplicity; i++) bitmapDat.applyFilter(bitmapDat, bitmapDat.rect, pointPrinter, BlitFiltersCore.getFilter(filterID));
		}
		
		public function registerFilter(filterID:uint, multiplicity:uint = 1):void
		{
			filterAutoVec.push(new Point(filterID, multiplicity));
			updateAlgoStatus();
		}
		
		public function removeFilter(filterID:uint):void
		{
			for (var i:int = filterAutoVec.length - 1; i >= 0; i--)
			{
				if (filterAutoVec[i].x == filterID)
				{
					filterAutoVec.splice(i, 1);
				}
			}
			updateAlgoStatus();
		}
		
		private function updateAlgoStatus():void
		{
			if (!algoAdded && (filterAutoVec.length > 0 || entityVec.length > 0))
			{
				Core.addAlgo(algo);
				algoAdded = true;
			}else if (algoAdded && (filterAutoVec.length == 0 && entityVec.length == 0))
			{
				Core.removeAlgo(algo);
				algoAdded = false;
			}
		}
		
		/**
		 * This method will be passed to Core to be called on every frame
		 */
		private function algo():void
		{
			if (enabled)
			{
				if (frameErase) erase();
				for (var i:int = filterAutoVec.length - 1; i >= 0; i--)
				{
					applyFilter(filterAutoVec[i].x, filterAutoVec[i].y);
				}
				for (i = entityVec.length - 1; i >= 0; i--)
				{
					entityVec[i].algo();
					if (entityVec[i].visible) directPrint(entityVec[i].M_ID, entityVec[i].C_ID, entityVec[i].x, entityVec[i].y);
				}
				
			}
		}
		
		/* CORE METHODS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Call this to register an entity to be printed and managed by this canvas
		 * @param	obj
		 */
		public function registerBlitEntity(obj:BlitEntity):void
		{
			entityVec.push(obj);
			updateAlgoStatus();
		}
		
		/**
		 * Call this to remove an entity from this canvas's management
		 * @param	obj
		 */
		public function disposeBlitEntity(obj:BlitEntity):void
		{
			entityVec.splice(entityVec.indexOf(obj), 1);
			updateAlgoStatus();
		}
		
		/**
		 * If you intend to no longer use an instance of the blitCanvas object, ensure dispose is called
		 * so that it can remove all references to Core engine, its child entities, and filter automations.
		 */
		public function dispose():void
		{
			entityVec = new Vector.<BlitEntity>();
			filterAutoVec = new Vector.<Point>();
			updateAlgoStatus();
		}
		
		/* VIRTUAL OBJECT HANDLING */
		//-----------------------------------------------------------------------------------------
	}
	
}