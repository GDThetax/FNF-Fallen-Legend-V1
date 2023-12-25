package;

import flixel.util.FlxTimer;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.sound.FlxSound;

using StringTools;

typedef DialogueFileData =
{
	// identification~delay~textSpeed~dialogueText~charImageSprite
	var identifiction:Null<String>;
	var delay:Null<Float>;
	var dialogueText:Null<String>;
	var textSpeed:Null<Float>; // Counts as image fade time for images
	var charImageSprite:Null<String>;
}

class StoryDialogueCore extends FlxSpriteGroup
{
	var dialogueBoxSprite:FlxSprite;
	var dialogueImage:FlxSprite;

	var popupTmrActive:Bool = false;

	public var startSong:Bool = false;

	var unlockDialogueEnter:Bool = false;
	var ignoreThisFrame:Bool = true;

	var dialogueData:DialogueFileData = null;
	var dialogueStringData:Array<String>;

	var curDialogueLine:Int = 0;

	var dialogueText:Alphabet = null;
	var sophieDialogueText:CustomAlphabets = null;

	public static var LEFT_CHAR_X:Float = -60;
	public static var RIGHT_CHAR_X:Float = -100;
	public static var DEFAULT_CHAR_Y:Float = 60;

	var characterSpriteArray:Array<FlxSprite> = [];
	var characterOffsetData:Array<Array<Float>> = [[85, 0], [1050, 150], [0, 0]];

	var blakePos:Float;
	var bfPos:Float;

	var charMap:Map<String, Int> = ["blake" => 0, "bf" => 1, "none" => -1, "sophie" => -1];

	var curCharacter:Int = -2;

	var blakeSprite:FlxSprite;
	var bfSprite:FlxSprite;

	var dialogueMusic:FlxSound;

	public static var DEFAULT_TEXT_X = 65;
	public static var DEFAULT_TEXT_Y = 400;

	public var finishThing:Void->Void;
	public var nextDialogueThing:Void->Void = null;
	public var skipDialogueThing:Void->Void = null;

	public function new(dialogueData:Array<String>)
	{
		super();

		dialogueMusic = new FlxSound();
		dialogueMusic.loadEmbedded(Paths.music("grief"), true, true);
		dialogueMusic.play(false, FlxG.random.int(0, Std.int(dialogueMusic.length / 2)));
		dialogueMusic.volume = 0;

		this.dialogueStringData = dialogueData;

		dialogueImage = new FlxSprite();
		dialogueImage.scrollFactor.set();
		dialogueImage.antialiasing = ClientPrefs.globalAntialiasing;
		dialogueImage.visible = false;
		add(dialogueImage);

		setupCharacters();

		dialogueBoxSprite = new FlxSprite(70, 370);
		dialogueBoxSprite.frames = Paths.getSparrowAtlas('speech_bubble');
		dialogueBoxSprite.scrollFactor.set();
		dialogueBoxSprite.antialiasing = ClientPrefs.globalAntialiasing;
		dialogueBoxSprite.animation.addByPrefix('normal', 'speech bubble normal', 24);
		dialogueBoxSprite.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
		dialogueBoxSprite.animation.play('normal', true);
		dialogueBoxSprite.visible = false;
		dialogueBoxSprite.setGraphicSize(Std.int(dialogueBoxSprite.width * 0.9));
		dialogueBoxSprite.updateHitbox();
		add(dialogueBoxSprite);

		nextDialogueAction();
	}

	function setupCharacters():Void
	{
		blakeSprite = new FlxSprite(LEFT_CHAR_X + characterOffsetData[0][0],
			DEFAULT_CHAR_Y + characterOffsetData[0][1]).loadGraphic(Paths.image('cutsceneAssets/characters/blake'));
		blakeSprite.setGraphicSize(Std.int(blakeSprite.width * 0.8));
		blakeSprite.updateHitbox();
		blakeSprite.scrollFactor.set();
		blakeSprite.alpha = 0.00001;
		add(blakeSprite);
		blakePos = blakeSprite.x;

		bfSprite = new FlxSprite(RIGHT_CHAR_X + characterOffsetData[1][0],
			DEFAULT_CHAR_Y + characterOffsetData[1][1]).loadGraphic(Paths.image('cutsceneAssets/characters/boyfriend'));
		bfSprite.setGraphicSize(Std.int(bfSprite.width * 0.8));
		bfSprite.updateHitbox();
		bfSprite.scrollFactor.set();
		bfSprite.alpha = 0.00001;
		add(bfSprite);
		bfPos = bfSprite.x;

		characterSpriteArray.push(blakeSprite);
		characterSpriteArray.push(bfSprite);
	}

