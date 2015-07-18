

var DOMUtil = {
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
