package;




import openfl.events.MouseEvent;

import openfl.display.Sprite;
import openfl.geom.Point;
import motion.easing.Bounce;
import motion.Actuate;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.geom.Rectangle;





interface GUI
{
	public function windowFrameID	() : Int ;
	public function buttonFrameID	() : Int ;
}






// Does animating, placement, and flow
//
typedef WidgetCallback = Dynamic -> Void;

class Widget extends Sprite
{
	//public var pos:Point;
	public var desiredSize:Point;
	var hitbox:Sprite;
	var frame:Sprite;
	var innerLip:Float;
	var callbacks:Map <String, Array<WidgetCallback> >;

	public function new (parent:Sprite) {
		super();
		parent.addChild(this);

		this.frame = new Sprite();
		addChild( frame );

		// Create the event callbacks
		this.callbacks = new Map <String, Array<WidgetCallback> >();

		// Creating the hitbox
		this.hitbox = new Sprite();
		addChild( hitbox );
		this.hitbox.buttonMode = true;
		this.hitbox.addEventListener( MouseEvent.CLICK, this._onClick );

		// Resize all the sprites
		innerLip = 12;
		this.resize( 64, 64);
	}

	public function resize( x:Float, y:Float ) {
		this.desiredSize = new Point(x,y);
		this.hitbox.graphics.clear();
		this.hitbox.graphics.beginFill( 0xFF0000, 0.3 );
		this.hitbox.graphics.drawRect( 0, 0, x, y );
		this.hitbox.graphics.endFill();
	}


	// TODO: Add a callback to this funciton
	public function slideTo ( pos:Point, time:Float=0 ) {
		var callback = false;
		var tween = Actuate.tween( this, time, { x:pos.x, y:pos.y } ).ease(Bounce.easeOut);

		if( callback ) {
			tween.onComplete( callback );
		}
	}


	public function onClick( callback:WidgetCallback ) {
		Debug.log("GUI","Adding callback to GUI element");
		addCallback("click", callback );
	}

	public function addCallback( event:String, callback:WidgetCallback ) {
		var callbackList = this.callbacks.get(event);
		if( callbackList == null ) {
			callbackList = new Array<WidgetCallback>();
			this.callbacks.set( event, callbackList );
		}
		callbackList.push( callback );
	}

	public function _onClick ( e:Dynamic ) {
		trace("CLICKED");
		var callbackList = this.callbacks.get("click");
		if( callbackList == null ) {
			return;
		}
		for( c in 0...callbackList.length ) {
			callbackList[c](e);
		}
	}
}







class Skin
{
	static var defaultSkin:GUISkin = null;
	var name:String="default";
	var tilesheet:Tilesheet = null;
	var SIZE = 16.0;
	var frames:Array< Array<Float>>;


	public function new ( assetPath:String, size:Float ) {
		this.SIZE = size;
		this.tilesheet = new Tilesheet( Assets.getBitmapData(assetPath));
		this.frames = new Array<Array<Float>>();

	}

	public function addFrame ( xIndexTL:Int, yIndexTL:Int ) : Int {
		var frame:Array<Float> = [
			// Top-left
			tilesheet.addTileRect( new Rectangle( (xIndexTL+0)*SIZE, (yIndexTL+0)*SIZE, SIZE, SIZE )),
			// Top-center
			tilesheet.addTileRect( new Rectangle( (xIndexTL+1)*SIZE, (yIndexTL+0)*SIZE, SIZE, SIZE )),
			// Top-right
			tilesheet.addTileRect( new Rectangle( (xIndexTL+2)*SIZE, (yIndexTL+0)*SIZE, SIZE, SIZE )),

			// Middle-left
			tilesheet.addTileRect( new Rectangle( (xIndexTL+0)*SIZE, (yIndexTL+1)*SIZE, SIZE, SIZE )),
			// Repeat (Middle-center)
			tilesheet.addTileRect( new Rectangle( (xIndexTL+1)*SIZE, (yIndexTL+1)*SIZE, SIZE, SIZE )),
			// Middle-right
			tilesheet.addTileRect( new Rectangle( (xIndexTL+2)*SIZE, (yIndexTL+1)*SIZE, SIZE, SIZE )),

			// Bottom-left
			tilesheet.addTileRect( new Rectangle( (xIndexTL+0)*SIZE, (yIndexTL+2)*SIZE, SIZE, SIZE )),
			// Bottom-center
			tilesheet.addTileRect( new Rectangle( (xIndexTL+1)*SIZE, (yIndexTL+2)*SIZE, SIZE, SIZE )),
			// Bottom-right
			tilesheet.addTileRect( new Rectangle( (xIndexTL+2)*SIZE, (yIndexTL+2)*SIZE, SIZE, SIZE )),
		];

		return this.frames.push( frame );
	}


