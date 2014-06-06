import gfx.events.EventDispatcher;

class UVDisplay extends gfx.core.UIComponent
{
	public var background: MovieClip;
	
	public var buttonCount: Number = 0;
	public var paddingTop: Number = 25;
	public var paddingBottom: Number = 25;
	public var paddingLeft: Number = 25;
	public var paddingRight: Number = 25;
	
	private var _imageLoader: MovieClipLoader;
	private var container: MovieClip;
	private var _texture: Object;
	private var _scale: Number = 25;
	private var _dragOffset: Object;
	private var _paiting: Boolean = false;
	private var brush: MovieClip = null;
	
	private var _headMesh: Object = null;
	
	public var disableInput: Boolean = false;
	
	// GFx Functions
	public var dispatchEvent: Function;
	public var addEventListener: Function;
	
	function UVDisplay()
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
	
	function createBrush(a_radius: Number, a_hardness: Number)
	{
		if(brush)
			brush.removeMovieClip();

		attachMovie("SelectionBrush", "brush", getNextHighestDepth());
		brush.radius = a_radius;
		brush.hardness = a_hardness;
		brush.color = 0xFFFFFF;
		if(a_hardness == 100) {
			brush.intensity = function() { return 1.0; };
		}
		brush.drawBrush();
		this.onMouseMove = this.moveBrush;
	}
	
	function deleteBrush()
	{
		if(brush) {
			delete brush;
			delete onMouseMove;
			_painting = false;
		}
	}
	
	function moveBrush()
	{
		var local:Object = {x:_xmouse, y:_ymouse};
		this.globalToLocal(point);
		this.brush.moveBrush(local.x, local.y);
			
		if(_painting)
			paint(this.brush);
	}
	
	function paint(a_brush: Object)
	{
		var point:Object = {x:a_brush._x, y:a_brush._y};
		this.localToGlobal(point);
					
		for(var i = 0; i < this.buttonCount; i++) {
			var vertexButton = this.container.buttons["v" + i];
			if(a_brush.hitTest(vertexButton)) {
				
				var globalPt:Object = {x:vertexButton._x, y:vertexButton._y};
				this.container.buttons.localToGlobal(globalPt);
				
				var diffX: Number = globalPt.x - point.x;
				var diffY: Number = globalPt.y - point.y;
				
				var r: Number = a_brush.radius;
				var d: Number = Math.sqrt(Math.pow(diffX, 2) + Math.pow(diffY, 2));
				var intensity: Number = a_brush.intensity(d);
				
				if(d <= r) {
					if(intensity > vertexButton.intensity)
						vertexButton.setIntensity(intensity);
				}
			}
		}
	}
	
	public function loadAssets(mesh: Object)
	{
		container = this.createEmptyMovieClip("container", this.getNextHighestDepth());
		
		_texture = GetHeadTexture(RaceMenuDefines.HEADPART_FACE);
		if(_texture) {
			var textureClip = container.createEmptyMovieClip("texture", container.getNextHighestDepth());
			_imageLoader.loadClip("img://" + _texture.relativePath, textureClip);
			//_imageLoader.loadClip("img://headMesh", textureClip);
			//_imageLoader.loadClip("femalehead.dds", textureClip);
		}
		
		_headMesh = mesh;
	}
	
	public function VisitSelection(functor: Function, data: Object): Void
	{
		for(var i = 0; i < buttonCount; ++i)
		{
			var vertexButton = container.buttons["v" + i];
			functor(data, i, vertexButton);
		}
	}
	
