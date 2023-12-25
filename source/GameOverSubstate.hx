package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxCamera;

class GameOverSubstate extends MusicBeatSubstate
{
	public static var instance:GameOverSubstate;
	public static var deathSoundName:String = 'gameOver';
	public static var endSoundName:String = 'gameOverEnd';
	public static var songName:String = '';

	var GOCamera:FlxCamera;

	var imageScreen:FlxSprite;
	var blackScreen:FlxSprite;
	var retryText:CustomAlphabets;

	public static function resetVariables()
	{
		deathSoundName = 'gameOver';
		songName = PlayState.SONG.song;
	}

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);
		FlxG.game.setFilters([]);

		super.create();
	}

	public function new()
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		GOCamera = new FlxCamera();
		FlxG.cameras.add(GOCamera);

		imageScreen = new FlxSprite().loadGraphic(Paths.image('gameOverScreens/' + songName));
		imageScreen.cameras = [GOCamera];
		imageScreen.scale.set(0.5, 0.5);
		imageScreen.updateHitbox();
		add(imageScreen);

		retryText = new CustomAlphabets(250, Std.int(FlxG.height / 2) - 100, 'retry', 'cursive', true, 0.1);
		retryText.cameras = [GOCamera];
		add(retryText);

		for (i in 0...retryText.lettersArray.length)
		{
			retryText.lettersArray[i].x -= 225 * i;
			new FlxTimer().start(0.5 * i, function(waveLetters:FlxTimer)
			{
				FlxTween.tween(retryText.lettersArray[i], {y: retryText.lettersArray[i].y - 30}, 4, {type: PINGPONG, ease: FlxEase.quadInOut});
			});
		}

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackScreen.cameras = [GOCamera];
		add(blackScreen);
		FlxTween.tween(blackScreen, {alpha: 0}, 6);

		FlxG.sound.play(Paths.sound(deathSoundName));
	}

	public var boyfriend:Boyfriend;

	var isEnding:Bool = false;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);

		if (controls.ACCEPT)
		{
			if (!isEnding)
			{
				isEnding = true;
				FlxG.sound.music.stop();
				FlxG.sound.play(Paths.music(endSoundName));
				FlxTween.globalManager.completeTweensOf(blackScreen);
				FlxTween.tween(blackScreen, {alpha: 1}, 2, {
					onComplete: function(retry:FlxTween)
					{
						MusicBeatState.resetState();
					}
				});
				retryTextConfirm();
				PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
			}
		}

		if (FlxG.sound.music.playing)
		{
			Conductor.songPosition = FlxG.sound.music.time;
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	function retryTextConfirm()
	{
		for (letter in 0...retryText.lettersArray.length)
		{
			FlxTween.cancelTweensOf(retryText.lettersArray[letter]);
			FlxTween.tween(retryText.lettersArray[letter], {x: retryText.lettersArray[letter].x + ((letter - 2) * 50), alpha: 0}, 2);
			FlxTween.tween(retryText.lettersArray[letter], {y: Std.int(FlxG.height / 2) - 115}, 2, {ease: FlxEase.quadOut});
		}
	}
}
