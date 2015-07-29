package simulation;


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
