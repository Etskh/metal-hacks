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

		this.skinColour = 0xe6dbbf;

		// For every loaded equipment item
		//
		var slot:Slot = null;
		
		slot = new Slot("debug", "assets/characters/character-rgb-test.png");
		slot.setColours( this.skinColour, 0x161719, 0xcf3213 );
		_slots.push( slot );


	}


}
