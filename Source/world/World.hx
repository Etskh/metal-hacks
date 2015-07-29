package world;


import openfl.display.Sprite;






class World extends Sprite
{
	var terrain:Terrain;
	var pathing:Pathing;

	public function new() {
		super();

		this.terrain = new Terrain();
		addChild( this.terrain );

		this.pathing = new Pathing();
		addChild(this.pathing);
	}
}
