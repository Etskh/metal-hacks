package world;


import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.display.Tilesheet;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import openfl.Assets;

typedef AvatarCallback= Null<Avatar->Void>;

class Avatar extends Entity
{
	public function new (
		char:character.Character,
		animSet:util.AnimationSet,
		height:Int,
		callback:AvatarCallback=null )
	{
		super();

		_size = new Point(64,64);

		_character = char;

		_animation = new util.AnimationContext(animSet, composeBitmap(char.getSlots()), _size.x );
		_animation.update();
		addChild( _animation );

		_hitbox = new Sprite();
        _hitbox.buttonMode = true;
        _hitbox.addEventListener( MouseEvent.CLICK, this._onClick );
		_hitbox.graphics.beginFill( Debug.avatar_hitbox_colour() , 0.2 );
		_hitbox.graphics.drawCircle( _size.x / 2, _size.y / 2, _size.x / 2 );
		addChild( _hitbox );

		_callback = callback;
	}


	public function getCharacter()
	{
		return _character;
	}


	/*
		TODO: Add a callback to this function
	*/
	public function walkTo ( pos:Point ) {

		var speed:Float = 128; // pixels per second
		var distance:Float = Point.distance( pos, new Point( this.x, this.y) );

		/*
		 	TODO Also trigger walk animation
		*/

		this.moveTo( pos, distance / speed );
	}


	public function _onClick ( e:Dynamic )
	{
		if( _callback != null ) {
			_callback( this );
		}
	}


	public function composeBitmap ( slots:Array<character.Slot> ) : BitmapData
	{
		/* TODO: Make sure all incoming slot's bitmap datas are the same size */

		// Make a fillmap the same size as the first bitmap
		var fillMap:BitmapData = new BitmapData(slots[0].getBitmap().width, slots[0].getBitmap().height, true, 0x000000 );
		var allOfIt = new Rectangle(0,0, fillMap.width, fillMap.height );
		var pixels:openfl.utils.ByteArray;

		for( s in 0...slots.length ) {
			var skin = new util.CompositeColour( slots[s].getRed() );
			var main = new util.CompositeColour( slots[s].getGreen() );
			var detail = new util.CompositeColour( slots[s].getBlue() );

			pixels = slots[s].getBitmap().getPixels(allOfIt);
			var skinLevel:Float;
			var mainLevel:Float;
			var detlLevel:Float;

			for( p in 0...fillMap.width*fillMap.height) {

				// If it's transparent, just skip it
				if( pixels[p*4+0] == 0 ) {
					continue;
				}
				skinLevel = pixels[p*4+1] / 255.0;
				mainLevel = pixels[p*4+2] / 255.0;
				detlLevel = pixels[p*4+3] / 255.0;

				pixels[p*4+0] = pixels[p*4+0]; // alpha
				pixels[p*4+1] = Std.int( (skinLevel*skin.r) + (mainLevel*main.r) + (detlLevel*detail.r));
				pixels[p*4+2] = Std.int( (skinLevel*skin.g) + (mainLevel*main.g) + (detlLevel*detail.g));
				pixels[p*4+3] = Std.int( (skinLevel*skin.b) + (mainLevel*main.b) + (detlLevel*detail.b));

			}

			fillMap.setPixels( allOfIt, pixels );
		}

		return fillMap;
	}


	var _hitbox:Sprite;
	var _animation:util.AnimationContext;
	var _size:Point;
	var _character:character.Character;
	var _callback:AvatarCallback;
	var _tilesheet:Tilesheet;
}
