package character;


import openfl.display.BitmapData;
import openfl.Assets;

/**
 *
 * Slot class holds information for slots on a character.
 * Some slots can be thought of inventory spaces (torso, instrument, legs)
 * Other slots are more permanent fixtures: ( face, hair, debug )
 *
 */
class Slot
{
    public function new ( name:String, assetPath:String )
    {
        // Get the bitmap data
        _bitmap = Assets.getBitmapData( assetPath );

        // Set the name object
        _name = name;

        // Statblock!
        _statblock = new StatBlock();
    }

    // Set the pallate
    public function setColours( red:UInt, green:UInt, blue:UInt )
    {
        _redColour  = red;
        _greenColour= green;
        _blueColour = blue;
    }


    public function getName () : String
    {
        return _name;
    }

    // Returns the bitmap data
    public function getBitmap () : BitmapData
    {
        return _bitmap;
    }


    // Colours
    public function getRed () : UInt
    {
        return _redColour;
    }

    public function getGreen() : UInt
    {
        return _greenColour;
    }

    public function getBlue () : UInt
    {
        return _blueColour;
    }

    var _bitmap:BitmapData;
    var _redColour:UInt;
    var _greenColour:UInt;
    var _blueColour:UInt;
    var _name:String;
    var _statblock:StatBlock;
}
