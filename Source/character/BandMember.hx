package character;


class BandMember extends Character
{
	public function new ( name:String ) {
		super(name);

		var slot:Slot = null;
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

		// Add the debug layer
		slot = new Slot("debug", "assets/characters/character-rgb-test.png");
		slot.setColours( this.skinColour, 0x161719, 0xcf3213 );

		// For every loaded equipment item
		//
		//slot = new Slot("torso", "assets/characters/equipment/pauldrons.png");
		//slot.setColours( this.skinColour, 0x161719, 0xcf3213 );

		_slots.push( slot );
	}


}
