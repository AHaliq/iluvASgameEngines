package iluvAS.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Haliq
	 */
	public class  BitmapCanvas extends Sprite
	{
		private var bitmapDat:BitmapData;
		private var bitmap:Bitmap;
		private var rBitmap:Point;
		
		private var nDatArr:Array = new Array();
		private var bDatArr:Array = new Array();
		private var rDatArr:Array = new Array();
		
		private var nCfmArr:Array = new Array();
		private var cCfmArr:Array = new Array();
		
		public function BitmapCanvas(wdt:Number, hgt:Number)
		{
			bitmapDat = new BitmapData(wdt, hgt, true, 0x00000000);
			bitmap = new Bitmap(bitmapDat, "auto", true);
			bitmap.smoothing = true;
			rBitmap = new Point(wdt, hgt);
			addChild(bitmap);
		}
		
		public function addToLibrary(obj:DisplayObjectContainer, stringID:String, translateType:String = "none", xpos:Number = 0, ypos:Number = 0):int
		{
			nDatArr.push(stringID);
			var newData:BitmapData = new BitmapData(obj.width, obj.height, true, 0x00FFFFFF);
			rDatArr.push(new Point(obj.width, obj.height));
			
			var translationMatrix:Matrix = new Matrix();
			switch(translateType)
			{
				case "point":
					translationMatrix.translate(xpos, ypos);
					break;
				case "mid":
					translationMatrix.translate(obj.width / 2, obj.height / 2);
					break;
				default:
					translationMatrix.translate(0, 0);
					break;
			}
			newData.draw(obj, translationMatrix);
			bDatArr.push(newData);
			
			return bDatArr.length - 1;
		}
		
		public function checkDefinition(stringID:String):Boolean
		{
			for (var i:String in nDatArr)
			{
				if (nDatArr[i] == stringID) return true;
			}
			return false;
		}
		
		public function print(stringID:*, xcod:Number, ycod:Number, placeMid:Boolean = false, alphaMul:Number = 1):void
		{
			var eNum:int
			if (stringID is String)
			{
				eNum = idToElement(stringID, nDatArr);
			}else
			{
				eNum = stringID;
			}
			// get element of bitmap data
			
			var bRes:Point = rDatArr[eNum];
			var bmd:BitmapData = bDatArr[eNum];
			// reference to data
			
			//THIS THING HAS NO ERRORS, IF YOU DO, ITS BECAUSE:
				// THE STRING LABEL CANT FIND THE ELEMENT OR
				// THE ELEMENT YOU SPECIFIED POINTS TO NOTHING
			
			if (alphaMul < 1)
			{
				bmd = bmd.clone();
				var rec:Rectangle = new Rectangle(placeMid ?  - bmd.width / 2 : 0, placeMid ? -bmd.height / 2 : 0, bmd.width, bmd.height);
				var colTrans:ColorTransform = new ColorTransform();
				colTrans.alphaMultiplier = alphaMul < 0 ? 0 : (alphaMul > 1 ? 1 : alphaMul);
				bmd.colorTransform(rec, colTrans);
			}
			bitmapDat.copyPixels(bmd, new Rectangle(0, 0, bRes.x, bRes.y), new Point(placeMid ? xcod - bmd.width / 2 : xcod, placeMid ? ycod - bmd.height / 2 : ycod), null, new Point(0, 0), true);
		}
		
		public function erase(xcod:Number = 0, ycod:Number = 0, wdt:Number = 0, hgt:Number = 0):void
		{
			if (wdt == 0 && hgt == 0)
			{
				wdt = rBitmap.x;
				hgt = rBitmap.y;
			}
			bitmapDat.fillRect(new Rectangle(xcod, ycod, wdt, hgt), 0x0000000000);
		}
		
		public function makeNewBlurFilter(stringID:String, blurX:Number, blurY:Number, quality:int = 3):void
		{
			nCfmArr.push(stringID);
			cCfmArr.push(new BlurFilter(blurX, blurY, quality));
		}
		
		public function makeNewAlphaColorFilter(stringID:String, alphaFade:Number, hex:Number = 0x000000, colorFade:Number = 0):void
		{
			if (colorFade > 1 || colorFade <= 0) colorFade = 0;
			colorFade = 1 - colorFade;
			var col:Array = new Array();
			col[0] = (hex & 0xFF0000) >> 16;
			col[1] = (hex & 0x00FF00) >> 8;
			col[2] = (hex & 0x0000FF);
			var cmfm:Array = [];
			cmfm = cmfm.concat([colorFade, 0, 0, 0, (1 - colorFade) * col[0]]);
			cmfm = cmfm.concat([0, colorFade, 0, 0, (1 - colorFade) * col[1]]);
			cmfm = cmfm.concat([0, 0, colorFade, 0, (1 - colorFade) * col[2]]);
			cmfm = cmfm.concat([0, 0, 0, alphaFade, 0]); 
			var cmf:ColorMatrixFilter = new ColorMatrixFilter(cmfm);
			
			nCfmArr.push(stringID);
			cCfmArr.push(cmf);
		}
		
		public function applyFilter(stringID:String, times:int = 1):void
		{
			if (times < 1) times = 1;
			var eNum:int = idToElement(stringID, nCfmArr);
			bitmapDat.applyFilter(bitmapDat, bitmapDat.rect, new Point(0, 0), cCfmArr[eNum]);
		}
		
		public function idToElement(stringID:String, arr:*):int
		{
			var arrRef:Array;
			if (!(arr is Array))
			{
				switch (arr)
				{
					case "n":
						arrRef = nDatArr;
						break;
				}
			}else if(arr is Array)
			{
				arrRef = arr;
			}
			if (arrRef != null)
			{
				for (var idToElement_i:String in arrRef)
				{
					if (arrRef[idToElement_i] == stringID) return int(idToElement_i);
				}
			}
			return 0;
		}
		
	}
	
}