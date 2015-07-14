package;




import flash.events.Event;
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
class Widget extends Sprite
{
	//public var pos:Point;
	public var desiredSize:Point;

	public function new (parent:Sprite) {
		super();
		parent.addChild(this);

		//this.pos = new Point(0,0);
		this.desiredSize = new Point(64,64);
	}

	public function resize( x:Float, y:Float ) {
		this.desiredSize = new Point(x,y);
		draw();
	}

	public function draw() {
		// empty
	}

	// TODO: Add a callback to this funciton
	public function slideTo ( pos:Point, time:Float=0 ) {
		var callback = false;
		var tween = Actuate.tween( this, time, { x:pos.x, y:pos.y } ).ease(Bounce.easeOut);

		if( callback ) {
			tween.onComplete( callback );
		}
	}
}







class Skin
{
	static var defaultSkin:GUISkin;
	var name:String="default";
	var tilesheet:Tilesheet = null;
	var SIZE = 16.0;
	var frames:Array< Array<Float>>;

	public function new ( assetPath:String, size:Float ) {
		this.SIZE = size;
		this.tilesheet = new Tilesheet( Assets.getBitmapData(assetPath));
		this.frames = new Array<Array<Float>>();

		if( skins == null) {
			skins = new Array<Skin>();
		}
		skins.push( this );
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


	public function drawFrame( frameID:Int, w:Float, h:Float, graphics:Graphics ) {
		var tiles = new Array<Float>();

		var cols:Int = Std.int ( desiredSize.x / SIZE );
		var rows:Int = Std.int ( desiredSize.y / SIZE );

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
		tilesheet.drawTiles( this.graphics, tiles, false );
	}

	static public function getDefault() {
		//
		// no skins have been made
		//
		if ( defaultSkin == null ) {
			defaultSkin = new GUISkin( "assets/gui/gui-test.png", 16.0 );
		}
		return defaultSkin;
	}
}


class GUISkin extends Skin implements GUI
{
	var basicButtonID:Int;
	var basicWindowID:Int;

	public function new() {
		super("assets/gui/gui-test.png", 16.0);

		basicButtonID = addFrame( 0, 0 );
		basicWindowID = addFrame( 3, 0 );
	}

	public function buttonFrameID	() : Int {
		return basicButtonID;
	}
	public function windowFrameID	() : Int {
		return basicWindowID;
	}
}



class Button extends Widget
{
	public function new( text:String, parent:Widget=null, skin:GUISkin = Skin.getDefault() ) {
		super(parent);
		this.desiredSize = new Point(128,64);
		skin.drawFrame( skin.buttonFrameID(), desiredSize.x, desiredSize.y, this.graphics );
	}

