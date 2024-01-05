package;

import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class TraClaw extends FlxSprite
{
	var clawVariant:String = '';
	var NoteID:Int;
	var trackedNote:Note;
	var NoteSprite:Note;

	public var NoteGroup:FlxTypedGroup<Note>;

	var shiftPosition:Float;

	public var strum:FlxTypedGroup<StrumNote>;

	var sawData:Array<Dynamic>;

	var sawDistractionTimer:FlxTimer;
	var toggleSwing:Bool = true;

	public var preLoadedAsset:Bool = false;

	var totalElapsed:Float = 0;

	public function new(x:Float, y:Float, variant:String, ignoreNoteCode:Bool = false, ?NoteID:Int, ?NoteSprite:Note, ?shiftPosition:Float)
	{
		super(x, y);

		this.clawVariant = variant;
		this.NoteID = NoteID;
		this.trackedNote = NoteSprite;
		this.NoteSprite = NoteSprite;
		this.shiftPosition = shiftPosition;
		this.preLoadedAsset = ignoreNoteCode;
		switch (variant)
		{
			case 'saw note':
				frames = Paths.getSparrowAtlas('UpdatedClawAnimations');
				animation.addByPrefix('slicerAnim', 'Slicer', 24, false);
				animation.play('slicerAnim');
				if (!ignoreNoteCode)
					FlxTween.tween(this, {x: NoteSprite.x + 10}, (7 / 12), {ease: FlxEase.expoOut, onComplete: removeNote});

			case 'grab Note':
				frames = Paths.getSparrowAtlas('UpdatedClawAnimations');
				animation.addByPrefix('noteRelease', 'Grabber_Slide-release', 24, false);
				animation.addByPrefix('noteGrab', 'Grabber_Slide-grab', 24, false);
				animation.play('noteGrab');
				if (!ignoreNoteCode)
					FlxTween.tween(this, {x: NoteSprite.x}, (7 / 24), {ease: FlxEase.expoOut, onComplete: shiftNote});
			case 'saw distraction':
				frames = Paths.getSparrowAtlas('SawGameplay');
				animation.addByPrefix('distraction', 'Distraction', 24);
				animation.addByPrefix('preSaw', 'SawPre', 24, false);
				animation.addByPrefix('saw', 'Sawsaw', 24);
				animation.addByPrefix('break', 'SawBreak', 24, false);
				animation.play('distraction');

				sawDistractionTimer = new FlxTimer();
		}

		antialiasing = ClientPrefs.globalAntialiasing;
	}

	override function update(elapsed:Float)
	{
		totalElapsed += elapsed;

		switch (this.clawVariant)
		{
			case 'saw note':
			case 'grab Note':
			case 'saw distraction':
				if (toggleSwing)
					angle = 260 + FlxMath.lerp(0, 20, -Math.cos(Math.PI * totalElapsed / 2) / 2 + .5);
		}

		if (this.clawVariant != 'saw distraction' && trackedNote != null)
		{
			if (!trackedNote.alive)
			{
				scrollFactor.set();
				return;
			}
			else
			{
				setPosition(trackedNote.x, trackedNote.y);
				scrollFactor.set(trackedNote.scrollFactor.x, trackedNote.scrollFactor.y);
			}
		}
		// if (this.clawVariant == 'saw distraction' && trackedNote == null)
		//	return;

		super.update(elapsed / 2);
	}

	function setSawData()
	{
		this.sawData = [
			[
				(FlxG.height / 2) - 475,
				-1025,
				this.strum.members[NoteID].y - 512,
				-135,
				100,
				-1025
			],
			[
				(FlxG.height / 2) + 200,
				(FlxG.height / 2) + 200 + 910,
				this.strum.members[NoteID].y + this.strum.members[NoteID].height + 260,
				-135,
				-100,
				(FlxG.height / 2) + 200 + 910
			]
		];
	}

	var directionSaw:Int = ClientPrefs.downScroll ? 1 : 0;

	public function triggerSawMech(distractionDuration:Float, StrumID:Int, ?debugY:Float)
	{
		NoteID = StrumID;
		setSawData();
		FlxTween.tween(this, {y: sawData[directionSaw][0]}, 3, {ease: FlxEase.backOut});
		sawDistractionTimer.start(3 + distractionDuration, sawStages);
	}

	function sawStages(timer:FlxTimer):Void
	{
		FlxTween.tween(this, {y: sawData[directionSaw][1]}, 3, {
			ease: FlxEase.backIn,
			onComplete: function(stage2:FlxTween)
			{
				toggleSwing = false;
				animation.play('preSaw');
				angle = 270;
				x += (strum.members[NoteID].width * NoteID) - 10;
			}
		});
		FlxTween.tween(this, {y: sawData[directionSaw][2]}, (12 / 24), {
			ease: FlxEase.circIn,
			startDelay: 3,
			onComplete: function(stage3:FlxTween)
			{
				animation.play('saw');
				new FlxTimer().start(1.5, function(stage4:FlxTimer)
				{
					animation.play('break');
					strum.members[NoteID].alpha = 0.5;
					FlxTween.tween(this, {x: x + sawData[directionSaw][3], y: y + sawData[directionSaw][4]}, (4 / 24), {
						ease: FlxEase.circOut
					});
					FlxTween.tween(this, {y: sawData[directionSaw][5]}, 2, {
						ease: FlxEase.cubeOut,
						startDelay: (4 / 24),
						onComplete: function(stage6:FlxTween)
						{
							animation.play('distraction');
							x = (FlxG.width / 2) - 325;
							toggleSwing = true;
						}
					});
				});
			}
		});
	}

	public function preExecuteSaw()
	{
		FlxTween.tween(this, {y: ClientPrefs.downScroll ? this.y - 500 : this.y + 500}, 1, {
			onComplete: function(reset:FlxTween)
			{
				ClientPrefs.downScroll ? y += 500 : y -= 500;
			}
		});
	}

	public function preExecuteClaw()
	{
		animation.play('noteRelease');
		FlxTween.tween(this, {x: this.x - 1500}, 1, {
			onComplete: function(reset:FlxTween)
			{
				x += 1500;
				destroy();
			}
		});
	}

	function removeNote(twn:FlxTween)
	{
		trackedNote = null;
		NoteSprite.kill();
		NoteGroup.remove(NoteSprite, true);
		NoteSprite.destroy();
		FlxTween.tween(this, {x: FlxG.width}, 1, {
			ease: FlxEase.expoOut,
			onComplete: destroyAsset.bind(_, this)
		});
	}

	function shiftNote(twn:FlxTween)
	{
		FlxTween.tween(NoteSprite, {x: shiftPosition}, 0.3, {
			ease: FlxEase.expoOut
		});

		FlxTween.tween(this, {x: shiftPosition}, 0.3, {
			ease: FlxEase.expoOut,
			onComplete: function(removeClaw:FlxTween)
			{
				animation.play('noteRelease');
				trackedNote = null;
			}
		});
		FlxTween.tween(this, {x: FlxG.width}, 1, {ease: FlxEase.circOut, startDelay: 0.3, onComplete: destroyAsset.bind(_, this)});
	}

	function destroyAsset(tween:FlxTween, asset:FlxSprite, destroy:Bool = true):Void
	{
		if (destroy)
			asset.destroy();
	}
}
