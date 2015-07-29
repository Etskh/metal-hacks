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
			#if flash
			trace(cat+": "+text );
			#else
			Sys.println(cat+": "+text );
			#end
		}
		if( globalFilters.indexOf( cat ) == -1 ) {
			globalFilters.push( cat );
		}
		#end
	}

	public static function avatar_hitbox_colour	() : UInt { return 0x00FF00; }
	public static function gui_hitbox_colour	() : UInt { return 0xFF0000; }
	public static function trigger_hitbox_colour() : UInt { return 0x0000FF; }

	#if debug
	public static var drawHitboxes = true;
	#else
	public static var drawHitboxes = false;
	#end
}
