package character.effects;


class Impress implements AbilityEffect
{
	var scalar:Float;
	var statBase:String;

	public function new ( scalar:Float, statBase:String )
	{
		this.scalar = scalar;
		this.statBase = statBase;
	}

	public function getMax	( caster:Character, targets:Array<Character> ) : Float
	{
		return caster.stats.get( this.statBase ) * scalar;
	}

	public function getStat	( ) : String
	{
		return statBase;
	}

	public function exec ( success:Float, caster:Character, targets:Array<Character>)
	{
		var oldImpress = targets[0].stats.get("impress");
		var val = caster.stats.get(this.statBase) * this.scalar;
		targets[0].stats.set("impress", oldImpress + ( val * success) );

		Debug.log("AbilityEffects", caster.name+" impresses "+ targets[0].name+" for "+ (val* success) );
	}
}
