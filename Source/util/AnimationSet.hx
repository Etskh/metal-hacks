package util;


/*
 *
 * AnimationSet is a set of pre-defined animation names and positions and times
 * on any Spritesheet.
 *

var bandAnimationSet = new AnimationSet("band");
bandAnimationSet.add("idle", 0x00, 0x00 );

 */
class AnimationSet
{
	public function new( name:String )
	{
		_name = name;
		_anims = new Array<Animation>();
	}

	//
	// Adds an animation to the set, and gives a start and finish for the
	// frameIDs
	//
	public function add	( name:String, start:Int, end:Int )
	{
		_anims.push( new Animation( name, start, end ));
	}

	public function getFirst () : Animation
	{
		if( _anims.length == 0 ) {
			trace("Animation set has no animations to get the first.");
		}
		return _anims[0];
	}

	public function get( name:String ) : Animation
	{
		var element = _anims.filter(function(anim:Animation){
			if( anim.getName() == name ) {
				return true;
			}
			return false;
		});

		return element[0];
	}

	var _name:String;
	var _anims:Array<Animation>;
}
