package simulation;




class BattleState implements State
{
	var sim:Simulation;
	var crowd:Array<character.CrowdCharacter>;

	public function new (sim:Simulation) {
		this.sim = sim;
		this.crowd = new Array<character.CrowdCharacter>();
	}

	public function init ( )
	{
		var crowdMember;

		crowdMember = new character.CrowdCharacter("Gremlin");
		crowdMember.stats.set("impress-max", 80);
		crowdMember.stats.set("coin-ratio", 1.5);
		crowd.push( crowdMember );

		crowdMember = new character.CrowdCharacter("Fiend");
		crowdMember.stats.set("impress-max", 50);
		crowdMember.stats.set("coin-ratio", 0.8);
		crowd.push( crowdMember );

		crowdMember = new character.CrowdCharacter("Brute");
		crowdMember.stats.set("impress-max", 70);
		crowd.push( crowdMember );

		//infoScreen = new GUI.FramedWidget( sim.stage );
		//infoScreen.slideTo( new Point(0,0) );
		//infoScreen.resize( 64, 64 );
	}

	public function update () : Bool {

		/*
		var crowdIndex = Std.random( crowd.length );
		var success = (Math.random()+2) / 3;

		sim.band[0].abilities[0].exec( success, sim.band[0], [crowd[crowdIndex]]);

		// Check if the whole crowd is impressed
		//
		var areAllImpressed = true;
		for( i in 0...crowd.length ) {
			if( crowd[i] ) {
				if( ! crowd[i].isImpressed() ) {
					areAllImpressed = false;
				}
			}
		}
		if( areAllImpressed ) {
			Debug.log("State", "Everyone is impressed!");
			this.sim.changeState( new SpoilsState(this.sim) );
		}
		*/
		return true;
	}

	public function exit () {
		//infoScreen.slideTo( new Point( -1 * infoScreen.desiredSize.x ,0), 2.0 );
	}

	public function name () {
		return "BattleState";
	}
}
