package;

import flixel.system.frontEnds.SignalFrontEnd;
import flixel.input.gamepad.lists.FlxGamepadAnalogStateList;
import flixel.util.FlxSignal;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.math.FlxRandom;
import flixel.FlxGame;
import flixel.FlxSubState;

using StringTools;

class MenuOverlaySubState extends MusicBeatSubstate
{
	public static var openedState:String = "";

	public var isPersistent:Bool = false;
	public static var tabState:Bool = true;

	var backOverlay:FlxSprite;
	var screenStatic:FlxSprite;

	var menuItems:Array<String> = ["story", "freeplay", "options", "credits"];

	var menuCloseState:Bool = false;

	var yPosition:Float = 100;

	var itemsGroup:FlxTypedGroup<FlxSprite>;

	var selectedInt:Int = 0;

	public function new()
	{
		new FlxTimer().start(0.1, function(allowExit:FlxTimer)
		{
			menuCloseState = true;
		});
		itemsGroup = new FlxTypedGroup<FlxSprite>();
		super();
		backOverlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		backOverlay.alpha = 0;
		add(backOverlay);

		screenStatic = new FlxSprite().loadGraphic(Paths.image('commonAssets/ScreenStatic'));
		screenStatic.antialiasing = ClientPrefs.globalAntialiasing;
		screenStatic.scale.set((1 / 3), (1 / 3));
		screenStatic.updateHitbox();
		screenStatic.alpha = 0;
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
		sideBarLower.graphic.persist = true;

		for (i in 0...menuItems.length)
		{
			var optionItem:FlxSprite = new FlxSprite();
			optionItem.antialiasing = ClientPrefs.globalAntialiasing;
			optionItem.scale.set((1 / 3), (1 / 3));
			optionItem.updateHitbox();
			optionItem.x = -670;
			optionItem.frames = Paths.getSparrowAtlas('ui/MenuOverlay/MenuButtons');
			optionItem.animation.addByPrefix('selected', menuItems[i] + '_selected', 24);
			optionItem.animation.addByPrefix('idle', menuItems[i] + '_unselected', 24);
			optionItem.ID = i;
			if (openedState == menuItems[i]) {
				optionItem.animation.play('selected');
				selectedInt = i;
			} else {
				optionItem.animation.play('idle');			
			}
			itemsGroup.add(optionItem);
		}

		add(sideBarLower);
		add(sideBarUpper);
		add(itemsGroup);

		itemsGroup.forEach(function(item:FlxSprite)
		{
			item.y = yPosition;
			yPosition += 100;
			FlxTween.tween(item, {x: item.x + 50}, 0.6, {ease: FlxEase.backOut});
		});

		var keyText:FlxText = new FlxText(250, 0, 0, "<[Z]>", 40);
		keyText.color = FlxColor.WHITE;
		keyText.setFormat(Paths.font("vcr.ttf"), 40);
		add(keyText);

		FlxTween.tween(sideBarLower, {x: sideBarLower.x + 50}, 0.5, {ease: FlxEase.backOut});
		FlxTween.tween(sideBarUpper, {x: sideBarUpper.x + 50}, 0.7, {ease: FlxEase.backOut});
		FlxTween.tween(keyText, {x: keyText.x + 50}, 0.8, {ease: FlxEase.backOut});
		FlxTween.tween(backOverlay, {alpha: 0.3}, 0.2);
		changeSelectionState();
	}

	function changeSelectionState(change:Int = 0):Void
	{
		selectedInt += change;
		if (selectedInt < 0)
			selectedInt = menuItems.length - 1;
		if (selectedInt >= menuItems.length)
			selectedInt = 0;
		openedState = menuItems[selectedInt];
		itemsGroup.forEach(function(buttons:FlxSprite)
		{
			for (i in 0...menuItems.length)
			{
				(buttons.ID == selectedInt ? buttons.animation.play('selected') : buttons.animation.play('idle'));
			}
		});
	}

	override function destroy()
	{	
		super.destroy();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.Z && menuCloseState)
		{
			tabState = true;
			close();
		}

		if (controls.UI_UP_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
			changeSelectionState(-1);
		}
		else if (controls.UI_DOWN_P)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.5);
			changeSelectionState(1);
		} else if (controls.ACCEPT) {
			tabState = true;
			FlxG.sound.play(Paths.sound('cancelMenu'), 0.5);
			switch (openedState)
			{
				case 'story':
					screenStatic.alpha = 1;
					MusicBeatState.switchState(new StoryMenuStateNew());
					FlxTween.tween(screenStatic, {alpha: 0}, 1);
				case 'freeplay':
					screenStatic.alpha = 1;
					MusicBeatState.switchState(new FreeplayStateNew());
					FlxTween.tween(screenStatic, {alpha: 0}, 1);
				case 'options':
					screenStatic.alpha = 1;
					MusicBeatState.switchState(new options.OptionsState());
					FlxTween.tween(screenStatic, {alpha: 0}, 1);
				case 'credits':
					screenStatic.alpha = 1;
					MusicBeatState.switchState(new CreditsStateNew());
					FlxTween.tween(screenStatic, {alpha: 0}, 1);
			}
		}
	}
}