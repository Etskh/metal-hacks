package;




import openfl.events.MouseEvent;

import openfl.display.Sprite;
import openfl.geom.Point;
import motion.easing.Bounce;
import motion.Actuate;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.geom.Rectangle;







class Skin
{
	static var defaultSkin:Skin = null;
	var name:String="default";
	var tilesheet:Tilesheet = null;
	var SIZE = 16.0;
	var frames:Array< Array<Float>>;
	var basicButtonID:Int;
	var basicWindowID:Int;
	var font:Font;

	public function new ()
	{
		this.SIZE = 16;
		this.tilesheet = new Tilesheet( Assets.getBitmapData("assets/gui/gui-test.png"));
		this.frames = new Array<Array<Float>>();

		basicButtonID = addFrame( 0, 0 );
		basicWindowID = addFrame( 3, 0 );
		font = new Font();

	}

	public function addFrame ( xIndexTL:Int, yIndexTL:Int ) : Int
	{
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




	public function buttonFrameID	() : Int {
		return basicButtonID;
	}
	public function windowFrameID	() : Int {
		return basicWindowID;
	}
	public function getFont() : Font {
		return font;
	}


	static public function getDefault() {
		//
		// no skins have been made
		//
		if ( defaultSkin == null ) {
			defaultSkin = new Skin();
		}
		return defaultSkin;
	}
}

















typedef WidgetCallback = Widget -> Void;
typedef TweenCallback = Void -> Void;

class Widget extends Sprite
{
	var skin:Skin;
	var callbacks:Map <String, Array<WidgetCallback> >;
	public var size:Point;
	var frameID:Null<Int>;
	var frameSprite:Sprite;
	var textSprite:Sprite;
	var textString:String;
	var textSize:Int;
	var hitboxSprite:Sprite;
	var collisionOn:Bool;
	var containerSprite:Sprite;

	public function new () {
		super();

		// Create the event callbacks
		this.callbacks = new Map <String, Array<WidgetCallback> >();
		this.skin = Skin.getDefault();
		this.size = new Point(128,32);

		// Background
		//
		this.frameSprite = new Sprite();
		this.frameID = null;
		addChild( this.frameSprite );

		// Text
		//
		this.textSprite = new Sprite(); // start with empty string
		textString = "";
		addChild( this.textSprite );

		// Hitbox
		//
		this.hitboxSprite = new Sprite(); // start with no collision
		collisionOn = false;
		addChild( this.hitboxSprite );

		// collision
		//
		this.containerSprite = new Sprite();
		addChild( this.containerSprite );
	}


	public function resize ( nsize:Point ) {
		this.size = nsize;
		if( this.frameID != null ) {
			this.frameSprite.graphics.clear();
			this.skin.drawFrame( this.frameID, size.x, size.y, this.frameSprite.graphics );
		}
		if( this.textString != "" ) {
			this.textSprite.graphics.clear();
			this.textSprite.y = 6;
			this.skin.getFont().drawText( textString, textSize, this.textSprite.graphics, size.x, Font.Centre );
		}
		if( this.collisionOn == true ) {
			this.hitboxSprite.graphics.clear();
			this.hitboxSprite.graphics.beginFill( 0xFF0000, Debug.drawHitboxes?0.05:0.0 );
			this.hitboxSprite.graphics.drawRect( 0, 0, size.x, size.y );
			this.hitboxSprite.graphics.endFill();
		}
	}

	public function hitbox () : Sprite {
		if( this.collisionOn == false ) {
			this.collisionOn = true;
			this.hitboxSprite.buttonMode = true;
			this.hitboxSprite.addEventListener( MouseEvent.CLICK, this._onClick );
			this.hitboxSprite.addEventListener( MouseEvent.MOUSE_OVER, this._onOver );
			this.hitboxSprite.addEventListener( MouseEvent.MOUSE_OUT, this._onOut );
			this.hitboxSprite.addEventListener( MouseEvent.MOUSE_DOWN, this._onDown );
			this.hitboxSprite.addEventListener( MouseEvent.MOUSE_UP, this._onOver );

			this.hitboxSprite.graphics.clear();
			this.hitboxSprite.graphics.beginFill( 0xFF0000, Debug.drawHitboxes?0.05:0.0 );
			this.hitboxSprite.graphics.drawRect( 0, 0, size.x, size.y );
			this.hitboxSprite.graphics.endFill();
		}

		return this.hitboxSprite;
	}

	public function setFrameID( id:Int ) {
		this.frameID = id;
		this.frameSprite.graphics.clear();
		this.skin.drawFrame( this.frameID, size.x, size.y, this.frameSprite.graphics );
	}

