package simulation;



class LoadState implements State
{
	var sim:Simulation;

	public function new (sim:Simulation) {
		this.sim = sim;
	}

	public function init () {
		character.Ability.loadAll();
	}

	public function update () : Bool {

		var askr = new character.BandMember("Askr");
		askr.abilities = new Array<character.Ability>();
		askr.abilities.push(character.Ability.getByName("Dive-Bomb"));
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
