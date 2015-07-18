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
	
	var size:Float = 32;

	public function new ( stage:Sprite ) {
		super();

		tilesheet = new Tilesheet( Assets.getBitmapData("assets/environment/environment-test-2.png"));

		var tiles:Array<Float> = [
			// 1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 1, 2, 2, 2, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 1, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 1, 1, 1, 1, 1, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
			0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		];
		
		
		for( cols in 0...16 ) {
			for( rows in 0...16 ) {
				tilesheet.addTileRect( new Rectangle( cols*size, rows*size, size, size ));
			}
		}

		var drawList= new Array<Float>();
		var r = 0;
		for( t in 0...tiles.length ) {
				
			if( t != 0 && t % 16 == 0 ) {
				r++;
			}
				
			drawList = drawList.concat([ (t%16)*size, r*size, tiles[t] ]);
		}
		tilesheet.drawTiles( graphics, drawList, true);

		stage.addChild( this );
	}

}
