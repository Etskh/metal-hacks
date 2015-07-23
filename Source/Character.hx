package;




typedef StatCallback = Float -> Float -> Void;
class StatBlock
{

	var values:Map <String, Float>;
	var triggers:Map <String, Array<StatCallback> >;

	public function new () {
		values = new Map();
		triggers=new Map();
	}

	public function get( key:String ) : Null<Float> {
		return this.values.get(key);
	}

	public function set( key:String, v:Float) : Float {
		var oldVal = this.values.get(key);

		this.values.set( key, v );
		var callbacks = this.triggers.get(key);
		if(callbacks != null ) {
			Debug.log("StatBlock", "Looking up triggers for "+key );
			for(i in 0...callbacks.length) {
				callbacks[i]( v, oldVal );
			}
		}

		return v;
	}

	public function addTrigger( key:String, callback:StatCallback ) {
		var callbacks = this.triggers.get(key);
		if( callbacks == null ) {
			callbacks = new Array<StatCallback>();
			this.triggers.set( key, callbacks );
		}
		callbacks.push( callback );
		Debug.log("StatBlock", "Added callback "+callback+" for "+key );
	}

	public function toString ( ) {
		var str="\n{\n";

		var valIter = this.values.iterator();
		var keyIter = this.values.keys();

		while( valIter.hasNext() && keyIter.hasNext() ) {
			str += "  \""+ keyIter.next() +"\": "+ valIter.next() +",\n";
		}
		str += "}";

		return str;
	}
}








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



class CrowdCharacter extends Character
{
	public function new ( name:String ) {
		super(name);

		this.stats.set("distance", 10.0 );
		this.stats.set("coin-ratio", 1);
		this.stats.set("impress", 0.0 );
		this.stats.set("impress-max", 50.0 );

		this.stats.addTrigger("impress", onImpress );
	}

	public function onImpress( newVal:Float, oldVal:Float ) {
		Debug.log( "CrowdCharacter", this.name+ "'s impress goes from "+oldVal+" to "+newVal);
		if( newVal >= this.stats.get("impress-max") ) {
			Debug.log( "CrowdCharacter", this.name + " is impressed!");
		}
	}

	public function isImpressed ( ) {
		return this.stats.get("impress") >= this.stats.get("impress-max");
	}
}


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

	public function createWorldAvatar( enviro:World.Environment ) {

		// Do init stuff, like assigning equipment and hair and stuff
		//

		return new World.BandMemberWorldAvatar( enviro );
	}
}




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
		ability.effects.push( new AbilityEffectImpress( 1.5, "charisma" ));
		abilities.push( ability );

		ability = new Ability("Spotlight");
		ability.desc = "Grants this band-member {effect-0-max}% more {effect-0-stat} for {effect-0-duration} bars (scales with level)";
		ability.effects.push( new AbilityEffectBuffScaled( "spotlight", 0.1, "charisma", 4 ));
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







interface AbilityEffect
{
	public function getMax	( caster:Character, targets:Array<Character> ) : Float;
	public function getStat	( ) : String;
	public function exec	( success:Float, caster:Character, targets:Array<Character> ) : Void;
}






class AbilityEffectImpress implements AbilityEffect
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


class AbilityEffectBuffScaled implements AbilityEffect
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
