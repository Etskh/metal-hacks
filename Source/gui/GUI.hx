package gui;




import openfl.events.MouseEvent;

import openfl.display.DisplayObjectContainer;
import openfl.geom.Point;
import motion.easing.Bounce;
import motion.Actuate;
import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.geom.Rectangle;






class GUI extends DisplayObjectContainer
{
	public function new() {
		super();

		this.mouseEnabled = false;
	}

	//var _overlay:Sprite;

	/*
	public function createButton( text:String, size:Point, onClick:Widget.Callback ) : Widget
	{
		var button:Widget;

		button = new Widget();

		button.setText( text, 16 );
		button.addCallback( "click", onClick );
		button.addCallback( "over", this._buttonOver );
		button.addCallback( "out", this._buttonOut );
		button.addCallback( "down", this._buttonDown );
		button.setFrameID( button.skin.buttonFrameID() );
		button.resize( size );

		return button;
	}


	public function createWindow( size:Point ) {
		var window:Widget = new Widget();

		window.setFrameID( window.skin.windowFrameID() );
		window.resize( size );

		return window;
	}


	public function _buttonOver ( widget:Widget ) {
		widget.setFrameID( widget.skin.hoverButtonFrameID() );
	}

	public function _buttonOut ( widget:Widget ) {
		widget.setFrameID( widget.skin.buttonFrameID() );
	}

	public function _buttonDown ( widget:Widget ) {
		widget.setFrameID( widget.skin.activeButtonFrameID() );
	}
	*/
}
