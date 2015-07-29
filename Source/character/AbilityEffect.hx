package character;



interface AbilityEffect
{
	public function getMax	( caster:Character, targets:Array<Character> ) : Float;
	public function getStat	( ) : String;
	public function exec	( success:Float, caster:Character, targets:Array<Character> ) : Void;
}
