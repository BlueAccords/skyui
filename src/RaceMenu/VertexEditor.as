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
	private var _exportHeadControl: Object;
	private var _importHeadControl: Object;
	private var _clearSculptControl: Object;

	private var _platform: Number;
	private var _bPS3Switch: Boolean;

	private var _importName: String;
	private var _importPath: String;
	private var _importData: Array;
	
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
		_bPS3Switch = a_bPS3Switch;
		
		bottomBar.setPlatform(a_platform, a_bPS3Switch);
		
		if(a_platform == 0) {
			_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_exportHeadControl = {keyCode: GlobalFunctions.getMappedKey("Quicksave", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_importHeadControl = {keyCode: GlobalFunctions.getMappedKey("Quickload", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		} else {
			_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_exportHeadControl = {keyCode: GlobalFunctions.getMappedKey("Sneak", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_importHeadControl = {keyCode: GlobalFunctions.getMappedKey("Sprint", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		}		
		
		_upControl = {keyCode: GlobalFunctions.getMappedKey("Up", Input.CONTEXT_MENUMODE, a_platform != 0)};
		_downControl = {keyCode: GlobalFunctions.getMappedKey("Down", Input.CONTEXT_MENUMODE, a_platform != 0)};
		_leftControl = {keyCode: GlobalFunctions.getMappedKey("Left", Input.CONTEXT_MENUMODE, a_platform != 0)};
		_rightControl = {keyCode: GlobalFunctions.getMappedKey("Right", Input.CONTEXT_MENUMODE, a_platform != 0)};
		_udControl = [_upControl, _downControl];
		_lrControl = [_leftControl, _rightControl];
		_clearSculptControl = {keyCode: GlobalFunctions.getMappedKey("Shout", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		
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
		
		if(_platform == 0) {			
			navPanel.addButton({text: "$Export Head", controls: _exportHeadControl}).addEventListener("click", this, "onExportHeadClicked");
			navPanel.addButton({text: "$Import Head", controls: _importHeadControl}).addEventListener("click", this, "onImportHeadClicked");
		} else {
			navPanel.addButton({text: "$Import Head", controls: _importHeadControl}).addEventListener("click", this, "onImportHeadClicked");
			navPanel.addButton({text: "$Export Head", controls: _exportHeadControl}).addEventListener("click", this, "onExportHeadClicked");
		}
		
		navPanel.addButton({text: "$Clear Sculpt", controls: _clearSculptControl}).addEventListener("click", this, "onClearSculptClicked");
		
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
			 if(IsBoundKeyPressed(details, _exportHeadControl, _platform)) {
				onExportHeadClicked();
				return true;
			}
			if(IsBoundKeyPressed(details, _importHeadControl, _platform)) {
				onImportHeadClicked();
				return true;
			}
			if(IsBoundKeyPressed(details, _clearSculptControl, _platform)) {
				onClearSculptClicked();
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
	
	private function onExportHeadClicked(): Void
	{		
		var now: Date = new Date();
		var dateStr: String = "Head_" + (now.getMonth()+1) + "-" + now.getDate() + "-" + now.getFullYear() + "_" + now.getHours() + "-" + now.getMinutes() + "-" + now.getSeconds();
		delete now;
		
		var dialog = DialogTweenManager.open(_root, "FileViewerDialog", {_platform: _platform, _bPS3Switch: _bPS3Switch, titleText: "$Export Head", defaultText: dateStr, path: "Data\\SKSE\\Plugins\\CharGen\\", patterns: ["*.nif"], disableInput: false});
		dialog.addEventListener("accept", this, "onExportFile");
	}
	
	private function onImportHeadClicked(): Void
	{
		var dialog = DialogTweenManager.open(_root, "FileViewerDialog", {_platform: _platform, _bPS3Switch: _bPS3Switch, titleText: "$Import Head", defaultText: "", path: "Data\\SKSE\\Plugins\\CharGen\\", patterns: ["*.nif"], disableInput: true});
		dialog.addEventListener("accept", this, "onImportFile");
		dialog.addEventListener("dialogClosed", this, "onImportDialogClosed");
		
		/*var dialog = DialogTweenManager.open(_root, "ImportDialog", {_platform: _platform, _bPS3Switch: _bPS3Switch, titleText: "$Import Part Matcher", importPath: _importPath, source: _importData, destination: meshWindow.GetInternalMeshes()});
		dialog.addEventListener("accept", this, "onImportHead");*/
	}
	
	public function onExportFile(event: Object): Void
	{
		var filePath = event.directoryPath + "\\" + event.input;
		_global.skse.plugins.CharGen.ExportHead(filePath);
	}
	
	public function onImportFile(event): Void
	{
		_importPath = event.directoryPath + "\\" + event.input;
		_importName = event.input;
		_importData = _global.skse.plugins.CharGen.ImportHead(_importPath);
	}
	
	public function onImportDialogClosed(event): Void
	{
		if(_importData.length > 0) {
			var dialog = DialogTweenManager.open(_root, "ImportDialog", {_platform: _platform, _bPS3Switch: _bPS3Switch, titleText: "$Import Part Matcher", importPath: _importPath, source: _importData, destination: meshWindow.GetInternalMeshes()});
			dialog.addEventListener("accept", this, "onImportHead");
		}
		
		dispatchEvent({type: "importedFile", success: (_importData.length > 0), name: _importName});
	}
	
	public function onImportHead(event): Void
	{
		_global.skse.plugins.CharGen.LoadImportedHead(event.matches);
	}
	
	public function onClearSculptClicked(): Void
	{
		var meshes: Array = meshWindow.GetInternalMeshes();
		var activeList: Array = new Array();
		for(var i = 0; i < meshes.length; i++) {
			if(meshes[i].locked == false) {
				activeList.push(meshes[i].meshIndex);
			}
		}
		
		_global.skse.plugins.CharGen.ClearSculptData(activeList);
		
		delete activeList;
	}
}
