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
	public var stats:StatBlock;
	public var abilities:Array<Ability>;

	public function new ( name:String ) {

		this.name = name;

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

	static public function loadAll ( ) {

		// Already loaded
		//
		if( abilities != null ) {
			return;
		}

		abilities = new Array<Ability>();
		var ability:Ability;

		// MAYBETODO: Load them in from a file? Maybe?

		var ability = new Ability("Groovy Lick");
		ability.desc = "Impresses one target for up to 150% of your technique ({effect-0-max})";
		ability.effects.push( new AbilityEffectImpress( 1.5, "technique" ));
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

	public function exec ( success:Float, caster:Character, targets:Array<Character>)
	{
		var oldImpress = targets[0].stats.get("impress");
		var val = caster.stats.get(this.statBase) * this.scalar;
		targets[0].stats.set("impress", oldImpress + ( val * success) );

		Debug.log("AbilityEffects", caster.name+" impresses "+ targets[0].name+" for "+ (val* success) );
	}
}


