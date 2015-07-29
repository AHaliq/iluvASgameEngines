package com.fw5.utils.bitmap 
{
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	/**
	 * ...
	 * @author Haliq
	 */
	public final class BlitFiltersCore 
	{
		
		private static var filtVec:Vector.<BitmapFilter> = new Vector.<BitmapFilter>();
		
		/**
		 * Create a filter that tints and/or reduces alpha
		 * @param	alphaReduc	% of alpha reduced
		 * @param	tintCol		desired color to tint to
		 * @param	colorReduc	% of tint applied
		 */
		public static function makeColorAlphaFilter(alphaReduc:Number, tintCol:uint = 0x000000, colorReduc:Number = 0):void
		{
			if (colorReduc > 1 || colorReduc <= 0) colorReduc = 0;
			colorReduc = 1 - colorReduc;
			
			var col:Array = new Array();
			col.push((tintCol & 0xFF0000) >> 16);
			col.push((tintCol & 0x00FF00) >> 8);
			col.push(tintCol & 0x0000FF);
			
			var arr:Array = new Array();
			arr.push(colorReduc, 0, 0, 0, (1 - colorReduc) * col[0]);
			arr.push(0, colorReduc, 0, 0, (1 - colorReduc) * col[1]);
			arr.push(0, 0, colorReduc, 0, (1 - colorReduc) * col[2]);
			arr.push(0, 0, 0, 1 - alphaReduc, 0);
			var filter:ColorMatrixFilter = new ColorMatrixFilter(arr);
			filtVec.push(filter);
		}
		
		/**
		 * Create a filter that blurs
		 * @param	blurX		X blur value
		 * @param	blurY		Y blur value
		 */
		public static function makeBlurFilter(blurX:Number = 4, blurY:Number = 4):void
		{
			var filter:BlurFilter = new BlurFilter(blurX, blurY, BitmapFilterQuality.HIGH);
			filtVec.push(filter);
		}
		
		/**
		 * Used by blitCanvases to retrieve filters
		 * @param	id
		 * @return
		 */
		internal static function getFilter(id:uint):BitmapFilter
		{
			return filtVec[id];
		}
		
	}

}