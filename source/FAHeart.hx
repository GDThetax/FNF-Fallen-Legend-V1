package;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class FAHeart extends FlxSprite {
    public var curBreakState:Int = 1;

    var sideAnimPrefix:String = '';

    public function new(x:Float, y:Float, side:Int) {
        super(x,y);
        
        frames = Paths.getSparrowAtlas('FabulaAmorisHearts');

        if (side == 0)
            sideAnimPrefix = 'b';
        else
            sideAnimPrefix = 's';

        for (i in 0...6) {
            animation.addByPrefix('heart_' + (i + 1), sideAnimPrefix + (i + 1), 24);
        }

        animation.play('heart_1');
    }

    public function updateBreakState() {
        animation.play('heart_' + curBreakState, true);
    }
}