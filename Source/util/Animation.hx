package util;

/*
 * Animation class defines a single Animation; it has a name and a set of frames
 * on the tilesheet, and a framerate. Animations need a single sprite
 * sheet to work, but can load-in pre-set animations from known data.
 *
 */

class Animation
{
	public function new ( name:String, start:Int, end:Int )
	{
		_name = name;
		_startFrame= start;
		_endFrame  = end;
	}

	public function getName()
	{
		return _name;
	}

	public function startFrame()
	{
		return _startFrame;
	}

	public function endFrame()
	{
		return _endFrame;
	}

	var _name:String;
	var _startFrame:Int;
	var _endFrame:Int;
}
