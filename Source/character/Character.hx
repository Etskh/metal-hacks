package character;


class Character
{
	public var name:String;
	public var level:Int;
	public var stats:StatBlock;
	public var abilities:Array<Ability>;

	public function new ( name:String ) {

		this.name = name;

		this.level = 1;

		this.abilities = new Array<Ability>();

		this.stats = new StatBlock();
	}


}
