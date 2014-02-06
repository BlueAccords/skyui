import gfx.events.EventDispatcher;
import gfx.ui.InputDetails;

import skyui.components.ButtonPanel;
import skyui.util.GlobalFunctions;
import skyui.defines.Input;

import com.greensock.TweenLite;
import com.greensock.OverwriteManager;
import com.greensock.easing.Linear;

class VertexEditor extends MovieClip
{
	public var wireframeDisplay: WireframeDisplay;
	public var uvDisplay: UVDisplay;
	
	public var bottomBar: BottomBar;
	public var navPanel: ButtonPanel;
	public var scaleWidget: ScaleWidget;
	
	public var selectedVertex: Object;
	public var vertexColor: Number = 0xFF000000;
	
	private var BOTTOMBAR_SHOWN_Y = 645;
	private var BOTTOMBAR_HIDDEN_Y = 745;
	
	public var Lock: Function;
	
	/* CONTROLS */
	private var _acceptControl: Object;
	
	function VertexEditor()
	{
		super();

		Mouse.addListener(this);
		EventDispatcher.initialize(this);
		
		navPanel = bottomBar.buttonPanel;
		
		uvDisplay._visible = uvDisplay.enabled = false;
		wireframeDisplay._visible = wireframeDisplay.enabled = false;
		scaleWidget._visible = scaleWidget.enabled = false;
		scaleWidget._alpha = 0;
		
		bottomBar._y = BOTTOMBAR_HIDDEN_Y;
	}
	
	function onLoad()
	{
		super.onLoad();
		uvDisplay.addEventListener("press", this, "onPressUVDisplay");
		uvDisplay.addEventListener("select", this, "onSelectVertex");
		wireframeDisplay.addEventListener("press", this, "onPressWireframeDisplay");
		bottomBar.hidePlayerInfo();
	}
	
	function InitExtensions()
	{
		
	}
	
	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		bottomBar.setPlatform(a_platform, a_bPS3Switch);
		
		if(a_platform == 0) {
			_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		} else {
			_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		}
		
		var leftEdge = Stage.visibleRect.x + Stage.safeRect.x;
		var rightEdge = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
		bottomBar.positionElements(leftEdge, rightEdge);
		
		updateBottomBar();
	}
	
	private function updateBottomBar(): Void
	{
		navPanel.clearButtons();
		navPanel.addButton({text: "$Done", controls: _acceptControl}).addEventListener("click", this, "onDoneClicked");
		
		navPanel.updateButtons(true);		
	}
	
	public function ShowAll(bShowAll: Boolean): Void
	{
		ShowBottomBar(bShowAll);
		ShowWidget(bShowAll);
		
		if(bShowAll) {
			TweenLite.to(this, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(this, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function ShowUV(bShowUV: Boolean): Void
	{
		if(bShowUV) {
			TweenLite.to(uvDisplay, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(uvDisplay, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function ShowWidget(bShowWidget: Boolean): Void
	{
		if(bShowWidget) {
			TweenLite.to(scaleWidget, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(scaleWidget, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function ShowWireframe(bShowWireframe: Boolean): Void
	{
		if(bShowWireframe) {
			TweenLite.to(wireframeDisplay, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(wireframeDisplay, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function ShowBottomBar(bShowBottomBar: Boolean): Void
	{
		if(bShowBottomBar) {
			TweenLite.to(bottomBar, 0.5, {autoAlpha: 100, _y: BOTTOMBAR_SHOWN_Y, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(bottomBar, 0.5, {autoAlpha: 0, _y: BOTTOMBAR_HIDDEN_Y, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		return false;
	}
	
	function loadAssets()
	{
		var headMesh: Object = GetHeadMesh(RaceMenuDefines.HEADPART_FACE);
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
	
	private function GetHeadMesh(a_partType: Number): Object
	{
		if(_global.skse.plugins.CharGen.GetHeadMesh)
			return _global.skse.plugins.CharGen.GetHeadMesh(a_partType);
			
		return undefined;
		/*return {uv: [{x: 0.5, y: 0.5},
					 {x: 0.75, y: 0.75},
					 {x: 1.0, y: 1.0}]};*/
	}
	
	private function GetVertexColors(a_vertices: Array, a_partType: Number): Array
	{
		if(_global.skse.plugins.CharGen.GetHeadVertexColors)
			return _global.skse.plugins.CharGen.GetHeadVertexColors(a_vertices, a_partType);
	}
	
	private function SetVertexColors(a_vertices: Array, a_partType: Number): Array
	{
		if(_global.skse.plugins.CharGen.SetHeadVertexColors)
			return _global.skse.plugins.CharGen.SetHeadVertexColors(a_vertices, a_partType);
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
				SetVertexColors([selectedVertex], RaceMenuDefines.HEADPART_FACE);
				selectedVertex = GetVertexColors([Number(event.vertex)], RaceMenuDefines.HEADPART_FACE);
				SetVertexColors([{index: Number(event.vertex), color: Number(vertexColor)}], RaceMenuDefines.HEADPART_FACE);
			}
		} else {
			selectedVertex = GetVertexColors([Number(event.vertex)], RaceMenuDefines.HEADPART_FACE);
			SetVertexColors([{index: Number(event.vertex), color: Number(vertexColor)}], RaceMenuDefines.HEADPART_FACE);
		}
	}
}
