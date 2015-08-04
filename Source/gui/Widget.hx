package gui;


import openfl.display.Sprite;
import openfl.geom.Point;
import motion.easing.Bounce;
import motion.Actuate;




typedef Callback = Widget -> Void;
typedef TweenCallback = Void -> Void;

class Widget extends Sprite
{
	var _skin:Skin;
	var _callbacks:Map <String, Array<Callback> >;
	var _size:Point;
	var frameID:Null<Int>;
	var frameSprite:Sprite;
	var textSprite:Sprite;
	var textString:String;
	var textSize:Int;
	var hitboxSprite:Sprite;
	var collisionOn:Bool;
	var containerSprite:Sprite;
	//var _isSoft:Bool;

	static var s_activeWidget:Null<Widget> = null;

	public function new ( size ) {
		super();

		// Create the event callbacks
		_callbacks = new Map <String, Array<Callback> >();
		_skin = Skin.getDefault();
		_size = size;
		//_isSoft = false;

		/*
		// Background
		//
		this.frameSprite = new Sprite();
		this.frameID = null;
		addChild( this.frameSprite );

		// Text
		//
		this.textSprite = new Sprite(); // start with empty string
		textString = "";
		addChild( this.textSprite );

		// Hitbox
		//
		this.hitboxSprite = new Sprite(); // start with no collision
		collisionOn = false;
		addChild( this.hitboxSprite );

		// collision
		//
		this.containerSprite = new Sprite();
		addChild( this.containerSprite );
		*/
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

	static public function getActive()
	{
		return s_activeWidget;
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

	/*
	public function resize ( nsize:Point ) {
		_size = nsize;
		if( this.frameID != null ) {
			this.frameSprite.graphics.clear();
			this.skin.drawFrame( this.frameID, _size.x, _size.y, this.frameSprite.graphics );
		}
		if( this.textString != "" ) {
			this.textSprite.graphics.clear();
			this.textSprite.y = 6;
			this.skin.getFont().drawText( textString, textSize, this.textSprite.graphics, _size.x, Font.Centre );
		}
		if( this.collisionOn == true ) {
			this.hitboxSprite.graphics.clear();
			this.hitboxSprite.graphics.beginFill( 0xFF0000, Debug.drawHitboxes?0.05:0.0 );
			this.hitboxSprite.graphics.drawRect( 0, 0, _size.x, _size.y );
			this.hitboxSprite.graphics.endFill();
		}
	}

	public function hitbox () : Sprite {
		if( this.collisionOn == false ) {
			this.collisionOn = true;
			this.hitboxSprite.buttonMode = true;
			this.hitboxSprite.addEventListener( MouseEvent.CLICK, this._onClick );
			this.hitboxSprite.addEventListener( MouseEvent.MOUSE_OVER, this._onOver );
			this.hitboxSprite.addEventListener( MouseEvent.MOUSE_OUT, this._onOut );
			this.hitboxSprite.addEventListener( MouseEvent.MOUSE_DOWN, this._onDown );
			this.hitboxSprite.addEventListener( MouseEvent.MOUSE_UP, this._onOver );

			this.hitboxSprite.graphics.clear();
			this.hitboxSprite.graphics.beginFill( 0xFF0000, Debug.drawHitboxes?0.05:0.0 );
			this.hitboxSprite.graphics.drawRect( 0, 0, _size.x, _size.y );
			this.hitboxSprite.graphics.endFill();
		}

		return this.hitboxSprite;
	}

	public function setFrameID( id:Int ) {
		this.frameID = id;
		this.frameSprite.graphics.clear();
		this.skin.drawFrame( this.frameID, _size.x, _size.y, this.frameSprite.graphics );
	}

	public function setText( text:String, size:Int ) {
		this.textString = text;
		this.textSize = size;
		this.textSprite.graphics.clear();
		this.skin.getFont().drawText( textString, textSize, this.textSprite.graphics, _size.x, Font.Centre );
	}

	public function container () : Sprite {
		return containerSprite;
	}

	public function add ( child:Sprite ) {
		container().addChild( child );
	}*/





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


	/*
		@TODO : Move into button class
	//
	// "Real" events
	//
	//
	public function _onClick ( e:Dynamic ) {
		fireCallbacks( "click", e );
	}
	public function _onOver ( e:Dynamic ) {
		if( e.relatedObject != null ) {
			var widget:Widget = cast e.relatedObject.parent;
			fireCallbacks( "over", widget);
		}
	}
	public function _onOut ( e:Dynamic ) {
		fireCallbacks( "out", this );
	}
	public function _onDown ( e:Dynamic ) {
		fireCallbacks( "down", this );
	}
	*/
}
