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
		this.tilesheet = new Tilesheet(data);
		this.tiles = new Array<Float>();
		var drawList = new Array<Float>();

		var cols:Int = cast ( data.width / size );
		var rows:Int = cast ( data.height / size );

		for( x in 0...cols) {
			for( y in 0...rows ) {
				this.tiles.push( tilesheet.addTileRect( new Rectangle( x*size, y*size, size, size )));
			}
		}

		var drawList= new Array<Float>();
		for( x in 0...16 ) {
			for( y in 0...16 ) {
				drawList = drawList.concat([ x*size, y*size, Std.random(tiles.length) ]);
			}
		}
		tilesheet.drawTiles( graphics, drawList, true);

		stage.addChild( this );
	}

}
