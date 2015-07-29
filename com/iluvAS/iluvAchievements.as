package iluvAS 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.net.SharedObject;
	import iluvAS.objects.iluvObj;
	/**
	 * ...
	 * @author iluvAS
	 */
	public class iluvAchievements extends iluvObj
	{
		[Embed(source = "assets/graphics/achievements/achievements graphics.swf", symbol = "ACH_DEF_LOGO")]
		private static var DEF_LOGO_CLASS:Class;
		private static var DEF_LOGO:Sprite = new DEF_LOGO_CLASS();
		
		[Embed(source = "assets/graphics/achievements/achievements graphics.swf", symbol = "ACH_OBJ")]
		private static var OBJ_CLASS:Class;
		private static var OBJ:MovieClip = new OBJ_CLASS();
		
		private static const SAVE_LABEL:String = "iluvAchievementsSave";
		private static var SPR_REF:Sprite = new Sprite();
		
		private static var labelArr:Array = new Array();
		private static var descArr:Array = new Array();
		private static var valArr:Array = new Array();
		private static var tpeArr:Array = new Array();
		private static var mchArr:Array = new Array();
		private static var logoArr:Array = new Array();
		private static var toShowEle:Array = new Array();
		private static var achArr:Array = new Array();
		
		public static function init(spr:Sprite, stWdt:Number, stHgt:Number):void
		{
			iluvSaveData.createOrLoad(SAVE_LABEL);
			var so:SharedObject = iluvSaveData.getSo(SAVE_LABEL);
			labelArr = so.data.labelArr == undefined ? new Array() : so.data.labelArr;
			descArr = so.data.descArr == undefined ? new Array() : so.data.descArr;
			valArr = so.data.valArr == undefined ? new Array() : so.data.valArr;
			tpeArr = so.data.tpeArr == undefined ? new Array() : so.data.tpeArr;
			mchArr = so.data.mchArr == undefined ? new Array() : so.data.mchArr;
			logoArr = so.data.logoArr == undefined ? new Array() : so.data.logoArr;
			achArr = so.data.achArr == undefined ? new Array() : so.data.achArr;
			// load data if any
			
			SPR_REF = spr;
			OBJ.x = stWdt - 200;
			OBJ.stop();
			spr.mouseEnabled = false;
			spr.mouseChildren = false;
		}
		
		public static function algo():void
		{
			var ele:int;
			if (toShowEle.length > 0 && !OBJ.stage)
			{
				ele = toShowEle[0];
				OBJ.objHolder.msg.text = labelArr[ele];
				OBJ.objHolder.msg2.text = descArr[ele];
				OBJ.objHolder.holder.addChild(logoArr[ele] == null ? DEF_LOGO : logoArr[ele]);
				OBJ.gotoAndPlay(1);
				SPR_REF.addChild(OBJ);
			}
			if (OBJ.stage)
			{
				if (OBJ.currentFrame == OBJ.totalFrames)
				{
					ele = toShowEle[0];
					OBJ.objHolder.holder.removeChild(logoArr[ele] == null ? DEF_LOGO : logoArr[ele]);
					OBJ.gotoAndStop(1);
					SPR_REF.removeChild(OBJ);
					toShowEle.shift();
				}
			}
		}
		
		// core functions -----------------------------------------------------------------------//
		
		public static function declareAchievement(label:String, description:String, tpe:int, initialValue:*, mch:*, logo:MovieClip = null):void
		{
			if (labelArr.indexOf(label) == -1)
			{
				if (logo != null) MovieClip(logo).stop();
				logo.width = logo.height = 29;
				labelArr.push(label);
				descArr.push(description);
				tpeArr.push(tpe);
				valArr.push(initialValue);
				mchArr.push(mch);
				logoArr.push(logo);
				achArr.push(false);
				saveData(false);
			}
		}
		
		public static function updateAchievement(label:String, val:*):void
		{
			var i:int = labelArr.indexOf(label);
			if (i > -1 && !achArr[i])
			{
				var achieve:Boolean = false;
				switch(tpeArr[i])
				{
					case 0:
						if (!achArr[i] && val >= mchArr[i]) achieve=true;
						valArr[i] = val > valArr[i] ? val : valArr[i];
						break;
					case 1:
						if (!achArr[i] && val <= mchArr[i]) achieve=true;
						valArr[i] = val < valArr[i] ? val : valArr[i];
						break;
					case 2:
						if (val == mchArr[i] && !achArr[i])
						{
							achieve = true;
							valArr[i] = val;
						}
						break;
				}
				if (achieve)
				{
					achArr[i] = true;
					toShowEle.push(i);
					saveData(false);
				}
			}
		}
		
		public static function getAchieveState(lbl:String):Boolean
		{
			var i:int = labelArr.indexOf(lbl);
			if (i > -1)
			{
				return achArr[i];
			}
			return false;
		}
		
		public static function clearData():void
		{
			iluvSaveData.clearData(SAVE_LABEL);
		}
		
		private static function saveData(valueOnly:Boolean = true):void
		{
			iluvSaveData.createOrLoad(SAVE_LABEL);
			var so:SharedObject = iluvSaveData.getSo(SAVE_LABEL);
			if (!valueOnly)
			{
				so.data.labelArr = labelArr;
				so.data.descArr = descArr;
				so.data.mchArr = mchArr;
				so.data.logoArr = logoArr;
				so.data.tpeArr = tpeArr;
				so.data.achArr = achArr;
			}
			so.data.valArr = valArr;
			so.flush();
		}
		
	}

}