	override function update(elapsed:Float)
	{
		if (ignoreThisFrame)
		{
			ignoreThisFrame = false;
			super.update(elapsed);
			return;
		}

		if (dialogueBoxSprite.animation.curAnim.name == 'normalOpen' && dialogueBoxSprite.animation.curAnim.finished)
			dialogueBoxSprite.animation.play('normal', true);

		if (!startSong)
		{
			if (dialogueMusic.volume < 0.5) dialogueMusic.volume += 0.5 * elapsed;
			if (PlayerSettings.player1.controls.ACCEPT && unlockDialogueEnter)
			{
				trace("pressed enter");

				curCharacter = -2;

				if (dialogueText != null && !dialogueText.finishedText)
				{
					if (!dialogueText.finishedText && !popupTmrActive)
					{
						dialogueText.killTheTimer();
						dialogueText.kill();
						remove(dialogueText);
						dialogueText.destroy();
						dialogueText = new Alphabet(DEFAULT_TEXT_X, DEFAULT_TEXT_Y, dialogueData.dialogueText, false, true, 0.0, 0.4, true);
						add(dialogueText);
					}
				}
				else if (sophieDialogueText != null && !sophieDialogueText.finishedText)
				{
					if (!sophieDialogueText.finishedText)
					{
						sophieDialogueText.killTheTimer();
						sophieDialogueText.kill();
						remove(sophieDialogueText);
						sophieDialogueText.destroy();
						sophieDialogueText = new CustomAlphabets(10, 10, dialogueData.dialogueText, "cursive", true, 0.07, true, 0.0);
						add(sophieDialogueText);
					}
				}
				else
				{
					nextDialogueAction();
					if (dialogueText != null)
					{
						dialogueText.killTheTimer();
						dialogueText.kill();
						remove(dialogueText);
						dialogueText.destroy();
						dialogueText = null;
					}

					if (sophieDialogueText != null)
					{
						sophieDialogueText.killTheTimer();
						sophieDialogueText.kill();
						remove(sophieDialogueText);
						sophieDialogueText.destroy();
						sophieDialogueText = null;
					}

					if (dialogueData.delay > 0 || dialogueData.identifiction == 'end' || dialogueData.identifiction == "sophie")
					{
						dialogueBoxSprite.animation.play('normalOpen', true, true);
						new FlxTimer().start((5 / 24), function(invisBox:FlxTimer)
						{
							dialogueBoxSprite.visible = false;
							dialogueBoxSprite.animation.play('normal', true);
						});
					}
					unlockDialogueEnter = false;
				}
			}

			if (curCharacter != -2 && characterSpriteArray.length > 0)
			{
				for (i in 0...characterSpriteArray.length)
				{
					var char = characterSpriteArray[i];
					if (char != null)
					{
						if (i != curCharacter)
						{
							switch (i)
							{
								case 0:
									char.x -= 250 * elapsed;
									if (char.x < blakePos)
										char.x = blakePos;
								case 1:
									char.x += 250 * elapsed;
									if (char.x > bfPos)
										char.x = bfPos;
							}
							char.alpha -= 5 * elapsed;
							if (char.alpha < 0.00001)
								char.alpha = 0.00001;
						}
						else
						{
							switch (i)
							{
								case 0:
									char.x += 250 * elapsed;
									if (char.x > blakePos + 50)
										char.x = blakePos + 50;
								case 1:
									char.x -= 250 * elapsed;
									if (char.x < bfPos - 50)
										char.x = bfPos - 50;
							}
							char.alpha += 5 * elapsed;
							if (char.alpha > 1)
								char.alpha = 1;
						}
					}
				}
			}
		}
		else
		{
			if (dialogueMusic.volume > 0) dialogueMusic.volume -= elapsed;
			else dialogueMusic.destroy();
			FlxTween.tween(dialogueImage, {alpha: 0}, 1);
			new FlxTimer().start(2, function(startSong:FlxTimer)
			{
				if (dialogueBoxSprite != null)
				{
					dialogueBoxSprite.kill();
					remove(dialogueBoxSprite);
					dialogueBoxSprite.destroy();
					dialogueBoxSprite = null;
				}

				if (dialogueBoxSprite == null)
				{
					finishThing();
					kill();
				}
			});
		}

		super.update(elapsed);
	}

