package com.fw5.factory 
{
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * This class simply serves to host a text field maker method. First the font will have to be
	 * embedded with the following tags:
		 * source = "source"
		 * fontName = "name used in method call"
		 * mimeType = "application/x-font"
		 * fontWeight = "normal"
		 * fontStyle = "normal"
		 * advancedAntiAliasing = "true"
		 * embedAsCFF = "false"
	 * @author iluvAS
	 */
	
	public final class TextMaker 
	{
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		// METHODS
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Use this method to generate a text field
		 * @param	font		The string used in the fontName tag when embedding
		 * @param	size		Size of text
		 * @param	input		TRUE - input text field
		 * @param	multi		TRUE - multiple lines allowed
		 * @param	autoSize	0 - None, 1 - Height autosize, 2 - Left, 3 - Right, 4 - Center
		 * @param	align		0 - Left, 1 - Center, 2 - Right
		 * @param	gridFit		TRUE - snaps to pixel
		 * @return
		 */
		public static function makeTextField(font:String, size:int = 12, input:Boolean = false, multi:Boolean = false,
		autoSize:int = 0, align:int = 0, gridFit:Boolean = false):TextField
		{
			var format:TextFormat = new TextFormat(font, size);
			var tf:TextField = new TextField();
			// generate objects
			
			switch(align)
			{
				case 1:
					format.align = TextFormatAlign.CENTER;
					break;
				case 2:
					format.align = TextFormatAlign.RIGHT;
					break;
				default:
					format.align = TextFormatAlign.LEFT;
					break;
			}
			format.size = size;
			format.font = font;
			// implement for format
			
			switch(autoSize)
			{
				case 1:
					tf.autoSize = TextFieldAutoSize.LEFT;
					tf.wordWrap = true;
					tf.multiline = true;
					break;
				case 2:
					tf.autoSize = TextFieldAutoSize.LEFT;
					break;
				case 3:
					tf.autoSize = TextFieldAutoSize.RIGHT;
					break;
				case 4:
					tf.autoSize = TextFieldAutoSize.CENTER;
					break;
				default:
					tf.autoSize = TextFieldAutoSize.NONE;
					break;
			}
			
			if (input)
			{
				tf.type = "input";
			}else
			{
				tf.selectable = false;
			}
			
			if (size > 48)
			{
				tf.antiAliasType = AntiAliasType.NORMAL;
			}else
			{
				tf.antiAliasType = AntiAliasType.ADVANCED;
			}
			
			if (tf.multiline && tf.wordWrap && tf.antiAliasType == AntiAliasType.ADVANCED)
			{
				tf.gridFitType = GridFitType.SUBPIXEL;
			}else
			{
				tf.gridFitType = gridFit ? GridFitType.PIXEL : GridFitType.NONE;
			}
			
			if (!tf.wordWrap)
			{
				tf.multiline = multi;
			}
			
			tf.embedFonts = true;
			tf.defaultTextFormat = format;
			// implement for tf
			
			return tf;
		}
		
		
	}

}