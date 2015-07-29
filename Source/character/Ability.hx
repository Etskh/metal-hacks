package character;


class Ability
{
	public var name:String;
	public var desc:String;
	public var cost:Int;
	//var iconBitmap:BitmapData;
	var effects:Array<AbilityEffect>;
	static var abilities:Array<Ability>;

	public function new (name:String)
	{
		this.name = name;
		this.desc = "Nondescript";
		this.cost = 0;
		//this.iconBitmap = BitmapData.LoadSomethingSomething();
		this.effects = new Array<AbilityEffect>();
	}

	public function exec ( success:Float, caster:Character, targets:Array<Character> )
	{
		Debug.log( "Ability", caster.name+" uses "+ this.name );
		for(i in 0...effects.length) {
			effects[i].exec( success, caster, targets );
		}
	}

	//
	// Parses the effect based on the character
	//
	public function getDesc(character:Character, targets:Array<Character> ):String {
		var finalDesc:String = this.desc;
		var replacements = new Map<String,String>();



		//
		// {effect-N-max} -- gets the highest effect possible
		//
		for( e in 0...this.effects.length ) {
			replacements.set(
				"{effect-"+Std.string(e)+"-max}",
				Std.string(this.effects[e].getMax(character, targets))
			);
		}
		//
		// {effect-N-stat} -- gets the affected or causal stat
		//
		for( e in 0...this.effects.length ) {
			replacements.set(
				"{effect-"+Std.string(e)+"-stat}",
				this.effects[e].getStat()
			);
		}

		// Cut the string into an array,
		// sew it back together,
		// splicing the value between each element
		//
		var itr = replacements.keys();
		while( itr.hasNext() ) {
			var key:String = itr.next();
			finalDesc = finalDesc.split(key).join(replacements.get(key));
		}
		return finalDesc;
	}

	static public function loadAll ( ) {

		// Already loaded
		//
		if( abilities != null ) {
			return;
		}

		abilities = new Array<Ability>();
		var ability:Ability;

		// MAYBETODO: Load them in from a file? Maybe?

		ability = new Ability("Dive-Bomb");
		ability.desc = "Impresses one target for up to 150% of your {effect-0-stat} ({effect-0-max})";
		ability.effects.push( new character.effects.Impress( 1.5, "charisma" ));
		abilities.push( ability );

		ability = new Ability("Spotlight");
		ability.desc = "Grants this band-member {effect-0-max}% more {effect-0-stat} for {effect-0-duration} bars (scales with level)";
		ability.effects.push( new character.effects.BuffScaled( "spotlight", 0.1, "charisma", 4 ));
		abilities.push( ability );
	}

	static public function getByName( name:String ) : Null<Ability> {
		Ability.loadAll();

		for(i in 0...abilities.length) {
			if( abilities[i].name == name ) {
				return abilities[i];
			}
		}
		return null;
	}
}