	private function onLoadInit(a_clip: MovieClip): Void
	{
		EventDispatcher.initialize(a_clip);
		a_clip.addEventListener("press", this, "beginDrag");
		a_clip.addEventListener("scroll", this, "onScrollWheel");
		a_clip.onPress = function(controllerIdx, keyboardOrMouse, button)
		{
			if (this.disabled) 
				return undefined;
		
			dispatchEvent({type: "press", controllerIdx: controllerIdx, button: button});
		}
		
		var vertWidth: Number = _texture.width;
		var vertHeight: Number = _texture.height;
		var buttonScale: Number = 2.0;
		var lineWidth: Number = 0.25;
		var lineColor: Number = 0xFFFFFF;
		
		a_clip._width = vertWidth;
		a_clip._height = vertHeight;
		
		if(_headMesh.uv.length > 0) {
			var triangleHolder: MovieClip = container.createEmptyMovieClip("triangles", container.getNextHighestDepth());
			
			for(var i = 0; i < _headMesh.faces.length; ++i) {
				var v1: Number = _headMesh.faces[i].v1;
				var v2: Number = _headMesh.faces[i].v2;
				var v3: Number = _headMesh.faces[i].v3;
				
				triangleHolder.lineStyle(lineWidth, lineColor, 100);
				triangleHolder.moveTo(_headMesh.uv[v1].x * vertWidth, _headMesh.uv[v1].y * vertHeight);
				triangleHolder.lineTo(_headMesh.uv[v2].x * vertWidth, _headMesh.uv[v2].y * vertHeight);
				triangleHolder.lineTo(_headMesh.uv[v3].x * vertWidth, _headMesh.uv[v3].y * vertHeight);
				triangleHolder.lineTo(_headMesh.uv[v1].x * vertWidth, _headMesh.uv[v1].y * vertHeight);
			}

			var buttonHolder: MovieClip = container.createEmptyMovieClip("buttons", container.getNextHighestDepth());
			for(var i = 0; i < _headMesh.uv.length; ++i) {
				var vertexButton = buttonHolder.attachMovie("UVButton", "v" + i, buttonHolder.getNextHighestDepth());
				vertexButton.addEventListener("press", this, "onUVButtonPress");
				vertexButton.scale = buttonScale;
				vertexButton._xscale = buttonScale;
				vertexButton._yscale = buttonScale;
				vertexButton._x = _headMesh.uv[i].x * vertWidth;
				vertexButton._y = _headMesh.uv[i].y * vertHeight;
			}
				
			buttonCount = _headMesh.uv.length;
		}
		
		triangleHolder._alpha = 10;
		scale = _scale;
		_headMesh = null;
		
		createBrush(50.0, 50.0);
	}
	
	public function onUVButtonPress(event): Void
	{
		var index: Number = event.sender._name.substr(1);
		dispatchEvent({type: "select", vertex: index});
	}
	
	private function GetHeadTexture(a_partType: Number): Object
	{
		if(_global.skse.plugins.CharGen.GetHeadTexture)
			return _global.skse.plugins.CharGen.GetHeadTexture(a_partType);
			
		return undefined;
		//return {height: 1024, width: 1024};
	}
	
	private function ReleaseHeadTexture()
	{
		if(_global.skse.plugins.CharGen.ReleaseHeadTexture)
			_global.skse.plugins.CharGen.ReleaseHeadTexture();
	}
	
	public function unloadAssets()
	{
		_imageLoader.unloadClip(container.texture);
		container.texture.removeMovieClip();
		container.triangles.removeMovieClip();
		for(var i = 0; i < buttonCount; i++)
			container.buttons["v" + i].removeMovieClip();
		container.buttons.removeMovieClip();
		container.removeMovieClip();
		
		ReleaseHeadTexture();
		buttonCount = 0;
	}
	
	private function calculateBackground()
	{
		background._width = paddingLeft + container._width + paddingRight;
		background._height = paddingTop + container._height + paddingBottom;
		
		container._x = paddingLeft - background._width / 2;
		container._y = paddingTop - background._height / 2;
	}
	
	public function get scale(): Number
	{
		return _scale;
	}
	
	public function set scale(newScale: Number)
	{
		if(newScale <= 0)
			newScale = 10;
		
		container._xscale = newScale;
		container._yscale = newScale;
		
		for(var i = 0; i < buttonCount; ++i)
		{
			var vertexButton = container.buttons["v" + i];
			vertexButton._xscale = (10000 * vertexButton.scale / newScale); //= (10000 / newScale) * vertexButton.scale;
			vertexButton._yscale = (10000 * vertexButton.scale / newScale); //= (10000 / newScale) * vertexButton.scale;
		}
		
		calculateBackground();
		_scale = newScale;
	}
	
	// @GFx	
	private function onMouseWheel(a_delta: Number): Void
	{
		if (disableInput)
			return;
			
		for (var target = Mouse.getTopMostEntity(); target && target != undefined; target = target._parent) {
			if (target == this) {
				if (a_delta < 0) {
					scale += 10;
				} else if (a_delta > 0) {
					scale -= 10;
				}
			}
		}
	}
	
	private function beginDrag(event)
	{
		onMouseMove = doDrag;
		onMouseUp = endDrag;
		
		_dragOffset = {x: _xmouse, y: _ymouse};
		
		if(this.brush) {
			_painting = true;
			paint(this.brush);
		}
		
		dispatchEvent({type: event.type, controllerIdx: event.controllerIdx, button: event.button});
	}

	private function doDrag()
	{
		if(!this.brush) {
			var diffX = _xmouse - _dragOffset.x;
			var diffY = _ymouse - _dragOffset.y;
			
			_x += diffX;
			_y += diffY;
		} else {
			moveBrush();
		}
	}

	private function endDrag()
	{
		delete onMouseUp;
		delete onMouseMove;
		if(this.brush) {
			onMouseMove = moveBrush;
		}
		_painting = false;
	}
}
