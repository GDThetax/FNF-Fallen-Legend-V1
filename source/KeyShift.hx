package;

using StringTools;

class KeyShift {
    static var directionMap:Map<String, Bool> = [
        'L' => false,
        'R' => true
    ];


    static var shiftKeyArray:Array<Dynamic> = [];
    public static var defaultKeyArray:Array<Dynamic> = [];
    public static function shiftKeys(shiftCode:String, keyReference:Array<Dynamic>):Array<Dynamic> {
        var shiftCodeData:Array<String> = shiftCode.split("");
        defaultKeyArray = keyReference;
        for (i in 0...keyReference.length) {
            shiftKeyArray.push(keyReference[applyShift(i, Std.parseInt(shiftCodeData[1]), directionMap[shiftCodeData[0]])]);
        }
        return shiftKeyArray;
    }

    static function applyShift(key:Int, value:Int, direction:Bool):Int {
        direction ? key += value : key -= value;
        if (key > 3) key -= 4;
        else if (key < 0) key += 4;
        return key;
    }

    /*static function getDirection(reference:String) {
        var retBool:Bool = false;
        switch (reference) {
            case 'L':
                retBool = false;
            case 'R':
                retBool = true;
        }
        return retBool;
    }*/
}