	public function onClick( callback:Void -> Void ) {
		// empty
	}
}


/*
// Does a frame, and can have children
//
// TODO: this would be better suited for a CRTP
class FramedWidget extends Widget
{
	static var tilesheet:Tilesheet = null;
	static var SIZE = 16.0;
	static var BUTTON_DEF_TL:Int;
	static var BUTTON_DEF_TC:Int;
	static var BUTTON_DEF_TR:Int;
	static var BUTTON_DEF_ML:Int;
	static var BUTTON_DEF_MC:Int;
	static var BUTTON_DEF_MR:Int;
	static var BUTTON_DEF_BL:Int;
	static var BUTTON_DEF_BC:Int;
	static var BUTTON_DEF_BR:Int;

	public function new ( parent:Sprite ) {
		super(parent);

		if( tilesheet == null ) {
			tilesheet = new Tilesheet( Assets.getBitmapData("assets/gui/gui-test.png"));
			BUTTON_DEF_TL = tilesheet.addTileRect( new Rectangle( 0*SIZE, 0*SIZE, SIZE, SIZE ));
			BUTTON_DEF_TC = tilesheet.addTileRect( new Rectangle( 1*SIZE, 0*SIZE, SIZE, SIZE ));
			BUTTON_DEF_TR = tilesheet.addTileRect( new Rectangle( 2*SIZE, 0*SIZE, SIZE, SIZE ));
			BUTTON_DEF_ML = tilesheet.addTileRect( new Rectangle( 0*SIZE, 1*SIZE, SIZE, SIZE ));
			BUTTON_DEF_MC = tilesheet.addTileRect( new Rectangle( 1*SIZE, 1*SIZE, SIZE, SIZE ));
			BUTTON_DEF_MR = tilesheet.addTileRect( new Rectangle( 2*SIZE, 1*SIZE, SIZE, SIZE ));
			BUTTON_DEF_BL = tilesheet.addTileRect( new Rectangle( 0*SIZE, 2*SIZE, SIZE, SIZE ));
			BUTTON_DEF_BC = tilesheet.addTileRect( new Rectangle( 1*SIZE, 2*SIZE, SIZE, SIZE ));
			BUTTON_DEF_BR = tilesheet.addTileRect( new Rectangle( 2*SIZE, 2*SIZE, SIZE, SIZE ));
		}

		draw();
	}


	override public function draw() {

		// Get the closest size of the thing to the multiples of 16
		var scale = new Point(1,1);
		var tiles = new Array<Float>();

		//var how many inside
		var cols:Int = Std.int ( desiredSize.x / SIZE );
		var rows:Int = Std.int ( desiredSize.y / SIZE );

		// Add the four corners
		tiles = tiles.concat([
			0,				0,				BUTTON_DEF_TL,
			(cols-1)*SIZE,	0,				BUTTON_DEF_TR,
			0,				(rows-1)*SIZE,	BUTTON_DEF_BL,
			(cols-1)*SIZE,	(rows-1)*SIZE,	BUTTON_DEF_BR,
		]);


		// Add the top and bottom
		for( x in 1...cols-1 ) {
			tiles = tiles.concat([
				x*SIZE, 0, BUTTON_DEF_TC,
				x*SIZE, (rows-1)*SIZE, BUTTON_DEF_BC
			]);
		}

		// Add the left and right
		for( y in 1...rows-1 ) {
			tiles = tiles.concat([
				0, y*SIZE, BUTTON_DEF_ML,
				(cols-1)*SIZE, y*SIZE, BUTTON_DEF_MR
			]);
		}

		// Add all the centre tiles
		for( x in 1...cols-1 ) {
			for( y in 1...rows-1 ) {
				tiles = tiles.concat([x*SIZE, y*SIZE, BUTTON_DEF_MC ]);
			}
		}


		// Draw them all!
		graphics.clear();
		tilesheet.drawTiles( this.graphics, tiles, false );
	}
}*/





class Font
{
	public var name:String;
	public var letters:Array<Letter>;

	public function new ( name:String ) {
		this.name = name;
		this.letters = new Array<Letter>();
	}

	static public function getDefault() : Font {
		var font = new Font("default");
		var width= 16;
		var col = 1;
		var row = 0;

		// space
		font.letters.push(new Letter(32, 0.8, [0, 0])); // space

		// lower-case
		//
		for( c in 0...26) {
			if(col==width) {
				col=0;
				row++;
			}
			font.letters.push(new Letter(97+c, 0.8, [ col, row]));
		}

		// upper-case
		//
		for( c in 0...26) {
			if(col==width) {
				col=0;
				row++;
			}
			font.letters.push(new Letter(65+c, 0.8, [ col, row]));
		}

		return font;
	}

}


class Letter
{
	public var breadth:Float;
	public var charCode:Int;
	public var height:Float;
	public var point:Array<Int>;

	public function new ( charCode:Int, breadth:Float, points:Array<Int>, height:Float = 0) {
		this.charCode= charCode;
		this.breadth = breadth;
		this.height  = height;
		this.point = points;
	}
}
