import gfx.events.EventDispatcher;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;
import gfx.io.GameDelegate;

import skyui.components.ButtonPanel;
import skyui.util.GlobalFunctions;
import skyui.defines.Input;

import com.greensock.TweenLite;
import com.greensock.OverwriteManager;
import com.greensock.easing.Linear;

class VertexEditor extends MovieClip
{
	public var wireframeDisplay: WireframeDisplay;
	public var meshWindow: MeshWindow;
	public var historyWindow: HistoryWindow;
	public var brushWindow: BrushWindow;
	
	public var bottomBar: BottomBar;
	public var navPanel: ButtonPanel;
		
	private var BOTTOMBAR_SHOWN_Y = 645;
	private var BOTTOMBAR_HIDDEN_Y = 745;
	
	public var Lock: Function;
	
	public var tempText: TextField;
		
	/* CONTROLS */
	private var _acceptControl: Object;

	private var _upControl: Object;
	private var _downControl: Object;
	private var _leftControl: Object;
	private var _rightControl: Object;
	private var _udControl: Array;
	private var _lrControl: Array;
	private var _savePresetControl: Object;
	
	private var _platform;
	
	public var dispatchEvent: Function;
	public var addEventListener: Function;
	
	function VertexEditor()
	{
		super();
		EventDispatcher.initialize(this);
		
		navPanel = bottomBar.buttonPanel;
		
		wireframeDisplay._visible = wireframeDisplay.enabled = false;
		wireframeDisplay._alpha = 0;
		
		meshWindow._visible = meshWindow.enabled = false;
		meshWindow._alpha = 0;
		
		historyWindow._visible = historyWindow.enabled = false;
		historyWindow._alpha = 0;
		
		brushWindow._visible = brushWindow.enabled = false;
		brushWindow._alpha = 0;
		
		tempText._visible = tempText.enabled = false;
		tempText._alpha = 0;
		
		bottomBar._y = BOTTOMBAR_HIDDEN_Y;
	}
	
	function onLoad()
	{
		super.onLoad();
		
		wireframeDisplay.addEventListener("beginPainting", this, "onBeginActivity");
		wireframeDisplay.addEventListener("endPainting", this, "onEndActivity");
		
		wireframeDisplay.addEventListener("beginRotating", this, "onBeginActivity");
		wireframeDisplay.addEventListener("endRotating", this, "onEndActivity");
		
		brushWindow.addEventListener("changeBrush", this, "onChangeBrush");
		
		bottomBar.playerInfo.RaceLabel.enabled = bottomBar.playerInfo.RaceLabel._visible = false;
		bottomBar.playerInfo.PlayerRace.enabled = bottomBar.playerInfo.PlayerRace._visible = false;
		bottomBar.playerInfo.NameLabel.text = "$Brush";
	}
	
	function InitExtensions()
	{
		historyWindow.InitExtensions();
	}
	
	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		_platform = a_platform;
		
		bottomBar.setPlatform(a_platform, a_bPS3Switch);
		
		if(a_platform == 0) {
			_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_savePresetControl = {keyCode: GlobalFunctions.getMappedKey("Quicksave", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		} else {
			_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_savePresetControl = {keyCode: GlobalFunctions.getMappedKey("Sneak", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		}		
		
		_upControl = {keyCode: GlobalFunctions.getMappedKey("Up", Input.CONTEXT_MENUMODE, a_platform != 0)};
		_downControl = {keyCode: GlobalFunctions.getMappedKey("Down", Input.CONTEXT_MENUMODE, a_platform != 0)};
		_leftControl = {keyCode: GlobalFunctions.getMappedKey("Left", Input.CONTEXT_MENUMODE, a_platform != 0)};
		_rightControl = {keyCode: GlobalFunctions.getMappedKey("Right", Input.CONTEXT_MENUMODE, a_platform != 0)};
		_udControl = [_upControl, _downControl];
		_lrControl = [_leftControl, _rightControl];
		
		var leftEdge = Stage.visibleRect.x + Stage.safeRect.x;
		var rightEdge = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
		bottomBar.positionElements(leftEdge, rightEdge);
		
		updateBottomBar();
	}
	
	private function updateBottomBar(): Void
	{
		navPanel.clearButtons();
		navPanel.addButton({text: "$Done", controls: _acceptControl}).addEventListener("click", this._parent, "onDoneClicked");
		navPanel.addButton({text: "$Brush", controls: _udControl});
		navPanel.addButton({text: "$Property", controls: _lrControl});
		navPanel.addButton({text: "$Save Preset", controls: _savePresetControl}).addEventListener("click", _parent.presetEditor, "onSavePresetClicked");
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
			if(bRequestLoad) {
				wireframeDisplay.loadAssets();
				brushWindow.loadAssets();
				meshWindow.loadAssets();
			}
			
			ShowMeshWindow(true);
			ShowWireframe(true);
			ShowHistoryWindow(true);
			ShowBrushWindow(true);
			TweenLite.to(tempText, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			if(bRequestUnload) {
				meshWindow.unloadAssets();
				historyWindow.unloadAssets();
				brushWindow.unloadAssets();
				wireframeDisplay.unloadAssets();
			}
			
			ShowMeshWindow(false);
			ShowWireframe(false);
			ShowHistoryWindow(false);
			ShowBrushWindow(false);
			TweenLite.to(tempText, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
		
		enabled = bShowAll;
	}
	
	public function ShowMeshWindow(bShowWindow: Boolean): Void
	{
		if(bShowWindow) {
			TweenLite.to(meshWindow, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(meshWindow, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function ShowHistoryWindow(bShowWindow: Boolean): Void
	{
		if(bShowWindow) {
			TweenLite.to(historyWindow, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(historyWindow, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function ShowBrushWindow(bShowWindow: Boolean): Void
	{
		if(bShowWindow) {
			TweenLite.to(brushWindow, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(brushWindow, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
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
	
	public function IsBoundKeyPressed(details: InputDetails, boundKey: Object, platform: Number): Boolean
	{
		return ((details.control && details.control == boundKey.name) || (details.skseKeycode && boundKey.name && boundKey.context && details.skseKeycode == GlobalFunctions.getMappedKey(boundKey.name, Number(boundKey.context), platform != 0)) || (details.skseKeycode && details.skseKeycode == boundKey.keyCode));
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (GlobalFunc.IsKeyPressed(details)) {
			if(IsBoundKeyPressed(details, _savePresetControl, _platform)) {
				_parent.presetEditor.onSavePresetClicked();
				return true;
			}
		}
		
		return brushWindow.handleInput(details, pathToFocus);
	}
	
	public function hasAssets(): Boolean
	{
		return wireframeDisplay.bLoadedAssets;
	}
	
	public function unloadAssets(): Void
	{
		meshWindow.unloadAssets();
		historyWindow.unloadAssets();
		brushWindow.unloadAssets();
		wireframeDisplay.unloadAssets();
	}
	
	public function onBeginActivity(event: Object)
	{
		brushWindow.bAllowBrushChange = false;
	}
	
	public function onEndActivity(event: Object)
	{
		brushWindow.bAllowBrushChange = true;
	}
	
	public function onChangeBrush(event: Object)
	{
		bottomBar.playerInfo.PlayerName.text = event.brushName;
	}
}
