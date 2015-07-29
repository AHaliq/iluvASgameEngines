package  
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class KeyboardClass 
	{
		public var downk:Boolean;
		public var upk:Boolean;
		public var leftk:Boolean;
		public var rightk:Boolean;
		public var spacek:Boolean;
		
		public var hdownk:Boolean;
		public var hupk:Boolean;
		public var hleftk:Boolean;
		public var hrightk:Boolean;
		public var hspacek:Boolean;
		
		
		public function KeyboardClass(stageRef:Object) 
		{
			stageRef.addEventListener(KeyboardEvent.KEY_DOWN, kd);
			stageRef.addEventListener(KeyboardEvent.KEY_UP, ku);
		}
		
		private function kd(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				case Keyboard.RIGHT:
					rightk = true;
					break;
				case Keyboard.DOWN:
					downk = true;
					break;
				case Keyboard.LEFT:
					leftk = true;
					break;
				case Keyboard.UP:
					upk = true;
					break;
				case Keyboard.SPACE:
					spacek = true;
					break;
			}
		}
		
		private function ku(evt:KeyboardEvent):void
		{
			switch(evt.keyCode)
			{
				case Keyboard.RIGHT:
					rightk = false;
					hrightk = false;
					break;
				case Keyboard.DOWN:
					downk = false;
					hdownk = false;
					break;
				case Keyboard.LEFT:
					leftk = false;
					hleftk = false;
					break;
				case Keyboard.UP:
					upk = false;
					hupk = false;
					break;
				case Keyboard.SPACE:
					spacek = false;
					hspacek = false;
					break;
			}
		}
		
	}

}