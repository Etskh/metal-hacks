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



import openfl.display.Sprite;
import flash.events.Event;





// Will extend Sprite to give a stage to draw on!
//
class Main extends Sprite
{

  public function new() {
		super ();

		// Create the background
		//
		/*
        var background = new Sprite();
		background.graphics.beginFill(0x324599);
		background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		addChild(background);
        */

      	// Start-up blurb
      	//
        var sysName = Sys.systemName();
        var sysTime = Std.string( Sys.time() );

      	Debug.log("System", "Week 6 Development Branch - " + sysTime );
      	Debug.log("System", "debug "+ sysName );

        // Add the main simulation object
        //
        var sim = new simulation.Simulation();
        this.addChild(sim);
        addEventListener (Event.ENTER_FRAME, sim.run );
    }
}
