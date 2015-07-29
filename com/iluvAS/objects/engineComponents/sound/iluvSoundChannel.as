package iluvAS.objects.engineComponents.sound 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvSoundChannel 
	{
		private var LABEL:String;
		private var snd:Sound;
		private var ch:SoundChannel;
		private var tr:SoundTransform;
		private var playPos:Number = 0;
		public var playing:Boolean = false;
		
		public function iluvSoundChannel(soundInstance:Sound, label:String) 
		{
			ch = new SoundChannel();
			tr = new SoundTransform();
			LABEL = label;
			snd = soundInstance;
		}
		
		public function getLabel():String { return LABEL; }
		
		public function playSound(reset:Boolean = true, loop:Boolean = false):void
		{
			stopSound();
			if (reset) playPos = 0;
			ch = snd.play(playPos, 0, tr);
			if (loop) ch.addEventListener(Event.SOUND_COMPLETE, loopSound);
			playing = true;
		}
		
		private function loopSound(e:Event):void
		{
			SoundChannel(e.target).removeEventListener(e.type, loopSound);
			playSound(true, true);
		}
		
		public function stopSound():void
		{
			ch.removeEventListener(Event.SOUND_COMPLETE, loopSound);
			playPos = ch.position;
			ch.stop();
			playing = false;
		}
		
		public function setVolume(vol:Number):void
		{
			tr.volume = vol;
			ch.soundTransform = tr;
		}
		
		public function setPan(pan:Number):void
		{
			tr.pan = pan;
			ch.soundTransform = tr;
		}
		
	}

}