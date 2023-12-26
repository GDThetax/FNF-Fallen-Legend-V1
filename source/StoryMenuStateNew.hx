package;

import flixel.FlxGame;
import openfl.display.Sprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import WeekData;

using StringTools;

class StoryMenuStateNew extends MusicBeatState
{
	var overlaySubState:MenuOverlaySubState;

	var scrolldisable:Bool = true;
	var selectedAct:Bool = false;

	var yPosition:Float = 100;
	var offset:Float = 100;

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;
	var curDifficulty:Int = 0;

	var screenStatic:FlxSprite;
	var blackScreen:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var ignoreThisFrame = true;

	var scoreText:FlxText;

	var subStateColor:FlxColor;

	private static var curAct:Int = 0;

	public static var actCompleted:Map<String, Bool> = new Map<String, Bool>();

	public static var exitState:Array<Dynamic> = [['', '', ''], 0, 0]; // song list; score; misses
	var currSavedSongText:FlxText;

	var fadedMenuItems:Array<String> = ["story", "freeplay", "options", "credits"];
	var loadedActs:Array<WeekData> = [];

	var fadedItemsGroup:FlxTypedGroup<FlxSprite>;
	var actGroup:FlxTypedGroup<Dynamic>;

	override function create()
	{
		if (FlxG.save.data.exitState != null)
		{
			exitState = FlxG.save.data.exitState;
		}
		if (FlxG.save.data.actCompleted != null) actCompleted = FlxG.save.data.actCompleted;
		overlaySubState = new MenuOverlaySubState();
		// MenuOverlaySubState.isPersistent = true;
		MenuOverlaySubState.openedState = "story";
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		PlayState.isStoryMode = true;
		WeekData.reloadWeekFiles(true);
		persistentUpdate = persistentDraw = true;
		curAct = 0;

		trace(exitState[0]);

		fadedItemsGroup = new FlxTypedGroup<FlxSprite>();

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 15);
		scoreText.setFormat("VCR OSD Mono", 15);
		scoreText.x = FlxG.width - scoreText.width - 20;

