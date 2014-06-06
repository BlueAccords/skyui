import gfx.events.EventDispatcher;

class WireframeDisplay extends gfx.core.UIComponent
{
	public var background: MovieClip;
	
	public var buttonCount: Number = 0;
	public var paddingTop: Number = 25;
	public var paddingBottom: Number = 25;
	public var paddingLeft: Number = 25;
	public var paddingRight: Number = 25;
	
	private var _dragOffset: Object;
	
	public var wireframe: MovieClip;
	
	public var disableInput: Boolean = false;
		
	// GFx Functions
	public var dispatchEvent: Function;
	public var addEventListener: Function;
	
	function WireframeDisplay()
	{
		super();
		_imageLoader = new MovieClipLoader();
		_imageLoader.addListener(this);
		Mouse.addListener(this);
		EventDispatcher.initialize(this);
	}
	
	function onLoad()
	{
		super.onLoad();		
		EventDispatcher.initialize(background);
		background.addEventListener("press", this, "beginDrag");
		background.addEventListener("scroll", this, "onScrollWheel");
		background.onPress = function(controllerIdx, keyboardOrMouse, button)
		{
			if (this.disabled) 
				return undefined;
		
			dispatchEvent({type: "press", controllerIdx: controllerIdx, button: button});
		}
	}
	
	public function loadAssets(headMesh: Object)
	{
		container = this.createEmptyMovieClip("container", this.getNextHighestDepth() );		
		wireframe = container.createEmptyMovieClip("wireframe", container.getNextHighestDepth());
		_imageLoader.loadClip("img://headMesh", wireframe);
		//_imageLoader.loadClip("femalehead.dds", wireframe);
	}
		
	public function unloadAssets()
	{				
		container.removeMovieClip();
	}
	
	private function calculateBackground()
	{
		background._width = paddingLeft + container._width + paddingRight;
		background._height = paddingTop + container._height + paddingBottom;
		container._x = paddingLeft - background._width / 2;
		container._y = paddingTop - background._height / 2;
	}	
	
	private function onLoadInit(a_clip: MovieClip): Void
	{
		EventDispatcher.initialize(a_clip);
		a_clip.onPress = function(controllerIdx, keyboardOrMouse, button)
		{
			if (this.disabled) 
				return undefined;
		
			dispatchEvent({type: "press", controllerIdx: controllerIdx, button: button});
		}
		a_clip.addEventListener("press", this, "beginMeshDrag");
		
		a_clip._width = 1024;
		a_clip._height = 1024;
		calculateBackground();
	}
	
	// @GFx	
	private function onMouseWheel(a_delta: Number): Void
	{
		if (disableInput)
			return;
			
		for (var target = Mouse.getTopMostEntity(); target && target != undefined; target = target._parent) {
			if (target == this) {
				if (a_delta < 0) {
					wireframe._xscale += 10;
					wireframe._yscale += 10;
				} else if (a_delta > 0) {
					wireframe._xscale -= 10;
					wireframe._yscale -= 10;
				}
				
				calculateBackground();
			}
		}
	}
	
	private function onPressedMesh(event)
	{
		dispatchEvent({type: event.type, controllerIdx: event.controllerIdx, button: event.button});
	}
	
	// Move mesh
	private function beginMeshDrag(event)
	{
		onMouseMove = doMeshDrag;
		onMouseUp = endMeshDrag;
		
		var width: Number = wireframe._width;
		var height: Number = wireframe._height;
		var x: Number = Math.max(0, Math.min(_xmouse + width / 2, width));
		var y: Number = Math.max(0, Math.min(_ymouse + height / 2, height));
		
		_global.skse.plugins.CharGen.BeginDragMesh(x, y);
	}
	private function doMeshDrag()
	{
		var width: Number = wireframe._width;
		var height: Number = wireframe._height;
		var x: Number = Math.max(0, Math.min(_xmouse + width / 2, width));
		var y: Number = Math.max(0, Math.min(_ymouse + height / 2, height));
				
		_global.skse.plugins.CharGen.OnDragMesh(x, y);
	}

	private function endMeshDrag()
	{
		delete onMouseUp;
		delete onMouseMove;
		
		_global.skse.plugins.CharGen.EndDragMesh();
	}
	
	// Move background
	private function beginDrag(event)
	{
		onMouseMove = doDrag;
		onMouseUp = endDrag;
		
		_dragOffset = {x: _xmouse, y: _ymouse};
		
		dispatchEvent({type: event.type, controllerIdx: event.controllerIdx, button: event.button});
	}

	private function doDrag()
	{
		var diffX = _xmouse - _dragOffset.x;
		var diffY = _ymouse - _dragOffset.y;
		
		_x += diffX;
		_y += diffY;
	}

	private function endDrag()
	{
		delete onMouseUp;
		delete onMouseMove;
	}
}