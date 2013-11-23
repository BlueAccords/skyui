import gfx.events.EventDispatcher;
import gfx.ui.InputDetails;

class VertexEditor extends MovieClip
{
	public var wireframeDisplay: WireframeDisplay;
	public var uvDisplay: UVDisplay;
	
	public var selectedVertex: Object;
	public var vertexColor: Number = 0xFF000000;
	
	function VertexEditor()
	{
		super();

		Mouse.addListener(this);
		EventDispatcher.initialize(this);
		
		//uvDisplay.Show(false);
		//wireframeDisplay.Show(false);
	}
	
	function onLoad()
	{
		super.onLoad();
		uvDisplay.addEventListener("press", this, "onPressUVDisplay");
		uvDisplay.addEventListener("select", this, "onSelectVertex");
		wireframeDisplay.addEventListener("press", this, "onPressWireframeDisplay");
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		return false;
	}
	
	public function Show(a_show: Boolean)
	{
		// TODO: Reimplement to tween objects in
		_visible = enabled = false;
	}
	
	function loadAssets()
	{
		var headMesh: Object = GetHeadMesh();
		if(headMesh) {
			uvDisplay.loadAssets(headMesh);
			wireframeDisplay.loadAssets(headMesh);
		} else {
			unloadAssets();
		}
	}
	
	function unloadAssets()
	{
		uvDisplay.unloadAssets();
		wireframeDisplay.unloadAssets();
	}
	
	private function GetHeadMesh(): Object
	{
		if(_global.skse.plugins.CharGen.GetHeadMesh)
			return _global.skse.plugins.CharGen.GetHeadMesh();
			
		return undefined;
	}
	
	private function GetVertexColors(a_vertices: Array): Array
	{
		if(_global.skse.plugins.CharGen.GetHeadVertexColors)
			return _global.skse.plugins.CharGen.GetHeadVertexColors(a_vertices);
	}
	
	private function SetVertexColors(a_vertices: Array): Array
	{
		if(_global.skse.plugins.CharGen.SetHeadVertexColors)
			return _global.skse.plugins.CharGen.SetHeadVertexColors(a_vertices);
	}
	
	public function onPressUVDisplay(event): Void
	{
		if(uvDisplay.getDepth() < wireframeDisplay.getDepth())
			uvDisplay.swapDepths(wireframeDisplay);
	}
	
	public function onPressWireframeDisplay(event): Void
	{
		if(wireframeDisplay.getDepth() < uvDisplay.getDepth())
			wireframeDisplay.swapDepths(uvDisplay);
	}
	
	public function onSelectVertex(event): Void
	{
		if(selectedVertex) {
			if(selectedVertex.index != event.vertex) { // Reset the previous vertex color
				SetVertexColors([selectedVertex]);
				selectedVertex = GetVertexColors([Number(event.vertex)]);
				SetVertexColors([{index: Number(event.vertex), color: Number(vertexColor)}]);
			}
		} else {
			selectedVertex = GetVertexColors([Number(event.vertex)]);
			SetVertexColors([{index: Number(event.vertex), color: Number(vertexColor)}]);
		}
	}
}
