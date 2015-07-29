package simulation;


interface State
{
	public function init	() : Void ;
	public function update	() : Bool ;
	public function exit	() : Void ;
	public function name	() : String;
}
