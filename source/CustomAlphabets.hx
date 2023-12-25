package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;

using StringTools;

class CustomAlphabets extends FlxSpriteGroup
{
	public var textSize:Float = 1.0;
	public var text:String = "";
	public var type:String = "";

	public var dropDownCharacters:String = "pqjgyJZz";

	public var typedText:Bool;
	public var finishedText:Bool = false;

	var _finalText:String = "";

	public var isAlternative:Bool = false;
	public var lettersArray:Array<CustomCharacter> = [];

	public var curRow:Int = 0;
	var loopNum:Int = 0;
	var xPos:Float = 0;
	var yMulti:Float = 1;
	var xPosResetted:Bool = false;

	var splitWords:Array<String> = [];

	var consecutiveSpaces:Int = 0;

	var lastSprite:CustomCharacter;

	var rowSpaces:Array<Int> = [0];

	public function new(x:Float, y:Float, text:String = "", type:String = '', alternative:Bool = false, textSize:Float = 1, typed:Bool = false, typingSpeed:Float = 0.05)
	{
		super(x, y);
		this.textSize = textSize;
		this.typedText = typed;
		_finalText = text;
		this.text = text;
		isAlternative = alternative;
		this.type = type;
		if (type != "scratch")
			this.scale.set((1 / 3), (1 / 3));
		this.updateHitbox();

		if (text != "")
		{
			if (typedText)
				startTypedText(typingSpeed);
			else
				addText();
		}
	}

	function doSplitWords():Void
	{
		splitWords = _finalText.split("");
	}

	var typeTimer:FlxTimer = null;
	public function startTypedText(speed:Float):Void
	{
		_finalText = text;
		doSplitWords();

		// trace(arrayShit);

		if(speed <= 0) {
			while(!finishedText) { 
				timerCheck();
			}
		} else {
			typeTimer = new FlxTimer().start(0.1, function(tmr:FlxTimer) {
				typeTimer = new FlxTimer().start(speed, function(tmr:FlxTimer) {
					timerCheck(tmr);
				}, 0);
			});
		}
	}

	var LONG_TEXT_ADD:Float = -24; //text is over 2 rows long, make it go up a bit
	public function timerCheck(?tmr:FlxTimer = null) {
		var autoBreak:Bool = false;
		if ((loopNum <= splitWords.length - 2 && splitWords[loopNum] == "\\" && splitWords[loopNum+1] == "n") ||
			((autoBreak = true) && xPos >= FlxG.width * 0.65 && splitWords[loopNum] == ' ' ))
		{
			if(autoBreak) {
				if(tmr != null) tmr.loops -= 1;
				loopNum += 1;
			} else {
				if(tmr != null) tmr.loops -= 2;
				loopNum += 2;
			}
			yMulti += 1;
			xPosResetted = true;
			xPos = 0;
			curRow += 1;
			if(curRow == 2) y += LONG_TEXT_ADD;
		}

		if(loopNum <= splitWords.length && splitWords[loopNum] != null) {
			var spaceChar:Bool = (splitWords[loopNum] == " " || (splitWords[loopNum] == "_"));
			if (spaceChar)
			{
				consecutiveSpaces++;
			}

			var isNumber:Bool = CustomCharacter.numbers.indexOf(splitWords[loopNum]) != -1;
			var isSymbol:Bool = CustomCharacter.symbols.indexOf(splitWords[loopNum]) != -1;
			var isAlphabet:Bool = CustomCharacter.alphabet.indexOf(splitWords[loopNum].toLowerCase()) != -1;

			if ((isAlphabet || isSymbol || isNumber) && (!spaceChar))
			{
				if (lastSprite != null && !xPosResetted)
				{
					lastSprite.updateHitbox();
					xPos += lastSprite.width + 3;
					// if (isBold)
					// xPos -= 80;
				}
				else
				{
					xPosResetted = false;
				}

				if (consecutiveSpaces > 0)
				{
					(type == "scratch" ? xPos += 60 * consecutiveSpaces * textSize : xPos += 200 * consecutiveSpaces * textSize);
				}
				consecutiveSpaces = 0;

				// var letter:AlphaCharacter = new AlphaCharacter(30 * loopNum, 0, textSize);
				var letter:CustomCharacter = new CustomCharacter(xPos, 55 * yMulti, textSize, type);
				letter.row = curRow;
				if (isAlternative)
				{
					if (isNumber)
					{
						letter.createAltNumber(splitWords[loopNum]);
					}
					else if (isSymbol)
					{
						letter.createAltSymbol(splitWords[loopNum]);
					}
					else
					{
						letter.createAltLetter(splitWords[loopNum]);
					}
				}
				else
				{
					if (isNumber)
					{
						letter.createNumber(splitWords[loopNum]);
					}
					else if (isSymbol)
					{
						letter.createSymbol(splitWords[loopNum]);
					}
					else
					{
						letter.createLetter(splitWords[loopNum]);
					}
				}
				letter.x += 90;

				add(letter);

				if (dropDownCharacters.contains(splitWords[loopNum]))
					letter.y += 150 * textSize;

				lastSprite = letter;
			}
		}

		loopNum++;
		if(loopNum >= splitWords.length) {
			if(tmr != null) {
				typeTimer = null;
				tmr.cancel();
				tmr.destroy();
			}
			finishedText = true;
		}
	}

