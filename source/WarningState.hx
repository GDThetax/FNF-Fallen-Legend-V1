package;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.filters.BitmapFilter;
import openfl.filters.ColorMatrixFilter;

using StringTools;

class WarningState extends MusicBeatState
{
	var warningText_1:FlxText;
	var warningText_2:FlxText;
	var switchToggle:Bool = false;
	var viewState:Int = 0;

	override public function create():Void
	{
		FlxG.mouse.visible = false;

		warningText_1 = new FlxText(0, 0, FlxG.width, "This mod was made by only one person with little\n
		to no experience in art, animation and music prior to development.\n
		Please take this into consideration when playing through\n
		this mod and I hope you enjoy playing my nearly 3 year project.\n
		...Press ENTER to continue...", 20);
		warningText_1.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER);
		warningText_1.screenCenter(Y);
		warningText_1.scale.set(1, 0);
		warningText_1.updateHitbox();
		add(warningText_1);

		warningText_2 = new FlxText(0, 0, FlxG.width, "!WARNING!\n
		This mod gets VERY flashy at some points and unfortunately\n
		there is no way to turn them off (sorry epileptic people).\n
		This mod contains topics some may find disturbing such as:\n
		depression, insanity, murder, self harm and slight gore\n
		This mod is not intended for younger audiences\n
		YOU HAVE BEEN WARNED\n
		...Press ENTER to continue...", 20);
		warningText_2.setFormat("VCR OSD Mono", 20, FlxColor.WHITE, CENTER);
		warningText_2.screenCenter(Y);
		warningText_2.y += 100;
		warningText_2.scale.set(1, 0);
		warningText_2.updateHitbox();
		add(warningText_2);

		FlxTween.tween(warningText_1.scale, {y: 1}, 0.1, {
			ease: FlxEase.backOut,
			startDelay: 1,
			onComplete: function(toggleSwitch:FlxTween)
			{
				switchToggle = true;
				viewState = 1;
			}
		});

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (switchToggle && FlxG.keys.justPressed.ENTER)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.25);
			switch viewState
			{
				case 1:
					switchToggle = false;
					FlxTween.tween(warningText_1.scale, {y: 0}, 0.1, {ease: FlxEase.backIn});
					FlxTween.tween(warningText_2.scale, {y: 1}, 0.1, {
						ease: FlxEase.backOut,
						startDelay: 1,
						onComplete: function(toggleSwitch:FlxTween)
						{
							viewState = 2;
							switchToggle = true;
						}
					});
				case 2:
					switchToggle = false;
					FlxTween.tween(warningText_2.scale, {y: 0}, 0.1, {
						ease: FlxEase.backIn,
					});
					new FlxTimer().start(0.5, function(switchState:FlxTimer)
					{
						MusicBeatState.switchState(new TitleState());
					});
			}
		}
	}
}
