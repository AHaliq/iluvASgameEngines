package iluvAS.utils 
{
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class ColorUtility 
	{
		/**
		 * Interpolates a colortransform object to the desired color, by percentage
		 * and returns the new color in the form of ColorTransform object
		 * @param	start		The initial colortransform object
		 * @param	col			The desired color
		 * @param	perc		Percentage value; 0 to 1
		 * @return
		 */
		
		public static function interpolateColor(start:ColorTransform, col:uint, perc:Number):ColorTransform
		{
			var end:ColorTransform = new ColorTransform();
			end.color = col;
			
			var result:ColorTransform = new ColorTransform();
			result.redMultiplier = start.redMultiplier + (end.redMultiplier - start.redMultiplier) * perc;
			result.greenMultiplier = start.greenMultiplier + (end.greenMultiplier - start.greenMultiplier) * perc;
			result.blueMultiplier = start.blueMultiplier + (end.blueMultiplier - start.blueMultiplier) * perc;
			result.alphaMultiplier = start.alphaMultiplier + (end.alphaMultiplier - start.alphaMultiplier) * perc;
			result.redOffset = start.redOffset + (end.redOffset - start.redOffset) * perc;
			result.greenOffset = start.greenOffset + (end.greenOffset - start.greenOffset) * perc;
			result.blueOffset = start.blueOffset + (end.blueOffset - start.blueOffset) * perc;
			result.alphaOffset = start.alphaOffset + (end.alphaOffset - start.alphaOffset) * perc;
			return result;
		}
		
		/**
		 * Gets a color value that transitions from source color to destination color at the point
		 * of percentage as given by the parameters
		 * @param	sourceColor	
		 * @param	destinationColor
		 * @param	percentage
		 * @return
		 */
		public static function colorTween(sourceColor:uint, destinationColor:uint, percentage:Number):uint
		{
			var inArr:Array = hexToArr(sourceColor);
			var deArr:Array = hexToArr(destinationColor);
			for(var i:String in inArr)
			{
				inArr[i] += (deArr[i] - inArr[i]) * percentage;
			}
			inArr[0] <<= 16;
			inArr[1] <<= 8;
			var fin:uint = inArr[0] | inArr[1] | inArr[2];
			return fin;
		}
		
		/**
		 * Breaks a hex color uint variable into its RGB components in an array form
		 * @param	col		Hex color value to be processed
		 * @return			Final array in the format [R,G,B]
		 */
		public static function hexToArr(col:uint):Array
		{
			var arr:Array = new Array();
			arr[0] = (col & 0xFF0000) >> 16;
			arr[1] = (col & 0x00FF00) >> 8;
			arr[2] = (col & 0x0000FF);
			return arr;
		}
	}

}