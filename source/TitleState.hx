package;

import openfl.display.ShaderParameter;
import openfl.display.ShaderData;
import openfl.display.GraphicsShader;
import FlxShader;
import openfl.display.Shader;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import flixel.sound.FlxSound;
import hx.files.*;
import flixel.*;
import flixel.ui.FlxButton;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxSpriteUtil;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import lime.ui.Window;
import flixel.math.FlxRandom;
#if desktop
import Discord.DiscordClient;
import sys.thread.Thread;
#end
import flixel.FlxG;
import flixel.math.FlxAngle;
import flixel.util.FlxPool;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import haxe.Json;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
#if desktop
import sys.FileSystem;
import sys.io.File;
#end
import options.GraphicsSettingsSubState;
// import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;
import lime.app.Application;
import lime.system.System;
import openfl.Assets;
import flixel.addons.ui.FlxUIInputText;

using StringTools;

typedef TitleData =
{
	titlex:Float,
	titley:Float,
	startx:Float,
	starty:Float,
	gfx:Float,
	gfy:Float,
	backgroundSprite:String,
	bpm:Int
}

class TitleState extends MusicBeatState
{
	var totalElaped:Float = 0;
	var ignoreThisFrame = true;

	public static var unlockedSongs:Array<String> = ["", "", "", "", "", "", "", "", "", ""];

	public static var availableSongs:Array<String> = [
		"disconsolate", "anamnesis", "emotional-restoration", "true-love", "traumatophobia", "insanity-virus", "treasured-memories", "static-torture",
		"fabula-amoris", "left-for-dead"
	];

	// Modded Variables
	var titleImage:FlxSprite;
	var titleFlickerState:Array<Int> = [0, 0]; // determines state of background flicker
	var staticEffect:FlxSprite; // static which displays on the television screen
	var randomImageString:String = "";
	var previousImageStorage:Null<String> = null;
	var moddedLogo:FlxSprite;

	public static var fullScreenToggle:Bool = false;

	var stopImages:Bool = false;

	var fireEffectGradient:FlxSprite;
	var testEmberEmitter:FlxTypedEmitter<FlxParticle>;

	var verticalParticle:FlxTypedEmitter<FlxParticle>;

	var titleFadeOn:FlxTween;

