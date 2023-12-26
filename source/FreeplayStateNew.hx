package;

import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import WeekData;

using StringTools;

class FreeplayStateNew extends MusicBeatState
{
	var songs:Array<String> = [];
	var curDifficulty:Int = 0;
	var yPosition:Float = 100;
	var offset:Float = 100;
	var screenStatic:FlxSprite;
	var blackScreen:FlxSprite;
	var fadedItemsGroup:FlxTypedGroup<FlxSprite>;
	var fadedMenuItems:Array<String> = ["story", "freeplay", "options", "credits"];
	var scrolldisable:Bool = false;

	var loadingText:FlxText;
	var ignoreThisFrame = true;

	var preventSongScroll:Bool = false;

	var epilepsyText:FlxText;

	var scoreText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	public static var unlockedSongs:Array<String> = ["", "", "", "", "", "", "", "", "", ""];

	public static var availableSongs:Array<String> = [
		"disconsolate", "anamnesis", "emotional-restoration", "true-love", "traumatophobia", "insanity-virus", "treasured-memories", "static-torture",
		"fabula-amoris", "left-for-dead"
	];

	var displayGroupingNum:Array<Array<Int>> = [[0, 1, 2], [3, 4], [6, 7], [8, 9]];
	var mysteryArray:Array<String> = ["treasured-memories", "static-torture", "fabula-amoris", "left-for-dead"];

	var iconGroup:FlxTypedGroup<FlxSprite>;

	public static var selectedSong:Int;
	public static var selectedSegment:Int;

	var songName:CustomAlphabets;

	public static function addSongUnlock(songName:String = "")
	{
		trace("adding song to freeplay");
		if (FlxG.save.data.unlockedSongs != null) unlockedSongs = FlxG.save.data.unlockedSongs;
		trace(unlockedSongs);
		unlockedSongs[availableSongs.indexOf(songName, 0)] = songName;
		FlxG.save.data.unlockedSongs = unlockedSongs;
		FlxG.save.flush();
	}

	override function create()
	{
		if (FlxG.save.data.unlockedSongs != null)
		{
			unlockedSongs = FlxG.save.data.unlockedSongs;
		}
		if (FlxG.save.data.mysteryArray != null)
		{
			mysteryArray = FlxG.save.data.mysteryArray;
		}
		trace(unlockedSongs);
		fadedItemsGroup = new FlxTypedGroup<FlxSprite>();
		iconGroup = new FlxTypedGroup<FlxSprite>();
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		persistentUpdate = true;
		MenuOverlaySubState.openedState = "freeplay";
		PlayState.isStoryMode = false;
		WeekData.reloadWeekFiles(false);

		if (unlockedSongs != [])
		{
			for (i in 0...unlockedSongs.length)
			{
				songs.push(unlockedSongs[i]);
			}
		}

		if (unlockedSongs.contains('insanity-virus'))
		{
			displayGroupingNum[1].push(5);
		}

		super.create();

		for (i in 0...availableSongs.length)
		{
			if (unlockedSongs.contains('insanity-virus') || availableSongs[i] != 'insanity-virus')
			{
				var freeplaySong:FlxSprite = new FlxSprite();
				if (unlockedSongs.contains(availableSongs[i]))
				{
					(mysteryArray.contains(availableSongs[i]) ? freeplaySong.loadGraphic(Paths.image("freeplayImages/questionMark")) : freeplaySong.loadGraphic(Paths.image("freeplayImages/"
						+ availableSongs[i])));
				}
				else
				{
					freeplaySong.loadGraphic(Paths.image("freeplayImages/locked"));
				}
				freeplaySong.antialiasing = ClientPrefs.globalAntialiasing;
				freeplaySong.scale.set((1 / 4), (1 / 4));
				freeplaySong.updateHitbox();
				freeplaySong.screenCenter();
				freeplaySong.y -= 100;
				freeplaySong.ID = i;
				iconGroup.add(freeplaySong);
			}
		}

		add(iconGroup);

		iconGroup.forEach(function(songIcon:FlxSprite)
		{
			for (i in 0...displayGroupingNum.length)
			{
				if (displayGroupingNum[i].contains(songIcon.ID))
				{
					songIcon.x += (FlxG.width * i) + offset;
				}
				switch (displayGroupingNum[i].length)
				{
					case 2:
						if (displayGroupingNum[i].contains(songIcon.ID))
						{
							/*songIcon.x -= (songIcon.width * (displayGroupingNum[i].indexOf(songIcon.ID) * -1)
								+ (50 * (displayGroupingNum[i].indexOf(songIcon.ID) * -1))); */
							songIcon.x -= (songIcon.width + 50) - (displayGroupingNum[i].indexOf(songIcon.ID) * songIcon.width * 2);
							songIcon.x += offset / 2;
						}
					case 3:
						if (displayGroupingNum[i].contains(songIcon.ID))
						{
							songIcon.x += (songIcon.width * ((displayGroupingNum[i][1] - songIcon.ID) * -1)
								+ (50 * ((displayGroupingNum[i][1] - songIcon.ID) * -1)));
						}
				}
			}
		});

		songName = new CustomAlphabets(0, 500, "placeholder", "cursive", true, 0.1);
		songName.screenCenter(X);
		songName.x -= offset;
		songName.antialiasing = ClientPrefs.globalAntialiasing;
		add(songName);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 20, FlxColor.WHITE, RIGHT);
		// scoreText.screenCenter(X);
		//scoreText.x -= offset;
		scoreText.y = 650;
		add(scoreText);

