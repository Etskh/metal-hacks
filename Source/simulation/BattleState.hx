package simulation;




class BattleState implements State
{
	var sim:Simulation;
	var crowd:Array<character.CrowdCharacter>;
	var crowdAvatars:Array<world.Avatar>;
	var dude:world.Avatar;

	public function new (sim:Simulation) {
		this.sim = sim;
		this.crowd = new Array<character.CrowdCharacter>();
		this.crowdAvatars = new Array<world.Avatar>();
	}

	public function init ( )
	{
		var crowdMember:character.CrowdCharacter;
		var crowdAvatar:world.Avatar;

		//
		crowdMember = new character.CrowdCharacter("Gremlin");
		crowdMember.stats.set("impress-max", 80);
		crowdMember.stats.set("coin-ratio", 1.5);
		crowd.push( crowdMember );
		//
		crowdAvatar = new world.Avatar( crowdMember, this.sim.crowdAnimSet, 64 );
		crowdAvatar.moveTo(new openfl.geom.Point(32,128), 0.5);
		this.crowdAvatars.push( crowdAvatar );
		this.sim.world.addChild( crowdAvatar );


		//
		crowdMember = new character.CrowdCharacter("Fiend");
		crowdMember.stats.set("impress-max", 50);
		crowdMember.stats.set("coin-ratio", 0.8);
		crowd.push( crowdMember );
		//
		crowdAvatar = new world.Avatar( crowdMember, this.sim.crowdAnimSet, 64 );
		crowdAvatar.moveTo(new openfl.geom.Point(64,128+32), 0.5);
		this.crowdAvatars.push( crowdAvatar );
		this.sim.world.addChild( crowdAvatar );

		crowdMember = new character.CrowdCharacter("Brute");
		crowdMember.stats.set("impress-max", 70);
		crowd.push( crowdMember );



		dude = new world.Avatar( this.sim.band[0], this.sim.bandAnimSet, 64, function( avatar:world.Avatar){
			trace( avatar.getCharacter().name );
		});
		dude.x = 640;
		dude.y = 0;
		dude.moveTo(new openfl.geom.Point(256,32), 0.5);
		this.sim.world.addChild( dude );

		//infoScreen = new GUI.FramedWidget( sim.stage );
		//infoScreen.slideTo( new Point(0,0) );
		//infoScreen.resize( 64, 64 );
	}

	public function update () : Bool {

		// Check if the whole crowd is impressed
		//
		var areAllImpressed = true;
		for( i in 0...crowd.length ) {
			if( crowd[i] != null ) {
				if( ! crowd[i].isImpressed() ) {
					areAllImpressed = false;
				}
			}
		}


		if( areAllImpressed ) {
			Debug.log("State", "Everyone is impressed!");
			this.sim.changeState( new WorldState(this.sim) );
		}
		else {
			var crowdIndex = Std.random( crowd.length );
			var success = (Math.random()+2) / 3;

			sim.band[0].abilities[0].exec( success, sim.band[0], [crowd[crowdIndex]]);

		}

		return true;
	}

	public function exit () {
		//infoScreen.slideTo( new Point( -1 * infoScreen.desiredSize.x ,0), 2.0 )

		// Remove the band avatars
		this.sim.world.removeChild( dude );

		// Remove the crowd avatars
		for( c in 0...crowdAvatars.length) {
			this.sim.world.removeChild(crowdAvatars[c]);
		}
	}

	public function name () {
		return "BattleState";
	}
}
