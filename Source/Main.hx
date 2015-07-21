/**
 *
 *	Main.hx contains the initializing code and the logic to prime the systems
 *	with resasonable defaults and starting files. Certain things like the starting
 *	simulation state will be done here, because between debug and release states,
 *	this is where most of the code changes should happen.
 *
 * Author:	Etskh
 * Date:	Jul 2015
 *
 */


package ;



import openfl.display.Sprite; // Main, Simulation
import flash.events.Event;
import openfl.events.MouseEvent;






import Simulation;




// Will extend Sprite to give a stage to draw on!
//
class Main extends Sprite {

  public function new() {
		super ();

		// Create the background
		//
		var background = new Sprite();
		background.graphics.beginFill(0x324599);
		background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		addChild(background);
		background.addEventListener( MouseEvent.CLICK, this._onClick );

  	// Start-up blurb
  	//
    var sysName = "Flash";
    var sysTime = "Unknown";
    #if !flash
      sysName = Sys.systemName();
      sysTime = Std.string( Sys.time() );
    #end
  	Debug.log("System", "Week 4 Development Branch - " + sysTime );
  	Debug.log("System", "debug "+ sysName );

    // Add the main simulation object
    //
    var simulation = new Simulation( background );
    addEventListener (Event.ENTER_FRAME, simulation.run );
  }

	public function _onClick( e:Dynamic ) {
		Debug.log("System", "Proving it works");
	}
}
