package iluvAS 
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import iluvAS.objects.engineComponents.sound.iluvSoundChannel;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvSound 
	{
		private static var sfxLabel:Vector.<String> = new Vector.<String>();
		private static var sfxSrc:Vector.<Sound> = new Vector.<Sound>();
		
		public static var sfxPlaying:uint = 0;
		private static var sfxOpen:Vector.<Boolean> = new Vector.<Boolean>();
		private static var sfxArr:Vector.<SoundChannel> = new Vector.<SoundChannel>();
		private static var sfxTr:SoundTransform = new SoundTransform();
		
		private static var bgArr:Array = new Array();
		private static var bgVolArr:Array = new Array();
		private static var selectedBgm:int = -1;
		private static var bgmMasterVol:Number = 1;
		private static var fadeStep:Number = 0.1;
		
		public static function declareSound(soundClass:Sound, label:String, isSfx:Boolean):void
		{
			if (isSfx)
			{
				sfxLabel.push(label);
				sfxSrc.push(soundClass);
			} else
			{
				var ilCh:iluvSoundChannel = new iluvSoundChannel(soundClass, label);
				bgArr.push(ilCh);
				bgVolArr.push(0);
			}
		}
		
		public static function algo():void
		{
			for (var i:String in bgArr)
			{
				if (int(i) == selectedBgm)
				{
					if (bgVolArr[i] < 1) bgVolArr[i] += fadeStep;
					else if (bgVolArr[i] > 1) bgVolArr[i] = 1;
					// turn up volume for selected bgm
				}else
				{
					if (bgVolArr[i] > 0) bgVolArr[i] -= fadeStep;
					else if (bgVolArr[i] < 0) bgVolArr[i] = 0;
					else if (bgVolArr[i] == 0 && bgArr[i].playing) bgArr[i].stopSound();
					// turn down volume till stop sound for non selected bgms
				}
				bgArr[i].setVolume(bgVolArr[i] * bgmMasterVol);
				// assign volume
			}
		}
		
		// core functions -----------------------------------------------------------------------//
		
		public static function playSfx(label:String):void
		{
			sfxPlaying++;
			var ele:int = sfxOpen.indexOf(true);
			var labelEle:int = sfxLabel.indexOf(label);
			if (ele == -1)
			{
				var sc:SoundChannel = new SoundChannel();
				sc = sfxSrc[labelEle].play();
				sfxOpen.push(false);
				sfxArr.push(sc);
				ele = sfxArr.length - 1;
			}else
			{
				sfxOpen[ele] = false;
				sfxArr[ele] = sfxSrc[labelEle].play();
			}
			sfxArr[ele].soundTransform = sfxTr;
			sfxArr[ele].addEventListener(Event.SOUND_COMPLETE, sfxEndDetect);
		}
		
		public static function setSfxVolume(vol:Number):void
		{
			sfxTr.volume = vol;
			for (var i:String in sfxArr) sfxArr[i].soundTransform = sfxTr;
		}
		
		public static function getSfxVolume():Number { return sfxTr.volume; }
		
		public static function setSfxPan(pan:Number):void
		{
			sfxTr.pan = pan;
			for (var i:String in sfxArr) sfxArr[i].soundTransform = sfxTr;
		}
		
		public static function stopSfx():void
		{
			sfxPlaying = 0;
			for (var i:String in sfxArr)
			{
				sfxArr[i].stop();
				sfxArr[i].removeEventListener(Event.SOUND_COMPLETE, sfxEndDetect);
				sfxOpen[i] = true;
			}
		}
		
		private static function sfxEndDetect(e:Event):void
		{
			sfxPlaying--;
			var ele:int = sfxArr.indexOf(e.target);
			sfxOpen[ele] = true;
			sfxArr[ele].removeEventListener(Event.SOUND_COMPLETE, sfxEndDetect);
		}
		
		// sfx functions ------------------------------------------------------------------------ //
		
		public static function playBgm(label:String, fS:Number = 0.1):void
		{
			fadeStep = fS;
			for (var i:String in bgArr)
			{
				if (bgArr[i].getLabel() == label && selectedBgm != int(i))
				{
					selectedBgm = int(i);
					bgArr[i].playSound(true, true);
					bgArr[i].setVolume(bgVolArr[i] * bgmMasterVol);
					break;
				}
			}
		}
		
		public static function stopBgm(fS:Number = 0.1):void
		{
			fadeStep = fS;
			selectedBgm = -1;
		}
		
		public static function setBgmMasterVolume(vol:Number):void
		{
			bgmMasterVol = vol;
			for (var i:String in bgArr[i]) bgArr[i].setVolume(bgVolArr[i] * bgmMasterVol);
		}
		
		public static function getBgmMasterVolume():Number { return bgmMasterVol; }
		
	}

}