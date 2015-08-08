package character;

/**
 *
 * Character contains all the gameplay-only elements of an entity.
 * this includes stats, and lists of abilties
 *
 */
class Character
{
	public var name:String;
	public var level:Int;
	public var stats:StatBlock;
	public var abilities:Array<Ability>;
	public var skinColour:UInt;

	public function new ( name:String ) {

		this.name = name;

		this.level = 1;

		this.abilities = new Array<Ability>();

		this.stats = new StatBlock();

		_slots = new Array<Slot>();

		skinColour = 0xe6dbbf;
	}

	public function addDebugSlot( assetPath:String, main:UInt, detail:UInt )
	{
		// Create the new slot with name "debug"
		var debugSlot:Slot = new Slot("debug", assetPath );

		// Set the colours
		debugSlot.setColours( this.skinColour, main, detail );

		//  Finally, add it to the array
		_slots.push( debugSlot );
	}

	public function getSlots() : Array<Slot>
	{
		return _slots;
	}

	var _slots:Array<Slot>;

}
