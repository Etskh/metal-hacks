package world;


import motion.easing.Bounce;
import openfl.display.Sprite;
import motion.Actuate;



class Camera extends Sprite
{
    public function new()
    {
        super();

        _zoom = 1;
    }

    public function zoomIn( seconds:Float, callback:Null<Void->Void>=null )
    {
        _zoom = ZOOM_MAX;
        var tween = Actuate.tween( this, seconds, { scale:_zoom } );

        if( callback != null ) {
            tween.onComplete( callback );
        }
    }

    var _zoom:Float;
    static inline var ZOOM_MAX:Float=2;
    static inline var ZOOM_MIN:Float=0.25;
}
