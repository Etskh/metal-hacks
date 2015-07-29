package character;


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
