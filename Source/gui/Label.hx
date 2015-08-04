package gui;

import openfl.geom.Point;
import openfl.display.Sprite;


class Label extends Widget
{
    public function new ( text:String, textSize:UInt, size:Point, font:gui.Font )
    {
        super(size);

        _text = text;
        _textSize = textSize;
        _font = font;
        _align = Font.LEFT;

        _textSprite = new Sprite();
        addChild( _textSprite );

        addCallback("redraw", this._redraw );
    }

    public function setFont ( font:gui.Font )
    {
        _font = font;
        fireCallbacks("redraw", this );
    }

    public function setAlignment ( align:UInt )
    {
        _align = align;
        fireCallbacks("redraw", this );
    }

    public function setText( text:String )
    {
        _text = text;
        fireCallbacks("redraw", this );
    }


    function _redraw ( widget:Widget )
    {
        _textSprite.graphics.clear();
        _font.drawText( _text, _textSize, _textSprite.graphics, _size.x, _align );
    }


    var _font:Font;
    var _textSprite:Sprite;
    var _text:String;
    var _textSize:UInt;
    var _align:UInt;
}
