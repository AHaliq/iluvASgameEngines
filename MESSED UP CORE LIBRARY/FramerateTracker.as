package  
{
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
    import flash.events.Event;
    import flash.text.TextField;
	
	/**
	 * ...
	 * @author Haliq
	 */
	public class FramerateTracker extends Sprite
    {
        private var time:int;
        private var prevTime:int = 0;
        private var fps:int;
        private var fps_txt:TextField;
		
		private var tmr:int = 0;
		private var currentTotal:int = 0;
		private var avg:Number = 0;
		
		private const tolerance:int = 2;
		private var laggInst:int = 0;
		private var okInst:int = 0;
		private var perc:String = "ok";
        
        public function FramerateTracker()
        {
			var tf:TextFormat = new TextFormat(null,null, 0xffffff);
			fps_txt = new TextField();
			fps_txt.defaultTextFormat = tf;
			fps_txt.text = "Some text";
			fps_txt.height = fps_txt.textHeight*1.5;
			fps_txt.text = "";
			
			graphics.beginFill(0x000000, 0.75);
			graphics.drawRect(0, 0, fps_txt.width, fps_txt.height);
			
            addChild(fps_txt);
            addEventListener(Event.ENTER_FRAME, getFps);
        }
		
        private function getFps(e:Event):void
        {
            time = getTimer();
            fps = 1000 / (time - prevTime);
            fps_txt.text = "fps: " + fps + " | " + avg +" | "+ perc;
            prevTime = getTimer();
			
			currentTotal += fps;
			tmr++;
			if (tmr >= stage.frameRate)
			{
				avg = Math.round(currentTotal / stage.frameRate);
				if (avg < stage.frameRate-tolerance)
				{
					perc = "lagg";
				}else
				{
					perc = "ok";
				}
				currentTotal = 0;
				tmr = 0;
			}
        }
	}

}