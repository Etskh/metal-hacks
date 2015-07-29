package character;


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
