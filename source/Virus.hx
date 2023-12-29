package;

import flixel.sound.FlxSound;
import lime.app.Application;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.FlxG;

using StringTools;

class Virus extends FlxSprite
{
	var songPath:String = '';
	var flashSFX:FlxSound;

	var random:Bool = false;
	var removeTMR:FlxTimer;

	var transition:Bool = false;
	var transitionType:String = "";

	var toggleFullscreenFlash:Bool = true;

	public var switchTransitionPhase:Int = 0;

	public static var forRandomMessage:Array<String> = [
		'cheater',
		'ha',
		'no wonder they hate you',
		'passion towards you is stupid',
		'pathetic',
		'shes using you',
		'you deserve failure',
		'youll become a hated format',
		'your fans are childish',
		'your mods will be a humiliation',
		'your songs are stupid',
		'you should feel ashamed for liking this',
		'cheater+',
		'ha+',
		'no wonder they hate you+',
		'passion towards you is stupid+',
		'pathetic+',
		'shes using you+',
		'you deserve failure+',
		'youll become a hated format+',
		'your fans are childish+',
		'your mods will be a humiliation+',
		'your songs are stupid+',
		'you should feel ashamed for liking this+'
	];

	public function new(x:Float, y:Float, message:String = '', song:String = '', ?transition:Bool = false, ?random:Bool = false)
	{
		CoolUtil.precacheSound("flash");
		flashSFX = new FlxSound().loadEmbedded(Paths.sound('flash'));
		super(x, y);
		this.transition = transition;
		this.transitionType = message;

		removeTMR = new FlxTimer();

		if (TitleState.fullScreenToggle)
			toggleFullscreenFlash = false;
		if (PlayState.SONG.song == 'insanity-virus')
			toggleFullscreenFlash = true;

		switch (formatToFileFormat(song))
		{
			case 'insanity-virus':
				this.songPath = 'IV';
			case 'left-for-dead':
				this.songPath = 'SF';
			default:
				this.songPath = 'IV';
		}
		antialiasing = ClientPrefs.globalAntialiasing;
		if (!transition)
		{
			alpha = 0.0001;
		}
		else
		{
			frames = Paths.getSparrowAtlas('virus/' + songPath + '/' + message);
			animation.addByPrefix('body', 'transition', 24, false);
		}
	}

	public function virusFlash(message:String, randomMes:Bool)
	{
		loadGraphic(Paths.image('virus/' + songPath + '/' + formatToFileFormat(randomMes ? forRandomMessage[FlxG.random.int(0, 23)] : message)));
		if (toggleFullscreenFlash)
			lime.app.Application.current.window.fullscreen = true;
		flashSFX.play(true);
		alpha = 1;
		removeTMR.start(0.05, destroyImage);
	}

	function destroyImage(timer:FlxTimer):Void
	{
		flashSFX.stop();
		alpha = 0.0001;
		if (toggleFullscreenFlash)
			lime.app.Application.current.window.fullscreen = false;
	}

	public function updateTransitionPhase()
	{
		if (this.transition)
		{
			if (this.transitionType == 'transition-bodies_1')
			{
				switch (switchTransitionPhase)
				{
					case 1:
						animation.play('body');
					case 2:
						if (toggleFullscreenFlash)
							lime.app.Application.current.window.fullscreen = true;
						flashSFX.play(true);
					case 3:
						alpha = 0;
						flashSFX.stop();
						flashSFX.destroy();
						if (toggleFullscreenFlash)
							lime.app.Application.current.window.fullscreen = false;
					default:
				}
			}
			else
			{
				animation.play('body');
				new FlxTimer().start(FlxG.random.float(0.08, 0.2), function(flash:FlxTimer)
				{
					alpha = 0.0001;
					if (switchTransitionPhase != 2)
					{
						alpha = 1;
						if (toggleFullscreenFlash)
							lime.app.Application.current.window.fullscreen = true;
						flashSFX.play(true);
						new FlxTimer().start(0.075, function(removeAlpha:FlxTimer)
						{
							alpha = 0.0001;
							flashSFX.stop();
							if (toggleFullscreenFlash)
								lime.app.Application.current.window.fullscreen = false;
						});
					}
				}, 0);
			}
		}
	}

	public static function formatToFileFormat(name:String)
	{
		return name.toLowerCase().replace(' ', '-');
	}
}
