package character;


class BandMember extends Character
{
	public function new ( name:String ) {
		super(name);
		//
		// Stats!
		//
		this.stats.set("charisma", 12.0 );
		this.stats.set("technique", 12.0 );
		this.stats.set("fortitude", 12.0 );

		this.stats.set("energy", 100.0 );
		this.stats.set("energy-max", 0.0 );
		this.stats.set("energy-per-second", 1.0 );
	}


}
