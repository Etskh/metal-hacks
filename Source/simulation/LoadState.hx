package simulation;



class LoadState implements State
{
	var sim:Simulation;

	public function new (sim:Simulation) {
		this.sim = sim;
	}

	public function init () {


		// Load the abilities
		//
		character.Ability.loadAll();


		// Load the band members
		//
		var askr = new character.BandMember("Askr");
		askr.abilities = new Array<character.Ability>();
		askr.abilities.push(character.Ability.getByName("Dive-Bomb"));
		//askr.abilities.push(character.Ability.getByName("Dive-Bomb"));
		//askr.abilities.push(character.Ability.getByName("Dive-Bomb"));
		//askr.abilities.push(character.Ability.getByName("Dive-Bomb"));

		askr.addDebugSlot( "assets/characters/character-rgb-test.png", 0x161719, 0xcf3213 );
		this.sim.band.push( askr );




		// Load the animation sets
		//
		this.sim.bandAnimSet.add("idle", 0x00, 0x00 );
		this.sim.crowdAnimSet.add("idle", 0x00, 0x00 );
	}

	public function update () : Bool {

		// Load the band members





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
