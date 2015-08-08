package util;

import openfl.display.Sprite;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;

/*
 * AnimationContext class defines a single entity who has an animation. It is a
 * sprite and has an AnimationSet that it can use to draw the tilesheet.
 */

class AnimationContext extends Sprite
{
	public function new ( animSet:AnimationSet, spritesheet:BitmapData, height:Float )
	{
		super();
		this.mouseEnabled = false;

		_height = height;
		_animSet = animSet;
		_anim = animSet.getFirst();
		_currentFrame = _anim.startFrame();

		_tilesheet = new Tilesheet(spritesheet);
		for( x in 0...Std.int(spritesheet.width / _height)) {
			for( y in 0...Std.int(spritesheet.height / _height)) {
				_tilesheet.addTileRect(new openfl.geom.Rectangle( x*_height, y*_height, _height, _height ));
			}
		}

		apply();
	}

	public function play( animName:String )
	{
		_anim = _animSet.get(animName);
		_currentFrame = _anim.startFrame();

		apply();
	}

	public function update()
	{
		apply();

		_currentFrame++;
		if( _currentFrame > _anim.endFrame() ) {
			_currentFrame = _anim.startFrame();
		}
	}

	public function apply()
	{
		this.graphics.clear();
		_tilesheet.drawTiles( this.graphics, [ 0.0, 0.0, _currentFrame], true );
	}

	var _tilesheet:Tilesheet;
	var _currentFrame:Int;
	var _height:Float;
	var _anim:Animation;
	var _animSet:AnimationSet;
}