	public function changeText(newText:String)
	{
		for (i in 0...lettersArray.length)
		{
			var letter = lettersArray[0];
			letter.destroy();
			remove(letter);
			lettersArray.remove(letter);
		}
		var lastX = x;
		x = 0;
		lettersArray = [];
		splitWords = [];
		curRow = 0;
		loopNum = 0;
		xPos = 0;
		xPosResetted = false;
		finishedText = false;
		consecutiveSpaces = 0;
		lastSprite = null;
		text = newText;
		_finalText = newText;
		addText();
		x = lastX;
	}

	public function addText()
	{
		doSplitWords();

		var xPos:Float = 0;
		for (character in splitWords)
		{
			var spaceChar:Bool = (character == " " || character == "_");
			if (spaceChar)
			{
				consecutiveSpaces++;
				rowSpaces[curRow]++;
			}
			var lineBreak:Bool = (character == "~");
			if (lineBreak)
			{
				curRow++;
				rowSpaces.push(0);
			}

			var isNumber:Bool = CustomCharacter.numbers.indexOf(character) != -1;
			var isSymbol:Bool = CustomCharacter.symbols.indexOf(character) != -1;
			var isAlphabet:Bool = CustomCharacter.alphabet.indexOf(character.toLowerCase()) != -1;
			if ((isAlphabet || isSymbol || isNumber || lineBreak) && (!spaceChar))
			{
				if (lineBreak)
				{
					lastSprite = null;
					xPos = 0;
				}
				else
				{
					if (lastSprite != null)
					{
						xPos = lastSprite.x + lastSprite.width;
					}

					if (consecutiveSpaces > 0)
					{
						(type == "scratch" ? xPos += 60 * consecutiveSpaces * textSize : xPos += 200 * consecutiveSpaces * textSize);
					}
					consecutiveSpaces = 0;

					// var letter:AlphaCharacter = new AlphaCharacter(30 * loopNum, 0, textSize);
					var letter:CustomCharacter = new CustomCharacter(xPos, 0, textSize, type);
					letter.row = curRow;

					if (isAlternative)
					{
						if (isNumber)
						{
							letter.createAltNumber(character);
						}
						else if (isSymbol)
						{
							letter.createAltSymbol(character);
						}
						else
						{
							letter.createAltLetter(character);
						}
					}
					else
					{
						if (isNumber)
						{
							letter.createNumber(character);
						}
						else if (isSymbol)
						{
							letter.createSymbol(character);
						}
						else
						{
							letter.createLetter(character);
						}
					}

					add(letter);

					if (type != 'scratch' && dropDownCharacters.contains(character))
						letter.y += 150 * textSize;

					lettersArray.push(letter);
					lastSprite = letter;
				}
			}
		}
		for (rowLine in 0...curRow + 1)
		{
			var totalRowWidth:Float = 0;
			for (i in 0...lettersArray.length)
			{
				if (lettersArray[i].y == ((110 - lettersArray[i].height) + (rowLine * 60)))
				{
					totalRowWidth += lettersArray[i].width;
				}
			}
			totalRowWidth += 60 * rowSpaces[rowLine] * textSize;
			for (i in 0...lettersArray.length)
			{
				if (lettersArray[i].y == ((110 - lettersArray[i].height) + (rowLine * 60)))
				{
					lettersArray[i].x -= (totalRowWidth * 0.5);
				}
			}
		}
	}

