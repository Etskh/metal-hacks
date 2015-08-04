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
	var size:Float;
	var frames:Array< Array<Float>>;
	var defaultButtonID:Int;
	var hoverButtonID:Int;
	var activeButtonID:Int;
	var basicWindowID:Int;
	var font:Font;

	public function new ()
	{
		this.size = 16;
		var data = Assets.getBitmapData("assets/gui/gui-test.png");
		this.tilesheet = new Tilesheet(data);

		var cols:Int = Std.int( data.width / this.size );
		var rows:Int = Std.int( data.height/ this.size );


		for( y in 0...cols) {
			for( x in 0...rows ) {
				this.tilesheet.addTileRect( new Rectangle( x*size, y*size, size, size ));
			}
		}

		defaultButtonID = 0x11; //addFrame( 0, 0 );
		hoverButtonID = 0x14; //addFrame( 3, 3 );
		activeButtonID = 0x17; //addFrame( 4, 0 );
		basicWindowID = 0x1A; //addFrame( 6, 0 );

		font = new Font();
	}


	public function drawFrame( frameID:UInt, w:Float, h:Float, graphics:openfl.display.Graphics ) {
		var tiles:Array<Float> = new Array<Float>();

		// x, y, tileID, a, b, c, d
		var tileWidth:Int = Std.int( w / size );
		var tileHeight:Int= Std.int( h / size );
		var widthDiff:Int = Std.int( w % size );
		var heightDiff:Int= Std.int( h % size );

		var tileID = 0;
		for( x in 0...tileWidth ) {
			for ( y in 0...tileHeight ) {

				tileID = frameID;

				tiles.push( x*size );
				tiles.push( y*size );

				if( x == 0 ) {
					tileID -= 1;
				}
				else if( x == tileWidth-1 ) {
					tileID += 1;
				}

				if( y == 0 ) {
					tileID -= 16;
				}
				else if( y == tileHeight-1 ) {
					tileID += 16;
				}

				tiles.push( tileID );
			}
		}

		// Draw them all!
		graphics.clear();
		tilesheet.drawTiles( graphics, tiles, false );
		//tilesheet.drawTiles( graphics, tiles, false, TILE_TRANS_2x2 );
	}


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
