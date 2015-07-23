
//
// The brush API
//
var Brush = (function(){

	//
	// The list of brushes
	//
	//
	var brushes = [{
		name: "Single Tile",
		desc: "Rudimentary brush - select the individual tile image and paste it onto the terrain.",
		options: {
			"selectedTile" : 0x12,
		},
		exec: function( tile, options ) {
			Map.setTileImage( tile, options.selectedTile );
		}
	},{
		name: "Randomized",
		desc: "A little more advanced; it uses a mask to change the individual tile to a randomized tile.",
		options: {
			"selectedSet" : 0x01,
			"mask" : 0x1111,
		},
		exec: function( tile, options ) {
			var ts = Map.getTilesheet().getTileSetByID( options.selectedSet );
			Map.setTileImage( tile, ts.getCellWithMask( options.mask ).random() );
		}
	},{
		name: "Build Terrain",
		desc: "Fills a tile with the selected set, then it adjusts adjacent tiles.",
		options: {
			"selectedSet" : 0x01,
		},
		exec: function( tile, options ) {
			var ts = Map.getTilesheet().getTileSetByID( options.selectedSet );

			Map.forceMask( tile, 0x1111, ts );

			var tileX = parseInt( tile.dataset.x );
			var tileY = parseInt( tile.dataset.y );

			// Sides
			//
			Map.forceMask( Map.getTileByXY( tileX, tileY - 1 ), 0x0111, ts ); // top
			Map.forceMask( Map.getTileByXY( tileX + 1, tileY ), 0x1011, ts ); // right
			Map.forceMask( Map.getTileByXY( tileX, tileY + 1 ), 0x1101, ts ); // bottom
			Map.forceMask( Map.getTileByXY( tileX - 1, tileY ), 0x1110, ts ); // left

			// Corners
			//
			Map.forceMask( Map.getTileByXY( tileX - 1, tileY - 1 ), 0x0110, ts ); // top-left
			Map.forceMask( Map.getTileByXY( tileX + 1, tileY - 1 ), 0x0011, ts ); // top-right
			Map.forceMask( Map.getTileByXY( tileX + 1, tileY + 1 ), 0x1001, ts ); // bottom-right
			Map.forceMask( Map.getTileByXY( tileX - 1, tileY + 1 ), 0x1100, ts ); // bottom-left

		}
	},{
		name: "Terrain Single",
		desc: "Sets the single tile and modifies all surrounding tiles",
		options: {
			"selectedSet" : 0x01,
		},
		exec: function( tile, options ) {

			var ts = Map.getTilesheet().getTileSetByID( options.selectedSet );

			Map.forceMask( tile, 0x1111, ts );

			Map.allNeighbours( tile, function( neighbour ) {
				if( neighbour ) {
					neighbour.dataset.tileset = options.selectedSet;
					Map.chooseTileImage( neighbour );
				}
			});
		}
	},{
		name: "Eraser",
		desc: "Sets any tile it touches to void.",
		options: {
			// none
		},
		exec: function( tile, options ) {

			Map.setTileImage( tile, 0x0 );
			tile.dataset.mask = (0x0000).toString(16);
			Map.computeMask( tile );
			Map.allNeighbours( tile, function(neighbour) {
				Map.computeMask( neighbour );
			});
		}
	}];


	//
	// Create all the brushes in the menu
	//
	var brushesDOM = document.getElementById('brushes');
	//
	for( var b=0; b<brushes.length; b++ ) {
		//
		// Container for brush
		//
		var brushDOM = document.createElement('div');
		brushDOM.className = "brush";
		brushDOM.dataset.brushID = b;
		//
		// Add the title of the brush
		//
		var brushTitleDOM = document.createElement('div');
		brushTitleDOM.className ="selector";
		brushTitleDOM.title = brushes[b].desc;
		brushTitleDOM.appendChild( document.createTextNode(brushes[b].name) );
		brushTitleDOM.onclick = function() {
			Brush.select( parseInt( this.parentNode.dataset.brushID ) );
		};
		brushDOM.appendChild( brushTitleDOM );
		//
		// Add options in here
		//
		var optionsDOM = document.createElement('div');
		optionsDOM.className = "options";
		for( var p in brushes[b].options ) {

			var optionDOM = document.createElement('div');
			optionDOM.className = "option";

			// name
			//
			var optionNameDOM = document.createElement('div');
			optionNameDOM.className = "name";
			optionNameDOM.innerHTML = p;
			optionDOM.appendChild( optionNameDOM );

			// value
			//
			var optionValueDOM = document.createElement('div');
			optionValueDOM.className = "value";
			switch( p ) {
			case "selectedTile":
				optionValueDOM.innerHTML= "("+brushes[b].options[p]+")";
				break;
			case "selectedSet":
				optionValueDOM.innerHTML= "("+brushes[b].options[p]+")";
				break;
			case "mask":
				optionValueDOM.innerHTML= "("+brushes[b].options[p].toString(16) +")";
				break;
			default:
				console.error( "`"+p+"` is an undetected option.");
			}
			optionDOM.appendChild( optionValueDOM );
			optionsDOM.appendChild( optionDOM );
		}
		brushDOM.appendChild( optionsDOM );

		//
		brushesDOM.appendChild( brushDOM );
	}


	console.log("Brushes initialised");
	return {
		//
		// The active brush
		//
		active : undefined,

		//
		// Selects a new brush by brushID
		//
		select : function( id ) {
			var b =0;

			Brush.active = brushes[id];

			var brushList = document.getElementsByClassName("brush");
			for( b=0; b< brushList.length; b++) {
				DOMUtil.removeClass( brushList[b], "active");
			}

			var brushesDOM = document.getElementById('brushes');
			for( b=0; b< brushesDOM.childNodes.length; b++) {
				if( brushesDOM.childNodes[b].dataset ) {
					if( parseInt(brushesDOM.childNodes[b].dataset.brushID) == id ) {
						DOMUtil.addClass( brushesDOM.childNodes[b], "active");
					}
				}
			}
			console.log( "Selected `"+ brushes[id].name +"` brush");
			return brushes[id];
		},

		//
		// Just launches the active brush with the data of the brush
		//
		useActive : function ( tile ) {
			Brush.active.exec( tile, Brush.active.options );
		},
	}
})();
Brush.select(0);
