package simulation;





class Simulation extends openfl.display.Sprite
{
	// Party characters
	public var band:Array<character.BandMember>;

	public var world:world.World;
	public var gui:gui.GUI;

	// Current state logic
	var state:State;
	var nextState:Null<State>;




	public function new ( ) {
		super();

		this.band = new Array<character.BandMember>();

		this.world = new world.World();
		addChild(this.world);

		//this.gui = new gui.GUI();
		//addChild(this.gui);

		this.state = new LoadState(this);
		this.nextState = null;
		this.state.init();
	}

	public function changeState( state:State ) {
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