		actGroup = new FlxTypedGroup<MenuItem>();
		add(actGroup);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		leftArrow = new FlxSprite(465, 0);
		leftArrow.frames = ui_tex;
		leftArrow.screenCenter(Y);
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		leftArrow.x -= leftArrow.width;
		leftArrow.antialiasing = ClientPrefs.globalAntialiasing;
		rightArrow = new FlxSprite(1015, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		rightArrow.antialiasing = ClientPrefs.globalAntialiasing;

		currSavedSongText = new FlxText(0, 600, 0, "", 20);
		currSavedSongText.alignment = CENTER;
		currSavedSongText.setFormat(Paths.font("vcr.ttf"), 20);

		var num:Int = 0;

		for (i in 0...WeekData.weeksList.length)
		{
			var actFile:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var isLocked:Bool = weekIsLocked(WeekData.weeksList[i]);
			loadedActs.push(actFile);
			if (!isLocked)
			{
				var actImg:MenuItem = new MenuItem(0, 0, actFile.actImage);
				actImg.scale.set((1 / 4), (1 / 4));
				actImg.updateHitbox();
				actImg.screenCenter();
				actImg.y = 50;
				actImg.x += ((FlxG.width * num) + offset);
				actGroup.add(actImg);
				actImg.antialiasing = ClientPrefs.globalAntialiasing;
				var actNum:CustomAlphabets = new CustomAlphabets(0, ((1500 / 4) + 40), actFile.actName, "cursive", true, 0.15);
				actNum.screenCenter(X);
				actNum.antialiasing = ClientPrefs.globalAntialiasing;
				actNum.x += ((FlxG.width * num) + offset);
				var actMess:CustomAlphabets = new CustomAlphabets(0, ((1500 / 4) + 75), actFile.actMessage, "cursive", true, 0.07);
				actMess.screenCenter(X);
				actMess.x += ((FlxG.width * num) + offset);
				actMess.antialiasing = ClientPrefs.globalAntialiasing;
				actGroup.add(actNum);
				actGroup.add(actMess);
				var txtTracklist:FlxText = new FlxText(0, 600, 0, "", 20);
				txtTracklist.alignment = CENTER;
				txtTracklist.setFormat(Paths.font("vcr.ttf"), 20);
				txtTracklist.color = FlxColor.WHITE;
				actGroup.add(txtTracklist);

				actGroup.add(currSavedSongText);

				if (exitState[0].contains('Emotional Restoration')) {
					currSavedSongText.text = 'Current Saved Story Progress:\n' + exitState[0][0];
					currSavedSongText.screenCenter(X);
					currSavedSongText.x += -350 + offset;
				} else if (exitState[0].contains('Insanity Virus')) {
					currSavedSongText.text = 'Current Saved Story Progress:\n' + exitState[0][0];
					currSavedSongText.screenCenter(X);
					currSavedSongText.x += -350 + FlxG.width + offset;
				}

				var stringThing:Array<String> = [];
				for (i in 0...actFile.songs.length)
				{
					stringThing.push(actFile.songs[i][0]);
				}

				txtTracklist.text = 'Songs:\n';
				for (i in 0...stringThing.length)
				{
					if (stringThing[i] != 'Insanity Virus' || FlxG.save.data.unlockedSongs.contains("insanity-virus"))
					{
						txtTracklist.text += stringThing[i] + '\n';
					}
				}

				txtTracklist.text = txtTracklist.text.toUpperCase();

				txtTracklist.screenCenter(X);
				txtTracklist.x += ((FlxG.width * num) + offset);
			}
			else
			{
				var lockedAct:FlxSprite = new FlxSprite().makeGraphic(Std.int(1500 / 4), Std.int(1500 / 4), FlxColor.BLACK);
				var lockedOutline:FlxSprite = new FlxSprite().makeGraphic(Std.int((1500 / 4) + 10), Std.int((1500 / 4) + 10), FlxColor.WHITE);
				lockedAct.screenCenter(X);
				lockedAct.x += ((FlxG.width * num) + offset);
				lockedOutline.screenCenter(X);
				lockedOutline.x += ((FlxG.width * num) + offset);
				lockedAct.y = 50;
				lockedOutline.y = 45;
				actGroup.add(lockedOutline);
				actGroup.add(lockedAct);
				var actMess:CustomAlphabets = new CustomAlphabets(0, ((1500 / 4) + 75), "Complete " + actFile.weekBefore + " to unlock", "cursive", true, 0.1);
				actMess.screenCenter(X);
				actMess.x += ((FlxG.width * num) + offset);
				actGroup.add(actMess);
				var lockIcon:FlxSprite = new FlxSprite().loadGraphic(Paths.image("commonAssets/LockIcon"));
				lockIcon.antialiasing = ClientPrefs.globalAntialiasing;
				lockIcon.scale.set((1 / 2), (1 / 2));
				lockIcon.updateHitbox();
				lockIcon.screenCenter(X);
				lockIcon.x += ((FlxG.width * num) + offset);
				lockIcon.y = (50 + 0.5 * (Std.int(1500 / 4)) - 0.5 * (lockIcon.height));
				actGroup.add(lockIcon);
			}
			num++;
		}

		add(scoreText);

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

		scrollAct();

		add(leftArrow);
		add(rightArrow);

		blackScreen = new FlxSprite().makeGraphic(1280, 720, FlxColor.BLACK);
		add(blackScreen);

		FlxTween.tween(blackScreen, {alpha: 0}, 2, {
			onComplete: function(enableScrolling:FlxTween)
			{
				scrolldisable = false;
			}
		});

		super.create();
	}

	function weekIsLocked(name:String):Bool
	{
		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
		return (!leWeek.startUnlocked
			&& leWeek.weekBefore.length > 0
			&& (!actCompleted.exists(leWeek.weekBefore) || !actCompleted.get(leWeek.weekBefore)));
	}

	override function openSubState(SubState:FlxSubState)
	{
		super.openSubState(SubState);
	}

