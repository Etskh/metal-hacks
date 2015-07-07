package;






class Font
{
	public var name:String;
	public var letters:Array<Letter>;

	public function new ( name:String ) {
		this.name = name;
		this.letters = new Array<Letter>();
	}

	static public function getDefault() : Font {
		var font = new Font("default");
		var width= 16;
		var col = 1;
		var row = 0;

		// space
		font.letters.push(new Letter(32, 0.8, [0, 0])); // space

		// lower-case
		//
		for( c in 0...26) {
			if(col==width) {
				col=0;
				row++;
			}
			font.letters.push(new Letter(97+c, 0.8, [ col, row]));
		}

		// upper-case
		//
		for( c in 0...26) {
			if(col==width) {
				col=0;
				row++;
			}
			font.letters.push(new Letter(65+c, 0.8, [ col, row]));
		}

		return font;
	}

}


class Letter
{
	public var breadth:Float;
	public var charCode:Int;
	public var height:Float;
	public var point:Array<Int>;

	public function new ( charCode:Int, breadth:Float, points:Array<Int>, height:Float = 0) {
		this.charCode= charCode;
		this.breadth = breadth;
		this.height  = height;
		this.point = points;
	}
}