	public function setText( text:String, size:Int ) {
		this.textString = text;
		this.textSize = size;
		this.textSprite.graphics.clear();
		this.skin.getFont().drawText( textString, textSize, this.textSprite.graphics, this.size.x, Font.Centre );
	}

	public function container () : Sprite {
		return containerSprite;
	}

	public function add ( child:Sprite ) {
		container().addChild( child );
	}






	// Movement
	//
	public function slideTo ( pos:Point, time:Float, callback:TweenCallback ) {
		var tween = Actuate.tween( this, time, { x:pos.x, y:pos.y } );
		tween.ease( Bounce.easeOut );
		tween.onComplete( callback );
	}






	//
	// Callback-wrappers
	//
	public function addCallback( event:String, callback:WidgetCallback ) {

		// Thing does stuff? Add a hitbox.
		hitbox();

		var callbackList = this.callbacks.get(event);
		if( callbackList == null ) {
			callbackList = new Array<WidgetCallback>();
			this.callbacks.set( event, callbackList );
		}
		callbackList.push( callback );
	}

	//
	// Fires all callbacks registered to an event
	// returns the number of callbacks attached to the event name
	//
	public function fireCallbacks ( eventName:String, widget:Widget ) {
		var callbackList = this.callbacks.get(eventName);
		if( callbackList == null ) {
			return 0;
		}
		for( c in 0...callbackList.length ) {
			callbackList[c](widget);
		}
		return callbackList.length;
	}


	//
	// "Real" events
	//
	//
	public function _onClick ( e:Dynamic ) {
		fireCallbacks( "click", e );
	}
	public function _onOver ( e:Dynamic ) {
		if( e.relatedObject != null ) {
			var widget:Widget = cast e.relatedObject.parent;
			fireCallbacks( "over", widget);
		}
	}
	public function _onOut ( e:Dynamic ) {
		if( e.relatedObject != null ) {
			var widget:Widget = cast e.relatedObject.parent;
			fireCallbacks( "out", widget);
		}
	}
	public function _onDown ( e:Dynamic ) {
		if( e.relatedObject != null ) {
			var widget:Widget = cast e.relatedObject.parent;
			fireCallbacks( "down", widget);
		}
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

	public static inline var Centre=0;
	public static inline var Center=0;
	public static inline var Left=1;
	public static inline var Right=2;

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




	public function drawText ( text:String, size:Float, graphics:openfl.display.Graphics, width:Float, align:Int ) {
		var drawList:Array<Float> = new Array<Float>();

		// Choose a starting position
		var cursor:Float = (
			(align==Font.Left)?
				0 : ((align==Font.Right) ?
					width - this.getTextWidth(text,size) :
					width/2 - this.getTextWidth(text,size)/2
				)
			);

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








class GUI extends Sprite
{
	public function new() {
		super();
	}


	public function createButton( text:String, size:Point, onClick:WidgetCallback ) : Widget
	{
		var button:Widget;
		var skin:Skin = Skin.getDefault();

		button = new Widget();

		button.setText( text, 16 );
		button.addCallback( "click", onClick );
		button.addCallback( "over", this._buttonOver );
		button.addCallback( "out", this._buttonOut );
		button.addCallback( "down", this._buttonDown );
		button.setFrameID( skin.buttonFrameID() );
		button.resize( size );

		return button;
	}



	public function _buttonOver ( widget:Widget ) {
		var hitbox:Sprite = widget.hitbox();

		// later, just set the frameID to overbutton

		hitbox.graphics.clear();
		hitbox.graphics.beginFill( 0xFFFFFF, 0.05 );
		hitbox.graphics.drawRect( 0, 0, widget.size.x, widget.size.y );
		hitbox.graphics.endFill();
	}

	public function _buttonOut ( widget:Widget ) {
		var hitbox:Sprite = widget.hitbox();

		// later, just set the frameID to out-button

		hitbox.graphics.clear();
		hitbox.graphics.beginFill( 0xFFFFFF, 0 );
		hitbox.graphics.drawRect( 0, 0, widget.size.x, widget.size.y );
		hitbox.graphics.endFill();
	}

	public function _buttonDown ( widget:Widget ) {
		var hitbox:Sprite = widget.hitbox();

		// later, just set the frameID to downbutton

		hitbox.graphics.clear();
		hitbox.graphics.beginFill( 0x000000, 0.2 );
		hitbox.graphics.drawRect( 0, 0, widget.size.x, widget.size.y );
		hitbox.graphics.endFill();
	}
}
