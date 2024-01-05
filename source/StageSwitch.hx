package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import StageData;

using StringTools;

class StageSwitch
{
	public static var newStageData:StageFile;

	public static var backGround:BGSprite;
	public static var middleGround:BGSprite;
	public static var foreGround:BGSprite;
	public static var skyline:BGSprite;
	public static var screenBack:BGSprite;
	public static var buildings:BGSprite;
	public static var signPost:BGSprite;
	public static var shadingOverlay:BGSprite;

	public static function addStageToGroup(stage:String)
	{
		switch (stage)
		{
			case "warzone":
				trace("Adding warzone to groups");
				backGround = new BGSprite("switchedStages/ivWarzone/background", -500, -200, 0.7, 0.7);
				PlayState.stageSwitchBackgroundGroup.add(backGround);

				middleGround = new BGSprite("switchedStages/ivWarzone/middleGround", -500, -200, 1, 1);
				PlayState.stageSwitchBackgroundGroup.add(middleGround);

				foreGround = new BGSprite("switchedStages/ivWarzone/foreground", -500, -200, 1, 1);
				PlayState.stageSwitchOverlayGroup.add(foreGround);
			case "myworld":
				trace("Adding myworld to groups");
				skyline = new BGSprite('MYWORLD/skyBack', -500, -200, 1, 1);
				skyline.scale.set(0.5, 0.5);
				skyline.updateHitbox();
				PlayState.stageSwitchBackgroundGroup.add(skyline);

				screenBack = new BGSprite('MYWORLD/screenBack', -500, -200, 1, 1);
				screenBack.scale.set(0.5, 0.5);
				screenBack.updateHitbox();
				PlayState.stageSwitchBackgroundGroup.add(screenBack);

				buildings = new BGSprite('MYWORLD/street', -500, -200, 1, 1);
				buildings.scale.set(0.5, 0.5);
				buildings.updateHitbox();
				PlayState.stageSwitchBackgroundGroup.add(buildings);

				signPost = new BGSprite('MYWORLD/signPost', -650, 0, 1.5, 1.5);
				signPost.scale.set(0.5, 0.5);
				signPost.updateHitbox();
				PlayState.stageSwitchBackgroundGroup.add(signPost);

				shadingOverlay = new BGSprite('MYWORLD/Shading', -500, -200, 1, 1);
				shadingOverlay.scale.set(0.5, 0.5);
				shadingOverlay.updateHitbox();
				shadingOverlay.blend = HARDLIGHT;
				shadingOverlay.alpha = 0.9;
				PlayState.stageSwitchOverlayGroup.add(shadingOverlay);
		}
	}

	public static function resetGroupAlphas(opacity:Float)
	{
		PlayState.stageSwitchBackgroundGroup.forEach(function(backgroundAsset:BGSprite)
		{
			backgroundAsset.alpha = opacity;
		});
		PlayState.stageSwitchOverlayGroup.forEach(function(opverlayAsset:BGSprite)
		{
			opverlayAsset.alpha = opacity;
		});
	}

	public static function destroyStage(stageToDestroy:String) {
		switch(stageToDestroy) {
			case "warzone":
				PlayState.stageSwitchBackgroundGroup.remove(backGround);
				PlayState.stageSwitchBackgroundGroup.remove(middleGround);
				PlayState.stageSwitchOverlayGroup.remove(foreGround);
				backGround.destroy();
				middleGround.destroy();
				foreGround.destroy();
			case "myworld":
				PlayState.stageSwitchBackgroundGroup.remove(skyline);
				PlayState.stageSwitchBackgroundGroup.remove(screenBack);
				PlayState.stageSwitchBackgroundGroup.remove(buildings);
				PlayState.stageSwitchBackgroundGroup.remove(signPost);
				PlayState.stageSwitchOverlayGroup.remove(shadingOverlay);
				skyline.destroy();
				screenBack.destroy();
				buildings.destroy();
				signPost.destroy();
				shadingOverlay.destroy();
		}
	}

	public static function showStage(stageToShow:String)
	{
		newStageData = StageData.getStageFile(stageToShow, true);

		switch (stageToShow)
		{
			case "warzone":
				trace("Switched to warzone");
				resetGroupAlphas(0.0001);
				backGround.alpha = 1;
				middleGround.alpha = 1;
				foreGround.alpha = 1;
			case "myworld":
				trace("Switched to myworld");
				resetGroupAlphas(0.0001);
				skyline.alpha = 1;
				screenBack.alpha = 1;
				buildings.alpha = 1;
				signPost.alpha = 1;
				shadingOverlay.alpha = 0.9;
			case "alley":
				trace("Switched to alley");
				resetGroupAlphas(1);
				backGround.alpha = 0.0001;
				middleGround.alpha = 0.0001;
				foreGround.alpha = 0.0001;
				skyline.alpha = 0.0001;
				screenBack.alpha = 0.0001;
				buildings.alpha = 0.0001;
				signPost.alpha = 0.0001;
				shadingOverlay.alpha = 0.0001;
		}
	}
}
