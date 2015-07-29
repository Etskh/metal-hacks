package gui;




import openfl.events.MouseEvent;

import openfl.display.Sprite;
import openfl.geom.Point;
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
	var defaultButtonID:Int;
	var hoverButtonID:Int;
	var activeButtonID:Int;
	var basicWindowID:Int;
	var font:Font;

	public function new ()
	{
		this.size = 16;
		this.tilesheet = new Tilesheet( Assets.getBitmapData("assets/gui/gui-test.png"));

		for( y in 0...cols) {
			for( x in 0...rows ) {
				this.tilesheet.addTileRect( new Rectangle( x*size, y*size, size, size ));
			}
		}

		defaultButtonID = 0x11; //addFrame( 0, 0 );
		hoverButtonID = 0x11; //addFrame( 3, 3 );
		activeButtonID = 0x11; //addFrame( 4, 0 );
		basicWindowID = 0x11; //addFrame( 6, 0 );

		font = new Font();
	}

	/*public function addFrame ( xIndexTL:Int, yIndexTL:Int ) : Int
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
	}*/


	public function drawFrame( frameID:UInt, w:Float, h:Float, graphics:openfl.display.Graphics ) {
		var tiles:Array<Float> = new Array<Float>();

		for( x in 0...2 ) {
			for ( y in 0...2 ) {
				//tiles.push( frameID );
			}
		}

		// Draw them all!
		graphics.clear();
		tilesheet.drawTiles( graphics, tiles, false );
	}

	/*
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
	}*/




	public function buttonFrameID	() : Int {
		return defaultButtonID;
	}
	public function hoverButtonFrameID	() : Int {
		return hoverButtonID;
	}
	public function activeButtonFrameID	() : Int {
		return activeButtonID;
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