	public function killTheTimer() {
		if(typeTimer != null) {
			typeTimer.cancel();
			typeTimer.destroy();
		}
		typeTimer = null;
	}
}

class CustomCharacter extends FlxSprite
{
	public static var alphabet:String = "abcdefghijklmnopqrstuvwxyz";
	public static var numbers:String = "1234567890";
	public static var symbols:String = "?!,.";

	var _finalText:String = "";

	public var row:Int = 0;

	private var textSize:Float = 1;

	public function new(x:Float, y:Float, textSize:Float, variant:String = '')
	{
		super(x, y);
		var tex = Paths.getSparrowAtlas(variant + 'alphabet');
		frames = tex;

		setGraphicSize(Std.int(width * textSize));
		updateHitbox();
		this.textSize = textSize;
		antialiasing = ClientPrefs.globalAntialiasing;
	}

	public function createAltLetter(letter:String)
	{
		animation.addByPrefix(letter, letter + " -white", 24);
		animation.play(letter);
		updateHitbox();

		y = (110 - height);
		y += row * 60;
	}

	public function createAltNumber(letter:String):Void
	{
		animation.addByPrefix(letter, "white-" + letter, 24);
		animation.play(letter);
		updateHitbox();

		y = (110 - height);
		y += row * 60;
	}

	public function createAltSymbol(letter:String)
	{
		switch (letter)
		{
			case '.':
				animation.addByPrefix(letter, 'PERIOD -white', 24);
			case "?":
				animation.addByPrefix(letter, 'QUESTION MARK -white', 24);
			case "!":
				animation.addByPrefix(letter, 'EXCLAMATION POINT -white', 24);
			case ",":
				animation.addByPrefix(letter, 'COMMA -white', 24);
			default:
				animation.addByPrefix(letter, 'white- ' + letter, 24);
		}
		animation.play(letter);
		updateHitbox();

		y = (110 - height);
		y += row * 60;
	}

	public function createLetter(letter:String):Void
	{
		var letterCase:String = "lowercase";
		var altString:String;
		if (letter.toLowerCase() != letter)
		{
			letterCase = 'capital';
		}

		animation.addByPrefix(letter, letter + " " + letterCase, 24);

		animation.play(letter);
		updateHitbox();

		y = (110 - height);
		y += row * 60;
	}

	public function createNumber(letter:String):Void
	{
		animation.addByPrefix(letter, letter, 24);
		animation.play(letter);

		updateHitbox();

		y = (110 - height);
		y += row * 60;
	}

	public function createSymbol(letter:String)
	{
		switch (letter)
		{
			case '.':
				animation.addByPrefix(letter, 'period', 24);
			case "?":
				animation.addByPrefix(letter, 'question mark', 24);
			case "!":
				animation.addByPrefix(letter, 'exclamation point', 24);
			case ",":
				animation.addByPrefix(letter, 'comma', 24);
			default:
				animation.addByPrefix(letter, letter, 24);
		}

		animation.play(letter);

		updateHitbox();

		y = (110 - height);
		y += row * 60;
	}
}
