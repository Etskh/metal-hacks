package world;


import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;



class Avatar extends Entity
{

	static public function create ( char:character.Character, height:Int )
	{
		var avatar:Avatar = new Avatar( char );
		var slots:Array<character.Slot> = char.getSlots();
		for( s in 0...slots.length ) {
			avatar.addLayer( slots[s].getBitmap(), slots[s].getRed(), slots[s].getGreen(), slots[s].getBlue() );
		}

		return avatar;
	}



	public function new ( char:character.Character ) {
		super();

		_size = new Point(64,64);

		_character = char;

		_animation = new Sprite();
		addChild( _animation );

		_hitbox = new Sprite();
        _hitbox.buttonMode = true;
        _hitbox.addEventListener( MouseEvent.CLICK, this._onClick );
		_hitbox.graphics.beginFill( Debug.avatar_hitbox_colour() , 0.2 );
		_hitbox.graphics.drawRect( 0, 0, _size.x, _size.y );
		addChild( _hitbox );

		//var bitmapData = Assets.getBitmapData("assets/characters/character-rgb-test.png").clone();
		//this.addLayer( bitmapData, 0xe6dbbf, 0x161719, 0xcf3213 );

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
		trace("Wat");
	}


	public function addLayer( input:BitmapData, skinColour:UInt, mainColour:UInt, detailColour:UInt )
	{
		var pixels:openfl.utils.ByteArray;
		var allOfIt = new Rectangle(0,0, input.width, input.height );

		input.lock();

		var skin = new util.CompositeColour( skinColour );
		var main = new util.CompositeColour( mainColour );
		var detail = new util.CompositeColour( detailColour );

		pixels = input.getPixels(allOfIt);
		var skinLevel:Float;
		var mainLevel:Float;
		var detlLevel:Float;

		for( p in 0...input.width*input.height) {

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

		//this.animation.setPixels(allOfIt, pixels);
		input.unlock();
	}

	var _hitbox:Sprite;
	var _animation:Sprite;
	var _size:Point;
	var _character:character.Character;
}