	function selectAct()
	{
		if (!weekIsLocked(loadedActs[curAct].fileName))
		{
			var songArray:Array<String> = [];
			var leWeek:Array<Dynamic> = loadedActs[curAct].songs;
			for (i in 0...leWeek.length)
			{
				songArray.push(leWeek[i][0]);
			}

			PlayState.storyPlaylist = songArray;

			// Nevermind that's stupid lmao

			trace(exitState[0].length + ", " + songArray[2] + ", " + PlayState.storyPlaylist.contains(songArray[2]));

			if (exitState[0].length < 3 && exitState[0].contains(songArray[2]))
			{
				PlayState.storyPlaylist = exitState[0];
				trace("Set story playlist to exit state.");
			}

			PlayState.isStoryMode = true;
			selectedAct = true;

			var diffic = CoolUtil.getDifficultyFilePath(curDifficulty);
			if (diffic == null)
				diffic = '';

			PlayState.storyDifficulty = curDifficulty;

			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;

			trace(PlayState.storyPlaylist);
			if (exitState[0] != PlayState.storyPlaylist && PlayState.storyPlaylist.length == 3)
			{
				for (i in 0...PlayState.storyPlaylist.length)
				{
					exitState[0][i] = (PlayState.storyPlaylist[i]);
				}
				PlayState.campaignScore = exitState[1];
				PlayState.campaignMisses = exitState[2];
			}
			PlayState.SONG = Song.loadFromJson(exitState[0][0] + diffic, exitState[0][0]);

			FlxG.save.data.exitState = exitState;

			/*if (exitState != ['', '', ''])
				{
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
					PlayState.campaignScore = 0;
					PlayState.campaignMisses = 0;
				}
				else
				{
					PlayState.SONG = Song.loadFromJson(exitState[0] + diffic, exitState[0]);
					PlayState.campaignScore = Std.parseInt(exitState[1]);
					PlayState.campaignMisses = Std.parseInt(exitState[2]);
			}*/

			FlxG.sound.play(Paths.sound('confirmMenu'), 0.5);
			FlxTween.tween(FlxG.camera, {zoom: 3}, 30);
			FlxTween.tween(blackScreen, {alpha: 1}, 0.5, {
				startDelay: 0.5,
				onComplete: function(enterSong:FlxTween)
				{
					LoadingState.loadAndSwitchState(new PlayState(), true);
					// FreeplayState.destroyFreeplayVocals();
				}
			});
		}
		else
		{
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.5);
			FlxG.camera.shake(0.005, 0.1);
		}
	}

	override function update(elapsed:Float)
	{
		if (ignoreThisFrame)
			{
				ignoreThisFrame = false;
				super.update(elapsed);
				return;
			}
		if (FlxG.keys.justPressed.Z)
		{
			if (MenuOverlaySubState.tabState)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
				MenuOverlaySubState.tabState = false;
				openSubState(new MenuOverlaySubState());
			}
		}

		if (MenuOverlaySubState.tabState)
		{
			(controls.UI_RIGHT ? rightArrow.animation.play('press') : rightArrow.animation.play('idle'));
			(controls.UI_LEFT ? leftArrow.animation.play('press') : leftArrow.animation.play('idle'));

			if (controls.UI_RIGHT_P && !scrolldisable)
			{
				scrollAct(1);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
			}
			else if (controls.UI_LEFT_P && !scrolldisable)
			{
				scrollAct(-1);
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
			}
			else if (controls.ACCEPT)
			{
				selectAct();
			}

			if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.5);
				MusicBeatState.switchState(new TitleState());
			}
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 30, 0, 1)));
		if (Math.abs(intendedScore - lerpScore) < 10)
			lerpScore = intendedScore;

		scoreText.text = "ACT SCORE:" + lerpScore;

		super.update(elapsed);
	}

	function scrollAct(direction:Int = 0):Void
	{
		curAct += direction;
		if (direction != 0)
		{
			if (!(curAct > loadedActs.length - 1 || curAct < 0))
			{
				var chosenAct:WeekData = loadedActs[curAct];
				WeekData.setDirectoryFromWeek(chosenAct);
				if (FlxMath.inBounds(direction, 0, 1))
				{
					actGroup.forEach(function(part:Dynamic)
					{
						scrolldisable = true;
						FlxTween.tween(part, {x: (part.x - FlxG.width)}, 1, {
							ease: FlxEase.cubeOut,
							onComplete: function(returnscrollingability:FlxTween)
							{
								scrolldisable = false;
							}
						});
					});
				}
				else
				{
					actGroup.forEach(function(part:Dynamic)
					{
						scrolldisable = true;
						FlxTween.tween(part, {x: (part.x + FlxG.width)}, 1, {
							ease: FlxEase.cubeOut,
							onComplete: function(returnscrollingability:FlxTween)
							{
								scrolldisable = false;
							}
						});
					});
				}
			}
			else
			{
				curAct -= direction;
			}
		}

		PlayState.storyWeek = curAct;
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if (diffStr != null)
			diffStr = diffStr.trim(); // Fuck you HTML5

		if (diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if (diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if (diffs[i].length < 1)
						diffs.remove(diffs[i]);
				}
				--i;
			}

			if (diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty) ? curDifficulty = Math.round(Math.max(0,
			CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty))) : curDifficulty = 0);
		intendedScore = Highscore.getWeekScore(loadedActs[curAct].fileName, curDifficulty);
	}
}
