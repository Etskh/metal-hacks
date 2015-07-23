package;


import openfl.display.Sprite;
import flash.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point; // Camera
import motion.easing.Sine; // Dude
import motion.Actuate;

import openfl.display.Tilesheet;
import openfl.Assets;
import openfl.geom.Rectangle;





interface SimulationState
{
	public function init	() : Void ;
	public function update	() : Bool ;
	public function exit	() : Void ;
	public function name	() : String;
}




class Simulation
{
	// Party characters
	public var band:Array<Character.BandMember>;

	// Environment
	public var enviro:World.Environment;

	// Stage
	public var parent:Sprite;

	// Current state logic
	var state:SimulationState;
	var nextState:Null<SimulationState>;




	public function new ( parent:Sprite ) {

		this.band = new Array<Character.BandMember>();

		this.enviro = new World.Environment( parent );

		this.parent = parent;
		parent.addEventListener( MouseEvent.CLICK, _onClick );

		this.state = new LoadState(this);
		this.nextState = null;
		this.state.init();
	}

	public function _onClick( e:Dynamic ) {
		//trace("Simulation recieves events!");
	}

	public function changeState( state:SimulationState ) {
		this.nextState = state;
	}

	public function run ( e:Dynamic ) {

		if( this.state.update() == false ) {
			return;
		}

		if( this.nextState != null ) {

			Debug.log("Simulation", "Changing state from "+this.state.name()+" to "+this.nextState.name() );

			this.state.exit();
			this.nextState.init();
			this.state = this.nextState;
			this.nextState = null;
		}
	}
}







class LoadState implements SimulationState
{
	var sim:Simulation;

	public function new (sim:Simulation) {
		this.sim = sim;
	}

	public function init () {
		Character.Ability.loadAll();
	}

	public function update () : Bool {

		var askr = new Character.BandMember("Askr");
		askr.abilities = new Array<Character.Ability>();
		askr.abilities.push(Character.Ability.getByName("Groovy Lick"));
    this.sim.band.push(askr);

		sim.changeState( new WorldState(this.sim) );
		return true;
	}

	public function exit () {
		// empty
	}

	public function name () {
		return "LoadState";
	}
}






class WorldState implements SimulationState
{
	var sim:Simulation;
	var battleButton:GUI.Button;
	var dude:World.Avatar;

	public function new (sim:Simulation) {
		this.sim = sim;
	}

	public function init () {

		this.battleButton = new GUI.Button("To Battle!");
		this.sim.parent.addChild( this.battleButton );

		this.dude = new World.Avatar();
		this.dude.x = 64;
		this.dude.y = 64;
		this.sim.parent.addChild( this.dude );
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

	public function onBattleButton( e:Dynamic ) {
		//Debug.log("WorldState","Going to Battle state now!");
		trace("I bet it works now...");
	}

}







class BattleState implements SimulationState
{
	var sim:Simulation;
	var crowd:Array<Character.CrowdCharacter>;
	var stats:Character.StatBlock;
	var infoScreen:GUI.Widget;

	public function new (sim:Simulation) {
		this.sim = sim;
		this.crowd = new Array<Character.CrowdCharacter>();

		this.stats = new Character.StatBlock();
		this.stats.set("crowd-impressed", 0 );
		this.stats.set("coin-won", 0 );
	}

	public function init ( )
	{
		var crowdMember;

		crowdMember = new Character.CrowdCharacter("Gremlin");
		crowdMember.stats.set("impress-max", 80);
		crowdMember.stats.set("coin-ratio", 1.5);
		crowd.push( crowdMember );

		crowdMember = new Character.CrowdCharacter("Fiend");
		crowdMember.stats.set("impress-max", 50);
		crowdMember.stats.set("coin-ratio", 0.8);
		crowd.push( crowdMember );

		crowdMember = new Character.CrowdCharacter("Brute");
		crowdMember.stats.set("impress-max", 70);
		crowd.push( crowdMember );

		//infoScreen = new GUI.FramedWidget( sim.stage );
		//infoScreen.slideTo( new Point(0,0) );
		//infoScreen.resize( 64, 64 );
	}

	public function update () : Bool {

		var crowdIndex = Std.random( crowd.length );
		var success = (Math.random()+2) / 3;

		sim.band[0].abilities[0].exec( success, sim.band[0], [crowd[crowdIndex]]);

		// Check if the whole crowd is impressed
		//
		var areAllImpressed = true;
		for( i in 0...crowd.length ) {
			if( ! crowd[i].isImpressed() ) {
				areAllImpressed = false;
			}
		}
		if( areAllImpressed ) {
			Debug.log("State", "Everyone is impressed!");
			this.sim.changeState( new SpoilsState(this.sim) );
		}

		return true;
	}

	public function exit () {
		//infoScreen.slideTo( new Point( -1 * infoScreen.desiredSize.x ,0), 2.0 );
	}

	public function name () {
		return "BattleState";
	}
}





class SpoilsState implements SimulationState
{
	var sim:Simulation;
	var infoScreen:GUI.Widget;

	public function new (sim:Simulation) {
		this.sim = sim;

		//infoScreen = new GUI.FramedWidget(sim.stage);
		//infoScreen.resize( 256, 256 );
		//infoScreen.slideTo( new Point(-256,0) );
	}

	public function init () {
		//infoScreen.slideTo( new Point( (sim.stage.width/2) + 128, 0), 2);
	}

	public function update () : Bool {
		return true;
	}

	public function exit () {
		// empty
	}

	public function name () {
		return "SpoilsState";
	}
}
