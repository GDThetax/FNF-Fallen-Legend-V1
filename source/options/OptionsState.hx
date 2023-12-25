package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class OptionsState extends MusicBeatState
{
	var options:Array<String> = [
		'Controls',
		'Adjust Delay and Combo',
		'Graphics',
		'Visuals and UI',
		'Gameplay'
	];
	private var grpOptions:FlxTypedGroup<Alphabet>;

	private static var curSelected:Int = 0;
	public static var menuBG:FlxSprite;

	var screenStatic:FlxSprite;
	var blackScreen:FlxSprite;

	var fadedMenuItems:Array<String> = ["story", "freeplay", "options", "credits"];
	var fadedItemsGroup:FlxTypedGroup<FlxSprite>;
	var yPosition:Float = 100;

	function openSelectedSubstate(label:String)
	{
		blackBG.alpha = 1;
		switch (label)
		{
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
		}
	}

	var selectorLeft:Alphabet;
	var selectorRight:Alphabet;
	var blackBG:FlxSprite;

	override function openSubState(SubState:FlxSubState)
	{
		super.openSubState(SubState);
	}

	override function create()
	{
		blackBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackBG.alpha = 0;
		// openSubState(new MenuOverlaySubState(0, 0));
		fadedItemsGroup = new FlxTypedGroup<FlxSprite>();
		destroySubStates = false;
		MenuOverlaySubState.openedState = "options";
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end

		screenStatic = new FlxSprite().loadGraphic(Paths.image('commonAssets/ScreenStatic'));
		screenStatic.antialiasing = ClientPrefs.globalAntialiasing;
		screenStatic.scale.set((1 / 3), (1 / 3));
		screenStatic.updateHitbox();
		screenStatic.alpha = 0.15;
		screenStatic.blend = MULTIPLY;

		new FlxTimer().start(0.01, function(staticMovement:FlxTimer)
		{
			screenStatic.x = new FlxRandom().float(-1280, 0);
			screenStatic.y = new FlxRandom().float(-360, 0);
		}, 0);
		// add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...options.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, options[i], true, false, 0, 0.5);
			optionText.screenCenter();
			optionText.x += 100;
			optionText.y += (100 * (i - (options.length / 2))) + 50;
			grpOptions.add(optionText);
		}

		selectorLeft = new Alphabet(0, 0, '>', true, false, 0, 0.5);
		add(selectorLeft);
		selectorRight = new Alphabet(0, 0, '<', true, false, 0, 0.5);
		add(selectorRight);

		changeSelection();
		ClientPrefs.saveSettings();

		super.create();

		blackScreen = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		add(blackScreen);
		FlxTween.tween(blackScreen, {alpha: 0}, 2);

		var sideBarLower:FlxSprite = new FlxSprite(-200, -50).loadGraphic(Paths.image("ui/MenuOverlay/MenuOverlayLower"));
		var sideBarUpper:FlxSprite = new FlxSprite(-275, -50).loadGraphic(Paths.image("ui/MenuOverlay/MenuOverlayUpper"));
		sideBarLower.antialiasing = ClientPrefs.globalAntialiasing;
		sideBarUpper.antialiasing = ClientPrefs.globalAntialiasing;
		sideBarLower.scale.set((1 / 3), (1 / 3));
		sideBarUpper.scale.set((1 / 3), (1 / 3));
		sideBarLower.updateHitbox();
		sideBarUpper.updateHitbox();
		sideBarLower.alpha = 0.5;
		sideBarUpper.alpha = 0.5;

		for (i in 0...fadedMenuItems.length)
		{
			var fadedItem:FlxSprite = new FlxSprite();
			fadedItem.antialiasing = ClientPrefs.globalAntialiasing;
			fadedItem.scale.set((1 / 3), (1 / 3));
			fadedItem.updateHitbox();
			fadedItem.x = -670;
			fadedItem.frames = Paths.getSparrowAtlas('ui/MenuOverlay/MenuButtonsFaded');
			fadedItem.animation.addByPrefix('idle', fadedMenuItems[i] + '_unselected', 24);
			fadedItem.animation.play('idle');
			fadedItem.ID = i;
			fadedItemsGroup.add(fadedItem);
		}

		add(sideBarLower);
		add(sideBarUpper);
		add(fadedItemsGroup);

		fadedItemsGroup.forEach(function(item:FlxSprite)
		{
			item.y = yPosition;
			yPosition += 100;
		});

		var keyText:FlxText = new FlxText(250, 0, 0, "<[Z]>", 40);
		keyText.color = FlxColor.WHITE;
		keyText.setFormat(Paths.font("vcr.ttf"), 40);
		add(keyText);
		add(blackBG);
		add(screenStatic);
	}

	override function closeSubState()
	{
		super.closeSubState();
		ClientPrefs.saveSettings();
		blackBG.alpha = 0;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.Z)
		{
			if (MenuOverlaySubState.tabState)
			{
				MenuOverlaySubState.tabState = false;
				openSubState(new MenuOverlaySubState());
			}
		}

		if (MenuOverlaySubState.tabState)
		{
			if (controls.UI_UP_P)
			{
				changeSelection(-1);
			}
			if (controls.UI_DOWN_P)
			{
				changeSelection(1);
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.25);
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				openSelectedSubstate(options[curSelected]);
			}
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0)
			{
				item.alpha = 1;
				selectorLeft.x = item.x - 63;
				selectorLeft.y = item.y;
				selectorRight.x = item.x + item.width + 15;
				selectorRight.y = item.y;
			}
		}
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.25);
	}
}