	public function drawFrame( frameID:Int, w:Float, h:Float, graphics:openfl.display.Graphics ) {
		var tiles = new Array<Float>();

		var cols:Int = Std.int ( w / SIZE );
		var rows:Int = Std.int ( h / SIZE );

		// Add the four corners
		tiles = tiles.concat([
			0,				0,				frames[frameID][0],
			(cols-1)*SIZE,	0,				frames[frameID][2],
			0,				(rows-1)*SIZE,	frames[frameID][6],
			(cols-1)*SIZE,	(rows-1)*SIZE,	frames[frameID][8],
		]);


		// Add the top and bottom
		for( x in 1...cols-1 ) {
			tiles = tiles.concat([
				x*SIZE,		0,				frames[frameID][1],
				x*SIZE,		(rows-1)*SIZE,	frames[frameID][7]
			]);
		}

		// Add the left and right
		for( y in 1...rows-1 ) {
			tiles = tiles.concat([
				0,				y*SIZE,		frames[frameID][3],
				(cols-1)*SIZE,	y*SIZE,		frames[frameID][5]
			]);
		}

		// Add all the centre tiles
		for( x in 1...cols-1 ) {
			for( y in 1...rows-1 ) {
				tiles = tiles.concat([x*SIZE, y*SIZE, frames[frameID][4] ]);
			}
		}

		// Draw them all!
		graphics.clear();
		tilesheet.drawTiles( graphics, tiles, false );
	}

	static public function getDefault() {
		//
		// no skins have been made
		//
		if ( defaultSkin == null ) {
			defaultSkin = new GUISkin();
		}
		return defaultSkin;
	}
}


class GUISkin extends Skin implements GUI
{
	var basicButtonID:Int;
	var basicWindowID:Int;
	var font:Font;

	public function new( ) {
		super("assets/gui/gui-test.png", 16.0);

		basicButtonID = addFrame( 0, 0 );
		basicWindowID = addFrame( 3, 0 );

		font = new Font();
	}

	public function buttonFrameID	() : Int {
		return basicButtonID;
	}
	public function windowFrameID	() : Int {
		return basicWindowID;
	}
	public function getFont() : Font {
		return font;
	}
}





class Button extends Widget
{
	public var skin:GUISkin;
	var textSprite:Sprite;

	public function new( text:String, parent:Sprite=null ) {
		super(parent);

		this.hitbox.buttonMode = true;
		this.hitbox.useHandCursor = true;

		this.textSprite = new Sprite();
		addChild( this.textSprite );

		this.skin = Skin.getDefault();
		this.resize(128,64);

		this.skin.getFont().drawText( text, 32, this.textSprite.graphics );
	}
}







class Letter {
	public var tileID:Int;
	public var charCode:Int;
	public var breadth:Float;

	public function new ( letter:String, tileID:Int, breadth:Null<Float>=1.0 ) {
		this.charCode = letter.charCodeAt(0);
		this.tileID = tileID;
		this.breadth= breadth;
	}

}








class Font {

	var breadth:Int;
	var tileSize:Int;
	var tilesheet:Tilesheet;
	var letters:Map<Int,Letter>;

