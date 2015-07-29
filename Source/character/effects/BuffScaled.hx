package character.effects;



class BuffScaled implements AbilityEffect
{
	var name:String;
	var amount:Float;
	var stat:String;
	var duration:Float;

	public function new( name:String, amount:Float, stat:String, duration:Float )
	{
		this.name = name;
		this.amount= amount;
		this.stat = stat;
		this.duration = duration;
	}

	public function getMax	( caster:Character, targets:Array<Character> ) : Float
	{
		return caster.stats.get( this.stat ) * amount;
	}

	public function getStat	( ) : String
	{
		return stat;
	}

	public function exec ( success:Float, caster:Character, targets:Array<Character>)
	{
		// TODO: implement this
	}

}