		epilepsyText = new FlxText(0, FlxG.height - 80, FlxG.width, "!EPILEPSY WARNING!", 15);
		epilepsyText.setFormat(Paths.font("vcr.ttf"), 15, FlxColor.WHITE, CENTER);
		epilepsyText.screenCenter(X);
		epilepsyText.x += 90;
		epilepsyText.alpha = 0;
		add(epilepsyText);

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

		changeSelection(0, true);

		FlxTween.tween(blackScreen, {alpha: 0}, 2);

		loadingText = new FlxText(0, FlxG.height - 32, FlxG.width, "LOADING...");
		loadingText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		loadingText.alpha = 0;
		add(loadingText);
	}

	override function update(elapsed:Float)
	{
		if (ignoreThisFrame)
			{
				ignoreThisFrame = false;
				super.update(elapsed);
				return;
			}
		super.update(elapsed);

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = 'PERSONAL BEST: ' + lerpScore;

		if (selectedSong == 5 || selectedSong == 7 || selectedSong == 9) {
			epilepsyText.alpha = 1;
		} else epilepsyText.alpha = 0;

		if (FlxG.keys.justPressed.Z)
		{
			if (MenuOverlaySubState.tabState)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
				MenuOverlaySubState.tabState = false;
				openSubState(new MenuOverlaySubState());
			}
		}

		if (MenuOverlaySubState.tabState && !preventSongScroll)
		{
			if (controls.UI_LEFT_P && !scrolldisable)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
				changeSelection(-1);
			}
			else if (controls.UI_RIGHT_P && !scrolldisable)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
				changeSelection(1);
			}
			else if (controls.ACCEPT && !scrolldisable)
			{
				persistentUpdate = false;
				preventSongScroll = true;
				if (unlockedSongs.contains(availableSongs[selectedSong]))
				{
					var songLowercase:String = Paths.formatToSongPath(songs[selectedSong]);
					var poop:String = Highscore.formatSong(songLowercase, curDifficulty);
					PlayState.SONG = Song.loadFromJson(poop, songLowercase);
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					FlxTween.tween(FlxG.camera, {zoom: 3}, 30);
					FlxTween.tween(blackScreen, {alpha: 1}, 0.5, {
						startDelay: 0.5,
						onComplete: function(enterSong:FlxTween)
						{
							loadingText.alpha = 1;
							FlxG.camera.zoom = 1;
							LoadingState.loadAndSwitchState(new PlayState(), true, false);
							FlxG.sound.music.volume = 0;
							// FreeplayState.destroyFreeplayVocals();
							mysteryArray.remove(availableSongs[selectedSong]);
							FlxG.save.data.mysteryArray = mysteryArray;
						}
					});
				}
				else
				{
					FlxG.sound.play(Paths.sound('cancelMenu'), 0.5);
					FlxG.camera.shake(0.005, 0.05);
					preventSongScroll = false;
				}
			}
			else if (controls.BACK)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'), 0.5);
				selectedSong = 0;
				selectedSegment = 0;
				MusicBeatState.switchState(new TitleState());
			}
		}
	}

	function changeSelection(change:Int = 0, ?skipToSong:Bool = false)
	{
		var fullScroll:Int = 0;
		selectedSong += change;
		if (!skipToSong)
		{
			if (selectedSong < 0)
			{
				selectedSong = availableSongs.length - 1;
				selectedSegment = 3;
				fullScroll = -1;
			}
			if (selectedSong >= availableSongs.length)
			{
				selectedSong = 0;
				fullScroll = 1;
				selectedSegment = 0;
			}
			if (!unlockedSongs.contains('insanity-virus') && selectedSong == 5)
			{
				if (change > 0)
				{
					selectedSong += 1;
				}
				else
					selectedSong -= 1;
			}
			if (!displayGroupingNum[selectedSegment].contains(selectedSong)
				&& !(selectedSong < 0 || selectedSong >= availableSongs.length))
			{
				selectedSegment += change;
				scrolldisable = true;
				iconGroup.forEach(function(scrollSegment:FlxSprite)
				{
					FlxTween.tween(scrollSegment, {x: scrollSegment.x - (FlxG.width * change)}, 0.25, {
						ease: FlxEase.cubeOut,
						onComplete: function(retrunScroll:FlxTween)
						{
							scrolldisable = false;
						}
					});
				});
			}
			if (fullScroll == -1)
			{
				scrolldisable = true;
				iconGroup.forEach(function(scrollSegment:FlxSprite)
				{
					FlxTween.tween(scrollSegment, {x: scrollSegment.x - (FlxG.width * 3)}, 0.25, {
						ease: FlxEase.cubeOut,
						onComplete: function(retrunScroll:FlxTween)
						{
							scrolldisable = false;
						}
					});
				});
			}
			else if (fullScroll == 1)
			{
				scrolldisable = true;
				iconGroup.forEach(function(scrollSegment:FlxSprite)
				{
					FlxTween.tween(scrollSegment, {x: scrollSegment.x + (FlxG.width * 3)}, 0.25, {
						ease: FlxEase.cubeOut,
						onComplete: function(retrunScroll:FlxTween)
						{
							scrolldisable = false;
						}
					});
				});
			}
		} else {
			if (selectedSegment != 0) {
				scrolldisable = true;
				iconGroup.forEach(function(scrollSegment:FlxSprite)
				{
					FlxTween.tween(scrollSegment, {x: scrollSegment.x - (FlxG.width * selectedSegment)}, 0.25, {
						ease: FlxEase.cubeOut,
						onComplete: function(retrunScroll:FlxTween)
						{
							scrolldisable = false;
						}
					});
				});
			}
		}

		iconGroup.forEach(function(scaleUp:FlxSprite)
		{
			if (scaleUp.ID == selectedSong)
			{
				scaleUp.scale.set((1 / 3.5), (1 / 3.5));
			}
			else
			{
				scaleUp.scale.set((1 / 4), (1 / 4));
			}
		});
		// trace(songs[selectedSong].songName);
		if (unlockedSongs.contains(availableSongs[selectedSong]))
			intendedScore = Highscore.getScore(availableSongs[selectedSong], curDifficulty);
		updateText();
	}

	function updateText()
	{
		if (unlockedSongs.contains(availableSongs[selectedSong]))
		{
			scoreText.alpha = 1;
			if (mysteryArray.contains(availableSongs[selectedSong]))
			{
				songName.changeText("?????");
				songName.screenCenter(X);
				songName.y = 500;
				songName.x += offset;
			}
			else
			{
				songName.changeText(availableSongs[selectedSong].replace('-', ' '));
				songName.screenCenter(X);
				songName.y = 500;
				songName.x += offset;
			}
		}
		else
		{
			scoreText.alpha = 0;
			switch (selectedSegment)
			{
				case 0:
					songName.changeText("complete songs in story to unlock");
					songName.screenCenter(X);
					songName.y = 500;
					songName.x += offset;
				case 1:
					songName.changeText("complete songs in story to unlock");
					songName.screenCenter(X);
					songName.y = 500;
					songName.x += offset;
				case 2:
					songName.changeText("complete act 1 to unlock");
					songName.screenCenter(X);
					songName.y = 500;
					songName.x += offset;
				case 3:
					songName.changeText("complete act 2 to unlock");
					songName.screenCenter(X);
					songName.y = 500;
					songName.x += offset;
			}
		}
	}
}
