import gfx.events.EventDispatcher;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;

import skyui.components.ButtonPanel;
import skyui.util.GlobalFunctions;
import skyui.defines.Input;

import com.greensock.TweenLite;
import com.greensock.OverwriteManager;
import com.greensock.easing.Linear;

class VertexEditor extends MovieClip
{
	public var wireframeDisplay: WireframeDisplay;
	
	public var bottomBar: BottomBar;
	public var navPanel: ButtonPanel;
		
	private var BOTTOMBAR_SHOWN_Y = 645;
	private var BOTTOMBAR_HIDDEN_Y = 745;
	
	public var Lock: Function;
	
	public var tempText: TextField;
	
	/* CONTROLS */
	private var _acceptControl: Object;
	
	function VertexEditor()
	{
		super();

		Mouse.addListener(this);
		EventDispatcher.initialize(this);
		
		navPanel = bottomBar.buttonPanel;
		
		wireframeDisplay._visible = wireframeDisplay.enabled = false;
		wireframeDisplay._alpha = 0;
		
		tempText._visible = tempText.enabled = false;
		tempText._alpha = 0;
		
		bottomBar._y = BOTTOMBAR_HIDDEN_Y;
	}
	
	function onLoad()
	{
		super.onLoad();
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
		navPanel.addButton({text: "$Done", controls: _acceptControl}).addEventListener("click", this._parent, "onDoneClicked");
		
		navPanel.updateButtons(true);		
	}
	
	public function ShowAll(bShowAll: Boolean, bRequestLoad: Boolean, bRequestUnload: Boolean): Void
	{
		ShowBottomBar(bShowAll);		
		if(bShowAll) {
			TweenLite.to(this, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(this, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
		
		if(bShowAll) {
			if(bRequestLoad)
				wireframeDisplay.loadAssets();
			
			ShowWireframe(true);
			TweenLite.to(tempText, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			if(bRequestUnload)
				wireframeDisplay.unloadAssets();
			
			ShowWireframe(false);
			TweenLite.to(tempText, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
		
		enabled = bShowAll;
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
		// Consume Left/Right input
		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.RIGHT) {
				return true;
			} else if (details.navEquivalent == NavigationCode.LEFT) {
				return true;
			}
		}
		return false;
	}
	
	public function Finalize(): Void
	{
		wireframeDisplay.unloadAssets();
	}
}
