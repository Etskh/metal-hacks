package simulation;



import openfl.geom.Point;


class WorldState implements State
{
	var sim:Simulation;
	var leftWindow:gui.Widget;
	var battleButton:gui.Button;
	var dude:world.Avatar;
	//var vanity:Sprite;

	public function new (sim:Simulation) {
		this.sim = sim;
	}

	public function init () {

		//
		// Create the GUI system
		//
		this.leftWindow = new gui.Window( new Point( 150, 300 ));

		// The "To Battle" button
		//
		battleButton = new gui.Button("To Battle!", new Point(128,32), function( widget:gui.Widget ) {
			this.leftWindow.fadeOut( 1.0, function(){
				this.sim.changeState( new BattleState(this.sim) );
			});
		});
		battleButton.x = 8;
		battleButton.y = 8;
		this.leftWindow.addChild( battleButton );
		//this.sim.addChild( battleButton );

		// The build test
		//
		var debugText = new gui.Label("Loading information", 16, new Point(128,32), gui.Skin.getDefault().getFont() );
		debugText.x = 8;
		debugText.y = 64;
		this.leftWindow.addChild( debugText );

		this.sim.addChild( this.leftWindow );

		// Create world avatars
		//
		this.dude = world.Avatar.create( this.sim.band[0], 64 );
		this.dude.moveTo(new Point(128,128), 0);
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
}
