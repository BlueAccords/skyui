class VertexSelection
{
	private var _selection: Array;
	private var _storedSelection: Array;
	
	public function VertexSelection()
	{
		_selection = new Array();
		_storedSelection = new Array();
	}
	
	public function ClearStoredSelection()
	{
		for(var i = 0; i < _storedSelection.length; i++) {
			delete _storedSelection[i];
		}
		_storedSelection.splice(0, _storedSelection.length);
	}

	public function StoreSelection()
	{
		for(var i = 0; i < _selection.length; i++) {
			_storedSelection.push({index: _selection[i].index, vertex: {x: _selection[i].vertex.x, y: _selection[i].vertex.y, z: _selection[i].vertex.z}});
		}
	}
	
	public function GetStoredVertex(index: Number): Object
	{
		for(var i = 0; i < _storedSelection.length; i++) {
			if(_storedSelection[i].index == index)
				return _storedSelection[i].vertex;
		}
		
		return null;
	}
	
	public function VisitSelection(functor: Function, data, vertices): Void
	{
		for(var i = 0; i < _selection.length; i++) {
			functor(data, _selection[i], vertices);
		}
	}
	
	public function AddSelection(index: Number, strength: Number, vertex: Object)
	{
		for(var i = 0; i < _selection.length; i++) {
			if(_selection[i].index == index) {
				_selection[i].strength = strength;
				return;
			}
		}
		_selection.push({index: index, strength: strength, vertex: vertex});
	}
	
	public function ClearSelection()
	{
		_selection.splice(0, _selection.length);
	}
}