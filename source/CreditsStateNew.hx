package;

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
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end
import lime.utils.Assets;

using StringTools;

class CreditsStateNew extends MusicBeatState
{
	var offset:Float = 100;
	var yPosition:Float = 100;
	var screenStatic:FlxSprite;
	var blackScreen:FlxSprite;
	var fadedItemsGroup:FlxTypedGroup<FlxSprite>;
	var fadedMenuItems:Array<String> = ["story", "freeplay", "options", "credits"];
	var viewingState:Bool = true;
	var scrolldisable:Bool = false;

	var thankGroup:FlxTypedGroup<Dynamic>;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];
	var descText:FlxText;
	var offsetThing:Float = -75;
	var curSelected:Int = -1;
	var descBox:AttachedSprite;

	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		persistentUpdate = true;

		grpOptions = new FlxTypedGroup<Alphabet>();
		thankGroup = new FlxTypedGroup<Dynamic>();
		add(grpOptions);
		add(thankGroup);
		var engineDevelopment:Array<Array<String>> = [
			// Name - Icon name - Description - Link - BG Color
			['Psych Engine Team'],
			[
				'Shadow Mario',
				'shadowmario',
				'Main Programmer of Psych Engine',
				'https://twitter.com/Shadow_Mario_',
				'444444'
			],
			[
				'RiverOaken',
				'riveroaken',
				'Main Artist/Animator of Psych Engine',
				'https://twitter.com/RiverOaken',
				'C30085'
			],
			[
				'shubs',
				'shubs',
				'Additional Programmer of Psych Engine',
				'https://twitter.com/yoshubs',
				'279ADC'
			],
			[''],
			['Former Engine Members'],
			[
				'bb-panzu',
				'bb-panzu',
				'Ex-Programmer of Psych Engine',
				'https://twitter.com/bbsub3',
				'389A58'
			],
			[''],
			['Engine Contributors'],
			[
				'iFlicky',
				'iflicky',
				'Composer of Psync and Tea Time\nMade the Dialogue Sounds',
				'https://twitter.com/flicky_i',
				'AA32FE'
			],
			[
				'SqirraRNG',
				'gedehari',
				'Chart Editor\'s Sound Waveform base',
				'https://twitter.com/gedehari',
				'FF9300'
			],
			[
				'PolybiusProxy',
				'polybiusproxy',
				'.MP4 Video Loader Extension',
				'https://twitter.com/polybiusproxy',
				'FFEAA6'
			],
			[
				'Keoiki',
				'keoiki',
				'Note Splash Animations',
				'https://twitter.com/Keoiki_',
				'FFFFFF'
			],
			[
				'Smokey',
				'smokey',
				'Spritemap Texture Support',
				'https://twitter.com/Smokey_5_',
				'4D5DBD'
			],
			[''],
			["Funkin' Crew"],
			[
				'ninjamuffin99',
				'ninjamuffin99',
				"Programmer of Friday Night Funkin'",
				'https://twitter.com/ninja_muffin99',
				'F73838'
			],
			[
				'PhantomArcade',
				'phantomarcade',
				"Animator of Friday Night Funkin'",
				'https://twitter.com/PhantomArcade3K',
				'FFBB1B'
			],
			[
				'evilsk8r',
				'evilsk8r',
				"Artist of Friday Night Funkin'",
				'https://twitter.com/evilsk8r',
				'53E52C'
			],
			[
				'kawaisprite',
				'kawaisprite',
				"Composer of Friday Night Funkin'",
				'https://twitter.com/kawaisprite',
				'6475F3'
			]
		];
		for (i in engineDevelopment)
		{
			creditsStuff.push(i);
		}

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		leftArrow = new FlxSprite(FlxG.width + 300, 0);
		leftArrow.frames = ui_tex;
		leftArrow.screenCenter(Y);
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		// leftArrow.x -=leftArrow.width;
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		rightArrow = new FlxSprite(1200, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;
		add(leftArrow);
		add(rightArrow);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false, 0, 0.5);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			optionText.x += (offset * 2) + FlxG.width;
			if (isSelectable)
			{
				optionText.x -= 70;
			}
			// optionText.forceX = optionText.x;
			// optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if (isSelectable)
			{
				if (creditsStuff[i][5] != null)
				{
					Paths.currentModDirectory = creditsStuff[i][5];
				}

				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
				icon.x += (offset * 2) + FlxG.width;

				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Paths.currentModDirectory = '';

				if (curSelected == -1)
					curSelected = i;
			}
		}

		var thankOne:FlxText = new FlxText(0, 0, 0, "Mod developed by:", 25);
		thankOne.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, CENTER);
		thankOne.screenCenter();
		thankOne.x += offset;
		thankOne.y = 100;
		thankGroup.add(thankOne);
		var thankTwo:CustomAlphabets = new CustomAlphabets(0, 0, "Thetax", 'cursive', true, 0.1);
		thankTwo.screenCenter(XY);
		thankTwo.x += offset + 90;
		thankTwo.y = 90;
		thankGroup.add(thankTwo);
		var thankThree:FlxText = new FlxText(0, 0, FlxG.width - 400,
			"and a big thank you to my friends who helped me along the way helping make this two year solo project possible",
			20);
		thankThree.setFormat(Paths.font("vcr.ttf"), 25, FlxColor.WHITE, CENTER);
		thankThree.screenCenter();
		thankThree.x += offset;
		thankThree.y = 250;
		thankGroup.add(thankThree);

		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		descBox.x += FlxG.width;
		add(descBox);

		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER /*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		descText.x += FlxG.width;
		// descText.borderSize = 2.4;
		descBox.sprTracker = descText;
		add(descText);

		changeSelection();

		fadedItemsGroup = new FlxTypedGroup<FlxSprite>();

		super.create();

		screenStatic = new FlxSprite().loadGraphic(Paths.image('commonAssets/ScreenStatic'));
		screenStatic.antialiasing = ClientPrefs.globalAntialiasing;
		screenStatic.scale.set((1 / 3), (1 / 3));
		screenStatic.updateHitbox();
		screenStatic.alpha = 0.15;
		screenStatic.blend = MULTIPLY;
		add(screenStatic);

		new FlxTimer().start(0.01, function(staticMovement:FlxTimer)
		{
			screenStatic.x = new FlxRandom().float(-1280, 0);
			screenStatic.y = new FlxRandom().float(-360, 0);
		}, 0);

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

		blackScreen = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		add(blackScreen);
		FlxTween.tween(blackScreen, {alpha: 0}, 2);
	}

	private function unselectableCheck(num:Int):Bool
	{
		return creditsStuff[num].length <= 1;
	}

	var moveTween:FlxTween = null;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do
		{
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		}
		while (unselectableCheck(curSelected));

		var selectedScroll:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = selectedScroll - curSelected;
			selectedScroll++;

			if (!unselectableCheck(selectedScroll - 1))
			{
				item.alpha = 0.6;
				if (item.targetY == 0)
				{
					item.alpha = 1;
				}
			}
		}

		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;

		if (moveTween != null)
			moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y: descText.y + 75}, 0.25, {ease: FlxEase.sineOut});

		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
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
		if (MenuOverlaySubState.tabState && !viewingState)
		{
			if (controls.UI_RIGHT)
				rightArrow.animation.play('press')
			else
				rightArrow.animation.play('idle');

			if (controls.UI_LEFT)
				leftArrow.animation.play('press');
			else
				leftArrow.animation.play('idle');
			if (creditsStuff.length > 1)
			{
				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;

				if (upP)
				{
					changeSelection(-1);
				}
				else if (downP)
				{
					changeSelection(1);
				}
			}
		}
        if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.5);
				MusicBeatState.switchState(new TitleState());
			}
		if (controls.UI_RIGHT_P && viewingState && !scrolldisable)
		{
			scrolldisable = true;
			viewingState = false;
			grpOptions.forEach(function(credit:Alphabet)
			{
				FlxTween.tween(credit, {x: credit.x - FlxG.width}, 0.25, {
					ease: FlxEase.sineOut,
					onComplete: function(returnScroll:FlxTween)
					{
						scrolldisable = false;
					}
				});
			});
			thankGroup.forEach(function(thank:Dynamic)
			{
				FlxTween.tween(thank, {x: thank.x - FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			});
			for (i in 0...iconArray.length)
			{
				FlxTween.tween(iconArray[i], {x: iconArray[i].x - FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			}
			FlxTween.tween(descBox, {x: descBox.x - FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			FlxTween.tween(descText, {x: descText.x - FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			FlxTween.tween(rightArrow, {x: rightArrow.x - FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			FlxTween.tween(leftArrow, {x: leftArrow.x - FlxG.width}, 0.25, {ease: FlxEase.sineOut});
		}
		else if (controls.UI_LEFT_P && !viewingState && !scrolldisable)
		{
			viewingState = true;
			scrolldisable = true;
			grpOptions.forEach(function(credit:Alphabet)
			{
				FlxTween.tween(credit, {x: credit.x + FlxG.width}, 0.25, {
					ease: FlxEase.sineOut,
					onComplete: function(returnScroll:FlxTween)
					{
						scrolldisable = false;
					}
				});
			});
			thankGroup.forEach(function(thank:Dynamic)
			{
				FlxTween.tween(thank, {x: thank.x + FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			});
			for (i in 0...iconArray.length)
			{
				FlxTween.tween(iconArray[i], {x: iconArray[i].x + FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			}
			FlxTween.tween(descBox, {x: descBox.x + FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			FlxTween.tween(descText, {x: descText.x + FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			FlxTween.tween(rightArrow, {x: rightArrow.x + FlxG.width}, 0.25, {ease: FlxEase.sineOut});
			FlxTween.tween(leftArrow, {x: leftArrow.x + FlxG.width}, 0.25, {ease: FlxEase.sineOut});
		}
	}
}
