package;



import openfl.display.Sprite;
import flash.events.Event;
import openfl.events.MouseEvent;

import motion.easing.Sine;
import motion.Actuate;

import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.geom.Rectangle;
import openfl.geom.Point; // Camera




class Entity extends Sprite
{
	public var pos:Point;

	public function new ( parent:Sprite ) {
		super();

		parent.addChild( this );

		this.pos = new Point(0,0);
	}

	// TODO: Add a callback to this funciton
	public function move ( pos:Point, time:Float=0 ) {
		var callback = false;
		var tween = Actuate.tween( this, time, { x:pos.x, y:pos.y } ).ease(Sine.easeInOut);

		if( callback ) {
			tween.onComplete( callback );
		}
	}

	// TODO: Add a callback to this function
	public function walk ( pos:Point, speed:Float=128 ) {
		var distance = Point.distance( pos, this.pos );
		move( pos, distance / speed );
	}

	public function update () {
		// empty
	}
}


class Avatar extends Entity
{
	var tilesheet:Tilesheet;
	var hitbox:Sprite;

	public function new ( enviro:World.Environment ) {
		super(enviro);

		this.hitbox = new Sprite();
		this.hitbox.graphics.beginFill( 0xFFFFFF, 0.2 );
		this.hitbox.graphics.drawRect( 0, 0, 64, 64 );
		addChild( hitbox );

		this.tilesheet = new Tilesheet( Assets.getBitmapData("assets/characters/character-test.png"));
		this.tilesheet.addTileRect( new Rectangle( 0, 0, 64, 64 ));
		this.tilesheet.drawTiles( this.graphics, [0, 0, 0], true);

	}
}



class BandMemberWorldAvatar extends Avatar
{
	public static inline var MOVE_SPEED=128; // pixels a second

	public function new ( enviro:World.Environment ) {
		super(enviro);
		hitbox.addEventListener( MouseEvent.CLICK, onActivate );
	}

	public function onActivate( e:Dynamic ) {
		Debug.log("Avatar","Activated!");
		walk(new Point(128, 128), MOVE_SPEED );
	}

}




class Camera extends Entity
{
	public function new ( parent:Sprite ) {
		super(parent);
	}
}



class Environment extends Sprite
{
	var tilesheet:Tilesheet;
	var size:Int;
	var tiles:Array<Float>;

	public function new ( stage:Sprite ) {
		super();

		var data:openfl.display.BitmapData = Assets.getBitmapData("assets/environment/environment-lobby.png");
		this.size = 32;
		var breadth = 512;
		this.tilesheet = new Tilesheet(data);

		var levelData:Array<Float> = [
			0,0,0,0,32,0,0,64,0,0,96,0,0,128,0,0,160,0,0,192,0,0,224,0,0,256,0,0,288,0,0,320,0,0,352,0,0,384,0,0,416,0,0,448,0,0,480,0,32,0,0,32,32,0,32,64,0,32,96,0,32,128,0,32,160,0,32,192,0,32,224,0,32,256,0,32,288,0,32,320,0,32,352,0,32,384,0,32,416,0,32,448,0,32,480,0,64,0,0,64,32,4,64,64,20,64,96,17,64,128,33,64,160,0,64,192,0,64,224,0,64,256,0,64,288,0,64,320,0,64,352,0,64,384,0,64,416,0,64,448,0,64,480,0,96,0,0,96,32,5,96,64,21,96,96,47,96,128,18,96,160,36,96,192,0,96,224,0,96,256,0,96,288,0,96,320,0,96,352,0,96,384,0,96,416,0,96,448,0,96,480,0,128,0,0,128,32,6,128,64,46,128,96,46,128,128,21,128,160,37,128,192,0,128,224,0,128,256,0,128,288,0,128,320,0,128,352,0,128,384,0,128,416,0,128,448,0,128,480,0,160,0,0,160,32,0,160,64,6,160,96,19,160,128,22,160,160,35,160,192,0,160,224,1,160,256,20,160,288,20,160,320,36,160,352,0,160,384,0,160,416,0,160,448,0,160,480,0,192,0,0,192,32,0,192,64,0,192,96,0,192,128,0,192,160,0,192,192,0,192,224,2,192,256,47,192,288,47,192,320,37,192,352,0,192,384,0,192,416,0,192,448,0,192,480,0,224,0,0,224,32,0,224,64,0,224,96,0,224,128,0,224,160,0,224,192,4,224,224,47,224,256,46,224,288,47,224,320,37,224,352,0,224,384,0,224,416,0,224,448,0,224,480,0,256,0,0,256,32,4,256,64,20,256,96,20,256,128,20,256,160,17,256,192,47,256,224,47,256,256,21,256,288,46,256,320,37,256,352,0,256,384,0,256,416,0,256,448,0,256,480,0,288,0,1,288,32,47,288,64,46,288,96,21,288,128,18,288,160,18,288,192,47,288,224,18,288,256,46,288,288,21,288,320,34,288,352,0,288,384,0,288,416,0,288,448,0,288,480,0,320,0,5,320,32,21,320,64,18,320,96,18,320,128,21,320,160,47,320,192,46,320,224,46,320,256,18,320,288,19,320,320,38,320,352,0,320,384,0,320,416,0,320,448,0,320,480,0,352,0,2,352,32,18,352,64,46,352,96,21,352,128,46,352,160,47,352,192,21,352,224,46,352,256,35,352,288,0,352,320,0,352,352,0,352,384,0,352,416,0,352,448,0,352,480,0,384,0,5,384,32,47,384,64,18,384,96,47,384,128,47,384,160,22,384,192,22,384,224,35,384,256,0,384,288,0,384,320,0,384,352,0,384,384,0,384,416,0,384,448,0,384,480,0,416,0,6,416,32,22,416,64,22,416,96,19,416,128,35,416,160,0,416,192,0,416,224,0,416,256,0,416,288,0,416,320,0,416,352,0,416,384,0,416,416,0,416,448,0,416,480,0,448,0,0,448,32,0,448,64,0,448,96,0,448,128,0,448,160,0,448,192,0,448,224,0,448,256,0,448,288,0,448,320,0,448,352,0,448,384,0,448,416,0,448,448,0,448,480,0,480,0,0,480,32,0,480,64,0,480,96,0,480,128,0,480,160,0,480,192,0,480,224,0,480,256,0,480,288,0,480,320,0,480,352,0,480,384,0,480,416,0,480,448,0,480,480,0
		];

		var drawList = new Array<Float>();

		var cols:Int = cast ( data.width / size );
		var rows:Int = cast ( data.height / size );

		for( y in 0...cols) {
			for( x in 0...rows ) {
				tilesheet.addTileRect( new Rectangle( x*size, y*size, size, size ));
			}
		}

		tilesheet.drawTiles( graphics, levelData, true);

		stage.addChild( this );
	}

}
