package gui;


import openfl.geom.Point;
import openfl.display.Sprite;
import openfl.events.MouseEvent;


class Window extends Widget
{
    public function new( size:Point )
    {
        super( size );

        //
        // Add the frame
        //
        _frame = new Sprite();
        addChild( _frame );

        addCallback("redraw", this._redraw );

        resize( size );
    }

    public function _redraw ( widget:Widget )
    {
        _skin.drawFrame( _skin.windowFrameID(), _size.x, _size.y, _frame.graphics );
    }


    //
    // Text and frame
    //
    var _frame: Sprite;
}
