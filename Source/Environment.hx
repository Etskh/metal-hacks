package;



import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.geom.Rectangle;



class Environment extends Sprite
{
	var tilesheet:Tilesheet;

	public function new ( stage:Sprite ) {
		super();

		tilesheet = new Tilesheet( Assets.getBitmapData("assets/environment/environment-test.png"));

		for( cols in 0...16 ) {
			for( rows in 0...16 ) {
				tilesheet.addTileRect( new Rectangle( cols*32, rows*32, 32, 32 ));
			}
		}

		var drawList= new Array<Float>();
		for( cols in 0...16 ) {
			for( rows in 0...16 ) {
				drawList = drawList.concat([ cols*32, rows*32, rows + cols*16]);
			}
		}
		tilesheet.drawTiles( graphics, drawList, true);

		stage.addChild( this );
	}

}
