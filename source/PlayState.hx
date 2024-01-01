package;

import openfl.display.TriangleCulling;
import openfl.filters.ShaderFilter;
import flixel.system.FlxBGSprite;
import flixel.sound.FlxSound;
import flixel.math.FlxRandom;
import flixel.util.FlxSpriteUtil;
import openfl.display.GradientType;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.effects.particles.FlxParticle;
import flixel.effects.particles.FlxEmitter.FlxTypedEmitter;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.math.FlxAngle;
import flixel.system.FlxSound;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import flixel.util.FlxGradient;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.util.FlxSave;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import MergeJson;
#if sys
import sys.FileSystem;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	var stageDimensions:Array<Float> = [];
	var anamnesisBlackScreen:FlxSprite;
	var secondaryBlackScreen:FlxSprite;
	var memoryMessage:CustomAlphabets;
	var playerBarGroup:FlxTypedGroup<FlxSprite>;
	var opponentBarGroup:FlxTypedGroup<FlxSprite>;
	var primaryBarArray:Array<Int> = [];
	var sideBarToggle:Bool = false;
	var verticalToggle:Bool = false;
	var heartToggle:Bool = false;
	var heartGradient:FlxSprite;
	var warningBack:FlxSprite;
	var traumaHealthDrainBool:Bool = false;
	var heavyRainEffect:FlxTypedEmitter<FlxParticle>;
	var sawClaw:TraClaw;
	var revertTimer:FlxTimer;
	var checkRevert:Bool = false;
	var colourPulseTrigger:Bool = false;
	var pulseSprite:FlxSprite;
	var vignette:BGSprite;

	public var overlayBlackScreen:FlxSprite;

	var blackFadeOut:Float = 0;
	var cameraZoomOffset:Float = 0;
	var cityBG:BGSprite;
	var fireGradient:FlxSprite;
	var emberEmitter:FlxTypedEmitter<FlxParticle>;
	var AnamnesisEffectToggle:Bool = false;
	var verticalParticleUP:FlxTypedEmitter<FlxParticle>;
	var verticalParticleDOWN:FlxTypedEmitter<FlxParticle>;

	public var ERDrop:Bool = false;

	var storySophieGhost:FlxSprite;
	var drainClaw:FlxSprite;
	var staticEffect:FlxSprite;
	var staticFlickerTimer:FlxTimer; // for optimisation and to avoid conflictions
	var gameplayClawGroup:FlxTypedGroup<FlxSprite>;
	var doubleLayerChar:Bool = false;
	var hangingFlash:FlxSprite;
	var upperBackAnimated:BGSprite;
	var lowerBackAnimated:BGSprite;

	var commandPrompt:CommandPrompt;
	var glitchShader:OverlayShader;
	var cameraEffectShader:CameraEffectShader;
	var shaderFilter:ShaderFilter;
	var IVINtroText:CustomAlphabets;
	var bodyTransition:Virus;
	var knifeTransition:Virus;
	var flashVirus:Virus;

	public var cameraEffectState:Float = 0;
	public var cameraEffectZoom:Float = 1.3;
	public var zoomRate:Float = 1;

	var IVVirusTransitionAnim:FlxSprite;
	var IVScratchAnim:FlxSprite;
	var scratchToggle:Bool = false;

	var FAUpperBlackScreen:FlxSprite;
	var FALowerBlackScreen:FlxSprite;
	var FAmissCount:Array<Int> = [0, 0];
	var FAControlLeftText:FlxText;
	var FAControlRightText:FlxText;
	var blakeHeart:FAHeart;
	var sophieHeart:FAHeart;

	var ignoreThisFrame = true;

	public static var stageSwitchBackgroundGroup:FlxTypedGroup<BGSprite>;
	public static var stageSwitchOverlayGroup:FlxTypedGroup<BGSprite>;

	var determineWhichZoom:Bool = false;

	var duplicationGroup:FlxGroup;

	var totalElapsed:Float = 0; // for use of elapsed variable outside of update function
	var externalElapsed:Float;

	// Vertical sound bar system
	var _upperBound:FlxRect;
	var _lowerBound:FlxRect;
	var upperPlayerGroup:FlxSpriteGroup;
	var lowerPlayerGroup:FlxSpriteGroup;
	var upperOppGroup:FlxSpriteGroup;
	var lowerOppGroup:FlxSpriteGroup;
	var primaryVertBarArray:Array<Int> = [];
	var gradientOverlay:FlxSprite;
	var toggleDouble:Bool = false;

	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var ratingStuff:Array<Dynamic> = [
		['You Suck!', 0.2], // From 0% to 19%
		['Shit', 0.4], // From 20% to 39%
		['Bad', 0.5], // From 40% to 49%
		['Bruh', 0.6], // From 50% to 59%
		['Meh', 0.69], // From 60% to 68%
		['Nice', 0.7], // 69%
		['Good', 0.8], // From 70% to 79%
		['Great', 0.9], // From 80% to 89%
		['Sick!', 1], // From 90% to 99%
		['Perfect!!', 1] // The value on this one isn't used actually, since Perfect is always "1"
	];

	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();

	// event variables
	private var isCameraOnForcedPos:Bool = false;

	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;

	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;

	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;

	public var vocals:FlxSound;

	public var dad:Character = null;
	public var layeredDad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Boyfriend = null;
	public var layeredBF:Character = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];

	private var strumLine:FlxSprite;

	// Handles the new epic mega sexy cam code that i've done
	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;

	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var doubleStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public var camZooming:Bool = false;

	private var curSong:String = "";

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	private var healthBarBG:AttachedSprite;

	public var healthBar:FlxBar;

	var songPercent:Float = 0;

	private var timeBarBG:AttachedSprite;

	public var timeBar:FlxBar;

	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;

	private var generatedMusic:Bool = false;

	public var endingSong:Bool = false;
	public var startingSong:Bool = false;

	private var updateTime:Bool = true;

	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	// Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = true;
	public var practiceMode:Bool = false;

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	public var camBlackFade:FlxCamera;
	public var IVStaticTranCam:FlxCamera;
	public var cameraSpeed:Float = 1;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var halloweenBG:BGSprite;
	var halloweenWhite:BGSprite;

	var phillyCityLights:FlxTypedGroup<BGSprite>;
	var phillyTrain:BGSprite;
	var blammedLightsBlack:ModchartSprite;
	var blammedLightsBlackTween:FlxTween;
	var phillyCityLightsEvent:FlxTypedGroup<BGSprite>;
	var phillyCityLightsEventTween:FlxTween;
	var trainSound:FlxSound;

	var limoKillingState:Int = 0;
	var limo:BGSprite;
	var limoMetalPole:BGSprite;
	var limoLight:BGSprite;
	var limoCorpse:BGSprite;
	var limoCorpseTwo:BGSprite;
	var bgLimo:BGSprite;
	var grpLimoParticles:FlxTypedGroup<BGSprite>;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:BGSprite;

	var upperBoppers:BGSprite;
	var bottomBoppers:BGSprite;
	var santa:BGSprite;
	var heyTimer:Float;

	var bgGirls:BackgroundGirls;
	var wiggleShit:WiggleEffect = new WiggleEffect();
	var bgGhouls:BGSprite;

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var scoreTxt:FlxText;

	var timeTxt:FlxText;
	var scoreTxtTween:FlxTween;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;

	var songLength:Float = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	// Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;

	public var luaArray:Array<FunkinLua> = [];

	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;

	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;

	// Less laggy controls
	public var keysArray:Array<Dynamic>;

	private var doubleKeysArray:Array<Dynamic>;

	override public function create()
	{
		Paths.clearStoredMemory();
		STErrors.resetErrors();

		// for lua
		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));
		PauseSubState.songName = null; // Reset to default

		keysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))
		];

		doubleKeysArray = [
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('right_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('right_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('right_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('right_right')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('left_left')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('left_down')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('left_up')),
			ClientPrefs.copyKey(ClientPrefs.keyBinds.get('left_right'))
		];

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
		healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
		practiceMode = ClientPrefs.getGameplaySetting('practice', false);
		// cpuControlled = ClientPrefs.getGameplaySetting('botplay', true);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camOther = new FlxCamera();
		camBlackFade = new FlxCamera();
		IVStaticTranCam = new FlxCamera();
		camHUD.bgColor = FlxColor.TRANSPARENT;
		camOther.bgColor = FlxColor.TRANSPARENT;
		IVStaticTranCam.bgColor = FlxColor.TRANSPARENT;
		// camOther.bgColor.alpha = 1;
		camBlackFade.color = FlxColor.BLACK;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camBlackFade);
		FlxG.cameras.add(camOther);
		FlxG.cameras.add(IVStaticTranCam);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();
		playerBarGroup = new FlxTypedGroup<FlxSprite>();
		opponentBarGroup = new FlxTypedGroup<FlxSprite>();

		duplicationGroup = new FlxGroup();

		// Setting up upper and lower bounds
		_upperBound = new FlxRect(0, 0, FlxG.width, Std.int(FlxG.height / 2));
		_lowerBound = new FlxRect(0, FlxG.height / 2, FlxG.width, Std.int(FlxG.height / 2));

		stageSwitchBackgroundGroup = new FlxTypedGroup<BGSprite>();
		add(stageSwitchBackgroundGroup);

		FlxCamera.defaultCameras = [camGame];
		CustomFadeTransition.nextCamera = camOther;
		// FlxG.cameras.setDefaultDrawTarget(camGame, true);

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		trace(SONG.song);

		if (SONG.song == 'insanity-virus')
		{
			FlxG.fullscreen = false;
			lime.app.Application.current.window.fullscreen = false;
		}

		#if desktop
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: " + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);

		curStage = PlayState.SONG.stage;
		// trace('stage is: ' + curStage);
		if (PlayState.SONG.stage == null || PlayState.SONG.stage.length < 1)
		{
			switch (songName)
			{
				case 'disconsolate' | 'anamnesis' | 'emotional-restoration' | 'true-love' | 'traumatophobia' | 'insanity-virus':
					curStage = 'alley';
				case 'treasured-memories':
					doubleLayerChar = true;
					curStage = 'peace';
				default:
					curStage = 'stage';
			}
		}

		var stageData:StageFile = StageData.getStageFile(curStage);
		if (stageData == null)
		{ // Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,

				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				hide_girlfriend: false,

				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if (stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if (boyfriendCameraOffset == null) // Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if (opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		girlfriendCameraOffset = stageData.camera_girlfriend;
		if (girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		switch (curStage)
		{
			case 'alley':
				if (SONG.song == 'traumatophobia')
				{
					cityBG = new BGSprite('BuildingFire', -1000, -1200, 1, 1, ['fire'], true);
					cityBG.updateHitbox();
					PlayState.stageSwitchBackgroundGroup.add(cityBG);
				}

				var citySky:BGSprite = new BGSprite('city', -500, -150, 0.5, 0.5);
				citySky.scale.set(0.5, 0.5);
				citySky.updateHitbox();
				stageSwitchBackgroundGroup.add(citySky);
				var alleyBG:BGSprite = new BGSprite('alleyBG', -500, -200, 1, 1);
				alleyBG.scale.set(0.5, 0.5);
				alleyBG.updateHitbox();
				stageSwitchBackgroundGroup.add(alleyBG);
				stageDimensions = [-500, -150, alleyBG.width, alleyBG.height];
			case 'apartment':
				var apartBG:BGSprite = new BGSprite('apartment', -28, -198, 1, 1);
				apartBG.scale.set(0.5, 0.5);
				apartBG.updateHitbox();
				add(apartBG);
				stageDimensions = [-28, -198, apartBG.width, apartBG.height];
			case 'myworld':
				var skyline:BGSprite = new BGSprite('MYWORLD/skyBack', -500, -200, 1, 1);
				skyline.scale.set(0.5, 0.5);
				skyline.updateHitbox();
				add(skyline);
				var screenBack:BGSprite = new BGSprite('MYWORLD/screenBack', -500, -200, 1, 1);
				screenBack.scale.set(0.5, 0.5);
				screenBack.updateHitbox();
				add(screenBack);
				for (i in 0...4)
				{
					var virusScreen:BGSprite = new BGSprite('virus/SF/' + Virus.formatToFileFormat(Virus.forRandomMessage[FlxG.random.int(0, 12)]), 247, 424,
						1, 1);
					virusScreen.scale.set(645 / 1280, 372 / 720);
					virusScreen.updateHitbox();
					virusScreen.alpha = 0.0001;
					switch (i)
					{
						case 0:
							virusScreen.setPosition(247, 424);
						case 1:
							virusScreen.setPosition(-959.5, 424);
						case 2:
							virusScreen.setPosition(1558, 419.5);
						case 3:
							virusScreen.setPosition(1558, -159.5);
					}
					add(virusScreen);
					new FlxTimer().start(FlxG.random.float(0.5, 10), function(flashAndUpdate:FlxTimer)
					{
						virusScreen.alpha = 1;
						new FlxTimer().start(0.05, function(removeFlash:FlxTimer)
						{
							virusScreen.alpha = 0.0001;
							virusScreen.loadGraphic(Paths.image('virus/SF/' + Virus.formatToFileFormat(Virus.forRandomMessage[FlxG.random.int(0, 12)])));
						});
					}, 0);
				}
				var buildings:BGSprite = new BGSprite('MYWORLD/street', -500, -200, 1, 1);
				buildings.scale.set(0.5, 0.5);
				buildings.updateHitbox();
				add(buildings);
				var signPost:BGSprite = new BGSprite('MYWORLD/signPost', -650, 0, 1.5, 1.5);
				signPost.scale.set(0.5, 0.5);
				signPost.updateHitbox();
				add(signPost);
				var postVirus:BGSprite = new BGSprite('virus/SF/' + Virus.formatToFileFormat(Virus.forRandomMessage[FlxG.random.int(0, 12)]), 1190.5, 237.6,
					1.5, 1.5);
				postVirus.scale.set(579 / 1280, 325.6875 / 720);
				postVirus.updateHitbox();
				postVirus.alpha = 0.0001;
				add(postVirus);
				new FlxTimer().start(FlxG.random.float(0.5, 10), function(flashAndUpdate:FlxTimer)
				{
					postVirus.alpha = 1;
					new FlxTimer().start(0.05, function(removeFlash:FlxTimer)
					{
						postVirus.alpha = 0.0001;
						postVirus.loadGraphic(Paths.image('virus/SF/' + Virus.formatToFileFormat(Virus.forRandomMessage[FlxG.random.int(0, 12)])));
					});
				}, 0);
			case 'peace':
				var landScape:BGSprite = new BGSprite('peace/windowBackDrop', -500, -200, 0.7, 0.7);
				landScape.scale.set(0.5, 0.5);
				landScape.updateHitbox();
				add(landScape);
				var backStage:BGSprite = new BGSprite('peace/homeBack', -500, -200, 1, 1);
				backStage.scale.set(0.5, 0.5);
				backStage.updateHitbox();
				add(backStage);
			case 'splitStory':
				var upperBack:BGSprite = new BGSprite('fabulaAmoris/upperStatic', 0, 0, 1, 1);
				upperBack.scale.set(1280 / 5320, 360 / 1500);
				upperBack.updateHitbox();
				add(upperBack);

				upperBackAnimated = new BGSprite('fabulaAmoris/upperAnimated', 0, 0, 1, 1, ["upper"], true);
				upperBackAnimated.scale.set(1280 / 2660, 360 / 750);
				upperBackAnimated.updateHitbox();
				upperBackAnimated.alpha = 0.0001;
				add(upperBackAnimated);

				FAControlLeftText = new FlxText(176.5, ClientPrefs.downScroll ? 540 : 180, FlxG.width, 'A     S     D     F');
				FAControlLeftText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				FAControlLeftText.cameras = [camHUD];
				FAControlLeftText.alpha = 0.0001;
				add(FAControlLeftText);

				FAControlRightText = new FlxText(741.5, ClientPrefs.downScroll ? 540 : 180, FlxG.width, 'H     J     K     L');
				FAControlRightText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
				FAControlRightText.cameras = [camHUD];
				FAControlRightText.alpha = 0.0001;
				add(FAControlRightText);

				blakeHeart = new FAHeart(25, 40, 0);
				blakeHeart.alpha = 0.0001;
				blakeHeart.scale.set(1 / 5, 1 / 5);
				blakeHeart.updateHitbox();
				blakeHeart.cameras = [camHUD];
				add(blakeHeart);

				sophieHeart = new FAHeart(1154, 40, 1);
				sophieHeart.alpha = 0.0001;
				sophieHeart.scale.set(1 / 5, 1 / 5);
				sophieHeart.updateHitbox();
				sophieHeart.cameras = [camHUD];
				add(sophieHeart);
		}

		var preLoadClaw:TraClaw = new TraClaw(2000, 0, 'grab Note', true);
		add(preLoadClaw);
		preLoadClaw.preExecuteClaw();

		anamnesisBlackScreen = new FlxSprite(-500, -200).makeGraphic(2660, 1500, FlxColor.BLACK);
		anamnesisBlackScreen.scrollFactor.set(1, 1);
		anamnesisBlackScreen.alpha = 0.0001;
		add(anamnesisBlackScreen);

		secondaryBlackScreen = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		secondaryBlackScreen.alpha = 0.0001;
		secondaryBlackScreen.camera = camHUD;
		add(secondaryBlackScreen);

		if (curStage == 'apartment' || curStage == 'myworld' || SONG.song == 'insanity-virus')
		{
			if (curStage == 'apartment')
			{
				var hang:BGSprite = new BGSprite('hangingBlake', -28, -198, 1, 1);
				add(hang);
			}

			staticEffect = new FlxSprite().loadGraphic(Paths.image('commonAssets/ScreenStatic'));
			staticEffect.antialiasing = ClientPrefs.globalAntialiasing;
			staticEffect.scale.set((1 / 3), (1 / 3));
			staticEffect.updateHitbox();
			staticEffect.alpha = 0.0001;
			staticEffect.cameras = [camHUD];
			add(staticEffect);

			new FlxTimer().start(0.01, function(staticMovement:FlxTimer)
			{
				staticEffect.x = new FlxRandom().float(-1280, 0);
				staticEffect.y = new FlxRandom().float(-360, 0);
			}, 0);
		}

		storySophieGhost = new FlxSprite(70, 180);
		storySophieGhost.frames = Paths.getSparrowAtlas('storySophie');
		storySophieGhost.animation.addByPrefix('forwardFacing', 'Forward', 24, true);
		storySophieGhost.animation.addByPrefix('headDown', 'Head_Down', 24, true);
		storySophieGhost.antialiasing = ClientPrefs.globalAntialiasing;
		storySophieGhost.scale.set(1.5, 1.5);
		storySophieGhost.updateHitbox();
		if (SONG.song == 'traumatophobia' || SONG.song == 'insanity-virus')
			storySophieGhost.animation.play('headDown');
		else
			storySophieGhost.animation.play('forwardFacing');
		add(storySophieGhost);
		if (SONG.song == 'emotional-restoration'
			|| SONG.song == 'true-love'
			|| SONG.song == 'traumatophobia'
			|| SONG.song == 'insanity-virus')
			storySophieGhost.alpha = 0.25;
		else
			storySophieGhost.alpha = 0;

		if (isPixelStage)
		{
			introSoundsSuffix = '-pixel';
		}

		add(gfGroup); // Needed for blammed lights

		// Shitty layering but whatev it works LOL
		if (curStage == 'limo')
			add(limo);

		add(dadGroup);

		if (curStage == 'splitStory')
		{
			var lowerBack:BGSprite = new BGSprite('fabulaAmoris/LowerStatic', 0, 360, 1, 1);
			lowerBack.scale.set(1280 / 5320, 360 / 1500);
			lowerBack.updateHitbox();
			add(lowerBack);

			lowerBackAnimated = new BGSprite('fabulaAmoris/lowerAnimated', 0, 360, 1, 1, ["lower"], true);
			lowerBackAnimated.scale.set(1280 / 2660, 360 / 750);
			lowerBackAnimated.updateHitbox();
			lowerBackAnimated.alpha = 0.0001;
			add(lowerBackAnimated);
		}

		add(boyfriendGroup);
		duplicationGroup.add(dadGroup);
		duplicationGroup.add(boyfriendGroup);

		if (curStage == 'splitStory')
		{
			var split:BGSprite = new BGSprite('fabulaAmoris/SplitGrad', 0, 0, 1, 1);
			split.scale.set(0.5, 0.5);
			split.updateHitbox();
			add(split);

			FAUpperBlackScreen = new FlxSprite().makeGraphic(1280, 360, FlxColor.BLACK);
			add(FAUpperBlackScreen);
			FALowerBlackScreen = new FlxSprite(0, 360).makeGraphic(1280, 360, FlxColor.BLACK);
			add(FALowerBlackScreen);
		}

		stageSwitchOverlayGroup = new FlxTypedGroup<BGSprite>();
		add(stageSwitchOverlayGroup);

		if (curStage == 'spooky')
		{
			add(halloweenWhite);
		}

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		if (curStage == 'philly')
		{
			phillyCityLightsEvent = new FlxTypedGroup<BGSprite>();
			for (i in 0...5)
			{
				var light:BGSprite = new BGSprite('philly/win' + i, -10, 0, 0.3, 0.3);
				light.visible = false;
				light.setGraphicSize(Std.int(light.width * 0.85));
				light.updateHitbox();
				phillyCityLightsEvent.add(light);
			}
		}

		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if (Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if (FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if (file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if (FileSystem.exists(Paths.modFolders(luaFile)))
		{
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		}
		else
		{
			luaFile = Paths.getPreloadPath(luaFile);
			if (FileSystem.exists(luaFile))
			{
				doPush = true;
			}
		}

		if (doPush)
			luaArray.push(new FunkinLua(luaFile));
		#end

		if (!modchartSprites.exists('blammedLightsBlack'))
		{ // Creates blammed light black fade in case you didn't make your own
			blammedLightsBlack = new ModchartSprite(FlxG.width * -0.5, FlxG.height * -0.5);
			blammedLightsBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
			var position:Int = members.indexOf(gfGroup);
			if (members.indexOf(boyfriendGroup) < position)
			{
				position = members.indexOf(boyfriendGroup);
			}
			else if (members.indexOf(dadGroup) < position)
			{
				position = members.indexOf(dadGroup);
			}
			insert(position, blammedLightsBlack);

			blammedLightsBlack.wasAdded = true;
			modchartSprites.set('blammedLightsBlack', blammedLightsBlack);
		}
		if (curStage == 'philly')
			insert(members.indexOf(blammedLightsBlack) + 1, phillyCityLightsEvent);
		blammedLightsBlack = modchartSprites.get('blammedLightsBlack');
		blammedLightsBlack.alpha = 0.0;

		var gfVersion:String = SONG.gfVersion;
		if (gfVersion == null || gfVersion.length < 1)
		{
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				default:
					gfVersion = 'gf';
			}
			SONG.gfVersion = gfVersion; // Fix for the Chart Editor
		}

		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);
		}

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		startCharacterLua(dad.curCharacter);

		boyfriend = new Boyfriend(0, 0, SONG.player1);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterLua(boyfriend.curCharacter);

		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if (gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if (dad.curCharacter.startsWith('gf'))
		{
			dad.setPosition(GF_X, GF_Y);
			if (gf != null)
				gf.visible = false;
		}

		if (SONG.song == 'insanity-virus')
		{
			gf.animation.play('scared', true);
			gf.specialAnim = true;
		}

		switch (curStage)
		{
			case 'limo':
				resetFastCar();
				insert(members.indexOf(gfGroup) - 1, fastCar);

			case 'schoolEvil':
				var evilTrail = new FlxTrail(dad, null, 4, 24, 0.3, 0.069); // nice
				insert(members.indexOf(dadGroup) - 1, evilTrail);
			case 'myworld':
				gf.animation.play('scared', true);
				gf.specialAnim = true;
			case 'peace':
				var table:BGSprite = new BGSprite('peace/table', -500, -200, 1, 1);
				table.scale.set(0.5, 0.5);
				table.updateHitbox();
				add(table);

				layeredDad = new Character(DAD_X, DAD_Y, SONG.player2, false, true);
				startCharacterPos(layeredDad, true);
				add(layeredDad);
				startCharacterLua(dad.curCharacter);

				layeredBF = new Boyfriend(BF_X, BF_Y, SONG.player1, true);
				startCharacterPos(layeredBF);
				add(layeredBF);
				startCharacterLua(boyfriend.curCharacter);
		}

		var file:String = Paths.json(songName + '/dialogue'); // Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file))
		{
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); // Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file))
		{
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000;

		// Setting up bar groups and bar sprites
		upperPlayerGroup = new FlxSpriteGroup();
		lowerPlayerGroup = new FlxSpriteGroup();
		upperPlayerGroup.clipRect = _upperBound;
		lowerPlayerGroup.clipRect = _lowerBound;
		upperPlayerGroup.cameras = [camHUD];
		lowerPlayerGroup.cameras = [camHUD];

		upperOppGroup = new FlxSpriteGroup();
		lowerOppGroup = new FlxSpriteGroup();
		upperOppGroup.clipRect = _upperBound;
		lowerOppGroup.clipRect = _lowerBound;
		upperOppGroup.cameras = [camHUD];
		lowerOppGroup.cameras = [camHUD];

		if (SONG.song == 'traumatophobia')
		{
			var foreGroundBuilding:BGSprite = new BGSprite('foreGroundBuilding', -1000, -1200, 1, 1);
			foreGroundBuilding.scale.set(0.5, 0.5);
			foreGroundBuilding.updateHitbox();
			foreGroundBuilding.alpha = 0;
			stageSwitchOverlayGroup.add(foreGroundBuilding);
			var fireShading:BGSprite = new BGSprite('foreGroundShading', -1000, -1200, 1, 1);
			fireShading.scale.set(0.5, 0.5);
			fireShading.updateHitbox();
			fireShading.blend = SCREEN;
			fireShading.alpha = 0.0001;
			stageSwitchOverlayGroup.add(fireShading);

			emberEmitter = new FlxTypedEmitter<FlxParticle>(0, FlxG.height).loadParticles(Paths.image('commonAssets/emberPart'));
			emberEmitter.width = FlxG.width;
			emberEmitter.lifespan.set(1, 4);
			emberEmitter.alpha.set(0);
			emberEmitter.scale.set((1 / 3));
			emberEmitter.launchAngle.set(-80, -100);
			emberEmitter.speed.set(200, 300);
			emberEmitter.acceleration.set(0, 0, 0, 100);
			emberEmitter.start(false, 0.75);
			emberEmitter.cameras = [camHUD];
			add(emberEmitter);
			fireGradient = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.fromInt(0x00FF0000), FlxColor.fromInt(0xFFFF6A00)]);
			fireGradient.alpha = 0.0001;
			fireGradient.cameras = [camHUD];
			add(fireGradient);
		}

		if (SONG.song == 'emotional-restoration')
		{
			verticalParticleUP = new FlxTypedEmitter<FlxParticle>(0, FlxG.height / 2).loadParticles(Paths.image('commonAssets/circularPart'));
			verticalParticleUP.width = FlxG.width;
			verticalParticleUP.lifespan.set(3);
			verticalParticleUP.alpha.set(0);
			verticalParticleUP.scale.set((1 / 3), (1 / 3), (1 / 3), (1 / 3), 0.01, 0.01);
			verticalParticleUP.launchAngle.set(-90);
			verticalParticleUP.speed.set(100);
			verticalParticleUP.start(false, 0.1);
			verticalParticleUP.cameras = [camHUD];
			add(verticalParticleUP);

			verticalParticleDOWN = new FlxTypedEmitter<FlxParticle>(0, FlxG.height / 2).loadParticles(Paths.image('commonAssets/circularPart'));
			verticalParticleDOWN.width = FlxG.width;
			verticalParticleDOWN.lifespan.set(3);
			verticalParticleDOWN.alpha.set(0);
			verticalParticleDOWN.scale.set((1 / 3), (1 / 3), (1 / 3), (1 / 3), 0.01, 0.01);
			verticalParticleDOWN.launchAngle.set(90);
			verticalParticleDOWN.speed.set(100);
			verticalParticleDOWN.start(false, 0.1);
			verticalParticleDOWN.cameras = [camHUD];
			add(verticalParticleDOWN);

			for (section in 0...2)
			{
				for (i in 0...Std.int((FlxG.width / 2) / 40) * 2)
				{
					var verticalBar:FlxSprite;
					if (i > 16)
					{
						verticalBar = FlxGradient.createGradientFlxSprite(40, Std.int(FlxG.height / 2), [FlxColor.BLACK, FlxColor.RED, FlxColor.RED], 1, -90);
						verticalBar.setPosition((FlxG.width / 2) * section, 0);
						verticalBar.x += verticalBar.width * (i - 16);
						switch (section)
						{
							case 0:
								lowerOppGroup.add(verticalBar);
							case 1:
								lowerPlayerGroup.add(verticalBar);
						}
						verticalBar.ID = i - 16;
					}
					else
					{
						verticalBar = FlxGradient.createGradientFlxSprite(40, Std.int(FlxG.height / 2), [FlxColor.BLACK, FlxColor.RED, FlxColor.RED]);
						verticalBar.setPosition((FlxG.width / 2) * section, FlxG.height / 2);
						verticalBar.x += verticalBar.width * (i);
						switch (section)
						{
							case 0:
								upperOppGroup.add(verticalBar);
							case 1:
								upperPlayerGroup.add(verticalBar);
						}
						verticalBar.ID = i;
					}
					FlxSpriteUtil.bound(verticalBar, verticalBar.x, verticalBar.x + 40, 0, FlxG.height);
				}
			}
		}

		add(upperPlayerGroup);
		add(lowerPlayerGroup);
		add(upperOppGroup);
		add(lowerOppGroup);
		if (SONG.song == 'emotional-restoration')
			setPrimaryVerticalBars(upperPlayerGroup);

		for (i in 0...Std.int(FlxG.height / 20))
		{
			var playerSideBar:FlxSprite = new FlxSprite(FlxG.width).makeGraphic(200, 20, FlxColor.WHITE, false, 'play');
			FlxGradient.overlayGradientOnFlxSprite(playerSideBar, Std.int(playerSideBar.width), Std.int(playerSideBar.height),
				FlxColor.gradient(FlxColor.WHITE, FlxColor.BLACK, 20), 0, 0, 1, 0);
			playerSideBar.y = playerSideBar.height * i;
			playerSideBar.ID = i;
			playerBarGroup.add(playerSideBar);
			var oppSideBar:FlxSprite = new FlxSprite(0).makeGraphic(200, 20, FlxColor.WHITE, false, 'opp');
			FlxGradient.overlayGradientOnFlxSprite(oppSideBar, Std.int(oppSideBar.width), Std.int(oppSideBar.height),
				FlxColor.gradient(FlxColor.WHITE, FlxColor.BLACK, 20), 0, 0, 1, 180);
			oppSideBar.y = oppSideBar.height * i;
			oppSideBar.x -= oppSideBar.width;
			oppSideBar.ID = 2 * i;
			opponentBarGroup.add(oppSideBar);
		}
		playerBarGroup.camera = camHUD;
		add(playerBarGroup);
		opponentBarGroup.camera = camHUD;
		add(opponentBarGroup);

		setPrimaryBars(playerBarGroup);

		gradientOverlay = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height,
			[FlxColor.fromInt(0x00FF0000), FlxColor.RED, FlxColor.fromInt(0x00FF0000)]);
		gradientOverlay.alpha = 0.0001;
		gradientOverlay.cameras = [camHUD];
		add(gradientOverlay);

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if (ClientPrefs.downScroll)
			strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		var showTime:Bool = false;
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		if (ClientPrefs.downScroll)
			timeTxt.y = FlxG.height - 44;

		if (ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.text = SONG.song;
		}
		updateTime = true;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = true;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT,
			(SONG.song == 'insanity-virus' ? Std.int((timeBarBG.width - 8) / 0.5736) : Std.int(timeBarBG.width - 8)), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(FlxColor.TRANSPARENT, 0xFFFFFFFF);
		timeBar.numDivisions = 400;
		timeBar.alpha = 0;
		timeBar.visible = true;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		if (ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();
		doubleStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if (FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if (FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
		}
		for (event in eventPushedMap.keys())
		{
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if (FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_events/' + event + '.lua');
				if (FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection(0);

		if (curStage == 'alley')
		{
			var alleyOverlay:BGSprite = new BGSprite('alleyOverlay', -400, -200, 1, 1);
			alleyOverlay.scale.set(0.5, 0.5);
			alleyOverlay.updateHitbox();
			stageSwitchOverlayGroup.add(alleyOverlay);
		}
		else if (curStage == 'peace')
		{
			var sunOverlay:BGSprite = new BGSprite('peace/homeShading', -500, -200, 1, 1);
			sunOverlay.scale.set(0.5, 0.5);
			sunOverlay.updateHitbox();
			sunOverlay.blend = ADD;
			sunOverlay.alpha = 0.75;
			add(sunOverlay);
		}

		vignette = new BGSprite('vignette', 0, 0, 1, 1);
		vignette.scale.set(0.5, 0.5);
		vignette.updateHitbox();
		vignette.cameras = [camHUD];
		if (curStage == 'alley' || curStage == 'myworld')
			add(vignette);

		healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.89;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		add(healthBarBG);
		if (ClientPrefs.downScroll)
			healthBarBG.y = 0.11 * FlxG.height;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		// healthBar
		healthBar.visible = !ClientPrefs.hideHud;
		healthBar.alpha = ClientPrefs.healthBarAlpha;
		add(healthBar);
		healthBarBG.sprTracker = healthBar;

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alpha = ClientPrefs.healthBarAlpha;
		add(iconP1);

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alpha = ClientPrefs.healthBarAlpha;
		add(iconP2);
		reloadHealthBarColors();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "BOTPLAY", 32);
		botplayTxt.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = false;
		add(botplayTxt);
		if (ClientPrefs.downScroll)
		{
			botplayTxt.y = timeBarBG.y - 78;
		}

		var messageText:String = 'remember';
		if (FlxG.random.int(1, 50) == 2)
			messageText = MemoryAnamnesis.memoryEasterMessage[FlxG.random.int(0, MemoryAnamnesis.memoryEasterMessage.length - 1)];
		memoryMessage = new CustomAlphabets(0, 0, messageText, "scratch", false, 0.2);
		memoryMessage.x = FlxG.width / 2;
		memoryMessage.camera = camHUD;
		memoryMessage.alpha = 0.0001;
		memoryMessage.y = botplayTxt.y + 5;
		add(memoryMessage);

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];

		if (curStage == 'splitStory')
		{
			healthBar.visible = false;
			healthBarBG.visible = false;
			iconP1.visible = false;
			iconP2.visible = false;
			// scoreTxt.visible = false;
		}

		botplayTxt.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];
		duplicationGroup.add(strumLineNotes);
		duplicationGroup.add(grpNoteSplashes);
		duplicationGroup.add(notes);
		duplicationGroup.add(healthBar);
		duplicationGroup.add(healthBarBG);
		duplicationGroup.add(iconP1);
		duplicationGroup.add(iconP2);
		duplicationGroup.add(scoreTxt);
		duplicationGroup.add(botplayTxt);
		duplicationGroup.add(timeBar);
		duplicationGroup.add(timeBarBG);
		duplicationGroup.add(timeTxt);
		duplicationGroup.add(doof);

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + Paths.formatToSongPath(SONG.song) + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + Paths.formatToSongPath(SONG.song) + '/'));
		if (Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + Paths.formatToSongPath(SONG.song) + '/'));
		#end

		for (folder in foldersToCheck)
		{
			if (FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if (file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene)
		{
			switch (daSong)
			{
				case 'traumatophobia':
					zoomOut(false);
					new FlxTimer().start(1.1, function(reset:FlxTimer)
					{
						zoomIn();
						startStoryDialogue(daSong);
					});
				case 'insanity-virus':
					StageSwitch.addStageToGroup("warzone");
					StageSwitch.addStageToGroup("myworld");
					changeStageMidway("warzone");
					camGame.setFilters([new ShaderFilter(cameraEffectShader)]);
					camHUD.setFilters([new ShaderFilter(cameraEffectShader)]);
					new FlxTimer().start(0.2, function(showWorld:FlxTimer)
					{
						changeStageMidway("myworld");
						new FlxTimer().start(0.2, function(resetToAlley:FlxTimer)
						{
							changeStageMidway("alley");

							new FlxTimer().start(0.2, function(strCou:FlxTimer)
							{
								startStoryDialogue(daSong);
							});
						});
					});
				default:
					startStoryDialogue(daSong);
			}
			seenCutscene = true;
		}
		else
		{
			if (SONG.song == 'traumatophobia')
			{
				zoomOut(false);
				new FlxTimer().start(2.1, function(reset:FlxTimer)
				{
					zoomIn();
					new FlxTimer().start(0.5, function(countdown:FlxTimer)
					{
						startCountdown();
					});
				});
			}
			else if (SONG.song == 'fabula-amoris')
			{
				upperBackAnimated.alpha = 1;
				lowerBackAnimated.alpha = 1;
				new FlxTimer().start(0.5, function(startSong:FlxTimer)
				{
					upperBackAnimated.alpha = 0.0001;
					lowerBackAnimated.alpha = 0.0001;
					startCountdown();
				});
			}
			else if (SONG.song == 'insanity-virus')
			{
				StageSwitch.addStageToGroup("warzone");
				StageSwitch.addStageToGroup("myworld");
				changeStageMidway("warzone");
				camGame.setFilters([new ShaderFilter(cameraEffectShader)]);
				camHUD.setFilters([new ShaderFilter(cameraEffectShader)]);
				new FlxTimer().start(0.2, function(showWorld:FlxTimer)
				{
					changeStageMidway("myworld");
					new FlxTimer().start(0.2, function(resetToAlley:FlxTimer)
					{
						changeStageMidway("alley");

						new FlxTimer().start(0.2, function(strCou:FlxTimer)
						{
							startCountdown();
						});
					});
				});
			}
			else
				startCountdown();
		}
		RecalculateRating();

		// PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if (ClientPrefs.hitsoundVolume > 0)
			CoolUtil.precacheSound('hitsound');
		CoolUtil.precacheSound('missnote1');
		CoolUtil.precacheSound('missnote2');
		CoolUtil.precacheSound('missnote3');
		if (SONG.song == 'insanity-virus' && isStoryMode)
			CoolUtil.precacheSound('ending');

		if (PauseSubState.songName != null)
		{
			CoolUtil.precacheMusic(PauseSubState.songName);
		}
		else if (ClientPrefs.pauseMusic != 'None')
		{
			CoolUtil.precacheMusic(Paths.formatToSongPath(ClientPrefs.pauseMusic));
		}

		if (SONG.song == 'traumatophobia')
		{
			sawClaw = new TraClaw((FlxG.width / 2) - 325, ClientPrefs.downScroll ? FlxG.height + 400 : -1025, 'saw distraction');
			sawClaw.strum = playerStrums;
			sawClaw.cameras = [camHUD];
			add(sawClaw);
			if (ClientPrefs.downScroll)
				sawClaw.flipX = true;
			sawClaw.preExecuteSaw();
		}

		// FlxTween.tween(sawClaw, {angle: 280}, 2, {type: PINGPONG, ease: FlxEase.sineInOut});

		gameplayClawGroup = new FlxTypedGroup<FlxSprite>();
		add(gameplayClawGroup);

		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end

		if (!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000;
		callOnLuas('onCreatePost', []);

		super.create();

		Paths.clearUnusedMemory();
		CustomFadeTransition.nextCamera = camOther;

		heavyRainEffect = new FlxTypedEmitter<FlxParticle>(-550, -200);
		heavyRainEffect.loadParticles(Paths.image('commonAssets/rainAsset'), 500);
		heavyRainEffect.width = 2760;
		heavyRainEffect.alpha.set(0.01, 0.25, 0, 0);
		heavyRainEffect.angle.set(10);
		heavyRainEffect.cameras = [camOther];
		heavyRainEffect.launchAngle.set(100);
		heavyRainEffect.scale.set(0.5, 0.5, 0.75, 0.75);
		heavyRainEffect.lifespan.set(0.25, 2);
		heavyRainEffect.speed.set(2000);
		heavyRainEffect.blend = ADD;
		heavyRainEffect.angularAcceleration.set(5, 10);
		heavyRainEffect.start(false, 0.0025);
		heavyRainEffect.emitting = false;
		add(heavyRainEffect);

		if (SONG.song == 'true-love' || SONG.song == 'treasured-memories')
		{
			new FlxTimer().start(FlxG.random.float(0.25, 0.5), function(generateminiheart:FlxTimer)
			{
				generateHeart(FlxG.random.int(1, 25) == 5 ? false : true);
			}, 0);
		}

		heartGradient = FlxGradient.createGradientFlxSprite(FlxG.width, FlxG.height, [FlxColor.fromInt(0x00FF0000), FlxColor.RED]);
		heartGradient.antialiasing = ClientPrefs.globalAntialiasing;
		heartGradient.camera = camHUD;
		heartGradient.alpha = 0.0001;
		add(heartGradient);

		STErrors.onScreenErrors = new FlxTypedGroup<FlxText>();
		add(STErrors.onScreenErrors);

		pulseSprite = new FlxSprite();
		pulseSprite.frames = Paths.getSparrowAtlas('commonAssets/colourPulses');
		for (i in 1...7)
		{
			pulseSprite.animation.addByPrefix(Std.string(i), Std.string(i), 24);
		}
		pulseSprite.cameras = [camHUD];
		pulseSprite.alpha = 0;
		pulseSprite.blend = ADD;
		pulseSprite.animation.play('1');
		add(pulseSprite);

		switch (Paths.formatToSongPath(SONG.song))
		{
			case 'disconsolate':
				dad.idleSuffix = '-sit';
				dad.recalculateDanceIdle();

				hangingFlash = new FlxSprite().loadGraphic(Paths.image("LightningFlash/" + FlxG.random.int(1, 5)));
				hangingFlash.alpha = 0;
				hangingFlash.scale.set(0.5, 0.5);
				hangingFlash.updateHitbox();
				hangingFlash.cameras = [camOther];
				add(hangingFlash);
			case 'static-torture':
				for (i in 0...opponentStrums.members.length)
				{
					opponentStrums.members[i].x = -1500;
				}
				boyfriend.alpha = 0;
			case 'left-for-dead':
				var shadingOverlay:BGSprite = new BGSprite('MYWORLD/Shading', -500, -200, 1, 1);
				shadingOverlay.scale.set(0.5, 0.5);
				shadingOverlay.updateHitbox();
				shadingOverlay.blend = HARDLIGHT;
				shadingOverlay.alpha = 0.9;
				add(shadingOverlay);
			default:
		}

		drainClaw = new FlxSprite(FlxG.width, iconP1.y);
		drainClaw.frames = Paths.getSparrowAtlas('GameplayClaws');
		drainClaw.animation.addByPrefix('preGrab', 'Drain-pre', 24, false);
		drainClaw.animation.addByPrefix('grab', 'Drain-grab', 24, false);
		drainClaw.animation.addByPrefix('release', 'Drain-release', 24, false);
		drainClaw.cameras = [camHUD];
		drainClaw.antialiasing = true;
		add(drainClaw);
		FlxTween.tween(drainClaw, {x: 200}, 1, {
			onComplete: function(reset:FlxTween)
			{
				drainClaw.x = FlxG.width;
			}
		});

		commandPrompt = new CommandPrompt(50, 50, camOther);
		add(commandPrompt);
		add(commandPrompt.cTextGroup);

		overlayBlackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		overlayBlackScreen.alpha = 0.0001;
		overlayBlackScreen.cameras = [camOther];
		add(overlayBlackScreen);

		if (SONG.song == 'insanity-virus' || SONG.song == 'fabula-amoris')
		{
			IVINtroText = new CustomAlphabets(0, 0, "", "cursive", true, SONG.song == 'insanity-virus' ? 0.15 : 0.075);
			IVINtroText.screenCenter(XY);
			IVINtroText.alpha = 0;
			IVINtroText.cameras = [camOther];
			add(IVINtroText);
			IVINtroText.changeText(SONG.song == 'insanity-virus' ? "so it's come to this" : "don't let their hearts break");
			IVINtroText.screenCenter(XY);
		}

		if (SONG.song == 'left-for-dead' || SONG.song == 'insanity-virus')
		{
			glitchShader = new OverlayShader();
			shaderFilter = new ShaderFilter(glitchShader);
			FlxG.game.setFilters([shaderFilter]);

			flashVirus = new Virus(0, 0, "", SONG.song, false, false);
			flashVirus.cameras = [camOther];
			add(flashVirus);

			if (SONG.song == 'insanity-virus')
			{
				cameraEffectShader = new CameraEffectShader();
				cameraEffectShader.data.zoom.value = [1.3];
				if (lime.app.Application.current.window.maximized)
				{
					cameraEffectShader.data.scaleDown.value = [1.1];
				}
				else
					cameraEffectShader.data.scaleDown.value = [1.2];

				bodyTransition = new Virus(0, 0, "transition-bodies_1", SONG.song, true);
				bodyTransition.cameras = [camOther];
				add(bodyTransition);

				IVScratchAnim = new FlxSprite();
				IVScratchAnim.frames = Paths.getSparrowAtlas("virus/scratchOverlay");
				IVScratchAnim.animation.addByPrefix("smile", "smile", 24);
				IVScratchAnim.animation.addByPrefix("sophie", "sophie", 24);
				IVScratchAnim.animation.addByPrefix("face", "face", 24);
				IVScratchAnim.animation.addByPrefix("knife", "knife", 24);
				IVScratchAnim.animation.play("smile");
				IVScratchAnim.alpha = 0.0001;
				IVScratchAnim.cameras = [camOther];
				add(IVScratchAnim);

				knifeTransition = new Virus(0, 0, "transition-knife", SONG.song, true);
				knifeTransition.cameras = [camOther];
				knifeTransition.alpha = 0.0001;
				add(knifeTransition);

				IVVirusTransitionAnim = new FlxSprite();
				IVVirusTransitionAnim.frames = Paths.getSparrowAtlas("virus/transition-bodies_2");
				IVVirusTransitionAnim.animation.addByPrefix("Transition", "scared", 24, false);
				IVVirusTransitionAnim.animation.play("Transition", true);
				IVVirusTransitionAnim.cameras = [camOther];
				IVVirusTransitionAnim.alpha = 0.0001;
				add(IVVirusTransitionAnim);
			}
		}
	}

	function set_songSpeed(value:Float):Float
	{
		if (generatedMusic)
		{
			var ratio:Float = value / songSpeed; // funny word huh
			for (note in notes)
			{
				if (note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
			for (note in unspawnNotes)
			{
				if (note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					note.scale.y *= ratio;
					note.updateHitbox();
				}
			}
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	public function addTextToDebug(text:String)
	{
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText)
		{
			spr.y += 20;
		});

		if (luaDebugGroup.members.length > 34)
		{
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup));
		#end
	}

	public function reloadHealthBarColors()
	{
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));

		healthBar.updateBar();
	}

	public function addCharacterToList(newCharacter:String, type:Int)
	{
		switch (type)
		{
			case 0:
				if (!boyfriendMap.exists(newCharacter))
				{
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if (!dadMap.exists(newCharacter))
				{
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if (gf != null && !gfMap.exists(newCharacter))
				{
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		if (FileSystem.exists(Paths.modFolders(luaFile)))
		{
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		}
		else
		{
			luaFile = Paths.getPreloadPath(luaFile);
			if (FileSystem.exists(luaFile))
			{
				doPush = true;
			}
		}

		if (doPush)
		{
			for (lua in luaArray)
			{
				if (lua.scriptName == luaFile)
					return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false)
	{
		if (gfCheck && char.curCharacter.startsWith('gf'))
		{ // IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String):Void
	{
	#if VIDEOS_ALLOWED
	var foundFile:Bool = false;
	var fileName:String = #if MODS_ALLOWED Paths.modFolders('videos/' + name + '.' + Paths.VIDEO_EXT); #else ''; #end
	#if sys
	if (FileSystem.exists(fileName))
	{
		foundFile = true;
	}
	#end

	if (!foundFile)
	{
		fileName = Paths.video(name);
		#if sys
		if (FileSystem.exists(fileName))
		{
		#else
		if (OpenFlAssets.exists(fileName))
		{
		#end
			foundFile = true;
		}
		} if (foundFile)
		{
			inCutscene = true;
			var bg = new FlxSprite(-FlxG.width, -FlxG.height).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
			bg.scrollFactor.set();
			bg.cameras = [camHUD];
			add(bg);

			(new FlxVideo(fileName)).finishCallback = function()
			{
				remove(bg);
				startAndEnd();
			}
			return;
		}
		else
		{
			FlxG.log.warn('Couldnt find video file: ' + fileName);
			startAndEnd();
		}
		#end
		startAndEnd();
	}

	function startAndEnd()
	{
		if (endingSong)
			endSong();
		else
			startCountdown();
	}

	var dialogueCount:Int = 0;

	public var psychDialogue:DialogueBoxPsych;
	public var dialogueFallen:StoryDialogueCore;

	public function startDialogue(dialogueFileData:Array<String>)
	{
		if (dialogueFallen != null)
			return;

		if (dialogueFileData.length > 0)
		{
			inCutscene = true;
			CoolUtil.precacheSound('dialogue');
			CoolUtil.precacheSound('dialogueClose');
			dialogueFallen = new StoryDialogueCore(dialogueFileData);
			dialogueFallen.scrollFactor.set();

			dialogueFallen.finishThing = function()
			{
				dialogueFallen = null;
				startCountdown();
			}

			dialogueFallen.cameras = [camOther];
			add(dialogueFallen);

			// dialogueFallen.nextDialogueThing = nextDialogueAction;
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;

	public static var startOnTime:Float = 0;

	function startStoryDialogue(songName:String)
	{
		#if desktop
		if (sys.FileSystem.exists(Paths.dialogue(songName + "/dialogue")))
		{
			startDialogue(sys.io.File.getContent(Paths.dialogue(songName + "/dialogue")).split("\n"));
		}
		else
			startCountdown();
		#end
	}

	public function startCountdown():Void
	{
		if (startedCountdown)
		{
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', []);
		if (ret != FunkinLua.Function_Stop)
		{
			if (skipCountdown || startOnTime > 0)
				skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);

			if (SONG.song != 'fabula-amoris')
			{
				warningBack = new FlxSprite(playerStrums.members[0].x).makeGraphic(Std.int((playerStrums.members[3].x - playerStrums.members[0].x)
					+ playerStrums.members[3].width), FlxG.height, FlxColor.RED);
				warningBack.alpha = 0;
				warningBack.cameras = [camHUD];
				add(warningBack);
			}
			else
			{
				for (i in 0...doubleStrums.length)
				{
					setOnLuas('defaultPlayerStrumX' + i, doubleStrums.members[i].x);
					setOnLuas('defaultPlayerStrumY' + i, doubleStrums.members[i].y);
				}
			}

			for (i in 0...playerStrums.length)
			{
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length)
			{
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				// if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			var swagCounter:Int = 0;

			if (skipCountdown || startOnTime > 0)
			{
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 500);
				return;
			}

			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				if (gf != null
					&& tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0
					&& !gf.stunned
					&& gf.animation.curAnim.name != null
					&& !gf.animation.curAnim.name.startsWith("sing")
					&& !gf.stunned)
				{
					gf.dance();
				}
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0
					&& boyfriend.animation.curAnim != null
					&& !boyfriend.animation.curAnim.name.startsWith('sing')
					&& !boyfriend.stunned)
				{
					boyfriend.dance();
					if (curStage == 'peace')
						layeredBF.dance();
				}
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0
					&& dad.animation.curAnim != null
					&& !dad.animation.curAnim.name.startsWith('sing')
					&& !dad.stunned)
				{
					dad.dance();
					if (curStage == 'peace')
						layeredDad.dance();
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if (isPixelStage)
				{
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				// head bopping for bg characters on Mall
				if (curStage == 'mall')
				{
					if (!ClientPrefs.lowQuality)
						upperBoppers.dance(true);

					bottomBoppers.dance(true);
					santa.dance(true);
				}

				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
					case 1:
						countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						countdownReady.scrollFactor.set();
						countdownReady.updateHitbox();
						countdownReady.camera = camOther;

						if (PlayState.isPixelStage)
							countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));

						countdownReady.screenCenter();
						countdownReady.antialiasing = antialias;
						add(countdownReady);
						FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownReady);
								countdownReady.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
					case 2:
						countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						countdownSet.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));

						countdownSet.screenCenter();
						countdownSet.antialiasing = antialias;
						countdownSet.camera = camOther;
						add(countdownSet);
						FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownSet);
								countdownSet.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
					case 3:
						countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						countdownGo.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));

						countdownGo.updateHitbox();

						countdownGo.screenCenter();
						countdownGo.antialiasing = antialias;
						countdownGo.camera = camOther;
						add(countdownGo);
						FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownGo);
								countdownGo.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);
					case 4:
						switch (SONG.song)
						{
							case 'disconsolate':
								blackFadeOut = 10;
							case 'anamnesis':
								blackFadeOut = 5;
							case 'emotional-restoration':
								blackFadeOut = 3;
							case 'true-love':
								blackFadeOut = 5;
							case 'traumatophobia':
								blackFadeOut = 0.75;
							case 'static-torture':
								blackFadeOut = 10;
							case 'treasured-memories':
								var whiteScreen:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
								whiteScreen.cameras = [camHUD];
								add(whiteScreen);
								FlxTween.tween(whiteScreen, {alpha: 0}, 5, {startDelay: 2});
								blackFadeOut = 2;
							case 'insanity-virus':
								blackFadeOut = 1;
								overlayBlackScreen.alpha = 1;
								FlxTween.tween(overlayBlackScreen, {alpha: 0}, 3, {startDelay: 11});

								FlxTween.tween(IVINtroText, {alpha: 1}, 0.5, {
									startDelay: 0.5,
								});
								FlxTween.tween(IVINtroText, {alpha: 0}, 1, {
									startDelay: 2,
									onComplete: function(next:FlxTween)
									{
										IVINtroText.changeText("don't give up now");
										IVINtroText.screenCenter(XY);
									}
								});
								FlxTween.tween(IVINtroText, {alpha: 1}, 0.5, {
									startDelay: 4,
								});
								FlxTween.tween(IVINtroText, {alpha: 0}, 1, {
									startDelay: 5.5,
									onComplete: function(next:FlxTween)
									{
										IVINtroText.changeText("good luck");
										IVINtroText.screenCenter(XY);
										camGame.setFilters([]);
										camHUD.setFilters([]);
									}
								});
								FlxTween.tween(IVINtroText, {alpha: 1}, 0.5, {
									startDelay: 7.5,
								});
								FlxTween.tween(IVINtroText, {alpha: 0}, 1, {startDelay: 9});
							case 'fabula-amoris':
								blackFadeOut = 1;
								FlxTween.tween(IVINtroText, {alpha: 1}, 1, {startDelay: 3});
								FlxTween.tween(IVINtroText, {alpha: 0}, 1, {startDelay: 6});
							default:
								blackFadeOut = 3;
						}
						FlxTween.tween(vignette, {alpha: 0.5}, blackFadeOut + 1);
						FlxTween.tween(camBlackFade, {alpha: 0}, blackFadeOut, {
							onComplete: function(resetCam:FlxTween)
							{
								camBlackFade.alpha = 1;
								camBlackFade.bgColor.alpha = 0;
							}
						});
				}

				notes.forEachAlive(function(note:Note)
				{
					note.copyAlpha = false;
					note.alpha = note.multAlpha;
					if (ClientPrefs.middleScroll && !note.mustPress)
					{
						note.alpha *= 0.5;
					}
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0)
		{
			var daNote:Note = unspawnNotes[i];
			if (daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0)
		{
			var daNote:Note = notes.members[i];
			if (daNote.strumTime - 500 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function setSongTime(time:Float)
	{
		if (time < 0)
			time = 0;

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.play();

		vocals.time = time;
		vocals.play();

		Conductor.songPosition = time;
	}

	function startNextDialogue()
	{
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue()
	{
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.75, false);

		FlxG.sound.music.onComplete = onSongComplete;
		vocals.volume = 0.75;
		vocals.play();

		if (startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if (paused)
		{
			// trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength);
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();

	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype', 'multiplicative');

		switch (songSpeedType)
		{
			case "multiplicative":
				songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1);
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if sys
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file))
		{
		#else
		if (OpenFlAssets.exists(file))
		{
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) // Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}
				var oldNote:Note;

				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);

				if (swagNote.noteType == 'saw note' || swagNote.noteType == 'grabNote')
				{
					swagNote.strumTime *= 2;
				}
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.slideID = songNotes[4];
				swagNote.gfNote = (section.gfSection && (songNotes[1] < 4));
				swagNote.noteType = songNotes[3];
				if (!Std.isOfType(songNotes[3], String))
					swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; // Backward compatibility + compatibility with Week 7 charts
				swagNote.scrollFactor.set();
				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);
				var floorSus:Int = Math.floor(susLength);

				if (floorSus > 0)
				{
					for (susNote in 0...floorSus + 1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
						var sustainNote:Note = new Note(daStrumTime
							+ (Conductor.stepCrochet * susNote)
							+ (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote,
							true);

						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1] < 4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.scrollFactor.set();
						unspawnNotes.push(sustainNote);
						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						else if (ClientPrefs.middleScroll)
						{
							sustainNote.x += 310;
							if (daNoteData > 1) // Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}
				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if (ClientPrefs.middleScroll)
				{
					swagNote.x += 310;
					if (daNoteData > 1) // Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}
				if (!noteTypeMap.exists(swagNote.noteType))
				{
					noteTypeMap.set(swagNote.noteType, true);
				}
				if (swagNote.noteType == 'grab Note')
					swagNote.noteData = swagNote.slideID;
			}
			daBeats += 1;
		}
		for (event in songData.events) // Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}
		// trace(unspawnNotes.length);
		// playerCounter += 1;
		unspawnNotes.sort(sortByShit);
		if (eventNotes.length > 1)
		{ // No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:EventNote)
	{
		switch (event.event)
		{
			case 'Change Character':
				var charType:Int = 0;
				switch (event.value1.toLowerCase())
				{
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);
		}

		if (!eventPushedMap.exists(event.event))
		{
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float
	{
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event.event]);
		if (returnedValue != 0)
		{
			return returnedValue;
		}

		switch (event.event)
		{
			case 'Kill Henchmen': // Better timing so that the kill sound matches the beat intended
				return 280; // Plays 280ms before the actual position
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; // for lua

	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...4)
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1 && ClientPrefs.middleScroll)
				targetAlpha = 0.35;

			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				// babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: 1}, targetAlpha, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				if (SONG.song != 'fabula-amoris')
					playerStrums.add(babyArrow);
				else
				{
					doubleStrums.add(babyArrow);
				}
			}
			else
			{
				if (ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if (i > 1)
					{ // Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				if (SONG.song != 'fabula-amoris')
					opponentStrums.add(babyArrow);
				else
					doubleStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);

			babyArrow.postAddedToGroup();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;

			if (blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = false;
			if (phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = false;

			if (carTimer != null)
				carTimer.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars)
			{
				if (char != null && char.colorTween != null)
				{
					char.colorTween.active = false;
				}
			}

			for (tween in modchartTweens)
			{
				tween.active = false;
			}
			for (timer in modchartTimers)
			{
				timer.active = false;
			}

			if (!isDead)
			{
				FlxTimer.globalManager.forEach(function(pauseTimers:FlxTimer)
				{
					pauseTimers.active = false;
				});
				FlxTween.globalManager.forEach(function(pauseTweens:FlxTween)
				{
					pauseTweens.active = false;
				});
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;

			if (blammedLightsBlackTween != null)
				blammedLightsBlackTween.active = true;
			if (phillyCityLightsEventTween != null)
				phillyCityLightsEventTween.active = true;

			if (carTimer != null)
				carTimer.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars)
			{
				if (char != null && char.colorTween != null)
				{
					char.colorTween.active = true;
				}
			}

			for (tween in modchartTweens)
			{
				tween.active = true;
			}
			for (timer in modchartTimers)
			{
				timer.active = true;
			}
			FlxTimer.globalManager.forEach(function(pauseTimers:FlxTimer)
			{
				pauseTimers.active = true;
			});
			FlxTween.globalManager.forEach(function(pauseTweens:FlxTween)
			{
				pauseTweens.active = true;
			});
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer != null && startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song
					+ " ("
					+ storyDifficultyText
					+ ")", iconP2.getCharacter(), true,
					songLength
					- Conductor.songPosition
					- ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song
					+ " ("
					+ storyDifficultyText
					+ ")", iconP2.getCharacter(), true,
					songLength
					- Conductor.songPosition
					- ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if (finishTimer != null)
			return;

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	public var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	var limoSpeed:Float = 0;

	override public function update(elapsed:Float)
	{
		if (ignoreThisFrame)
		{
			ignoreThisFrame = false;
			super.update(elapsed);
			return;
		}
		totalElapsed += elapsed;
		externalElapsed = elapsed;

		if (traumaHealthDrainBool)
		{
			health -= 0.002 * (60 / lime.app.Application.current.window.frameRate);
		}

		if (curStage == 'splitStory')
		{
			blakeHeart.angle = 5 * Math.sin(totalElapsed);
			sophieHeart.angle = 5 * Math.sin(totalElapsed + 1);
		}

		if (SONG.song == 'left-for-dead' || SONG.song == 'insanity-virus')
		{
			glitchShader.data.iTime.value = [totalElapsed];
			if (SONG.song == 'insanity-virus')
			{
				cameraEffectShader.data.iTime.value = [totalElapsed];
				if (cameraEffectShader.data.zoom.value[0] != cameraEffectZoom)
					cameraEffectShader.data.zoom.value[0] = FlxMath.lerp(cameraEffectShader.data.zoom.value[0], cameraEffectZoom,
						CoolUtil.boundTo(zoomRate * elapsed, 0, 1));
				switch (cameraEffectState)
				{
					case 0:
						cameraEffectShader.data.xPosFormula.value = [0.75 * totalElapsed];
						cameraEffectShader.data.yPosFormula.value = [300];
					case 1:
						cameraEffectShader.data.xPosFormula.value = [-totalElapsed];
						cameraEffectShader.data.yPosFormula.value = [-totalElapsed];
					case 2:
						cameraEffectShader.data.xPosFormula.value = [-totalElapsed];
						cameraEffectShader.data.yPosFormula.value = [0.5 * totalElapsed];
					case 3:
						cameraEffectShader.data.xPosFormula.value = [0.5 * Math.cos(3.5 * totalElapsed)];
						cameraEffectShader.data.yPosFormula.value = [Math.sin(2 * totalElapsed)];
				}
			}
		}

		if (checkRevert && FlxG.keys.anyJustPressed(commandPrompt.finalResetKey))
		{
			revertTimer.cancel();
			checkRevert = false;
			keysArray = KeyShift.defaultKeyArray;
		}

		// updating group clipping
		upperPlayerGroup.clipRect = upperPlayerGroup.clipRect;
		lowerPlayerGroup.clipRect = lowerPlayerGroup.clipRect;
		upperOppGroup.clipRect = upperOppGroup.clipRect;
		lowerOppGroup.clipRect = lowerOppGroup.clipRect;

		playerBarGroup.forEach(function(maxSafeGuard:FlxSprite)
		{
			if (maxSafeGuard.x <= FlxG.width - maxSafeGuard.width)
				maxSafeGuard.x = FlxG.width - maxSafeGuard.width;
		});
		opponentBarGroup.forEach(function(maxOppSafeGuard:FlxSprite)
		{
			if (maxOppSafeGuard.x >= 0)
				maxOppSafeGuard.x = 0;
		});
		upperPlayerGroup.forEach(function(maxOppSafeGuard:FlxSprite)
		{
			if (maxOppSafeGuard.y <= 0)
				maxOppSafeGuard.y = 0;
		});

		upperOppGroup.forEach(function(maxOppSafeGuard:FlxSprite)
		{
			if (maxOppSafeGuard.y <= 0)
				maxOppSafeGuard.y = 0;
		});

		lowerPlayerGroup.forEach(function(maxOppSafeGuard:FlxSprite)
		{
			if (maxOppSafeGuard.y >= FlxG.height / 2)
				maxOppSafeGuard.y = FlxG.height / 2;
		});

		lowerOppGroup.forEach(function(maxOppSafeGuard:FlxSprite)
		{
			if (maxOppSafeGuard.y >= FlxG.height / 2)
				maxOppSafeGuard.y = FlxG.height / 2;
		});
		/*if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
	}*/

		callOnLuas('onUpdate', [elapsed]);

		switch (curStage)
		{
			case 'schoolEvil':
				if (!ClientPrefs.lowQuality && bgGhouls.animation.curAnim.finished)
				{
					bgGhouls.visible = false;
				}
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed * 1.5;
			case 'limo':
				if (!ClientPrefs.lowQuality)
				{
					grpLimoParticles.forEach(function(spr:BGSprite)
					{
						if (spr.animation.curAnim.finished)
						{
							spr.kill();
							grpLimoParticles.remove(spr, true);
							spr.destroy();
						}
					});

					switch (limoKillingState)
					{
						case 1:
							limoMetalPole.x += 5000 * elapsed;
							limoLight.x = limoMetalPole.x - 180;
							limoCorpse.x = limoLight.x - 50;
							limoCorpseTwo.x = limoLight.x + 35;

							var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
							for (i in 0...dancers.length)
							{
								if (dancers[i].x < FlxG.width * 1.5 && limoLight.x > (370 * i) + 130)
								{
									switch (i)
									{
										case 0 | 3:
											if (i == 0)
												FlxG.sound.play(Paths.sound('dancerdeath'), 0.5);

											var diffStr:String = i == 3 ? ' 2 ' : ' ';
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 200, dancers[i].y, 0.4, 0.4,
												['hench leg spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x + 160, dancers[i].y + 200, 0.4, 0.4,
												['hench arm spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);
											var particle:BGSprite = new BGSprite('gore/noooooo', dancers[i].x, dancers[i].y + 50, 0.4, 0.4,
												['hench head spin' + diffStr + 'PINK'], false);
											grpLimoParticles.add(particle);

											var particle:BGSprite = new BGSprite('gore/stupidBlood', dancers[i].x - 110, dancers[i].y + 20, 0.4, 0.4, ['blood'],
												false);
											particle.flipX = true;
											particle.angle = -57.5;
											grpLimoParticles.add(particle);
										case 1:
											limoCorpse.visible = true;
										case 2:
											limoCorpseTwo.visible = true;
									} // Note: Nobody cares about the fifth dancer because he is mostly hidden offscreen :(
									dancers[i].x += FlxG.width * 2;
								}
							}

							if (limoMetalPole.x > FlxG.width * 2)
							{
								resetLimoKill();
								limoSpeed = 800;
								limoKillingState = 2;
							}

						case 2:
							limoSpeed -= 4000 * elapsed;
							bgLimo.x -= limoSpeed * elapsed;
							if (bgLimo.x > FlxG.width * 1.5)
							{
								limoSpeed = 3000;
								limoKillingState = 3;
							}

						case 3:
							limoSpeed -= 2000 * elapsed;
							if (limoSpeed < 1000)
								limoSpeed = 1000;

							bgLimo.x -= limoSpeed * elapsed;
							if (bgLimo.x < -275)
							{
								limoKillingState = 4;
								limoSpeed = 800;
							}

						case 4:
							bgLimo.x = FlxMath.lerp(bgLimo.x, -150, CoolUtil.boundTo(elapsed * 9, 0, 1));
							if (Math.round(bgLimo.x) == -150)
							{
								bgLimo.x = -150;
								limoKillingState = 0;
							}
					}

					if (limoKillingState > 2)
					{
						var dancers:Array<BackgroundDancer> = grpLimoDancers.members;
						for (i in 0...dancers.length)
						{
							dancers[i].x = (370 * i) + bgLimo.x + 280;
						}
					}
				}
			case 'mall':
				if (heyTimer > 0)
				{
					heyTimer -= elapsed;
					if (heyTimer <= 0)
					{
						bottomBoppers.dance(true);
						heyTimer = 0;
					}
				}
		}

		if (!inCutscene)
		{
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if (!startingSong && !endingSong && boyfriend.animation.curAnim.name.startsWith('idle'))
			{
				boyfriendIdleTime += elapsed;
				if (boyfriendIdleTime >= 0.15)
				{ // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			}
			else
			{
				boyfriendIdleTime = 0;
			}
		}

		super.update(elapsed);

		if (ratingName == '?')
		{
			scoreTxt.text = 'Score: ' + songScore + ' | Misses: ' + songMisses + ' | Rating: ' + ratingName;
		}
		else
		{
			scoreTxt.text = 'Score: ' + songScore + ' | Misses: ' + songMisses + ' | Rating: ' + ratingName + ' ('
				+ Highscore.floorDecimal(ratingPercent * 100, 2) + '%)' + ' - ' + ratingFC; // peeps wanted no integer rating
		}

		if (botplayTxt.visible)
		{
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', []);
			if (ret != FunkinLua.Function_Stop)
			{
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;

				// 1 / 1000 chance for Gitaroo Man easter egg
				/*if (FlxG.random.bool(0.1))
				{
					// gitaroo man easter egg
					cancelMusicFadeTween();
					MusicBeatState.switchState(new GitarooPause());
				}
				else { */
				if (FlxG.sound.music != null)
				{
					FlxG.sound.music.pause();
					vocals.pause();
				}
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
				// }

				#if desktop
				DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
			}
		}

		/*if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene)
		{
			openChartEditor();
	}*/

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x
			+ (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01))
			+ (150 * iconP1.scale.x - 150) / 2
			- iconOffset;
		iconP2.x = healthBar.x
			+ (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01))
			- (150 * iconP2.scale.x) / 2
			- iconOffset * 2;

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		/*if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene)
		{
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
	}*/

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if (updateTime)
				{
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if (curTime < 0)
						curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					if (ClientPrefs.timeBarType == 'Time Elapsed')
						songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if (secondsTotal < 0)
						secondsTotal = 0;

					if (ClientPrefs.timeBarType != 'Song Name')
						timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125), 0, 1));
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && !inCutscene && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		if (unspawnNotes[0] != null)
		{
			var time:Float = 3000; // shit be werid on 4:3
			if (songSpeed < 1)
				time /= songSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if (!inCutscene)
			{
				if (!cpuControlled)
				{
					keyShit();
				}
				else if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration
					&& boyfriend.animation.curAnim.name.startsWith('sing')
					&& !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend.dance();
					if (curStage == 'peace')
						layeredBF.dance();
					// boyfriend.animation.curAnim.finish();
				}
			}

			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
				if (SONG.song != 'fabula-amoris')
				{
					if (!daNote.mustPress)
						strumGroup = opponentStrums;
				}
				else
				{
					strumGroup = doubleStrums;
					if (!daNote.mustPress)
					{
						daNote.mustPress = true;
						daNote.noteData += 4;
					}
				}

				var strumX:Float = strumGroup.members[daNote.noteData].x;
				var strumY:Float = strumGroup.members[daNote.noteData].y;
				var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
				var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
				var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
				var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;
				strumAlpha *= daNote.multAlpha;

				if (strumScroll) // Downscroll
				{
					// daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					if (daNote.noteType == 'saw note' || daNote.noteType == 'grab Note')
						daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * (songSpeed / 2));
					else
						daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * (songSpeed));
				}
				else // Upscroll
				{
					if (daNote.noteType == 'saw note' || daNote.noteType == 'grab Note')
						daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * (songSpeed / 2));
					else
						daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * (songSpeed));
				}

				var angleDir = strumDirection * Math.PI / 180;
				if (daNote.copyAngle)
					daNote.angle = strumDirection - 90 + strumAngle;

				if (daNote.copyAlpha)
					daNote.alpha = strumAlpha;

				if (daNote.copyX && daNote.noteType != 'grab Note')
					daNote.x = strumX + Math.cos(angleDir) * daNote.distance;

				if (daNote.copyY)
				{
					daNote.y = strumY + Math.sin(angleDir) * daNote.distance;

					// Jesus fuck this took me so much mother fucking time AAAAAAAAAA
					if (strumScroll && daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith('end'))
						{
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));

							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
							if (PlayState.isPixelStage)
							{
								daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
							}
							else
							{
								daNote.y -= 19;
							}
						}
						daNote.y += (Note.swagWidth / 2) - (60.5 * (songSpeed - 1));
						daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					opponentNoteHit(daNote);
				}

				if ((ClientPrefs.downScroll && daNote.y >= 0) || (!ClientPrefs.downScroll && daNote.y <= camHUD.height))
				{
					if (daNote.mustPress && (daNote.noteType == 'saw note' || daNote.noteType == 'grab Note'))
					{
						daNote.hasEnteredScreen = true;
						if (daNote.preScreenBool != daNote.hasEnteredScreen)
						{
							new FlxTimer().start(FlxG.random.float(0, 0.25), function(generateClaw:FlxTimer)
							{
								/*if (daNote.noteType == 'grab Note')
								{
									FlxTween.tween(daNote, {x: playerStrums.members[daNote.slideID].x}, 0.3, {
										ease: FlxEase.expoOut
									});
									trace('moving note');
							}*/
								var clawSprite:TraClaw = new TraClaw(FlxG.width, 0, daNote.noteType, false, daNote.slideID, daNote,
									playerStrums.members[daNote.slideID].x);
								clawSprite.NoteGroup = notes;
								clawSprite.cameras = [camHUD];
								add(clawSprite);
							});
							daNote.preScreenBool = true;
						}
					}
				}

				if (daNote.mustPress && cpuControlled)
				{
					if (daNote.isSustainNote)
					{
						if (daNote.canBeHit)
						{
							goodNoteHit(daNote);
						}
					}
					else if (daNote.strumTime <= Conductor.songPosition || (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress))
					{
						goodNoteHit(daNote);
					}
				}

				var center:Float = strumY + Note.swagWidth / 2;
				if (strumGroup.members[daNote.noteData].sustainReduce
					&& daNote.isSustainNote
					&& (daNote.mustPress || !daNote.ignoreNote)
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					if (strumScroll)
					{
						if (daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;

							daNote.clipRect = swagRect;
						}
					}
					else
					{
						if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;

							daNote.clipRect = swagRect;
						}
					}
				}

				// Kill extremely late notes and cause misses
				if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
				{
					if (daNote.mustPress && !cpuControlled && !daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit))
					{
						noteMiss(daNote);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}

		checkEventNote();
		#if debug
		if (!endingSong && !startingSong)
		{
			if (FlxG.keys.justPressed.ONE)
			{
				KillNotes();
				FlxG.sound.music.onComplete();
			}
			if (FlxG.keys.justPressed.TWO)
			{ // Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
		}
		#end
		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);
	}

	function openChartEditor()
	{
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	public var isDead:Bool = false; // Don't mess with this on Lua!!!

	function doDeathCheck(?skipHealthCheck:Bool = false)
	{
		if ((((skipHealthCheck && instakillOnMiss) || health <= 0 || (FAmissCount[0] >= 24 || FAmissCount[1] >= 24))
			&& !practiceMode
			&& !isDead))
		{
			var ret:Dynamic = callOnLuas('onGameOver', []);
			if (ret != FunkinLua.Function_Stop)
			{
				boyfriend.stunned = true;
				if (curStage == 'peace')
					layeredBF.stunned = true;
				deathCounter++;

				paused = true;

				vocals.stop();

				FlxG.sound.music.stop();

				persistentUpdate = false;
				persistentDraw = false;
				for (tween in modchartTweens)
				{
					tween.active = true;
				}
				for (timer in modchartTimers)
				{
					timer.active = true;
				}
				isDead = true;
				openSubState(new GameOverSubstate());

				// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				return true;
			}
		}
		return false;
	}

	public function checkEventNote()
	{
		while (eventNotes.length > 0)
		{
			var leStrumTime:Float = eventNotes[0].strumTime;
			if (Conductor.songPosition < leStrumTime)
			{
				break;
			}

			var value1:String = '';
			if (eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if (eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String)
	{
		var pressed:Bool = Reflect.getProperty(controls, key);
		// trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String)
	{
		switch (eventName)
		{
			case 'Hey!':
				var value:Int = 2;
				switch (value1.toLowerCase().trim())
				{
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if (Math.isNaN(time) || time <= 0)
					time = 0.6;

				if (value != 0)
				{
					if (dad.curCharacter.startsWith('gf'))
					{ // Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					}
					else if (gf != null)
					{
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}

					if (curStage == 'mall')
					{
						bottomBoppers.animation.play('hey', true);
						heyTimer = time;
					}
				}
				if (value != 1)
				{
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if (Math.isNaN(value) || value < 1)
					value = 1;
				gfSpeed = value;

			case 'Blammed Lights':
				var lightId:Int = Std.parseInt(value1);
				if (Math.isNaN(lightId))
					lightId = 0;

				var chars:Array<Character> = [boyfriend, gf, dad];
				if (lightId > 0 && curLightEvent != lightId)
				{
					if (lightId > 5)
						lightId = FlxG.random.int(1, 5, [curLightEvent]);

					var color:Int = 0xffffffff;
					switch (lightId)
					{
						case 1: // Blue
							color = 0xff31a2fd;
						case 2: // Green
							color = 0xff31fd8c;
						case 3: // Pink
							color = 0xfff794f7;
						case 4: // Red
							color = 0xfff96d63;
						case 5: // Orange
							color = 0xfffba633;
					}
					curLightEvent = lightId;

					if (blammedLightsBlack.alpha == 0)
					{
						if (blammedLightsBlackTween != null)
						{
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 1}, 1, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								blammedLightsBlackTween = null;
							}
						});

						for (char in chars)
						{
							if (char.colorTween != null)
							{
								char.colorTween.cancel();
							}
							char.colorTween = FlxTween.color(char, 1, FlxColor.WHITE, color, {
								onComplete: function(twn:FlxTween)
								{
									char.colorTween = null;
								},
								ease: FlxEase.quadInOut
							});
						}
					}
					else
					{
						if (blammedLightsBlackTween != null)
						{
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = null;
						blammedLightsBlack.alpha = 1;

						for (char in chars)
						{
							if (char.colorTween != null)
							{
								char.colorTween.cancel();
							}
							char.colorTween = null;
						}
						dad.color = color;
						boyfriend.color = color;
						if (gf != null)
							gf.color = color;
					}

					if (curStage == 'philly')
					{
						if (phillyCityLightsEvent != null)
						{
							phillyCityLightsEvent.forEach(function(spr:BGSprite)
							{
								spr.visible = false;
							});
							phillyCityLightsEvent.members[lightId - 1].visible = true;
							phillyCityLightsEvent.members[lightId - 1].alpha = 1;
						}
					}
				}
				else
				{
					if (blammedLightsBlack.alpha != 0)
					{
						if (blammedLightsBlackTween != null)
						{
							blammedLightsBlackTween.cancel();
						}
						blammedLightsBlackTween = FlxTween.tween(blammedLightsBlack, {alpha: 0}, 1, {
							ease: FlxEase.quadInOut,
							onComplete: function(twn:FlxTween)
							{
								blammedLightsBlackTween = null;
							}
						});
					}

					if (curStage == 'philly')
					{
						phillyCityLights.forEach(function(spr:BGSprite)
						{
							spr.visible = false;
						});
						phillyCityLightsEvent.forEach(function(spr:BGSprite)
						{
							spr.visible = false;
						});

						var memb:FlxSprite = phillyCityLightsEvent.members[curLightEvent - 1];
						if (memb != null)
						{
							memb.visible = true;
							memb.alpha = 1;
							if (phillyCityLightsEventTween != null)
								phillyCityLightsEventTween.cancel();

							phillyCityLightsEventTween = FlxTween.tween(memb, {alpha: 0}, 1, {
								onComplete: function(twn:FlxTween)
								{
									phillyCityLightsEventTween = null;
								},
								ease: FlxEase.quadInOut
							});
						}
					}

					for (char in chars)
					{
						if (char.colorTween != null)
						{
							char.colorTween.cancel();
						}
						char.colorTween = FlxTween.color(char, 1, char.color, FlxColor.WHITE, {
							onComplete: function(twn:FlxTween)
							{
								char.colorTween = null;
							},
							ease: FlxEase.quadInOut
						});
					}

					curLight = 0;
					curLightEvent = 0;
				}

			case 'Kill Henchmen':
				killHenchmen();

			case 'Add Camera Zoom':
				if (ClientPrefs.camZooms && FlxG.camera.zoom < 1.35)
				{
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if (Math.isNaN(camZoom))
						camZoom = 0.015;
					if (Math.isNaN(hudZoom))
						hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Trigger BG Ghouls':
				if (curStage == 'schoolEvil' && !ClientPrefs.lowQuality)
				{
					bgGhouls.dance(true);
					bgGhouls.visible = true;
				}

			case 'Play Animation':
				// trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch (value2.toLowerCase().trim())
				{
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if (Math.isNaN(val2))
							val2 = 0;

						switch (val2)
						{
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if (Math.isNaN(val1))
					val1 = 0;
				if (Math.isNaN(val2))
					val2 = 0;

				isCameraOnForcedPos = false;
				if (!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2)))
				{
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch (value1.toLowerCase())
				{
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if (Math.isNaN(val))
							val = 0;

						switch (val)
						{
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length)
				{
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if (split[0] != null)
						duration = Std.parseFloat(split[0].trim());
					if (split[1] != null)
						intensity = Std.parseFloat(split[1].trim());
					if (Math.isNaN(duration))
						duration = 0;
					if (Math.isNaN(intensity))
						intensity = 0;

					if (duration > 0 && intensity != 0)
					{
						targetsArray[i].shake(intensity, duration);
					}
				}

			case 'Change Character':
				var charType:Int = 0;
				switch (value1)
				{
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if (Math.isNaN(charType)) charType = 0;
				}

				switch (charType)
				{
					case 0:
						if (boyfriend.curCharacter != value2)
						{
							if (!boyfriendMap.exists(value2))
							{
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							iconP1.changeIcon(boyfriend.healthIcon);
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if (dad.curCharacter != value2)
						{
							if (!dadMap.exists(value2))
							{
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if (!dad.curCharacter.startsWith('gf'))
							{
								if (wasGf && gf != null)
								{
									gf.visible = true;
								}
							}
							else if (gf != null)
							{
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							iconP2.changeIcon(dad.healthIcon);
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if (gf != null)
						{
							if (gf.curCharacter != value2)
							{
								if (!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
							setOnLuas('gfName', gf.curCharacter);
						}
				}
				reloadHealthBarColors();

			case 'BG Freaks Expression':
				if (bgGirls != null)
					bgGirls.swapDanceType();

			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if (Math.isNaN(val1))
					val1 = 1;
				if (Math.isNaN(val2))
					val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if (val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2, {
						ease: FlxEase.linear,
						onComplete: function(twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}
			case '[DIS][ANA] Toggle Rain Effect':
				FlxTween.cancelTweensOf(overlayBlackScreen);
				overlayBlackScreen.alpha = 0;
				if (Std.parseFloat(value2) == 1)
				{
					(Std.parseFloat(value1) == 1 ? heavyRainEffect.emitting = true : heavyRainEffect.emitting = false);
				}
				else if (Std.parseFloat(value2) == 2)
				{
					new FlxTimer().start(FlxG.random.float(2, 3), function(generateLightRain:FlxTimer)
					{
						var lightRainAsset:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('commonAssets/lightRainAsset'));
						var scaleRand:Float = randomisedRainScale();
						lightRainAsset.scale.set(scaleRand, scaleRand);
						lightRainAsset.updateHitbox();
						lightRainAsset.antialiasing = ClientPrefs.globalAntialiasing;
						lightRainAsset.x = FlxG.random.float(-550, 2160);
						lightRainAsset.y = -200 - lightRainAsset.height;
						lightRainAsset.alpha = FlxG.random.float(0.5, 1);
						lightRainAsset.camera = camGame;
						add(lightRainAsset);
						FlxTween.tween(lightRainAsset, {y: FlxG.height}, 1, {
							ease: FlxEase.expoIn,
							onComplete: function(playSoundplusDestroy:FlxTween)
							{
								lightRainAsset.destroy();
								FlxG.sound.play(Paths.sound('drop_' + FlxG.random.int(1, 3)), 0.2);
							}
						});
					}, 0);
				}
			case '[ANA] Toggle Anamnesis Words':
				AnamnesisEffectToggle = true;
				FlxTween.tween(anamnesisBlackScreen, {alpha: 1}, 0.5);
				for (i in 0...stageSwitchOverlayGroup.members.length)
				{
					FlxTween.tween(stageSwitchOverlayGroup.members[i], {alpha: 0}, 0.5);
				}
				FlxTween.tween(overlayBlackScreen, {alpha: 0.2}, 0.5);
				new FlxTimer().start(Std.parseFloat(value1), function(disableEffect:FlxTimer)
				{
					AnamnesisEffectToggle = false;
					FlxTween.tween(anamnesisBlackScreen, {alpha: 0}, 0.5);
					FlxTween.tween(overlayBlackScreen, {alpha: 0}, 0.5);
					for (i in 0...stageSwitchOverlayGroup.members.length)
					{
						FlxTween.tween(stageSwitchOverlayGroup.members[i], {alpha: (i == 1 ? 0.5 : 1)}, 0.5, {
							onComplete: function(resetVigAlph:FlxTween)
							{
								vignette.alpha = 0.5;
							}
						});
					}
				});
				new FlxTimer().start(FlxG.random.float(0.1, 1), function(addWord:FlxTimer)
				{
					if (AnamnesisEffectToggle)
					{
						var selectedWord:Int = FlxG.random.int(0, MemoryAnamnesis.anamnesisWords.length - 1);
						var word:CustomAlphabets = new CustomAlphabets(0, 0, MemoryAnamnesis.anamnesisWords[selectedWord][0], "scratch",
							MemoryAnamnesis.checkAlternative(MemoryAnamnesis.anamnesisWords[selectedWord][1]), FlxG.random.float(0.1, 1));
						word.antialiasing = ClientPrefs.globalAntialiasing;
						word.x += FlxG.random.float(stageDimensions[0] - 50, stageDimensions[2] - 50);
						word.y +=FlxG.random.float(stageDimensions[1] - 25, stageDimensions[3] - 25);
						word.alpha = 0;
						add(word);
						FlxTween.tween(word, {alpha: 1}, 0.25, {
							onComplete: function(fadeOut:FlxTween)
							{
								FlxTween.tween(word, {alpha: 0}, 0.5, {
									onComplete: destroyAsset.bind(_, word)
								});
							}
						});
					}
				}, 0);

			case '[ANA][ER] Show Memory Message':
				FlxTween.tween(memoryMessage, {alpha: 1}, 2);
				memoryMessage.forEach(function(letter:FlxSprite)
				{
					FlxTween.shake(letter, 0.03, Std.parseFloat(value1));
				});
				secondaryBlackScreen.alpha = 1;
				overlayBlackScreen.alpha = 1;
				FlxTween.tween(overlayBlackScreen, {alpha: 0}, 0.25);
				new FlxTimer().start(Std.parseFloat(value1), function(removeText:FlxTimer)
				{
					trace("Fading out message");
					FlxTween.tween(memoryMessage, {alpha: 0}, 0.5, {
						onComplete: destroyAsset.bind(_, memoryMessage)
					});
					FlxTween.tween(secondaryBlackScreen, {alpha: 0}, 0.5);
				});
			case '[ER] toggle side bars':
				(Std.parseFloat(value1) == 1 ? sideBarToggle = true : sideBarToggle = false);
			case '[TL]  Heart Effect':
				(Std.parseFloat(value1) == 1 ? heartToggle = true : heartToggle = false);
				FlxTween.tween(heartGradient, {alpha: heartToggle ? 0.23 : 0}, 2);
			case '[ANA][ER] memory warning':
				var memoryWarning:FlxSprite = new FlxSprite(warningBack.x + (warningBack.width / 2)).loadGraphic(Paths.image('commonAssets/WarningSymbol'));
				memoryWarning.antialiasing = ClientPrefs.globalAntialiasing;
				memoryWarning.alpha = 0;
				memoryWarning.cameras = [camHUD];
				memoryWarning.x -= memoryWarning.width / 2;
				memoryWarning.screenCenter(Y);
				add(memoryWarning);
				warningPulse(memoryWarning, 1);
				warningPulse(warningBack, 0.2, false);
				FlxG.sound.play(Paths.sound('MemoryWarning'), 0.1);
			case '[TRA] Claw Health Drain':
				clawDrain(Std.parseFloat(value1));
			case '[TRA] saw strum removal distraction':
				sawClaw.triggerSawMech(Std.parseFloat(value1), Std.parseInt(value2));
			case '[IV] Flash Virus':
				flashVirus.virusFlash(value1, value1 == "" ? true : false);
				health -= (0.1 * health * 1.25) + 0.01;
			case '[ST] display error message':
				STErrors.displayErrors(Std.parseInt(value1), camOther);
			case '[IV] Shift Keybinds':
				KeyShift.defaultKeyArray = keysArray;
				KeyShift.shiftKeys(value1, keysArray);
				checkRevert = true;
				revertTimer = new FlxTimer().start(10, function(preventRevert:FlxTimer)
				{
					checkRevert = false;
					KeyShift.defaultKeyArray = keysArray;
				});
			case '[ER] toggle vertical bars':
				camOther.flash();
				(Std.parseFloat(value1) == 1 ? {
					verticalToggle = true;
					gradientOverlay.alpha = 0.5;
					camHUD.bgColor = FlxColor.BLACK;
					verticalParticleUP.alpha.set(0.1);
					verticalParticleDOWN.alpha.set(0.1);
				} : {
					verticalToggle = false;
					gradientOverlay.alpha = 0;
					camHUD.bgColor = FlxColor.TRANSPARENT;
					verticalParticleUP.alpha.set(0);
					verticalParticleDOWN.alpha.set(0);
					});
			case '[ER] Toggle colour pulses':
				Std.parseInt(value1) == 1 ? colourPulseTrigger = true : colourPulseTrigger = false;
			case '[COM] Fade Screen Black':
				FlxTween.tween(overlayBlackScreen, {alpha: 1}, Std.parseFloat(value1));
				new FlxTimer().start(Std.parseFloat(value1) + Std.parseFloat(value2), function(resetCamColor:FlxTimer)
				{
					FlxTween.tween(overlayBlackScreen, {alpha: 0}, 0.5);
				});
			case '[DIS] camera zoom':
				isCameraOnForcedPos = false;
				if (determineWhichZoom)
				{
					cameraZoomOffset = (525 / (1.5 - 0.7)) * Std.parseFloat(value2) - 459.375;
					FlxTween.tween(camGame, {zoom: Std.parseFloat(value2)}, Std.parseFloat(value1), {ease: FlxEase.cubeOut});
					FlxTween.tween(camFollow, {y: (dad.getMidpoint().y - 100 + dad.cameraPosition[1] + opponentCameraOffset[1]) + cameraZoomOffset},
						Std.parseFloat(value1), {ease: FlxEase.cubeOut});
				}
				else
				{
					cameraZoomOffset = (120 / (1.5 - 0.7)) * Std.parseFloat(value2) - 105;
					FlxTween.tween(camGame, {zoom: Std.parseFloat(value2)}, Std.parseFloat(value1), {ease: FlxEase.cubeOut});
					FlxTween.tween(camFollow, {
						y: (boyfriend.getMidpoint().y - 100 + boyfriend.cameraPosition[1] + boyfriendCameraOffset[1]) + cameraZoomOffset
					}, Std.parseFloat(value1), {ease: FlxEase.cubeOut});
				}
			case '[TRA] Stage zoom out':
				if (Std.parseFloat(value1) == 1)
				{
					zoomOut();
				}
				else
				{
					zoomIn();
				}

			case '[COM] Flash Screen':
				camOther.flash(FlxColor.WHITE, Std.parseFloat(value1));
			case '[ER] Toggle drop zoom':
				Std.parseFloat(value1) == 1 ? ERDrop = true : ERDrop = false;
			case '[ER] set Sophie opacity':
				FlxTween.tween(storySophieGhost, {alpha: Std.parseFloat(value1)}, Std.parseFloat(value2));
			case '[TRA] Play Scream Animation':
				dad.playAnim('idle', true);
				snapCamFollowToPos(dad.getGraphicMidpoint().x - 150, dad.getGraphicMidpoint().y - 300);
				defaultCamZoom = 1.5;
				isCameraOnForcedPos = true;
			case '[ST] change static opacity':
				if (Std.parseFloat(value2) == 0)
				{
					var flickerCode = value1.split(';'); // [opacity1, opacity 2, flicker period, flicker num]
					FlxSpriteUtil.flicker(staticEffect, Std.parseFloat(flickerCode[2]) * Std.parseInt(flickerCode[3]), Std.parseFloat(flickerCode[2]));
				}
				else
					FlxTween.tween(staticEffect, {alpha: Std.parseFloat(value1)}, Std.parseFloat(value2));
			case '[ST] fade overlay black screen of Blake':
				FlxTween.tween(secondaryBlackScreen, {alpha: Std.parseFloat(value1)}, Std.parseFloat(value2));
			case '[DIS] hanging Flash':
				hangingFlash.alpha = 1;
				FlxTween.tween(hangingFlash, {alpha: 0}, 2);
			case '[IV][LFD] command prompt':
				switch (value1)
				{
					case "keybind":
						commandPrompt.addCommandText(value1, value2, 10);
						KeyShift.defaultKeyArray = keysArray;
						KeyShift.shiftKeys(value1, keysArray);
						checkRevert = true;
						revertTimer = new FlxTimer().start(10, function(preventRevert:FlxTimer)
						{
							checkRevert = false;
							KeyShift.defaultKeyArray = keysArray;
						});
					case "health":
						commandPrompt.addCommandText(value1, value2);
						health = Std.parseFloat(value2);
					default:
						commandPrompt.addCommandText(value1, value2);
				}
				FlxG.camera.shake(1, 0.075);
			case '[FA] Toggle animated backgrounds':
				upperBackAnimated.alpha = lowerBackAnimated.alpha = Std.parseFloat(value1);
			case '[IV] Body Transition':
				bodyTransition.switchTransitionPhase = Std.parseInt(value1);
				bodyTransition.updateTransitionPhase();
				if (value1 == "2")
				{
					IVVirusTransitionAnim.alpha = 1;
					IVVirusTransitionAnim.animation.play("Transition", true);
					staticEffect.cameras = [IVStaticTranCam];
					camOther.shake(0.02, 1.3);
				}
				else
				{
					IVVirusTransitionAnim.alpha = 0.0001;
					staticEffect.cameras = [camHUD];
				}
			case '[IV] knife Transition':
				knifeTransition.switchTransitionPhase = Std.parseInt(value1);
				knifeTransition.updateTransitionPhase();
			case '[IV] Toggle Camera Effect Status':
				if (Std.parseInt(value1) == 1)
				{
					camGame.setFilters([new ShaderFilter(cameraEffectShader)]);
					camHUD.setFilters([new ShaderFilter(cameraEffectShader)]);
				}
				else
				{
					camGame.setFilters([]);
					camHUD.setFilters([]);
				}
			case '[FA] change black cover opacity':
				var valuesArray:Array<String> = [value1, value2];

				for (i in 0...valuesArray.length)
				{
					var entrySplit:Array<String> = valuesArray[i].split(",");
					if (valuesArray[i] != null)
					{
						if (i == 0)
						{
							FlxTween.tween(FAUpperBlackScreen, {alpha: Std.parseFloat(entrySplit[0])}, Std.parseFloat(entrySplit[1]));
						}
						else
						{
							FlxTween.tween(FALowerBlackScreen, {alpha: Std.parseFloat(entrySplit[0])}, Std.parseFloat(entrySplit[1]));
						}
					}
				}
			case '[FA] Toggle double strum keys':
				if (Std.parseInt(value1) == 1)
				{
					keysArray = doubleKeysArray;
					toggleDouble = true;
				}
			case '[COM] Tween camera zoom':
				FlxTween.tween(FlxG.camera, {zoom: Std.parseFloat(value1)}, Std.parseFloat(value2), {ease: FlxEase.sineInOut});
			case '[IV] scratch effect':
				IVScratchAnim.animation.play("smile");
				if (value2 != "")
					IVScratchAnim.animation.play(value2);
				if (Std.parseInt(value1) == 1)
					scratchToggle = true;
				else
				{
					scratchToggle = false;
					IVScratchAnim.alpha = 0;
				}
			case '[IV] switch Stage Memory':
				changeStageMidway(value1);

				// This is literally so I can easily find the events section of this code
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
				// gggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	function changeStageMidway(stage:String)
	{
		StageSwitch.showStage(stage);
		trace("Reloaded stage sprites");
		boyfriendGroup.x = StageSwitch.newStageData.boyfriend[0];
		trace("set BF x position");
		boyfriendGroup.y = StageSwitch.newStageData.boyfriend[1];
		trace("set BF y position");
		dadGroup.x = StageSwitch.newStageData.opponent[0];
		trace("set opp x position");
		dadGroup.y = StageSwitch.newStageData.opponent[1];
		trace("set opp y position");
		if (StageSwitch.newStageData.hide_girlfriend)
			gfGroup.alpha = 0.0001;
		else
			gfGroup.alpha = 1;
		trace("set gf alpha");
		defaultCamZoom = StageSwitch.newStageData.defaultZoom;
		trace("set stage default zoom");
		boyfriendCameraOffset = StageSwitch.newStageData.camera_boyfriend;
		trace("set BF camera offset");
		opponentCameraOffset = StageSwitch.newStageData.camera_opponent;
		trace("set opp camera offset");
		cameraSpeed = StageSwitch.newStageData.camera_speed;
		trace("set camera speed");
	}

	function zoomOut(changeCam:Bool = true):Void
	{
		gf.animation.play('scared', true);
		gf.specialAnim = true;
		for (i in 1...stageSwitchBackgroundGroup.members.length)
		{
			FlxTween.tween(stageSwitchBackgroundGroup.members[i], {alpha: 0}, 1, {
				onComplete: function(flash:FlxTween)
				{
					// FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 0.35, externalElapsed);
					FlxTween.tween(FlxG.camera, {zoom: 0.35}, 1);
					defaultCamZoom = 0.35;
					isCameraOnForcedPos = false;
					if (changeCam)
					{
						camFollow.x = cityBG.getGraphicMidpoint().x;
						camFollow.y = cityBG.getGraphicMidpoint().y + 100;
					}
					isCameraOnForcedPos = true;
					emberEmitter.alpha.set(1, 1, 0, 0);
					fireGradient.alpha = 0.2;
				}
			});
		}
		for (i in 0...stageSwitchOverlayGroup.members.length)
		{
			// stageSwitchOverlayGroup.members[i].alpha = (i <= 1 ? 1 : 0);
			// stageSwitchOverlayGroup.members[i].alpha = FlxMath.lerp(stageSwitchOverlayGroup.members[i].alpha, (i <= 1 ? 1 : 0), externalElapsed);
			FlxTween.tween(stageSwitchOverlayGroup.members[i], {alpha: (i <= 1 ? 1 : 0)}, 1);
		}
	}

	function zoomIn():Void
	{
		for (i in 1...stageSwitchBackgroundGroup.members.length)
		{
			FlxTween.tween(stageSwitchBackgroundGroup.members[i], {alpha: 1}, 0.1, {
				onComplete: function(flash:FlxTween)
				{
					FlxG.camera.zoom = 0.7;
					defaultCamZoom = 0.7;
					isCameraOnForcedPos = false;
					moveCamera(true);
					gf.specialAnim = false;
					emberEmitter.alpha.set(0);
					fireGradient.alpha = 0;
					vignette.alpha = 0.5;
					for (strum in 0...playerStrums.members.length)
					{
						playerStrums.members[strum].alpha = 1;
					}
				}
			});
		}
		for (i in 0...stageSwitchOverlayGroup.members.length)
		{
			FlxTween.tween(stageSwitchOverlayGroup.members[i], {alpha: (i <= 1 ? 0 : 1)}, 0.1);
		}
	}

	function moveCameraSection(?id:Int = 0):Void
	{
		if (SONG.notes[id] == null)
			return;

		if (gf != null && SONG.notes[id].gfSection)
		{
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			tweenCamIn();
			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[id].mustHitSection)
		{
			moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	function warningPulse(asset:FlxSprite, maxAlp:Float, removeAsset:Bool = true)
	{
		FlxTween.tween(asset, {alpha: maxAlp}, 0.1, {
			onComplete: function(fadeOut:FlxTween)
			{
				FlxTween.tween(asset, {alpha: 0}, 0.5, {onComplete: destroyAsset.bind(_, asset, removeAsset)});
			}
		});
	}

	function clawDrain(duration:Float)
	{
		drainClaw.animation.play('preGrab');
		FlxTween.tween(drainClaw, {x: iconP1.x + 10}, 0.8, {
			ease: FlxEase.circOut,
			onComplete: function(drainHealth:FlxTween)
			{
				drainClaw.animation.play('grab');
				traumaHealthDrainBool = true;
				new FlxTimer().start(duration, function(removeClaw:FlxTimer)
				{
					traumaHealthDrainBool = false;
					drainClaw.animation.play('release');
					// drainClaw.x = FlxMath.lerp(drainClaw.x, FlxG.width, CoolUtil.boundTo(Math.sqrt(1 - (totalElapsed / 2 - 1) * (totalElapsed / 2 - 1)), 0, 1));
					FlxTween.tween(drainClaw, {x: FlxG.width}, 2, {ease: FlxEase.circOut});
				});
			}
		});
		new FlxTimer().start(0.01, function(updateClawX:FlxTimer)
		{
			if (traumaHealthDrainBool && drainClaw.exists)
				drainClaw.x = iconP1.x + 10;
		}, 0);
	}

	function generateHeart(size:Bool = true):Void
	{
		var heartAsset:FlxSprite = new FlxSprite(FlxG.random.float(0, FlxG.width), FlxG.height);
		heartAsset.frames = Paths.getSparrowAtlas('ImprovedHeartAssets');
		heartAsset.animation.addByPrefix('mini', 'heartEffect instance 1', 24);
		heartAsset.animation.addByPrefix('large', 'largeHeart', 24);
		heartAsset.animation.play(size ? 'mini' : 'large');
		heartAsset.antialiasing = ClientPrefs.globalAntialiasing;
		heartAsset.camera = camHUD;
		var scale:Float = randomisedHeartScale();
		heartAsset.scale.set(scale, scale);
		heartAsset.alpha = heartToggle ? 1 : 0;
		add(heartAsset);
		if (size)
		{
			FlxTween.tween(heartAsset, {alpha: 0, y: FlxG.random.float(0, FlxG.height / 2)}, 5, {onComplete: destroyAsset.bind(_, heartAsset)});
		}
		else
		{
			heartAsset.y = -(heartAsset.height);
			heartAsset.scale *= 1 / (2 * scale);
			FlxTween.tween(heartAsset, {y: FlxG.height, angle: FlxG.random.int(1, 3) * 360}, 8, {onComplete: destroyAsset.bind(_, heartAsset)});
		}
	}

	function destroyAsset(tween:FlxTween, asset:FlxSprite, destroy:Bool = true):Void
	{
		if (destroy)
			asset.destroy();
	}

	function randomisedHeartScale():Float
	{
		return FlxG.random.float(0.25, 1);
	}

	function randomisedRainScale():Float
	{
		return FlxG.random.float(0.1, 2);
	}

	var cameraTwn:FlxTween;

	public function moveCamera(isDad:Bool)
	{
		determineWhichZoom = isDad;
		if (isDad)
		{
			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
			tweenCamIn();
		}
		else
		{
			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {
					ease: FlxEase.elasticInOut,
					onComplete: function(twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}
	}

	function tweenCamIn()
	{
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3)
		{
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {
				ease: FlxEase.elasticInOut,
				onComplete: function(twn:FlxTween)
				{
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float)
	{
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	// Any way to do this without using a different function? kinda dumb
	private function onSongComplete()
	{
		finishSong(false);
	}

	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var finishCallback:Void->Void = endSong; // In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if (ClientPrefs.noteOffset <= 0 || ignoreNoteOffset)
		{
			finishCallback();
		}
		else
		{
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer)
			{
				finishCallback();
			});
		}
	}

	public var transitioning = false;

	public function endSong():Void
	{
		// Should kill you if you tried to cheat
		if (!startingSong)
		{
			notes.forEach(function(daNote:Note)
			{
				if (daNote.strumTime < songLength - Conductor.safeZoneOffset)
				{
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes)
			{
				if (daNote.strumTime < songLength - Conductor.safeZoneOffset)
				{
					health -= 0.05 * healthLoss;
				}
			}
			trace(health);

			if (doDeathCheck())
			{
				return;
			}
		}

		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if (achievementObj != null)
		{
			return;
		}
		else
		{
			var achieve:String = checkForAchievement([
				'week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss', 'week5_nomiss', 'week6_nomiss', 'week7_nomiss', 'ur_bad', 'ur_good', 'hype',
				'two_keys', 'toastie', 'debugger'
			]);

			if (achieve != null)
			{
				startAchievement(achieve);
				return;
			}
		}
		#end

		#if LUA_ALLOWED
		var ret:Dynamic = callOnLuas('onEndSong', []);
		#else
		var ret:Dynamic = FunkinLua.Function_Continue;
		#end

		if (ret != FunkinLua.Function_Stop && !transitioning)
		{
			if (SONG.validScore)
			{
				#if !switch
				var percent:Float = ratingPercent;
				if (Math.isNaN(percent))
					percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end
			}

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			trace(SONG.song);
			FreeplayStateNew.addSongUnlock(SONG.song);

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);
				StoryMenuStateNew.exitState[0] = storyPlaylist;
				StoryMenuStateNew.exitState[1] = campaignScore;
				StoryMenuStateNew.exitState[2] = campaignMisses;

				FlxG.save.data.exitState = StoryMenuStateNew.exitState;
				/*StoryMenuStateNew.exitState[1] = (Std.string(campaignScore));
				StoryMenuStateNew.exitState[2] = (Std.string(campaignMisses));


				if (StoryMenuStateNew.exitState != ['', '', ''])
				{
					for (i in 0...storyPlaylist.lastIndexOf(SONG.song, 0))
					{
						storyPlaylist.remove(storyPlaylist[i]);
					}
				}
				else
			 */

				if (storyPlaylist.length <= 0)
				{
					// FlxG.sound.music.fadeIn(5, 0, 1);

					cancelMusicFadeTween();
					if (FlxTransitionableState.skipNextTransIn)
					{
						CustomFadeTransition.nextCamera = null;
					}
					if (SONG.song == 'insanity-virus')
					{
						new FlxTimer().start(3, function(startEnding:FlxTimer)
						{
							FlxG.sound.play(Paths.sound('ending'), 1);
							new FlxTimer().start(4.15, function(showImage:FlxTimer)
							{
								staticEffect.cameras = [IVStaticTranCam];
								staticEffect.alpha = 0.0001;
								var endingImage:FlxSprite = new FlxSprite().loadGraphic(Paths.image("cutsceneAssets/ending"));
								endingImage.cameras = [camOther];
								add(endingImage);
								FlxTween.tween(staticEffect, {alpha: 1}, 5.54, {
									onComplete: function(end:FlxTween)
									{
										endingImage.destroy();
										staticEffect.alpha = 0.0001;
										new FlxTimer().start(1, function(switchState:FlxTimer)
										{
											FlxG.sound.playMusic(Paths.music('TIORemix'));
											MusicBeatState.switchState(new StoryMenuStateNew());
										});
									}
								});
							});
						});
					}
					else
					{
						FlxG.sound.playMusic(Paths.music('TIORemix'));
						MusicBeatState.switchState(new StoryMenuStateNew());
					}

					// if ()
					if (!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false))
					{
						StoryMenuStateNew.actCompleted.set(WeekData.weeksList[storyWeek], true);

						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						}
					}
					FlxG.save.data.actCompleted = StoryMenuStateNew.actCompleted;
					StoryMenuStateNew.exitState = [['', '', ''], 0, 0];
					FlxG.save.data.exitState = StoryMenuStateNew.exitState;
					changedDifficulty = false;
					switch (WeekData.weeksList[storyWeek])
					{
						case 'Act_1':
							TitleImages.addImagesToUnlocked(0);
							FreeplayStateNew.addSongUnlock("treasured-memories");
							FreeplayStateNew.addSongUnlock("static-torture");
						case 'Act_2':
							TitleImages.addImagesToUnlocked(1);
							FreeplayStateNew.addSongUnlock("fabula-amoris");
							FreeplayStateNew.addSongUnlock("left-for-dead");
					}
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					var winterHorrorlandNext = (Paths.formatToSongPath(SONG.song) == "eggnog");
					if (winterHorrorlandNext)
					{
						var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
							-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
						blackShit.scrollFactor.set();
						add(blackShit);
						camHUD.visible = false;

						FlxG.sound.play(Paths.sound('Lights_Shut_off'));
					}

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					if (winterHorrorlandNext)
					{
						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							cancelMusicFadeTween();
							LoadingState.loadAndSwitchState(new PlayState());
						});
					}
					else
					{
						cancelMusicFadeTween();
						LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				var titleImageInt:Int = 0;
				switch (SONG.song.toLowerCase())
				{
					case "treasured-memories":
						titleImageInt = 2;
					case "static-torture":
						titleImageInt = 3;
					case "fabula-amoris":
						titleImageInt = 4;
					case "left-for-dead":
						titleImageInt = 5;
				}
				if (titleImageInt != 0)
					TitleImages.addImagesToUnlocked(titleImageInt);
				cancelMusicFadeTween();
				if (FlxTransitionableState.skipNextTransIn)
				{
					CustomFadeTransition.nextCamera = null;
				}
				if (SONG.song == 'static-torture')
				{
					lime.app.Application.current.window.close();
				}
				else
					MusicBeatState.switchState(new FreeplayStateNew(), false);
				FlxG.sound.playMusic(Paths.music('TIORemix'));
				// FlxG.sound.music.fadeIn(5, 0, 1);
				changedDifficulty = false;
			}
			FlxG.save.flush();
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;

	function startAchievement(achieve:String)
	{
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}

	function achievementEnd():Void
	{
		achievementObj = null;
		if (endingSong && !inCutscene)
		{
			endSong();
		}
	}
	#end

	public function KillNotes()
	{
		while (notes.length > 0)
		{
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;
	public var showCombo:Bool = true;
	public var showRating:Bool = true;

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		// trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		// boyfriend.playAnim('hey');
		vocals.volume = 0.75;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, healthBarBG.y - 20, 0, placement, 32);
		// coolText.screenCenter();
		coolText.x = healthBarBG.x + healthBarBG.width + 20;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		// tryna do MS based judgment due to popular demand
		var daRating:String = Conductor.judgeNote(note, noteDiff);

		switch (daRating)
		{
			case "shit": // shit
				totalNotesHit += 0;
				note.ratingMod = 0;
				score = 50;
				if (!note.ratingDisabled)
					shits++;
			case "bad": // bad
				totalNotesHit += 0.5;
				note.ratingMod = 0.5;
				score = 100;
				if (!note.ratingDisabled)
					bads++;
			case "good": // good
				totalNotesHit += 0.75;
				note.ratingMod = 0.75;
				score = 200;
				if (!note.ratingDisabled)
					goods++;
			case "sick": // sick
				totalNotesHit += 1;
				note.ratingMod = 1;
				if (!note.ratingDisabled)
					sicks++;
		}
		note.rating = daRating;

		if (daRating == 'sick' && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}

		if (!practiceMode && !cpuControlled)
		{
			songScore += score;
			if (!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating();
			}

			if (ClientPrefs.scoreZoom)
			{
				if (scoreTxtTween != null)
				{
					scoreTxtTween.cancel();
				}
				scoreTxt.scale.x = 1.075;
				scoreTxt.scale.y = 1.075;
				scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
					onComplete: function(twn:FlxTween)
					{
						scoreTxtTween = null;
					}
				});
			}
		}

		/* if (combo > 60)
			daRating = 'sick';
		else if (combo > 12)
			daRating = 'good'
		else if (combo > 4)
			daRating = 'bad';
	 */

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.cameras = [camHUD];
		rating.screenCenter();
		if (SONG.song != 'fabula-amoris')
			rating.x = coolText.x - 40;
		rating.y = healthBarBG.y + (ClientPrefs.downScroll ? 100 : -100);
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = (!ClientPrefs.hideHud && showRating);
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= ClientPrefs.comboOffset[1];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.cameras = [camHUD];
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;
		comboSpr.visible = false;
		comboSpr.x += ClientPrefs.comboOffset[0];
		comboSpr.y -= ClientPrefs.comboOffset[1];

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		insert(members.indexOf(strumLineNotes), rating);

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.85));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if (combo >= 1000)
		{
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.cameras = [camHUD];
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.x += ClientPrefs.comboOffset[2];
			numScore.y -= ClientPrefs.comboOffset[3];

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.visible = false;

			// if (combo >= 10 || combo == 0)
			insert(members.indexOf(strumLineNotes), numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: destroyAsset.bind(_, numScore),
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
		trace(combo);
		trace(seperatedScore);
	 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		// trace('Pressed: ' + eventKey);

		if (!cpuControlled && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode))
		{
			if (!boyfriend.stunned && generatedMusic && !endingSong)
			{
				// more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				// var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote)
					{
						if (daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
							// notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort((a, b) -> Std.int(a.strumTime - b.strumTime));

				if (sortedNotesList.length > 0)
				{
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes)
						{
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1)
							{
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							}
							else
								notesStopped = true;
						}

						// eee jack detection before was not super good
						if (!notesStopped)
						{
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}
					}
				}
				else if (canMiss)
				{
					noteMissPress(key);
					callOnLuas('noteMissPress', [key]);
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;

				// more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if (SONG.song == 'fabula-amoris')
				spr = doubleStrums.members[key];
			if (spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		// trace('pressed: ' + controlArray);
	}

	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if (!cpuControlled && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if (SONG.song == 'fabula-amoris')
				spr = doubleStrums.members[key];
			if (spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		// trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if (key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if (key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keyShit():Void
	{
		// HOLDING

		var controlHoldArray:Array<Bool>;

		if (!toggleDouble)
		{
			var up = controls.NOTE_UP;
			var right = controls.NOTE_RIGHT;
			var down = controls.NOTE_DOWN;
			var left = controls.NOTE_LEFT;
			controlHoldArray = [left, down, up, right];
		}
		else
		{
			var leftUp = controls.LEFT_UP;
			var leftRight = controls.LEFT_RIGHT;
			var leftDown = controls.LEFT_DOWN;
			var leftLeft = controls.LEFT_LEFT;
			var rightUp = controls.RIGHT_UP;
			var rightRight = controls.RIGHT_RIGHT;
			var rightDown = controls.RIGHT_DOWN;
			var rightLeft = controls.RIGHT_LEFT;
			controlHoldArray = [rightLeft, rightDown, rightUp, rightRight, leftLeft, leftDown, leftUp, leftRight];
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if (ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [
				controls.NOTE_LEFT_P,
				controls.NOTE_DOWN_P,
				controls.NOTE_UP_P,
				controls.NOTE_RIGHT_P
			];
			if (controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if (controlArray[i])
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (!boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (daNote.isSustainNote && controlHoldArray[daNote.noteData] && daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit)
				{
					goodNoteHit(daNote);
				}
			});

			if (controlHoldArray.contains(true) && !endingSong)
			{
				#if ACHIEVEMENTS_ALLOWED
				var achieve:String = checkForAchievement(['oversinging']);
				if (achieve != null)
				{
					startAchievement(achieve);
				}
				#end
			}
			else if (boyfriend.holdTimer > Conductor.stepCrochet * 0.001 * boyfriend.singDuration
				&& boyfriend.animation.curAnim.name.startsWith('sing')
				&& !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.dance();
				if (curStage == 'peace')
					layeredBF.dance();
				// boyfriend.animation.curAnim.finish();
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if (ClientPrefs.controllerMode)
		{
			var controlArray:Array<Bool> = [
				controls.NOTE_LEFT_R,
				controls.NOTE_DOWN_R,
				controls.NOTE_UP_R,
				controls.NOTE_RIGHT_R
			];
			if (controlArray.contains(true))
			{
				for (i in 0...controlArray.length)
				{
					if (controlArray[i])
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
	}

	function noteMiss(daNote:Note):Void
	{ // You didn't hit the key and let it go offscreen, also used by Hurt Notes
		// Dupe note remove
		notes.forEachAlive(function(note:Note)
		{
			if (daNote != note
				&& daNote.mustPress
				&& daNote.noteData == note.noteData
				&& daNote.isSustainNote == note.isSustainNote
				&& Math.abs(daNote.strumTime - note.strumTime) < 1)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		combo = 0;

		if (SONG.song == 'insanity-virus' || SONG.song == 'left-for-dead')
		{
			flashVirus.virusFlash("failure", false);
		}

		if (daNote.noteType == 'FA Blake Note')
		{
			FAmissCount[0]++;
			FlxTween.shake(blakeHeart, 0.05, 0.25);
			if (FAmissCount[0] % 4 == 0 && FAmissCount[0] <= 24)
			{
				blakeHeart.curBreakState++;
				blakeHeart.updateBreakState();
			}
		}
		else if (daNote.noteType == 'FA Sophie Note')
		{
			FAmissCount[1]++;
			FlxTween.shake(sophieHeart, 0.05, 0.25);
			if (FAmissCount[1] % 4 == 0 && FAmissCount[1] <= 24)
			{
				sophieHeart.curBreakState++;
				sophieHeart.updateBreakState();
			}
		}
		else
			health -= daNote.missHealth * healthLoss;
		if (instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}

		// For testing purposes
		// trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		if (!practiceMode)
			songScore -= 10;

		totalPlayed++;
		RecalculateRating();

		var char:Character = boyfriend;
		if (daNote.gfNote)
		{
			char = gf;
		}
		else if (daNote.noteType == 'FA Blake Note')
			char = dad;

		if (char != null && char.hasMissAnimations)
		{
			var daAlt = '';
			if (daNote.noteType == 'Alt Animation')
				daAlt = '-alt';

			var animToPlay:String = singAnimations[Std.int(Math.abs(daNote.noteData))] + 'miss' + daAlt;
			char.playAnim(animToPlay, true);
			if (curStage == 'peace')
				layeredBF.playAnim(animToPlay, true);
		}

		callOnLuas('noteMiss', [
			notes.members.indexOf(daNote),
			daNote.noteData,
			daNote.noteType,
			daNote.isSustainNote
		]);
	}

	function noteMissPress(direction:Int = 1):Void // You pressed a key when there was no notes to press for this key
	{
		if (!boyfriend.stunned)
		{
			health -= 0.05 * healthLoss;
			if (instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}

			if (ClientPrefs.ghostTapping)
				return;

			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			if (!practiceMode)
				songScore -= 10;
			if (!endingSong)
			{
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating();

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
		});*/

			if (boyfriend.hasMissAnimations)
			{
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
				if (curStage == 'peace')
					layeredBF.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			vocals.volume = 0;
		}
	}

	function opponentNoteHit(note:Note):Void
	{
		if (Paths.formatToSongPath(SONG.song) != 'tutorial')
			camZooming = true;

		if (note.noteType == 'Hey!' && dad.animOffsets.exists('hey'))
		{
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		}
		else if (!note.noAnimation)
		{
			var altAnim:String = "";

			var curSection:Int = Math.floor(curStep / 16);
			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim || note.noteType == 'Alt Animation')
				{
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))] + altAnim;
			if (note.gfNote)
			{
				char = gf;
			}
			else if (note.noteType == 'FA Sophie Note')
				char = boyfriend;

			if (char != null)
			{
				if (note.animation.curAnim.name.endsWith('hold'))
				{
					if (!char.animation.curAnim.name.endsWith('-loop'))
					{
						char.playAnim(animToPlay + '-loop', true);
						if (curStage == 'peace')
						{
							layeredDad.playAnim(animToPlay + '-loop', true);
						}
					}
				}
				else if (note.animation.curAnim.name.endsWith('end'))
				{
					char.playAnim(animToPlay, true, false, 3);
					if (curStage == 'peace')
						layeredDad.playAnim(animToPlay, true, false, 3);
				}
				else
				{
					char.playAnim(animToPlay, true);
					if (curStage == 'peace')
						layeredDad.playAnim(animToPlay, true);
				}

				char.holdTimer = 0;
				if (curStage == 'peace')
					layeredDad.holdTimer = 0;
			}

			if (char.curCharacter == 'spirit-blake' && note.animation.curAnim.name.endsWith('Scroll'))
			{
				// trace((Math.floor(note.sustainLength / Conductor.stepCrochet) * Conductor.stepCrochet + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)))/1000);
				FlxTween.cancelTweensOf(char);
				char.alpha = 0.25;
				// FlxTween.tween(char, {alpha: 0}, Conductor.stepCrochet * 0.001 * 3.75);
				FlxTween.tween(char, {alpha: 0},
					(note.sustainLength > 0 ? ((Math.floor(note.sustainLength / Conductor.stepCrochet) * Conductor.stepCrochet
						+ (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2))) / 1000)
						+ Conductor.stepCrochet * 0.001 * 3.75 : Conductor.stepCrochet * 0.001 * 3.75));
			}
		}

		if (SONG.needsVoices)
			vocals.volume = 0.75;

		var time:Float = 0.15;
		if (note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
		{
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % 4, time);
		note.hitByOpponent = true;

		callOnLuas('opponentNoteHit', [
			notes.members.indexOf(note),
			Math.abs(note.noteData),
			note.noteType,
			note.isSustainNote
		]);

		if (note.animation.curAnim.name.endsWith('Scroll'))
		{
			if (note.isSustainNote)
			{
				pulseSideBars(note.noteData, opponentBarGroup, true);
				pulseVert(note.noteData + 1, upperOppGroup, 1, note.sustainLength);
				pulseVert(note.noteData + 1, lowerOppGroup, -1, note.sustainLength);
			}
			else
			{
				pulseSideBars(note.noteData + 1, opponentBarGroup, true);
				pulseVert(note.noteData + 1, upperOppGroup);
				pulseVert(note.noteData + 1, lowerOppGroup, -1);
			}
		}

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (SONG.song == 'fabula-amoris' && !camZooming)
			{
				camZooming = true;
			}
			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if (cpuControlled && (note.ignoreNote || note.hitCausesMiss))
				return;

			if (note.hitCausesMiss)
			{
				noteMiss(note);
				if (!note.noteSplashDisabled && !note.isSustainNote)
				{
					spawnNoteSplashOnNote(note);
				}

				switch (note.noteType)
				{
					case 'Hurt Note': // Hurt note
						if (boyfriend.animation.getByName('hurt') != null)
						{
							boyfriend.playAnim('hurt', true);
							boyfriend.specialAnim = true;
						}
				}

				note.wasGoodHit = true;

				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (note.animation.curAnim.name.endsWith('Scroll'))
			{
				pulseSideBars(note.noteData + 1, playerBarGroup);
				if (note.isSustainNote)
				{
					pulseVert(note.noteData + 1, upperPlayerGroup, 1, note.sustainLength);
					pulseVert(note.noteData + 1, lowerPlayerGroup, -1, note.sustainLength);
				}
				else
				{
					pulseVert(note.noteData + 1, upperPlayerGroup);
					pulseVert(note.noteData + 1, lowerPlayerGroup, -1);
				}
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				popUpScore(note);
				if (combo > 9999)
					combo = 9999;
			}
			health += note.hitHealth * healthGain;

			if (!note.noAnimation)
			{
				var daAlt = '';
				if (note.noteType == 'Alt Animation')
					daAlt = '-alt';

				var animToPlay:String = singAnimations[Std.int(Math.abs(note.noteData))];

				if (SONG.song == 'fabula-amoris' && note.noteData >= 4)
				{
					animToPlay = singAnimations[Std.int(Math.abs(note.noteData - 4))];
				}

				if (note.gfNote)
				{
					if (gf != null)
					{
						gf.playAnim(animToPlay + daAlt, true);
						gf.holdTimer = 0;
					}
				}
				else if (note.noteType == 'FA Blake Note')
				{
					if (note.animation.curAnim.name.endsWith('hold'))
					{
						if (!dad.animation.curAnim.name.endsWith('-loop'))
						{
							dad.playAnim(animToPlay + daAlt + '-loop', true);
						}
					}
					else if (note.animation.curAnim.name.endsWith('end'))
					{
						dad.playAnim(animToPlay + daAlt, true, false, 3);
						dad.holdTimer = 0;
					}
					else
					{
						dad.playAnim(animToPlay + daAlt, true);
					}
				}
				else if (note.noteType == 'FA Double Note')
				{
					boyfriend.playAnim(animToPlay + daAlt, true);
					dad.playAnim(animToPlay + daAlt, true);
					dad.holdTimer = 0;
				}
				else if (note.animation.curAnim.name.endsWith('hold'))
				{
					if (!boyfriend.animation.curAnim.name.endsWith('-loop'))
					{
						boyfriend.playAnim(animToPlay + daAlt + '-loop', true);
						if (curStage == 'peace')
						{
							layeredBF.playAnim(animToPlay + daAlt + '-loop', true);
						}
					}
				}
				else if (note.animation.curAnim.name.endsWith('end'))
				{
					boyfriend.playAnim(animToPlay + daAlt, true, false, 3);
					if (curStage == 'peace')
					{
						layeredBF.playAnim(animToPlay + daAlt, true, false, 3);
					}
				}
				else
				{
					boyfriend.playAnim(animToPlay + daAlt, true);
					if (curStage == 'peace')
					{
						layeredBF.playAnim(animToPlay + daAlt, true);
					}
				}

				if (note.noteType != 'FA Blake Note')
				{
					boyfriend.holdTimer = 0;
					if (curStage == 'peace')
					{
						layeredBF.holdTimer = 0;
					}
				}
				else
				{
					dad.holdTimer = 0;
				}

				if (note.noteType == 'Hey!')
				{
					if (boyfriend.animOffsets.exists('hey'))
					{
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}

					if (gf != null && gf.animOffsets.exists('cheer'))
					{
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if (cpuControlled)
			{
				var time:Float = 0.15;
				if (note.isSustainNote && !note.animation.curAnim.name.endsWith('end'))
				{
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)) % (note.noteData >= 4 ? 8 : 4), time);
			}
			else
			{
				if (SONG.song == 'fabula-amoris')
				{
					for (i in 0...doubleStrums.members.length) {
						if (Math.abs(note.noteData) == i) {
							doubleStrums.members[i].playAnim('confirm', true);
						}
					}
				}
				else
				{
					playerStrums.forEach(function(spr:StrumNote)
					{
						if (Math.abs(note.noteData) == spr.ID)
						{
							spr.playAnim('confirm', true);
						}
					});
				}
			}
			note.wasGoodHit = true;
			vocals.volume = 0.75;

			var isSus:Bool = note.isSustainNote; // GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	function spawnNoteSplashOnNote(note:Note)
	{
		if (ClientPrefs.noteSplashes && note != null)
		{
			var strum:StrumNote = playerStrums.members[note.noteData];
			if (SONG.song == 'fabula-amoris')
				strum = doubleStrums.members[note.noteData];
			if (strum != null)
			{
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null)
	{
		var skin:String = 'noteSplashes';
		if (PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0)
			skin = PlayState.SONG.splashSkin;

		var hue:Float = ClientPrefs.arrowHSV[data % 4][0] / 360;
		var sat:Float = ClientPrefs.arrowHSV[data % 4][1] / 100;
		var brt:Float = ClientPrefs.arrowHSV[data % 4][2] / 100;
		if (note != null)
		{
			skin = note.noteSplashTexture;
			hue = note.noteSplashHue;
			sat = note.noteSplashSat;
			brt = note.noteSplashBrt;
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data >= 4 ? data - 4 : data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	var fastCarCanDrive:Bool = true;

	function resetFastCar():Void
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var carTimer:FlxTimer;

	function fastCarDrive()
	{
		// trace('Car drive');
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		carTimer = new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
			carTimer = null;
		});
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;
	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			if (gf != null)
			{
				gf.playAnim('hairBlow');
				gf.specialAnim = true;
			}
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		if (gf != null)
		{
			gf.danced = false; // Sets head to the correct position once the animation ends
			gf.playAnim('hairFall');
			gf.specialAnim = true;
		}
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		if (!ClientPrefs.lowQuality)
			halloweenBG.animation.play('halloweem bg lightning strike');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		if (boyfriend.animOffsets.exists('scared'))
		{
			boyfriend.playAnim('scared', true);
		}

		if (gf != null && gf.animOffsets.exists('scared'))
		{
			gf.playAnim('scared', true);
		}

		if (ClientPrefs.camZooms)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;

			if (!camZooming)
			{ // Just a way for preventing it to be permanently zoomed until Skid & Pump hits a note
				FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 0.5);
				FlxTween.tween(camHUD, {zoom: 1}, 0.5);
			}
		}

		if (ClientPrefs.flashing)
		{
			halloweenWhite.alpha = 0.4;
			FlxTween.tween(halloweenWhite, {alpha: 0.5}, 0.075);
			FlxTween.tween(halloweenWhite, {alpha: 0}, 0.25, {startDelay: 0.15});
		}
	}

	function killHenchmen():Void
	{
		if (!ClientPrefs.lowQuality && ClientPrefs.violence && curStage == 'limo')
		{
			if (limoKillingState < 1)
			{
				limoMetalPole.x = -400;
				limoMetalPole.visible = true;
				limoLight.visible = true;
				limoCorpse.visible = false;
				limoCorpseTwo.visible = false;
				limoKillingState = 1;

				#if ACHIEVEMENTS_ALLOWED
				Achievements.henchmenDeath++;
				FlxG.save.data.henchmenDeath = Achievements.henchmenDeath;
				var achieve:String = checkForAchievement(['roadkill_enthusiast']);
				if (achieve != null)
				{
					startAchievement(achieve);
				}
				else
				{
					FlxG.save.flush();
				}
				FlxG.log.add('Deaths: ' + Achievements.henchmenDeath);
				#end
			}
		}
	}

	function resetLimoKill():Void
	{
		if (curStage == 'limo')
		{
			limoMetalPole.x = -500;
			limoMetalPole.visible = false;
			limoLight.x = -500;
			limoLight.visible = false;
			limoCorpse.x = -500;
			limoCorpse.visible = false;
			limoCorpseTwo.x = -500;
			limoCorpseTwo.visible = false;
		}
	}

	private var preventLuaRemove:Bool = false;

	override function destroy()
	{
		preventLuaRemove = true;
		for (i in 0...luaArray.length)
		{
			luaArray[i].call('onDestroy', []);
			luaArray[i].stop();
		}
		luaArray = [];

		if (!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}
		super.destroy();
	}

	public static function cancelMusicFadeTween()
	{
		if (FlxG.sound.music.fadeTween != null)
		{
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	public function removeLua(lua:FunkinLua)
	{
		if (luaArray != null && !preventLuaRemove)
		{
			luaArray.remove(lua);
		}
	}

	var lastStepHit:Int = -1;

	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		if (scratchToggle)
		{
			IVScratchAnim.x += FlxG.random.int(-10, 10);
			if (curStep % 5 == 0 || curStep % 3 == 0)
				IVScratchAnim.alpha = 0.001;
			else
				IVScratchAnim.alpha = 1;
		}

		if (curStep == lastStepHit)
		{
			return;
		}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;
	var lastBeatHit:Int = -1;

	override function beatHit()
	{
		super.beatHit();

		if (lastBeatHit >= curBeat)
		{
			// trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		if (SONG.notes[Math.floor(curStep / 16)] != null)
		{
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				// FlxG.log.add('CHANGED BPM!');
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[Math.floor(curStep / 16)].mustHitSection);
			setOnLuas('altAnim', SONG.notes[Math.floor(curStep / 16)].altAnim);
			setOnLuas('gfSection', SONG.notes[Math.floor(curStep / 16)].gfSection);
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null && !endingSong && !isCameraOnForcedPos)
		{
			moveCameraSection(Std.int(curStep / 16));
		}
		if (ERDrop)
		{
			if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 1 == 0)
			{
				FlxG.camera.zoom += 0.05;
				camHUD.zoom += 0.08;
			}
		}
		else
		{
			if (camZooming && FlxG.camera.zoom < 1.35 && ClientPrefs.camZooms && curBeat % 4 == 0)
			{
				FlxG.camera.zoom += 0.015;
				camHUD.zoom += 0.03;
			}
		}

		if (colourPulseTrigger)
		{
			FlxTween.cancelTweensOf(pulseSprite);
			pulseSprite.animation.play(Std.string(FlxG.random.int(1, 6)));
			pulseSprite.alpha = 0.25;
			FlxTween.tween(pulseSprite, {alpha: 0}, 0.25);
		}

		iconP1.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (gf != null
			&& curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0
			&& !gf.stunned
			&& gf.animation.curAnim.name != null
			&& !gf.animation.curAnim.name.startsWith("sing")
			&& !gf.stunned)
		{
			gf.dance();
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0
			&& boyfriend.animation.curAnim != null
			&& !boyfriend.animation.curAnim.name.startsWith('sing')
			&& !boyfriend.stunned)
		{
			boyfriend.dance();
			if (curStage == 'peace')
				layeredBF.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0
			&& dad.animation.curAnim != null
			&& !dad.animation.curAnim.name.startsWith('sing')
			&& !dad.stunned)
		{
			dad.dance();
			if (curStage == 'peace')
				layeredDad.dance();
		}
		switch (curStage)
		{
			case 'school':
				if (!ClientPrefs.lowQuality)
				{
					bgGirls.dance();
				}

			case 'mall':
				if (!ClientPrefs.lowQuality)
				{
					upperBoppers.dance(true);
				}

				if (heyTimer <= 0)
					bottomBoppers.dance(true);
				santa.dance(true);

			case 'limo':
				if (!ClientPrefs.lowQuality)
				{
					grpLimoDancers.forEach(function(dancer:BackgroundDancer)
					{
						dancer.dance();
					});
				}

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:BGSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1, [curLight]);

					phillyCityLights.members[curLight].visible = true;
					phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (curStage == 'spooky' && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat); // DAWGG?????
		callOnLuas('onBeatHit', []);
	}

	public var closeLuas:Array<FunkinLua> = [];

	public function callOnLuas(event:String, args:Array<Dynamic>):Dynamic
	{
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		for (i in 0...luaArray.length)
		{
			var ret:Dynamic = luaArray[i].call(event, args);
			if (ret != FunkinLua.Function_Continue)
			{
				returnVal = ret;
			}
		}

		for (i in 0...closeLuas.length)
		{
			luaArray.remove(closeLuas[i]);
			closeLuas[i].stop();
		}
		#end
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic)
	{
		#if LUA_ALLOWED
		for (i in 0...luaArray.length)
		{
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float)
	{
		var spr:StrumNote = null;
		if (SONG.song == 'fabula-amoris')
			spr = doubleStrums.members[id];
		else
		{
			if (isDad)
			{
				spr = strumLineNotes.members[id];
			}
			else
			{
				spr = playerStrums.members[id];
			}
		}

		if (spr != null)
		{
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;

	public function RecalculateRating()
	{
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', []);
		if (ret != FunkinLua.Function_Stop)
		{
			if (totalPlayed < 1) // Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				// trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if (ratingPercent >= 1)
				{
					ratingName = ratingStuff[ratingStuff.length - 1][0]; // Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length - 1)
					{
						if (ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
				}
			}

			// Rating FC
			ratingFC = "";
			if (sicks > 0)
				ratingFC = "SFC";
			if (goods > 0)
				ratingFC = "GFC";
			if (bads > 0 || shits > 0)
				ratingFC = "FC";
			if (songMisses > 0 && songMisses < 10)
				ratingFC = "SDCB";
			else if (songMisses >= 10)
				ratingFC = "Clear";
		}
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		if (chartingMode)
			return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		for (i in 0...achievesToCheck.length)
		{
			var achievementName:String = achievesToCheck[i];
			if (!Achievements.isAchievementUnlocked(achievementName) && !cpuControlled)
			{
				var unlock:Bool = false;
				switch (achievementName)
				{
					case 'week1_nomiss' | 'week2_nomiss' | 'week3_nomiss' | 'week4_nomiss' | 'week5_nomiss' | 'week6_nomiss' | 'week7_nomiss':
						if (isStoryMode
							&& campaignMisses + songMisses < 1
							&& CoolUtil.difficultyString() == 'HARD'
							&& storyPlaylist.length <= 1
							&& !changedDifficulty
							&& !usedPractice)
						{
							var weekName:String = WeekData.getWeekFileName();
							switch (weekName) // I know this is a lot of duplicated code, but it's easier readable and you can add weeks with different names than the achievement tag
							{
								case 'week1':
									if (achievementName == 'week1_nomiss') unlock = true;
								case 'week2':
									if (achievementName == 'week2_nomiss') unlock = true;
								case 'week3':
									if (achievementName == 'week3_nomiss') unlock = true;
								case 'week4':
									if (achievementName == 'week4_nomiss') unlock = true;
								case 'week5':
									if (achievementName == 'week5_nomiss') unlock = true;
								case 'week6':
									if (achievementName == 'week6_nomiss') unlock = true;
								case 'week7':
									if (achievementName == 'week7_nomiss') unlock = true;
							}
						}
					case 'ur_bad':
						if (ratingPercent < 0.2 && !practiceMode)
						{
							unlock = true;
						}
					case 'ur_good':
						if (ratingPercent >= 1 && !usedPractice)
						{
							unlock = true;
						}
					case 'roadkill_enthusiast':
						if (Achievements.henchmenDeath >= 100)
						{
							unlock = true;
						}
					case 'oversinging':
						if (boyfriend.holdTimer >= 10 && !usedPractice)
						{
							unlock = true;
						}
					case 'hype':
						if (!boyfriendIdled && !usedPractice)
						{
							unlock = true;
						}
					case 'two_keys':
						if (!usedPractice)
						{
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length)
							{
								if (keysPressed[j])
									howManyPresses++;
							}

							if (howManyPresses <= 2)
							{
								unlock = true;
							}
						}
					case 'toastie':
						if (/*ClientPrefs.framerate <= 60 &&*/ ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing && !ClientPrefs.imagesPersist)
						{
							unlock = true;
						}
					case 'debugger':
						if (Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice)
						{
							unlock = true;
						}
				}

				if (unlock)
				{
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}
	#end

	var curLight:Int = 0;
	var curLightEvent:Int = 0;

	function setPrimaryBars(group:FlxTypedGroup<FlxSprite>)
	{
		for (i in 1...5)
		{
			primaryBarArray.push(group.members[Std.int(((group.members.length - 1) / 5) * i)].ID);
		}
	}

	function setPrimaryVerticalBars(group:FlxSpriteGroup)
	{
		for (i in 1...5)
		{
			primaryVertBarArray.push(group.members[Std.int(((group.members.length - 1) / 5) * i)].ID);
		}
	}

	function pulseSideBars(primary:Int, group:FlxTypedGroup<FlxSprite>, ?isOpp:Bool = false)
	{
		if (!sideBarToggle)
			return;

		group.forEach(function(bar:FlxSprite)
		{
			FlxTween.cancelTweensOf(bar);
			if (isOpp)
			{
				FlxTween.tween(bar, {
					x: bar.x + ((2 * bar.width / 3) * Math.pow(0.9, Math.abs(bar.ID - primaryBarArray[primary - 1] * 2)))
				},
					Math.abs(Math.cos(Math.pow(0.9, (bar.ID - primaryBarArray[primary - 1] * 2)))) / 10, {
						ease: FlxEase.circOut,
						onComplete: function(returnTo:FlxTween)
						{
							FlxTween.tween(bar, {x: 0 - bar.width}, Math.abs(Math.sin(Math.pow(0.9, (bar.ID - primaryBarArray[primary - 1] * 2)))),
								{ease: FlxEase.circOut});
						}
					});
			}
			else
			{
				FlxTween.tween(bar, {
					x: bar.x - ((2 * bar.width / 3) * Math.pow(0.9, Math.abs(2 * bar.ID - primaryBarArray[primary - 1] * 2)))
				},
					Math.abs(Math.cos(Math.pow(0.9, (2 * bar.ID - primaryBarArray[primary - 1] * 2)))) / 10, {
						ease: FlxEase.circOut,
						onComplete: function(returnTo:FlxTween)
						{
							FlxTween.tween(bar, {x: FlxG.width}, Math.abs(Math.sin(Math.pow(0.9, (2 * bar.ID - primaryBarArray[primary - 1] * 2)))),
								{ease: FlxEase.circOut});
						}
					});
			}
		});
	}

	function pulseVert(PrID:Int, group:FlxSpriteGroup, ?direction:Int = 1, ?holdDuration:Float = 0)
	{
		if (verticalToggle)
		{
			group.forEach(function(verticalBar:FlxSprite)
			{
				FlxTween.cancelTweensOf(verticalBar);
				FlxTween.tween(verticalBar, {
					y: verticalBar.y - direction * (1.5 * (verticalBar.height / 3) * Math.pow(0.7, Math.abs(verticalBar.ID - primaryVertBarArray[PrID - 1])))
				},
					Math.abs(Math.cos(Math.pow(0.9, (verticalBar.ID - primaryVertBarArray[PrID - 1])))) / 20, {
						ease: FlxEase.circOut,
						onComplete: function(returnBar:FlxTween)
						{
							if (holdDuration == 0)
							{
								// verticalBar.y = FlxMath.lerp(verticalBar.y, ((direction > 0) ? FlxG.height / 2 : 0), (Math.abs(Math.cos(Math.pow(1.9, (verticalBar.ID - primaryVertBarArray[PrID - 1])))) / 10) * totalElapsed);
								FlxTween.tween(verticalBar, {y: ((direction > 0) ? FlxG.height / 2 : 0)},
									Math.abs(Math.cos(Math.pow(1.9, (verticalBar.ID - primaryVertBarArray[PrID - 1])))) / 10);
							}
							else
							{
								FlxTween.tween(verticalBar, {y: verticalBar.y + direction * (20)}, holdDuration, {
									onComplete: function(nor:FlxTween)
									{
										FlxTween.tween(verticalBar, {y: ((direction > 0) ? FlxG.height / 2 : 0)},
											Math.abs(Math.cos(Math.pow(0.9, (verticalBar.ID - primaryVertBarArray[PrID - 1])))) / 10);
									}
								});
							}
						}
					});
			});
		}
	}
}
