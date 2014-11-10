import gfx.events.EventDispatcher;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.managers.FocusHandler;

import Shared.GlobalFunc;

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
	private var _loadPresetControl: Object;
	private var _savePresetControl: Object;
		
	
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
		if(_global.skse.plugins.CharGen) {
			var entryObject: Object = {presetEditor: this, type: RaceMenuDefines.PRESET_ENTRY_TYPE_SLIDER, text: "$Preset Slot", filterFlag: 1, callbackName: "ChangePresetSlot", sliderMin: 0, sliderMax: _global.skse.plugins.CharGen.iNumPresets, sliderID: -1, position: _global.presetSlot, interval: 1, enabled: true};
			entryObject.internalCallback = function()
			{
				_global.presetSlot = this.position;
				this.entryObject.presetEditor.onReadPreset();
			}
			entryObject.sliderEnabled = true;
			entryObject.isColorEnabled = function(): Boolean { return false; }
			entryObject.hasColor = function(): Boolean { return false; }
			entryObject.hasGlow = function(): Boolean { return false; }
			entryObject.GetTextureList = function(raceMenu: Object): Array { return null; }
			itemList.entryList.push(entryObject);
		} else {
			var entryObject: Object = {type: RaceMenuDefines.PRESET_ENTRY_TYPE_TEXT, text: "CharGen Presets Unavailable", filterFlag: 1, enabled: true};
			itemList.entryList.push(entryObject);
		}
		
		onReadPreset();
		FocusHandler.instance.setFocus(itemList, 0);
		//itemList.requestInvalidate();
	}
	
	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		_platform = a_platform;
		bottomBar.setPlatform(a_platform, a_bPS3Switch);
		
		_activateControl = Input.Accept;
		
		if(_platform == 0) {
			_cancelControl = {name: "Tween Menu", context: Input.CONTEXT_GAMEPLAY};
			_savePresetControl = {keyCode: GlobalFunctions.getMappedKey("Quicksave", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_loadPresetControl = {keyCode: GlobalFunctions.getMappedKey("Quickload", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		} else {
			_cancelControl = Input.Cancel;
			_savePresetControl = {keyCode: GlobalFunctions.getMappedKey("Sneak", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_loadPresetControl = {keyCode: GlobalFunctions.getMappedKey("Toggle POV", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
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
		navPanel.addButton({text: "$Done", controls: _acceptControl}).addEventListener("click", _parent, "onDoneClicked");
		navPanel.addButton({text: "$Save Preset", controls: _savePresetControl}).addEventListener("click", this, "onSavePresetClicked");
		navPanel.addButton({text: "$Load Preset", controls: _loadPresetControl}).addEventListener("click", this, "onLoadPresetClicked");
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
		if (GlobalFunc.IsKeyPressed(details)) {
			if(IsBoundKeyPressed(details, _loadPresetControl, _platform) && !_parent.bTextEntryMode) {
				onLoadPresetClicked();
				return true;
			} else if(IsBoundKeyPressed(details, _savePresetControl, _platform) && !_parent.bTextEntryMode) {
				onSavePresetClicked();
				return true;
			}
		}
		
		if(itemList.handleInput(details, pathToFocus)) {
			return true;
		}
		
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
	
	public function onReadPreset(): Void
	{
		itemList.entryList.splice(1, itemList.entryList.length - 1);
		var filePath: String = "Data\\SKSE\\Plugins\\CharGen\\Presets\\" + _global.presetSlot + ".jslot";
		var preset: Object = new Object;
		
		var loadError: Boolean = _global.skse.plugins.CharGen.ReadPreset(filePath, preset, true);
		if(loadError) {
			filePath = "Data\\SKSE\\Plugins\\CharGen\\Presets\\" + _global.presetSlot + ".slot";
			loadError = _global.skse.plugins.CharGen.ReadPreset(filePath, preset, false);
		}
					
		if(!loadError) {			
			itemList.entryList.push({type: RaceMenuDefines.PRESET_ENTRY_TYPE_HEADER, text: "$Mods", filterFlag: 1, enabled: true});
			
			for(var i = 0; i < preset.mods.length; i++) {
				var mod = preset.mods[i];
				var textColor: Number = 0x189515;
				if(mod.loadedIndex == 255) {
					textColor = 0xFF0000;
				}
				
				itemList.entryList.push({type: RaceMenuDefines.PRESET_ENTRY_TYPE_TEXT, text: mod.name, filterFlag: 1, textFieldColor: textColor, enabled: true});
			}
			
			itemList.entryList.push({type: RaceMenuDefines.PRESET_ENTRY_TYPE_HEADER, text: "$Head Parts", filterFlag: 1, enabled: true});
			
			for(var i = 0; i < preset.headParts.length; i++) {
				itemList.entryList.push({type: RaceMenuDefines.PRESET_ENTRY_TYPE_TEXT, text: preset.headParts[i], filterFlag: 1, enabled: true});
			}
			
			itemList.entryList.push({type: RaceMenuDefines.PRESET_ENTRY_TYPE_HEADER, text: "$Colors", filterFlag: 1, enabled: true});
			
			var hairColor: Object = {type: RaceMenuDefines.PRESET_ENTRY_TYPE_COLOR, text: preset.hair.name, fillColor: (0xFF000000 | preset.hair.value), filterFlag: 1, enabled: true};
			hairColor.isColorEnabled = function(): Boolean { return true; }
			hairColor.hasColor = function(): Boolean { return true; }
			hairColor.hasGlow = function(): Boolean { return false; }
			itemList.entryList.push(hairColor);
			
			for(var i = 0; i < preset.tints.length; i++) {
				var tint = preset.tints[i];
				if((tint.color >>> 24) > 0) {
					var tintEntry: Object = {type: RaceMenuDefines.PRESET_ENTRY_TYPE_COLOR, text: stripTexturePath(tint.texture), fillColor: tint.color, filterFlag: 1, enabled: true};
					tintEntry.isColorEnabled = function(): Boolean { return true; }
					tintEntry.hasColor = function(): Boolean { return true; }
					tintEntry.hasGlow = function(): Boolean { return false; }
					itemList.entryList.push(tintEntry);
				}
			}
			
			itemList.entryList.push({type: RaceMenuDefines.PRESET_ENTRY_TYPE_HEADER, text: "$Sliders", filterFlag: 1, enabled: true});
			
			itemList.entryList.push({type: RaceMenuDefines.PRESET_ENTRY_TYPE_TEXT_VALUE, text: preset.weight.name, position: preset.weight.value, filterFlag: 1, enabled: true});
			
			for(var i = 0; i < preset.morphs.length; i++) {
				var morph = preset.morphs[i];
				if(morph.name)
					itemList.entryList.push({type: RaceMenuDefines.PRESET_ENTRY_TYPE_TEXT_VALUE, text: morph.name, position: morph.value, filterFlag: 1, enabled: true});
			}
		}
		
		itemList.InvalidateData();
	}
	
	private function stripTexturePath(a_texture: String): String
	{
		// Strip Path and extension
		var slashIndex: Number = -1;
		for(var k = a_texture.length - 1; k > 0; k--) {
			if(a_texture.charAt(k) == "\\" || a_texture.charAt(k) == "/") {
				slashIndex = k;
				break;
			}
		}
		var formatIndex: Number = a_texture.indexOf(".dds");
		if(formatIndex == -1)
			formatIndex = a_texture.length;
		
		return a_texture.substring(slashIndex + 1, formatIndex);
	}
	
	private function onSavePresetClicked(): Void
	{
		if(!_global.skse.plugins.CharGen) {
			skse.SendModEvent(_global.eventPrefix + "RequestSaveClipboard");
			_parent.setDisplayText("$Saved preset to clipboard");
		} else {
			_parent.setDisplayText("$Saved preset to slot {" + _global.presetSlot + "}");
			var filePath: String = "Data\\SKSE\\Plugins\\CharGen\\Presets\\" + _global.presetSlot + ".jslot";
			_global.skse.plugins.CharGen.SavePreset(filePath, true);
			onReadPreset();
		}
	}
	
	private function onLoadPresetClicked(): Void
	{
		if(!_global.skse.plugins.CharGen) {
			skse.SendModEvent(_global.eventPrefix + "RequestLoadClipboard");
		} else {
			var filePath: String = "Data\\SKSE\\Plugins\\CharGen\\Presets\\" + _global.presetSlot + ".jslot";
			var dataObject: Object = new Object();
			_parent.loadingIcon._visible = true;
			
			var loadError: Boolean = _global.skse.plugins.CharGen.LoadPreset(filePath, dataObject, true);
			if(loadError) {
				filePath = "Data\\SKSE\\Plugins\\CharGen\\Presets\\" + _global.presetSlot + ".slot";
				loadError = _global.skse.plugins.CharGen.LoadPreset(filePath, dataObject, false);
			}
					
			if(!loadError) {
				skse.SendModEvent(_global.eventPrefix + "RequestTintSave");
				_parent.requestSliderUpdate(dataObject);
			} else {
				_parent.setDisplayText("$Failed to load preset from slot {" + _global.presetSlot + "}");
				_parent.loadingIcon._visible = false;
			}
		}
	}
}
