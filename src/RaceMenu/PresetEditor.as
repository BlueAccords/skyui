import gfx.events.EventDispatcher;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;

import skyui.components.ButtonPanel;
import skyui.util.GlobalFunctions;
import skyui.defines.Input;

import skyui.components.list.BasicEnumeration;
import skyui.components.list.ScrollingList;

import com.greensock.TweenLite;
import com.greensock.OverwriteManager;
import com.greensock.easing.Linear;

class PresetEditor extends MovieClip
{
	public var bottomBar: BottomBar;
	public var navPanel: ButtonPanel;
	public var itemList: PresetList;
	
	private var presetPanel: MovieClip;
	
	private var ITEMLIST_HIDDEN_X = -478;
	private var BOTTOMBAR_SHOWN_Y = 645;
	private var BOTTOMBAR_HIDDEN_Y = 745;
	private var _panelX;
		
	public var Lock: Function;
		
	/* CONTROLS */
	private var _platform: Number;
	private var _acceptControl: Object;
	private var _activateControl: Object;
	private var _cancelControl: Object;
		
	
	function PresetEditor()
	{
		super();

		Mouse.addListener(this);
		EventDispatcher.initialize(this);
		
		navPanel = bottomBar.buttonPanel;
		itemList = presetPanel.itemList;
		itemList.disableSelection = itemList.disableInput = false;
				
		bottomBar._y = BOTTOMBAR_HIDDEN_Y;
	}
	
	function onLoad()
	{
		super.onLoad();		
		bottomBar.hidePlayerInfo();
	}
	
	function InitExtensions()
	{
		presetPanel.Lock("L");
		_panelX = presetPanel._x;
		presetPanel._x = ITEMLIST_HIDDEN_X;
		
		itemList.listEnumeration = new BasicEnumeration(itemList.entryList);
		for(var i = 0; i < 50; i++) {
			var slider = {type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Test Item" + i, filterFlag: 4, callbackName: "", sliderMin: 0, sliderMax: 50, sliderID: -1, position: i, interval: 1, enabled: true, sliderEnabled: false};
			slider.hasColor = function() : Boolean
			{
				return true;
			}
			slider.isColorEnabled = function(): Boolean
			{
				return true;
			}
			slider.hasGlow = function(): Boolean
			{
				return true;
			}
			itemList.entryList.push(slider);
		}
		itemList.requestInvalidate();
	}
	
	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		_platform = a_platform;
		bottomBar.setPlatform(a_platform, a_bPS3Switch);
		
		_activateControl = Input.Accept;
		
		if(_platform == 0) {
			_cancelControl = {name: "Tween Menu", context: Input.CONTEXT_GAMEPLAY};
		} else {
			_cancelControl = Input.Cancel;
		}
		
		_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};

		
		
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
	
	public function ShowPanel(bShowPanel: Boolean): Void
	{
		if(bShowPanel) {
			itemList.disableSelection = itemList.disableInput = false;
			TweenLite.to(presetPanel, 0.5, {autoAlpha: 100, _x: _panelX, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			itemList.disableSelection = itemList.disableInput = true;
			TweenLite.to(presetPanel, 0.5, {autoAlpha: 0, _x: ITEMLIST_HIDDEN_X, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function ShowAll(bShowAll: Boolean): Void
	{
		ShowPanel(bShowAll);
		ShowBottomBar(bShowAll);
		if(bShowAll) {
			TweenLite.to(this, 0.5, {autoAlpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(this, 0.5, {autoAlpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
		
		enabled = bShowAll;
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
		return false;
	}
}