	function setCurrentDialogueData():Void
	{
		var dataComponents:Array<String> = dialogueStringData[curDialogueLine].split("~");
		trace(dataComponents);

		dialogueData = {
			identifiction: StringTools.rtrim(dataComponents[0]),
			delay: Std.parseFloat(dataComponents[1]),
			textSpeed: Std.parseFloat(dataComponents[2]),
			dialogueText: StringTools.rtrim(dataComponents[3]),
			charImageSprite: StringTools.rtrim(dataComponents[4])
		}

		// dialogueStringData[0] = dialogueStringData[0].substr(dataComponents[1].length + 2).trim();
	}

	function nextDialogueAction()
	{
		setCurrentDialogueData();

		if (dialogueData.identifiction == "end")
		{
			startSong = true;
			return;
		}

		if (dialogueData.identifiction == 'popup' || dialogueData.identifiction == 'imgon' || dialogueData.identifiction == 'imgoff')
		{
			doUtilityAction();
		}

		if (dialogueData.delay > 0)
			curCharacter = -1;

		if (dialogueData.identifiction == 'sophie')
			FlxTween.tween(dialogueImage, {alpha: 0}, dialogueData.delay - 1);

		new FlxTimer().start(dialogueData.delay + (5 / 24), function(addText:FlxTimer)
		{
			unlockDialogueEnter = true;

			curCharacter = charMap.get(dialogueData.identifiction);
			trace(curCharacter);

			if (dialogueData.identifiction == 'sophie')
			{
				sophieDialogueText = new CustomAlphabets(10, 10, dialogueData.dialogueText, "cursive", true, 0.07, true, dialogueData.textSpeed);
				add(sophieDialogueText);
			}
			else
			{
				if (dialogueData.identifiction == 'blake' || dialogueData.identifiction == 'none' && !dialogueBoxSprite.flipX)
					dialogueBoxSprite.flipX = true;
				else if (dialogueData.identifiction == 'bf' && dialogueBoxSprite.flipX)
					dialogueBoxSprite.flipX = false;
				if (!dialogueBoxSprite.visible)
				{
					dialogueBoxSprite.visible = true;
					dialogueBoxSprite.animation.play("normalOpen", true);
				}

				dialogueText = new Alphabet(DEFAULT_TEXT_X, DEFAULT_TEXT_Y, dialogueData.dialogueText, false, true, dialogueData.textSpeed, 0.4, true);
				add(dialogueText);
			}

			if (nextDialogueThing != null)
			{
				nextDialogueThing();
			}

			curDialogueLine++;
		});
	}

	function doUtilityAction()
	{
		curDialogueLine++;

		var utilityType:String = dialogueData.identifiction;
		var utilityDelay:Float = dialogueData.delay;
		var utilitySpecial:Float = dialogueData.textSpeed;
		var utilityText:String = StringTools.rtrim(dialogueData.dialogueText);

		setCurrentDialogueData();

		switch (utilityType)
		{
			case 'popup':
				popupTmrActive = true;
				new FlxTimer().start(utilityDelay, function(popup:FlxTimer)
				{
					lime.app.Application.current.window.alert(utilityText, "ERROR");

					if (dialogueText != null)
					{
						dialogueText.killTheTimer();
						dialogueText.kill();
						remove(dialogueText);
						dialogueText.destroy();
						dialogueText = null;
					}

					if (sophieDialogueText != null)
					{
						sophieDialogueText.killTheTimer();
						sophieDialogueText.kill();
						remove(sophieDialogueText);
						sophieDialogueText.destroy();
						sophieDialogueText = null;
					}

					startSong = true;
				});
			case 'imgon':
				dialogueImage.loadGraphic(Paths.image('cutsceneAssets/' + utilityText));
				dialogueImage.alpha = 0;
				dialogueImage.visible = true;

				FlxTween.completeTweensOf(dialogueImage);
				FlxTween.tween(dialogueImage, {alpha: 1}, utilitySpecial);
			case 'imgoff':
				FlxTween.completeTweensOf(dialogueImage);
				FlxTween.tween(dialogueImage, {alpha: 0}, utilitySpecial);
		}

		trace("Triggered utility dialogue action");
	}
}
