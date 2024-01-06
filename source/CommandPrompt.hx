package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import flixel.FlxG;

using StringTools;

class CommandPrompt extends FlxSprite
{
	public var cTextGroup:FlxTypedGroup<FlxText>;

	var resetKeybinds:Array<FlxKey> = [E, F, G, C, V];

	var keybindForText:Array<String> = ["E", "F", "G", "C", "V"];

	public var finalResetKey:Array<FlxKey> = [];

	var displayCamera:FlxCamera;
	var countdownDisp:Int;

	public var customText:String = "";

	var reversionCountdownDissapear:FlxTimer;
	var stdMessageTimer:FlxTimer;
	var reversionAccept:Bool = false;

	public function new(x:Float, y:Float, ?camera:FlxCamera)
	{
		super(x, y);

		this.displayCamera = camera;
		if (camera != null)
			this.cameras = [displayCamera];

		frames = Paths.getSparrowAtlas("UPDATEDCommandPrompt");
		animation.addByPrefix("commandPrompt", "cPrompt", 24);
		animation.play("commandPrompt");

		cTextGroup = new FlxTypedGroup<FlxText>();

		alpha = 0.0001;
		this.reversionCountdownDissapear = new FlxTimer();
		this.stdMessageTimer = new FlxTimer();
		getResetKey();
	}

	function getResetKey()
	{
		for (i in 0...4)
		{
			for (j in 0...resetKeybinds.length)
			{
				if (PlayState.instance.keysArray[i].contains(resetKeybinds[j]))
				{
					resetKeybinds.remove(resetKeybinds[j]);
					keybindForText.remove(keybindForText[j]);
				}
			}
		}

		finalResetKey.push(resetKeybinds[0]);
	}

	public function addCommandText(commandType:String, commandVariable:String, ?countdownTime:Int)
	{
		alpha = 1;
		var mainCommandString:String = "";
		var cReversionString:String = "";

		switch (commandType)
		{
			case "keybind":
				mainCommandString = "extern:/unknownSourceInput-->CMD:kbnd-shift--";
				cReversionString = "press " + keybindForText[0] + " to revert changes...";
			case "speed":
				mainCommandString = "extern:/unknownSourceInput-->CMD:spd-hck(notes)--";
			case "health":
				mainCommandString = "extern:/unknownSourceInput-->CMD:/PlayState:/health--";
			case "custom":
				mainCommandString = "";
		}
		var cDisplayText:FlxText = new FlxText(this.x + 50, this.height - 23 + this.y, this.width - 85, mainCommandString + commandVariable, 10);
		cDisplayText.setFormat(Paths.font("vcr.ttf"), 10, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		if (this.cameras != null)
			cDisplayText.cameras = this.cameras;
		cTextGroup.add(cDisplayText);
		shiftTextUp();
		for (i in 0...cTextGroup.members.length)
		{
			cTextGroup.members[i].alpha = 1;
		}
		if (countdownTime != null)
		{
			this.countdownDisp = countdownTime;
			var cCountdown:FlxText = new FlxText(this.x + 50, this.height - 23 + this.y, this.width - 5, "", 10);
			cCountdown.setFormat(Paths.font("vcr.ttf"), 10, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			if (this.cameras != null)
				cCountdown.cameras = this.cameras;
			cTextGroup.add(cCountdown);
			shiftTextUp();
			stdMessageTimer.cancel();
			reversionCountdownDissapear.start(1, function(countDown:FlxTimer)
			{
				cCountdown.text = cReversionString + Std.string(this.countdownDisp);
				this.countdownDisp -= 1;
				if (this.countdownDisp == -1)
				{
					alpha = 0.0001;
					for (i in 0...cTextGroup.members.length)
					{
						cTextGroup.members[i].alpha = 0.0001;
					}
				}
			}, countdownTime + 1);
		}
		else if (!reversionCountdownDissapear.active)
		{
			if (stdMessageTimer.active)
				stdMessageTimer.cancel();
			stdMessageTimer.start(5, function(remove:FlxTimer)
			{
				alpha = 0.0001;
				for (i in 0...cTextGroup.members.length)
				{
					cTextGroup.members[i].alpha = 0.0001;
				}
			});
		}
	}

	function shiftTextUp()
	{
		if (cTextGroup.length > 0)
		{
			cTextGroup.forEach(function(commText:FlxText)
			{
				commText.y -= 20;
				if (commText.y < this.y + 25)
				{
					commText.kill();
					cTextGroup.remove(commText, true);
					commText.destroy();
				}
			});
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (this.countdownDisp != -1 && FlxG.keys.anyJustPressed(finalResetKey))
		{
			reversionCountdownDissapear.cancel();
			alpha = 0.0001;
			for (i in 0...cTextGroup.members.length)
			{
				cTextGroup.members[i].alpha = 0.0001;
			}
		}
	}
}
