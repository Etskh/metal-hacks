package world;


import openfl.display.Sprite;






class World extends Sprite
{
	var _terrain:Terrain;
	var _pathing:Pathing;
	var _camera:Camera;

	public function new() {
		super();

		_camera = new Camera();
		addChild( _camera );

		_terrain = new Terrain();
		_camera.addChild( _terrain );

		_pathing = new Pathing();
		_camera.addChild( _pathing);
	}
}
