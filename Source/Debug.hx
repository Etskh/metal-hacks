package;


class Debug {
	public static var filters:Array<String> = [
		"State",
		"System",
		"Simulation",
		"StatBlock",
		"Ability",
		"CrowdCharacter",
		"AbilityEffects",
		"Avatar",
		"GUI",
	];
	public static var globalFilters:Array<String> = new Array<String>();

	public static function log ( cat:String, text:String ) {
		#if debug
		if( filters.indexOf( cat ) != -1 ) {
			Sys.println(cat+": "+text );
		}
		if( globalFilters.indexOf( cat ) == -1 ) {
			globalFilters.push( cat );
		}
		#end
	}
}
