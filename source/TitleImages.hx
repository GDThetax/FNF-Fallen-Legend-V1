package;

import flixel.FlxG;

using StringTools;
class TitleImages {
    public static var unlockedImages:Array<String> = [
        "rose",
        "doves",
        "hearts",
        "hanging_body"
    ];
    
    public static function addImagesToUnlocked(lockedSegment:Int):Void {
        for (i in 0...lockedImages[lockedSegment].length) {
            if (!unlockedImages.contains(lockedImages[lockedSegment][i]))
                unlockedImages.push(lockedImages[lockedSegment][i]);
        }
		FlxG.save.data.unlockedImages = unlockedImages;
    }

    public static function RESETTHISSTUPIDTHING() {
        unlockedImages = 
        [
            "rose",
            "doves",
            "hearts",
            "hanging_body",
            "sitting",
            "words",
            "bars",
            "sophie",
            "claw",
            "virus",
            "blake",
            "sophieTM",
            "room",
            "hanging_blake",
            "fabula_amoris",
            "bodies",
            "victim"
        ];
        FlxG.save.data.unlockedImages = unlockedImages;
    }

    public static var lockedImages:Array<Array<String>> = [
        [
            "sitting",
            "words",
            "bars"
        ],
        [
            "sophie",
            "claw",
            "virus"
        ],
        [
            "blake",
            "sophieTM"
        ],
        [
            "room",
            "hanging_blake"
        ],
        [
            "fabula_amoris"
        ],
        [
            "bodies",
            "victim"
        ]

    ];
}