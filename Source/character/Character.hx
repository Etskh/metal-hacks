package character;


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

		skinColour = 0xFF0000;
	}

	public function getSlots() : Array<Slot>
	{
		return _slots;
	}

	var _slots:Array<Slot>;

}
