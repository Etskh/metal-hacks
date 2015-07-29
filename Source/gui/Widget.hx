package gui;



import openfl.events.MouseEvent;

import openfl.display.Sprite;
import openfl.geom.Point;
import motion.easing.Bounce;
import motion.Actuate;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.geom.Rectangle;




typedef Callback = Widget -> Void;
typedef TweenCallback = Void -> Void;

class Widget extends Sprite
{
	public var skin:Skin;
	var callbacks:Map <String, Array<Callback> >;
	public var size:Point;
	var frameID:Null<Int>;
	var frameSprite:Sprite;
	var textSprite:Sprite;
	var textString:String;
	var textSize:Int;
	var hitboxSprite:Sprite;
	var collisionOn:Bool;
	var containerSprite:Sprite;

	public function new () {
		super();

		// Create the event callbacks
		this.callbacks = new Map <String, Array<Callback> >();
		this.skin = Skin.getDefault();
		this.size = new Point(128,32);

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
	}


	public function resize ( nsize:Point ) {
		this.size = nsize;
		if( this.frameID != null ) {
			this.frameSprite.graphics.clear();
			this.skin.drawFrame( this.frameID, size.x, size.y, this.frameSprite.graphics );
		}
		if( this.textString != "" ) {
			this.textSprite.graphics.clear();
			this.textSprite.y = 6;
			this.skin.getFont().drawText( textString, textSize, this.textSprite.graphics, size.x, Font.Centre );
		}
		if( this.collisionOn == true ) {
			this.hitboxSprite.graphics.clear();
			this.hitboxSprite.graphics.beginFill( 0xFF0000, Debug.drawHitboxes?0.05:0.0 );
			this.hitboxSprite.graphics.drawRect( 0, 0, size.x, size.y );
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
			this.hitboxSprite.graphics.drawRect( 0, 0, size.x, size.y );
			this.hitboxSprite.graphics.endFill();
		}

		return this.hitboxSprite;
	}

	public function setFrameID( id:Int ) {
		this.frameID = id;
		this.frameSprite.graphics.clear();
		this.skin.drawFrame( this.frameID, size.x, size.y, this.frameSprite.graphics );
	}

	public function setText( text:String, size:Int ) {
		this.textString = text;
		this.textSize = size;
		this.textSprite.graphics.clear();
		this.skin.getFont().drawText( textString, textSize, this.textSprite.graphics, this.size.x, Font.Centre );
	}

	public function container () : Sprite {
		return containerSprite;
	}

	public function add ( child:Sprite ) {
		container().addChild( child );
	}






	// Movement
	//
	public function slideTo ( pos:Point, time:Float, callback:TweenCallback ) {
		var tween = Actuate.tween( this, time, { x:pos.x, y:pos.y } );
		tween.ease( Bounce.easeOut );
		tween.onComplete( callback );
	}






	//
	// Callback-wrappers
	//
	public function addCallback( event:String, callback:Callback ) {

		// Thing does stuff? Add a hitbox.
		hitbox();

		var callbackList = this.callbacks.get(event);
		if( callbackList == null ) {
			callbackList = new Array<Callback>();
			this.callbacks.set( event, callbackList );
		}
		callbackList.push( callback );
	}

	//
	// Fires all callbacks registered to an event
	// returns the number of callbacks attached to the event name
	//
	public function fireCallbacks ( eventName:String, widget:Widget ) {
		var callbackList = this.callbacks.get(eventName);
		if( callbackList == null ) {
			return 0;
		}
		for( c in 0...callbackList.length ) {
			callbackList[c](widget);
		}
		return callbackList.length;
	}


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
		if( e.relatedObject != null ) {
			var widget:Widget = cast e.relatedObject.parent;
			fireCallbacks( "down", widget);
		}
	}
}
