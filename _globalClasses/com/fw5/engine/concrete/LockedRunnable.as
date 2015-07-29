package com.fw5.engine.concrete 
{
	import com.fw5.engine.abstracts.Runnable;
	import com.fw5.engine.Core;
	import com.fw5.factory.TextMaker;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * This is a concrete runnable that is open to extention. It is used to display information
	 * after a swf has been locked.
	 * @author Haliq
	 */
	public final class LockedRunnable extends Runnable 
	{
		/* PROPERTIES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		[Embed(source="../../../../../TestBnM/lib/fonts/Juan_Casco_basica_unicode.ttf", fontName = "lockFont", mimeType = "application/x-font", fontWeight = "normal", fontStyle = "normal", advancedAntiAliasing = "true", embedAsCFF = "false")]
		private static var fClass:Class;
		
		/** Text field */
		private var tf:TextField;
		/** Sprite where text field is held */
		private var textLayer:Sprite = new Sprite();
		/** Sprite where background is colored */
		private var bgLayer:Sprite = new Sprite();
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Initialize the object with a background color
		 * @param	bgColor
		 */
		public function LockedRunnable(bgColor:uint = 0x000000) 
		{
			super();
			graphics.beginFill(bgColor);
			graphics.drawRect(0, 0, Core.WDT, Core.HGT);
			
			tf = TextMaker.makeTextField("lockFont", 50, false, true, 1, 1, false);
			addChild(tf);
			tf.width = Core.WDT;
		}
		
		/**
		 * Define a text of information to be displayed
		 * @param	htmlText
		 */
		public function declareText(htmlText:String = "<font color='#aaaaaa'> this game is locked </font>"):void
		{
			tf.htmlText = htmlText;
			tf.y = (Core.HGT - tf.height) * 0.5;
		}
		
	}

}