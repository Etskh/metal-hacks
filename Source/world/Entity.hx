package world;


import openfl.display.Sprite;
import flash.events.Event;
import openfl.events.MouseEvent;

import motion.easing.Sine;
import motion.Actuate;

import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.geom.Rectangle;
import openfl.geom.Point; // Camera

typedef EntityCallback = Entity -> Void;

class Entity extends Sprite
{
	public function new ( ) {
		super();
	}

	/*
		TODO: Add a callback to this function
	*/
	public function moveBy ( delta:Point, time:Float )
	{
		delta.x += this.x;
		delta.y += this.y;
		this.moveTo( delta, time );
	}

	/*
		TODO: Add a callback to this function
	*/
	public function moveTo ( pos:Point, time:Float )
	{
		var tween = Actuate.tween( this, time, { x:pos.x, y:pos.y } ).ease(Sine.easeInOut);

		//if( callback ) {
		//	tween.onComplete( callback );
		//}
	}

	public function update () {
		// empty
	}
}
