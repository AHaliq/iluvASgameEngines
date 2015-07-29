package  
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Haliq
	 */
	public class MouseClass
	{
		public var mouseState:Boolean;
		public var mouseHeld:Boolean;
		public var active:Boolean;
		private var stRef:Object;
		
		public function MouseClass(stageRef:Object) 
		{
			stRef = stageRef;
			stageRef.addEventListener(MouseEvent.MOUSE_DOWN, md);
			stageRef.addEventListener(MouseEvent.MOUSE_UP, mu);
			stageRef.addEventListener(Event.ACTIVATE, onActivate, false, 0, true );
			stageRef.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true );
		}
		private function onActivate( event:Event ):void
		{
			active = true;
		}
		private function onDeactivate( event:Event ):void
		{
			active = false;
		}
		
		public function rollOverObj(obj:Object):Boolean
		{
			if (obj == null) return false;
			if (obj.hitTestPoint(stRef.mouseX, stRef.mouseY, true))return true;
			return false;
		}
		
		public function rollOverCoord(xpos:Number, ypos:Number, wdt:Number, hgt:Number, objRef:Object = null):Boolean
		{
			if (objRef == null)
			{
				if (stRef.mouseX > xpos && stRef.mouseX < xpos + wdt && stRef.mouseY > ypos && stRef.mouseY < ypos + hgt) return true;
			}else
			{
				var pt1:Point = new Point(xpos, ypos);
				var pt2:Point = objRef.localToGlobal(pt1);
				if (stRef.mouseX > pt2.x && stRef.mouseX < pt2.x + wdt && stRef.mouseY > pt2.y && stRef.mouseY < pt2.y + hgt) return true;
			}
			return false;
		}
		
		public function clickObj(obj:DisplayObject):Boolean
		{
			if (mouseState && !mouseHeld && rollOverObj(obj))
			{
				mouseHeld = true;
				return true;
			}
			return false;
		}
		
		private function md(evt:Event):void
		{
			mouseState = true;
		}
		
		private function mu(evt:Event):void
		{
			mouseState = false;
			mouseHeld = false;
		}
		
	}

}