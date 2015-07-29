package simulation;




import openfl.geom.Point;


class WorldState implements State
{
	var sim:Simulation;
	var leftWindow:gui.Widget;
	var dude:world.Avatar;
	//var vanity:Sprite;

	public function new (sim:Simulation) {
		this.sim = sim;
	}

	public function init () {

		//
		// Create the GUI system
		//
		this.leftWindow = sim.gui.createWindow( new Point( 150, 300 ));

		// The "To Battle" button
		//
		var battleButton = sim.gui.createButton("To Battle!", new Point(128,32), onBattleButton );
		this.leftWindow.add( battleButton );

		this.sim.gui.addChild( this.leftWindow );

		// Create world avatars
		//
		this.dude = new world.Avatar();
		this.dude.x = 64;
		this.dude.y = 64;
		this.sim.world.addChild( this.dude );

		/*
		var bitmapData = Assets.getBitmapData("assets/characters/character-rgb-vanity.png").clone();
		Character.Equipment.Render( bitmapData, 0xe6dbbf, 0x161719, 0xcf3213 );
		this.vanity = new Sprite();
		this.vanity.graphics.beginBitmapFill(bitmapData, new openfl.geom.Matrix(), false, true);
		this.vanity.graphics.drawRect(100, 0, 256-100, bitmapData.height);
		this.vanity.graphics.endFill();
		this.sim.parent.addChild(this.vanity);
		*/
	}

	public function update () : Bool {
		return true;
	}

	public function exit () {
		// empty
	}

	public function name () {
		return "WorldState";
	}

	public function onBattleButton( widget:gui.Widget ) {
		this.leftWindow.slideTo( new Point(-150, 0), 1.0, this.transitionToBattle );
	}

	public function transitionToBattle() {
		this.sim.changeState( new BattleState(this.sim) );
	}
}
