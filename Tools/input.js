

var Input = (function(){
	var _down = false;

	document.onmousedown = function() {
		_down = true;
	}
	document.onmouseup = function() {
		_down = false;
	}

	return {

		isMouseDown : function() {
			return _down;
		}

	}
})();
