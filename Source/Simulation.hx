package;


import openfl.display.Sprite;
import flash.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point; // Camera
import motion.easing.Sine; // Dude
import motion.Actuate;

import Debug;
import Character;
import Environment;


class Entity extends Sprite
{
	public var pos:Point;

	public function new ( parent:Sprite ) {
		super();

		parent.addChild( this );

		this.pos = new Point(0,0);
	}

	// TODO: Add a callback to this funciton
	public function move ( pos:Point, time:Float=0 ) {
		var callback = false;
		var tween = Actuate.tween( this, time, { x:pos.x, y:pos.y } ).ease(Sine.easeInOut);

		if( callback ) {
			tween.onComplete( callback );
		}
	}

	// TODO: Add a callback to this function
	public function walk ( pos:Point, speed:Float=128 ) {
		var distance = Point.distance( pos, this.pos );
		move( pos, distance / speed );
	}

	public function update () {
		// empty
	}
}


class Avatar extends Entity
{
	public function new ( parent:Sprite ) {
		super();

		this.graphics.beginFill(0x222222 );
		this.graphics.drawRect(0,0,32,32);

		addEventListener (Event.ENTER_FRAME, onUpdate );
		addEventListener( MouseEvent.CLICK, onActivate );
	}

	public function onUpdate( e:Dynamic ) {
		super.update();
	}

	public function onActivate( e:Dynamic ) {
		walk(new Point(0, 128), 128 );
	}
}



class BandMemberWorldAvatar extends Avatar
{

	public function new ( parent:Sprite ) {
		super(parent);

		addEventListener (Event.ENTER_FRAME, onUpdate );
		addEventListener( MouseEvent.CLICK, onActivate );
	}

	public function onUpdate( e:Dynamic ) {
		super.update();
	}

	public function onActivate( e:Dynamic ) {
		Debug.log("Opening character info tab");
	}

	public function done() {
		trace("Done!");
	}

}




class Camera extends Entity
{

}




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
	public var band:Array<BandMember>;

	// Environment
	public var enviro:Environment;

	// Stage
	public var stage:Sprite;

	// Camera
	public var camera:Camera;

	// Current state logic
	var state:SimulationState;
	var nextState:Null<SimulationState>;




	public function new ( stage:Sprite ) {

		this.band = new Array<Character.BandMember>();

		this.enviro = new Environment.Environment( stage );

		this.stage = stage;

		this.camera = new Camera();

		this.state = new LoadState(this);
		this.nextState = null;
		this.state.init();
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
		Ability.loadAll();
	}

	public function update () : Bool {

		var askr = new BandMember("Askr");
		askr.abilities = new Array<Ability>();
		askr.abilities.push(Ability.getByName("Groovy Lick"));
        this.sim.band.push(askr);

		// Test
		var dude = new Dude( this.sim.stage );

		sim.changeState( new BattleState(this.sim) );
		return true;
	}

	public function exit () {
		// empty
	}

	public function name () {
		return "LoadState";
	}
}








class BattleState implements SimulationState
{
	var sim:Simulation;
	var crowd:Array<Character.CrowdCharacter>;
	var stats:Character.StatBlock;

	public function new (sim:Simulation) {
		this.sim = sim;
		this.crowd = new Array<Character.CrowdCharacter>();

		this.stats = new StatBlock();
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
			return false;
		}

		return true;
	}

	public function exit () {
		// empty
	}

	public function name () {
		return "BattleState";
	}


}
