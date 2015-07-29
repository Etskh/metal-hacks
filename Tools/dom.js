

var DOMUtil = {

	// Includes additional script files, and makes sure they're
	// included on the page
	//
	require : function(url, callback) {
		// from: http://stackoverflow.com/questions/950087/include-a-javascript-file-in-another-javascript-file
		// Adding the script tag to the head as suggested before
	    var body = document.getElementsByTagName('body')[0];
	    var script = document.createElement('script');
	    script.type = 'text/javascript';
	    script.src = url;

	    // Then bind the event to the callback function.
	    // There are several events for cross browser compatibility.
	    if( callback ) {
			script.onreadystatechange = callback;
	    	script.onload = callback;
		}

	    // Fire the loading
	    body.appendChild(script);
	},

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
