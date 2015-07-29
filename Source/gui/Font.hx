package gui;


import openfl.events.MouseEvent;

import openfl.display.Sprite;
import openfl.geom.Point;
import motion.easing.Bounce;
import motion.Actuate;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.geom.Rectangle;






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
