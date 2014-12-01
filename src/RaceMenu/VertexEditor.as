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
	
	public var bottomBar: BottomBar;
	public var navPanel: ButtonPanel;
		
	private var BOTTOMBAR_SHOWN_Y = 645;
	private var BOTTOMBAR_HIDDEN_Y = 745;
	
	public var Lock: Function;
	
	public var tempText: TextField;
	
	public var brushes: Array;
	public var currentBrush: Number = -1;
	
	/* CONTROLS */
	private var _acceptControl: Object;

	private var _leftControl: Object;
	private var _rightControl: Object;
	private var _lrControl: Array;
	
	private var _platform;
	
	function VertexEditor()
	{
		super();

		Mouse.addListener(this);
		EventDispatcher.initialize(this);
		
		navPanel = bottomBar.buttonPanel;
		
		wireframeDisplay._visible = wireframeDisplay.enabled = false;
		wireframeDisplay._alpha = 0;
		
		meshWindow._visible = meshWindow.enabled = false;
		meshWindow._alpha = 0;
		
		historyWindow._visible = historyWindow.enabled = false;
		historyWindow._alpha = 0;
		
		tempText._visible = tempText.enabled = false;
		tempText._alpha = 0;
		
		bottomBar._y = BOTTOMBAR_HIDDEN_Y;
	}
	
	function onLoad()
	{
		super.onLoad();
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
		} else {
			_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		}		
		
		_leftControl = {keyCode: GlobalFunctions.getMappedKey("Left", Input.CONTEXT_MENUMODE, a_platform != 0)};
		_rightControl = {keyCode: GlobalFunctions.getMappedKey("Right", Input.CONTEXT_MENUMODE, a_platform != 0)};
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
		navPanel.addButton({text: "$Brush", controls: _lrControl});		
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
				if(wireframeDisplay.loadAssets()) {
					brushes = _global.skse.plugins.CharGen.GetBrushes();
					
					var brushId: Number = _global.skse.plugins.CharGen.GetCurrentBrush();
					currentBrush = getBrushIndex(brushId);
					changeBrush(currentBrush, false);
				}
				
				meshWindow.loadAssets();
			}
			
			ShowMeshWindow(true);
			ShowWireframe(true);
			ShowHistoryWindow(true);
			TweenLite.to(tempText, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			if(bRequestUnload) {
				meshWindow.unloadAssets();
				historyWindow.unloadAssets();
				if(wireframeDisplay.unloadAssets()) {
					brushes = null;
					currentBrush = -1;
				}
			}
			
			ShowMeshWindow(false);
			ShowWireframe(false);
			ShowHistoryWindow(false);
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
				cycleBrush(true);
				return true;
			} else if (details.navEquivalent == NavigationCode.LEFT) {
				cycleBrush(false);
				return true;
			}
		}
				
		return false;
	}
	
	public function Finalize(): Void
	{
		if(wireframeDisplay.unloadAssets()) {
			brushes = null;
			currentBrush = -1;
		}
	}
	
	public function getBrushIndex(a_brushId: Number): Number
	{
		for(var i = 0; i < brushes.length; i++)
		{
			if(brushes[i].type == a_brushId)
				return i;
		}
		
		return -1;
	}
	
	public function setBrushName(a_brushId: Number)
	{
		switch(a_brushId) {
			case 1:
			bottomBar.playerInfo.PlayerName.text = "$Mask Add";
			break;
			case 2:
			bottomBar.playerInfo.PlayerName.text = "$Mask Subtract";
			break;
			case 3:
			bottomBar.playerInfo.PlayerName.text = "$Inflate";
			break;
			case 4:
			bottomBar.playerInfo.PlayerName.text = "$Deflate";
			break;
			case 5:
			bottomBar.playerInfo.PlayerName.text = "$Move";
			break;
			case 6:
			bottomBar.playerInfo.PlayerName.text = "$Smooth";
			break;
			default:
			bottomBar.playerInfo.PlayerName.text = "$Invalid";
			break;
		}
	}
	
	public function changeBrush(a_brushIndex: Number, a_update: Boolean)
	{
		var brush: Object = brushes[a_brushIndex];
		if(brush) {
			setBrushName(brush.type);
			updateBottomBar();
			if(a_update)
				_global.skse.plugins.CharGen.SetCurrentBrush(brush.type);
		}
	}
		
	public function cycleBrush(a_forward: Boolean)
	{
		if(currentBrush >= 0) {
			if(a_forward) {
				currentBrush++;
				if(currentBrush == brushes.length)
					currentBrush = 0;
					
				changeBrush(currentBrush, true);
			} else {
				currentBrush--;
				if(currentBrush < 0)
					currentBrush = brushes.length - 1;
				
				changeBrush(currentBrush, true);
			}
		}
	}
}