	public function new () {

		var data:openfl.display.BitmapData = Assets.getBitmapData("assets/gui/font-sheet-32.png");
		this.tilesheet = new Tilesheet(data);
		this.tileSize = 32;
		this.breadth = data.width;

		var cols:Int = cast ( data.width / tileSize );
		var rows:Int = cast ( data.height / tileSize );

		for( x in 0...rows ) {
			for( y in 0...cols) {
				tilesheet.addTileRect( new Rectangle( x*tileSize, y*tileSize, tileSize, tileSize ));
			}
		}

		this.letters = new Map<Int,Letter>();

		var data:Array<Letter> = [
			// special
			new Letter(" ", 0xFF, 0.3),

		  // 0 - lowercase
			new Letter("a", 0x00, 0.5),
			new Letter("b", 0x01 ),
			new Letter("c", 0x02 ),
			new Letter("d", 0x03 ),
			new Letter("e", 0x04, 0.5 ),
			new Letter("f", 0x05 ),
			new Letter("g", 0x06 ),
			new Letter("h", 0x07 ),
			new Letter("i", 0x08 ),
			new Letter("j", 0x09 ),
			new Letter("k", 0x0A ),
			new Letter("l", 0x0B, 0.25 ),
			new Letter("m", 0x0C ),
			new Letter("n", 0x0D ),
			new Letter("o", 0x0E, 0.5),
			new Letter("p", 0x0F ),
			// 1 - lowercase
			new Letter("q", 0x10 ),
			new Letter("r", 0x11 ),
			new Letter("s", 0x12 ),
			new Letter("t", 0x13, 0.35),
			new Letter("u", 0x14 ),
			new Letter("v", 0x15 ),
			new Letter("w", 0x16 ),
			new Letter("x", 0x17 ),
			new Letter("y", 0x18 ),
			new Letter("z", 0x19 ),
			// 2 - UPPERCASE
			new Letter("A", 0x20 ),
			new Letter("B", 0x21, 0.7),
			new Letter("C", 0x22 ),
			new Letter("D", 0x23 ),
			new Letter("E", 0x24 ),
			new Letter("F", 0x25 ),
			new Letter("G", 0x26 ),
			new Letter("H", 0x27 ),
			new Letter("I", 0x28 ),
			new Letter("J", 0x29 ),
			new Letter("K", 0x2A ),
			new Letter("L", 0x2B ),
			new Letter("M", 0x2C ),
			new Letter("N", 0x2D ),
			new Letter("O", 0x2E ),
			new Letter("P", 0x2F ),
			// 3 - more UPPERCASE
			new Letter("Q", 0x30 ),
			new Letter("R", 0x31 ),
			new Letter("S", 0x32 ),
			new Letter("T", 0x33, 0.5),
			new Letter("U", 0x34 ),
			new Letter("V", 0x35 ),
			new Letter("W", 0x36 ),
			new Letter("X", 0x37 ),
			new Letter("Y", 0x38 ),
			new Letter("Z", 0x39 ),
			// 4 - Arithmetic
			//
			// 5 - Symbols
			new Letter(".", 0x50 ),
			new Letter(",", 0x51 ),
			new Letter(":", 0x52 ),
			new Letter(";", 0x53 ),
			new Letter("!", 0x54, 0.25),
			new Letter("?", 0x55 ),
			new Letter("-", 0x56 ),
			new Letter("(", 0x57 ),
			new Letter(")", 0x58 ),
		];

		for( l in 0...data.length ) {
			this.letters.set(data[l].charCode, data[l]);
		}
	}




	public function drawText ( text:String, size:Float, graphics:openfl.display.Graphics ) {
		var drawList:Array<Float> = new Array<Float>();

		var cursor:Float = 0;
		for( c in 0...text.length ) {
			var letter:Letter = this.letters.get( text.charCodeAt(c) );
			if( letter == null ) {
				trace("ERROR: Could not find code for `"+text.charAt(c)+"` character.");
				continue;
			}

			var margin = (this.tileSize * (1 - letter.breadth)) / 2;

			// Add to the draw list
			drawList.push( cursor - margin );	// x-coord
			drawList.push( 0 );				// y-coord
			drawList.push( letter.tileID );
			drawList.push( size / this.tileSize );				// scale

			cursor += size * letter.breadth;
		}

		tilesheet.drawTiles( graphics, drawList, true, Tilesheet.TILE_SCALE);
	}


	// Gets the text's estimated width in pixels
	// Right now, it returns the exact measurements, but don't expect it
	// to always be perfect, as this function is made to be more of an estimate
	//
	public function getTextWidth ( text:String, size:Float ):Float {
		var cursor:Float = 0;
		for( c in 0...text.length ) {
			var letter:Letter = this.letters.get( text.charCodeAt(c) );
			if( letter == null ) {
				trace("ERROR: Could not find code for `"+text.charAt(c)+"` character.");
				continue;
			}
			cursor += size * letter.breadth;
		}
		return cursor;
	}

}
