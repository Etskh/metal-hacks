
var Mask = {

	//
	// Returns an array of the components from largest to smallest
	//
	toComponents : function ( mask ) {
		return [
			parseInt(mask/0x1000) % 16,
			parseInt(mask/0x100) % 16,
			parseInt(mask/0x10) % 16,
			parseInt(mask/0x1) % 16
		];
	},



	//
	// Merges the mask components back together
	//
	fromComponents : function ( components ) {
		return 0x1000*components[0] + 0x100*components[1] + 0x10*components[2] + components[3];
	},



	//
	// Create a mask with a single
	//
	create : function( id, T, R, B, L ) {
		return 0x1000*id*T + 0x100*id*R + 0x10*id*B + id*L;
	},



	//
	// Stomps over mask left's components if mask right's aren't 0
	//
	force : function ( maskLeft, maskRight ) {

		var maskLeftComp = Mask.toComponents( maskLeft );
		var maskRightComp= Mask.toComponents( maskRight );

		for( var c=0; c<4; c++) {
			maskLeftComp[c] = maskRightComp[c]==0?maskLeftComp[c]:maskRightComp[c];
		}

		return Mask.fromComponents( maskLeftComp );
	},
};




function Cell ( tileID, mask ) {
	var _tileIDs = [ tileID ];

	return {
		mask: mask,
		tileIDs : _tileIDs,
		random : function() {
			return _tileIDs[ parseInt( _tileIDs.length * Math.random() ) ];
		}
	}
}

function TileSet( id, name, breadth, data ) {
	var _tileset = {
		id: id,
		name: name,
		cells: [],
		getCellWithMask : function( mask ) {
			for( var c=0; c<_tileset.cells.length; c++ ) {
				if ( _tileset.cells[c].mask == mask ) {
					return _tileset.cells[c];
				}
			}
			console.error("Couldn't find cell with mask of "+mask.toString(16) );
			return null;
		},
	};

	function addCell( tileID, mask ) {

		for( var c=0; c< _tileset.cells.length; c++ ) {
			if( _tileset.cells[c].mask == mask ) {
				_tileset.cells[c].tileIDs.push( tileID );
			}
		}
		_tileset.cells.push(Cell( tileID, mask ));
	}

	var fillMask = Mask.create(id, 1,1,1,1);

	if( data.fills ) {
		for( var f=0; f<data.fills.length; f++) {
			addCell( data.fills[f], fillMask );
		}
	}

	if( data.areas ) {
		for( var f=0; f<data.areas.length; f++) {

			// Fill
			addCell( data.areas[f], fillMask );

			// Edges
			addCell( data.areas[f]-breadth, Mask.create(id,0,1,1,1) );		// Top
			addCell( data.areas[f] + 1,			Mask.create(id,1,0,1,1) );		// Right
			addCell( data.areas[f]+breadth,	Mask.create(id,1,1,0,1) );		// Bottom
			addCell( data.areas[f] - 1,			Mask.create(id,1,1,1,0) );		// Left

			// Corners
			addCell((data.areas[f]-breadth)-1,	Mask.create(id,0,1,1,0) );	// Top-Left
			addCell((data.areas[f]-breadth)+1,	Mask.create(id,0,0,1,1) );	// Top-Right
			addCell((data.areas[f]+breadth)-1,	Mask.create(id,1,1,0,0) );	// Bottom-Left
			addCell((data.areas[f]+breadth)+1,	Mask.create(id,1,0,0,1) );	// Bottom-Right
		}
	}

	if( data.stars ) {
		for( var f=0; f<data.stars.length; f++) {

			// Fill
			addCell( data.stars[f], fillMask );

			// Points
			addCell( data.stars[f]-breadth*2, Mask.create(id,0,0,1,0) );		// Top
			addCell( data.stars[f] + 2,				Mask.create(id,0,0,0,1) );		// Right
			addCell( data.stars[f]+breadth*2,	Mask.create(id,1,0,0,0) );		// Bottom
			addCell( data.stars[f] - 2,				Mask.create(id,0,1,0,0) );		// Left

			// Columns
			addCell( data.stars[f]-breadth, Mask.create(id,1,0,1,0) );		// Top
			addCell( data.stars[f] + 1,			Mask.create(id,0,1,0,1) );		// Right
			addCell( data.stars[f]+breadth,	Mask.create(id,1,0,1,0) );		// Bottom
			addCell( data.stars[f] - 1,			Mask.create(id,0,1,0,1) );		// Left

		}
	}

	return _tileset;
}



function TileSheet() {
	var tileSize = 32;
	var sheetSize = 512;

	var _tilesets = [
		TileSet( 0x1, "Stone", (sheetSize/tileSize), {
			fills: [ 0x2E, 0x2F ],
			areas: [ 0x12, 0x15, 0x18 ],
			stars: [ 0x42 ],
		})
	];

	return {

		tilesets : _tilesets,

		size : sheetSize,

		tileSize : tileSize,

		getTileSetByName : function( name ) {
			for( var t=0; t< _tilesets.length; t++ ) {
				if ( name == _tilesets[t].name ) {
					return _tilesets[t];
				}
			}
			return null;
		},

		getTileSetByID : function( id ) {
			for( var t=0; t< _tilesets.length; t++ ) {
				if ( id == _tilesets[t].id ) {
					return _tilesets[t];
				}
			}
			return null;
		},
	};
}
