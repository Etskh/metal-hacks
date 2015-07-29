package world;


import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Point;
import openfl.geom.Rectangle;



class Avatar extends Entity
{
	//var tilesheet:Tilesheet;
	var hitbox:Sprite;
	var animation:Sprite;
	var size:Point;

	public function new ( ) {
		super();

		this.size = new Point(64,64);

		this.animation = new Sprite();
		addChild( this.animation );

		this.hitbox = new Sprite();
		this.hitbox.graphics.beginFill( Debug.avatar_hitbox_colour() , 0.2 );
		this.hitbox.graphics.drawRect( 0, 0, size.x, size.y );
		addChild( this.hitbox );

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
}
