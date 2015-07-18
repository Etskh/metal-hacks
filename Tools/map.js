
/*
Cell = a certain kind of cell. All cells of the same mask are sorted together.
		The type of a cell is intrinsic because it always belongs to its parent
		which is an abstraction of the terrain.

TileSet = 1 kind of terrain. Each cell has a mask that knows what it moves to.
		This means with a mask of 0x1111, it knows that on the top, it goes to
		tilset 1, on the sides, it goes to tileset 1 as well, and at the bottom
		also 1. If it was 0x1201, it means the tile will go from 1 on the top, 2
		on the right-hand side, and the VOID on the bottom, then it goes to 1 on the
		left finally.

TileSheet = the whole sheet altogether. Stores all the tilesets for it, every kind of
		terrain.

Map =	The idea of the map. This interacts with the actual tiles; it has functions to
		get the DOM tiles from the grid. It also instantiates them.

*/




var Map = (function(){

	var size = { x: 16, y: 16 };
	var tilesheet = TileSheet();

	//
	// Create a tile for the map
	//
	var CreateTile = function( x, y ) {
		var tile = document.createElement('div');
		tile.className = "tile";
		tile.dataset.x = x;
		tile.dataset.y = y;
		tile.style.width = tilesheet.tileSize;
		tile.style.height= tilesheet.tileSize;
		tile.style.left= x*tilesheet.tileSize;
		tile.style.top = y*tilesheet.tileSize;
		tile.onmousemove = function() {
			if( Input.isMouseDown() ) {
				Brush.useActive( this );
			}
		};
		tile.onmousedown = function() {
			Brush.useActive( this );
		}
		tile.dataset.tileID = 0;
		tile.dataset.tileset= 0;
		return tile;
	};


	// Initialize map here
	//
	var map = document.getElementById('map');
	for( var x=0; x<size.x; x++ ) {
		for( var y=0; y < size.y; y++ ) {
			map.appendChild( CreateTile( x, y ));
		}
	}
	console.log("Map initialised");


	return {


		//
		// Get a tile by its X & Y coordinates
		//
		getTileByXY : function( x, y ) {
			DOMTiles = document.getElementById('map').childNodes;
			for( var t=0; t< DOMTiles.length; t++) {

				var tileX= parseInt( DOMTiles[t].dataset.x );
				var tileY= parseInt( DOMTiles[t].dataset.y );
				if( tileX == x && tileY == y ) {
					return DOMTiles[t];
				}
			}
			return null;
		},




		//
		// Looks at adjacent tiles and computes its mask
		//
		computeMask : function ( tile ) {

			var n = Map.allNeighbours( tile );
			var mask = Mask.create( 1,
				n[0]?n[0].dataset.tileset:0,
				n[1]?n[1].dataset.tileset:0,
				n[2]?n[2].dataset.tileset:0,
				n[3]?n[3].dataset.tileset:0
			);
			tile.dataset.mask = mask.toString(16);

			return mask;
		},






		//
		// It... well, gets the tilesheet
		//
		getTilesheet : function() {
			return tilesheet;
		},






		//
		// Set tile's image
		//
		setTileImage : function ( tile, tileID ) {

			// define the tileType for the tilsetid
			var tileType = "Stone";

			var x = tilesheet.size - tilesheet.tileSize *
				parseInt( tileID % ( tilesheet.size / tilesheet.tileSize ));
			var y = tilesheet.size - tilesheet.tileSize *
				parseInt( tileID / ( tilesheet.size / tilesheet.tileSize ));
			tile.dataset.tileID = tileID;
			var bgp = x + "px " + y + "px";
			tile.style.backgroundPosition = bgp;
			tile.dataset.tileType = tileType;
			tile.dataset.tileset = Map.getTilesheet().getTileSetByName(tileType).id;
		},







		//
		// Forces a mask on the tile and then updates the neighbours
		//
		forceMask : function ( tile, mask, tileset ) {

			// If no mask, compute it from neighbours
			//
			if( tile.dataset.mask === undefined ) {
				Map.computeMask( tile );
			}

			// Add the mask that we were given
			//
			var oldMask = parseInt( tile.dataset.mask, 16 );
			mask = Mask.force( oldMask, mask );
			tile.dataset.mask = mask.toString(16);

			// Choose a new tileID from the tileset
			//
			var cell = tileset.getCellWithMask( mask );
			Map.setTileImage( tile, cell.random() );
		},




		//
		// Determines the tileImage
		//
		chooseTileImage : function ( tile ) {

			tile.dataset.mask

		},



		//
		// Returns a list of neighbour tiles, going TOP, RIGHT, BOTTOM, LEFT
		//
		// if the function recieves a callback, it will loop over them and
		// pass the neighbour into the callback function
		//
		allNeighbours : function ( tile, callback ) {

			if( tile != null ) {

			}

			var x = parseInt( tile.dataset.x );
			var y = parseInt( tile.dataset.y );

			var neighbours = [
				Map.getTileByXY( x, y-1 ),
				Map.getTileByXY( x+1, y ),
				Map.getTileByXY( x, y-1 ),
				Map.getTileByXY( x-1, y )
			];

			if( callback ) {
				for( var n=0; n<neighbours.length; n++) {
					callback( neighbours[n] );
				}
			}

			return neighbours;
		},





		//
		// Export tiledata
		//
		export : function () {
			var tiles = [];
			DOMTiles = document.getElementById('map').childNodes;
			for(var t=0; t<DOMTiles.length; t++ ) {
				tiles.push( parseInt(DOMTiles[t].dataset.tileID) );
			}
			return tiles;
		}
	}
})();