	var isFullScreen:Bool = false;
	var flashInterval:Float = 0;

	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];

	public static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	#if TITLE_SCREEN_EASTER_EGG
	var easterEggKeys:Array<String> = ['SHADOW', 'RIVER', 'SHUBS', 'BBPANZU'];
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	var easterEggKeysBuffer:String = '';
	#end

	var mustUpdate:Bool = false;

	var titleJSON:TitleData;

	public static var updateVersion:String = '';

	var testSaw:TraClaw;

	override public function create():Void
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		// Just to load a mod on start up if ya got one. For mods that change the menu music and bg
		WeekData.loadTheFirstEnabledMod();
	

		// Data for screen static seen on television
		staticEffect = new FlxSprite().loadGraphic(Paths.image('commonAssets/ScreenStatic'));
		staticEffect.scale.set((1 / 6), (1 / 6));
		staticEffect.updateHitbox();
		staticEffect.alpha = 0.25;
		staticEffect.angle = -15;
		staticEffect.antialiasing = ClientPrefs.globalAntialiasing;
		staticEffect.color = FlxColor.fromInt(0x7F808080);
		// staticEffect.blend = MULTIPLY;
		add(staticEffect);

		// Data for background
		titleImage = new FlxSprite(0, 0).loadGraphic(Paths.image('TitleScreen/background_' + titleFlickerState[1]));
		titleImage.scale.set((1 / 3), (1 / 3));
		titleImage.updateHitbox();
		titleImage.antialiasing = ClientPrefs.globalAntialiasing;
		add(titleImage);

		// sets the black screen for fade effect
		blackScreen = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		/*
			#if CHECK_FOR_UPDATES
			if (!closedState)
			{
				trace('checking for update');
				var http = new haxe.Http("https://raw.githubusercontent.com/ShadowMario/FNF-PsychEngine/main/gitVersion.txt");

				http.onData = function(data:String)
				{
					updateVersion = data.split('\n')[0].trim();
					var curVersion:String = MainMenuState.psychEngineVersion.trim();
					trace('version online: ' + updateVersion + ', your version: ' + curVersion);
					if (updateVersion != curVersion)
					{
						trace('versions arent matching!');
						mustUpdate = true;
					}
				}

				http.onError = function(error)
				{
					trace('error: $error');
				}

				http.request();
			}
			#end
		 */

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

		super.create();

		FlxG.save.bind('funkin', 'ninjamuffin99');

		ClientPrefs.loadPrefs();

		Highscore.load();

		if (!initialized && FlxG.save.data != null && FlxG.save.data.fullscreen)
		{
			FlxG.fullscreen = FlxG.save.data.fullscreen;
			// trace('LOADED FULLSCREEN SETTING!!');
		}

		if (FlxG.save.data.weekCompleted != null)
		{
			StoryMenuStateNew.actCompleted = FlxG.save.data.actCompleted;
		}

		FlxG.mouse.visible = false;

		#if desktop
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			Application.current.onExit.add(function(exitCode)
			{
				DiscordClient.shutdown();
			});
		}
		#end

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		titleText = new FlxSprite();

		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = ClientPrefs.globalAntialiasing;
		titleText.animation.play('idle');
		titleText.scale.set(0.75, 0.75);
		titleText.updateHitbox();
		titleText.x = 10;
		titleText.y = 650;

		if (FlxG.save.data.unlockedImages != null)
			TitleImages.unlockedImages = FlxG.save.data.unlockedImages;

		// TitleImages.RESETTHISSTUPIDTHING();
		trace(TitleImages.unlockedImages);

		// This displays the periodic image on the title screen. Its complicated.
		new FlxTimer().start(5, function(displayRandomImage:FlxTimer)
		{
			if (!stopImages)
			{
				randomImageString = TitleImages.unlockedImages[(FlxG.random.int(0, TitleImages.unlockedImages.length - 1))];
				TitleImages.unlockedImages.remove(randomImageString);
				if (previousImageStorage != null)
				{
					TitleImages.unlockedImages.push(previousImageStorage);
				}

				var periodicImage:FlxSprite = new FlxSprite(830,
					0).loadGraphic(Paths.image('TitleScreen/TitleImages/' + randomImageString)); // creates a new image based on the randomly chosen number
				periodicImage.scale.set((1 / 3), (1 / 3));
				periodicImage.updateHitbox();
				periodicImage.antialiasing = ClientPrefs.globalAntialiasing;
				periodicImage.alpha = 0;
				add(periodicImage);
				FlxG.sound.play(Paths.sound('menuTick'), 0.75);
				FlxTween.tween(periodicImage, {alpha: 1}, 0.1, { // fades image on to avoid jarring transition
					onComplete: function(fadeoutImage:FlxTween)
					{
						FlxTween.tween(periodicImage, {alpha: 0}, 1, { // fades image out
							onComplete: function(removeImage:FlxTween)
							{
								periodicImage.destroy(); // removes the image after faded out to improve performance
								previousImageStorage = randomImageString;
							}
						});
					}
				});
			}
		}, 0);

		// addds logo to title
		moddedLogo = new FlxSprite().loadGraphic(Paths.image("FallenLegendLogo"));
		moddedLogo.scale.set((1 / 6), (1 / 6));
		moddedLogo.updateHitbox();
		moddedLogo.x = -100;
		moddedLogo.antialiasing = ClientPrefs.globalAntialiasing;
		add(moddedLogo);
		add(titleText);

		var titleRain:FlxTypedEmitter<FlxParticle> = new FlxTypedEmitter<FlxParticle>().loadParticles(Paths.image('commonAssets/rainAsset'), 500);
		titleRain.width = FlxG.width + 100;
		titleRain.alpha.set(0.005, 0.01, 0, 0);
		titleRain.angle.set(10);
		titleRain.launchAngle.set(100);
		titleRain.scale.set(0.5, 0.5, 0.75, 0.75);
		titleRain.lifespan.set(0.25, 2);
		titleRain.speed.set(2000);
		titleRain.blend = ADD;
		titleRain.angularAcceleration.set(5, 10);
		titleRain.start(false, 0.0025);
		add(titleRain);
		/*verticalParticle = new FlxTypedEmitter<FlxParticle>(0, FlxG.height / 2).loadParticles(Paths.image('commonAssets/circularPart'));
			verticalParticle.width = FlxG.width;
			verticalParticle.lifespan.set(3);
			verticalParticle.alpha.set(0.5);
			verticalParticle.scale.set((1/3), (1/3), (1/3), (1/3), 0.01, 0.01);
			verticalParticle.launchAngle.set(-90);
			verticalParticle.speed.set(100);
			verticalParticle.start(false, 0.1);
			add(verticalParticle);

			testEmberEmitter = new FlxTypedEmitter<FlxParticle>(0, FlxG.height).loadParticles(Paths.image('commonAssets/emberPart'));
				testEmberEmitter.width = FlxG.width;
				testEmberEmitter.lifespan.set(1, 4);
				testEmberEmitter.alpha.set(1, 1, 0, 0);
				testEmberEmitter.scale.set((1/3));
				testEmberEmitter.launchAngle.set(-80, -100);
				testEmberEmitter.speed.set(200, 300);
				testEmberEmitter.acceleration.set(0, 0, 0, 100);
				testEmberEmitter.start(false, 0.75);
				add(testEmberEmitter);

				fireEffectGradient = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.fromInt(0x00FF0000), FlxColor.fromInt(0xFFFF6A00)]);
				fireEffectGradient.alpha = 0.2;
				add(fireEffectGradient); */

		var fullTXT:FlxText = new FlxText(0, 0, 0, "	Press F for fullscreen");
		fullTXT.setFormat(Paths.font("vcr.ttf"), 10, FlxColor.WHITE, LEFT);
		fullTXT.scrollFactor.set(1, 1);
		add(fullTXT);

		add(blackScreen);

		// Continuously moves the static image around at random points to return a completely unique static effect
		new FlxTimer().start(0.01, function(staticMovement:FlxTimer)
		{
			staticEffect.x = new FlxRandom().float(-400.0, 400.0);
			staticEffect.y = new FlxRandom().float(-200.0, 200.0);
		}, 0);

		trace(FlxG.camera.zoom);
		lime.app.Application.current.window.onClose.add(saveCurrentImages);
		// testSaw = new TraClaw(200, 100, 'saw distraction');
		// add(testSaw);
	}

	function saveCurrentImages()
	{
		if (previousImageStorage != null && !TitleImages.unlockedImages.contains(previousImageStorage))
			TitleImages.unlockedImages.push(previousImageStorage);
		FlxG.save.data.unlockedImages = TitleImages.unlockedImages;
		previousImageStorage = null;
		FlxG.save.data.exitState = StoryMenuStateNew.exitState;
		FlxG.save.flush();
		trace("title images saved");
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			if (FlxG.sound.music == null)
			{
				FlxG.sound.playMusic(Paths.music('TIORemix'), 0);
				FlxG.sound.music.fadeIn(5, 0, 1);
			}
		}

		// Conductor.changeBPM(titleJSON.bpm);
		persistentUpdate = true;

		(initialized ? skipIntro() : initialized = true);
	}

	// Complex array mechanics to determine when the menu should change to light on or off
	function titleBackgroundFlicker():Void
	{
		titleFlickerState[0] = 0;
		new FlxTimer().start(new FlxRandom().float(0.2, 2), function(changeState:FlxTimer)
		{
			titleFlickerState = [0, 1];
			new FlxTimer().start(0.2, function(returnState:FlxTimer)
			{
				titleFlickerState[0] = titleFlickerState[1];
				titleFlickerState[1] = 0;
				returnState.destroy();
			});
			changeState.destroy();
		});
	}

	var transitioning:Bool = false;

	private static var playJingle:Bool = false;

	override function update(elapsed:Float)
	{
		if (ignoreThisFrame)
		{
			ignoreThisFrame = false;
			super.update(elapsed);
			return;
		}
		totalElaped += elapsed;
		titleBackgroundFlicker();

		// testShader.data.iResolution = [FlxG.camera.width, FlxG.camera.height];

		// Changes the background image depending on the array values
		titleImage.loadGraphic(Paths.image('TitleScreen/background_' + titleFlickerState[1]));

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen ? FlxG.fullscreen = false : FlxG.fullscreen = true;
			fullScreenToggle = !fullScreenToggle;
		}
	

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}

		// EASTER EGG

		if (initialized && !transitioning && skippedIntro)
		{
			if (pressedEnter)
			{
				stopImages = true;
				// lime.app.Application.current.window.alert('ERROR_\nThe current process has been temporarily terminated due to\nthe immediate suspected detection of an unknown virus.\nPress OK for further details.', 'VIRUS DETECTED');
				// lime.app.Application.current.window.alert('Suspected virus has been detected within Main.cpp\nSuspected virus type: ERROR_\nDanger level: ERROR_\nNo immediate damage to device or suspicious activity has been detected.\nPress OK to resume application', 'VIRUS DETECTED');
				if (titleText != null)
					titleText.animation.play('press');

				FlxG.camera.flash(FlxColor.WHITE, 1);
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.5);

				transitioning = true;
				// FlxG.sound.music.stop();

				if (mustUpdate)
				{
					MusicBeatState.switchState(new OutdatedState());
				}
				else
				{
					titleFadeOn.cancel();
					blackScreen.alpha = 0;
					FlxTween.tween(blackScreen, {alpha: 1}, 3, {
						onComplete: function(fadeOn:FlxTween)
						{
							if (previousImageStorage != null && !TitleImages.unlockedImages.contains(previousImageStorage))
								TitleImages.unlockedImages.push(previousImageStorage);
							FlxG.save.data.unlockedImages = TitleImages.unlockedImages;
							previousImageStorage = null;
							MusicBeatState.switchState(new StoryMenuStateNew());
						}
					});
				}
				closedState = true;
				// Because the title images did weirdness and just want to make sure that they are actually saved
			}
		}

		if (initialized && pressedEnter && !skippedIntro)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	private var sickBeats:Int = 0; // Basically curBeat but won't be skipped if you hold the tab or resize the screen

	public static var closedState:Bool = false;

	override function beatHit()
	{
		super.beatHit();
		if (!closedState)
		{
			skipIntro();
		}
	}

	var skippedIntro:Bool = false;
	var increaseVolume:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			titleFadeOn = FlxTween.tween(blackScreen, {alpha: 0}, 5);
			skippedIntro = true;
		}
	}
}
