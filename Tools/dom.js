

var DOMUtil = {

	// Use this function to add a class to a dom object
	//
	addClass : function( dom, className ) {
		var classes = dom.className.split(" ");
		var index = classes.indexOf(className);
		if( index != -1 ) {
			return false;
		}
		classes.push( className );
		//
		dom.className = classes.join(" ");
	},

	// This function removes a class from a dom object
	//
	removeClass : function( dom, className ) {
		var classes = dom.className.split(" ");
		var index = classes.indexOf(className);
		if( index == -1 ) {
			return false;
		}
		classes.splice(index, 1);
		//
		dom.className = classes.join(" ");
	},
};
