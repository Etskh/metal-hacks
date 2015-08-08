package gui;


import openfl.display.Sprite;
import openfl.geom.Point;
import motion.easing.Bounce;
import motion.Actuate;




typedef Callback = Widget -> Void;
typedef TweenCallback = Void -> Void;

class Widget extends Sprite
{

	static public function getActive()
	{
		return s_activeWidget;
	}


	public function new ( size )
	{
		super();

		// Create the event callbacks
		_callbacks = new Map <String, Array<Callback> >();
		_skin = Skin.getDefault();
		_size = size;
	}

	public function setActive()
	{
		s_activeWidget = this;
	}

	public function setInactive()
	{
		s_activeWidget = null;
	}

	public function isActive()
	{
		return s_activeWidget == this;
	}

	public function getSize () : Point
	{
		return _size;
	}

	public function resize ( newSize:Point )
	{
		_size = newSize;
		fireCallbacks ( "redraw", this );
	}





	//
	// Movement & Visibility
	//
	public function slideTo ( pos:Point, time:Float, callback:TweenCallback ) {
		var tween = Actuate.tween( this, time, { x:pos.x, y:pos.y } );
		tween.ease( Bounce.easeOut );
		tween.onComplete( callback );
	}
	//
	// Fades
	//
	public function fadeOut ( time:Float, callback:TweenCallback ) {
		var tween = Actuate.tween( this, time, { alpha:0 } );
		tween.onComplete( callback );
	}
	public function fadeIn ( time:Float, callback:TweenCallback ) {
		var tween = Actuate.tween( this, time, { alpha:1 } );
		tween.onComplete( callback );
	}

	public function hide ( ) {
		Actuate.apply ( this, { alpha: 0 });
	}

	public function show () {
		Actuate.apply ( this, { alpha: 1 });
	}




	//
	// Callback-wrappers
	//
	public function addCallback( event:String, callback:Callback ) {

		var callbackList = _callbacks.get(event);
		if( callbackList == null ) {
			callbackList = new Array<Callback>();
			_callbacks.set( event, callbackList );
		}
		callbackList.push( callback );
	}

	//
	// Fires all callbacks registered to an event
	// returns the number of callbacks attached to the event name
	//
	public function fireCallbacks ( eventName:String, widget:Widget ) {
		var callbackList:Array<Callback> = _callbacks.get(eventName);
		if( callbackList == null ) {
			return 0;
		}
		for( c in 0...callbackList.length ) {
			callbackList[c](widget);
		}

		for( c in 0...this.numChildren) {
			if( Std.is(this.getChildAt(c), Widget ) ) {
				cast( this.getChildAt(c), Widget).fireCallbacks( eventName, this );
			}
		}

		return callbackList.length;
	}


	static var s_activeWidget:Null<Widget> = null;

	var _skin:Skin;
	var _callbacks:Map <String, Array<Callback> >;
	var _size:Point;
}
