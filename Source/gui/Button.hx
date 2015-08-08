package gui;


import openfl.geom.Point;
import openfl.display.Sprite;
import openfl.events.MouseEvent;


class Button extends Widget
{
    public function new( text:String, size:Point, callback:gui.Widget.Callback )
    {
        super( size );

        this.tabChildren = false;

        //
        // Add the frame
        //
        _frame = new Sprite();
        _frame.buttonMode = false;
        _frame.mouseEnabled = false;
        addChild( _frame );

        //
        // Then add the text
        //
        _text = new Label( text, 16, _size, _skin.getFont() );
        _text.y = 6;
        _text.setAlignment( Font.CENTRE );
        addChild( _text );


        //
        // Hitbox
        //
        _hitbox = new Sprite();
        _hitbox.buttonMode = true;
        _hitbox.addEventListener( MouseEvent.CLICK, this._onClick );
        _hitbox.addEventListener( MouseEvent.MOUSE_OVER, this._onOver );
        _hitbox.addEventListener( MouseEvent.MOUSE_OUT, this._onOut );
        _hitbox.addEventListener( MouseEvent.MOUSE_DOWN, this._onDown );
        _hitbox.addEventListener( MouseEvent.MOUSE_UP, this._onUp );
        addChild( _hitbox );

        //
        // Callbacks
        //
        addCallback("click", callback );
        addCallback("redraw", this._redraw );

        resize( size );
    }


    public function _onClick ( e:Dynamic ) {
        fireCallbacks( "click", e );
    }

    public function _onOver ( e:Dynamic ) {
        if( e.relatedObject != null ) {
            var widget:Widget = cast e.relatedObject.parent;

            // If we're hoving over this object, set it to the active one
            if( widget == this ) {
                widget.setActive();
            }
            fireCallbacks( "over", widget);
            _redraw(this);
        }
    }

    public function _onUp ( e:Dynamic ) {
        _down = false;
        fireCallbacks( "up", this );
        _redraw(this);
    }

    public function _onOut ( e:Dynamic ) {
        _down = false;
        fireCallbacks( "out", this );
        this.setInactive();
        _redraw(this);
    }

    public function _onDown ( e:Dynamic ) {
        _down = true;
        fireCallbacks( "down", this );
        _redraw(this);
    }

    public function _redraw ( widget:Widget )
    {
        _hitbox.graphics.clear();
        _hitbox.graphics.beginFill( Debug.gui_hitbox_colour(), Debug.drawHitboxes?0.2:0.0 );
        _hitbox.graphics.drawRect( 0, 0, _size.x, _size.y );
        _hitbox.graphics.endFill();

        _skin.drawFrame(
            this.isActive() ?
                (_down ? _skin.activeButtonFrameID() : _skin.hoverButtonFrameID() )
                : _skin.buttonFrameID(),
            _size.x, _size.y, _frame.graphics
        );
    }


    //
    // Text and frame
    //
    var _down : Bool;
    var _hitbox: Sprite;
    var _text : gui.Label;
    var _frame: Sprite;
}
