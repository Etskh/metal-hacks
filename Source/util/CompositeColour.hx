package util;




class CompositeColour
{
	public var r:UInt;
	public var g:UInt;
	public var b:UInt;

	public function new ( colour:UInt ) {
		this.r = (colour & 0x00FF0000) >> 16;
		this.g = (colour & 0x0000FF00) >>  8;
		this.b = (colour & 0x000000FF) >>  0;
	}

	public function toUInt () {
		return (this.r << 16) + (this.g << 8) + this.b;
	}
}
