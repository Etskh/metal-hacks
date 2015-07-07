package ;



import openfl.display.Sprite; // Main, Simulation
import flash.events.Event;






import Simulation;




// Will extend Sprite to give a stage to draw on!
//
class Main extends Sprite {

    public function new() {

		super ();

		var background = new Sprite();
		background.graphics.beginFill(0x324599);
		background.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		addChild(background);

    	// Start-up blurb
    	//
    	Debug.log("System", "Week3 Development Branch - " + Sys.time());
    	Debug.log("System", "debug "+ Sys.systemName() );

        var simulation = new Simulation(background);
		addEventListener (Event.ENTER_FRAME, simulation.run );
    }
}
