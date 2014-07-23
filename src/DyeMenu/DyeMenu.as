import gfx.events.EventDispatcher;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.io.GameDelegate;

import Shared.GlobalFunc;

import com.greensock.OverwriteManager;
import com.greensock.easing.Linear;
import com.greensock.TweenMin;

import skyui.util.GlobalFunctions;
import skyui.defines.Input;
import skyui.components.list.BasicEnumeration;
import skyui.components.list.ScrollingList;
import skyui.components.ButtonPanel;

class DyeMenu extends MovieClip
{
	// Movie components
	public var itemView: ItemView;
	public var dyeView: DyeView;
	public var itemList: ItemList;
	public var dyeList: DyeList;
	public var bottomBar: BottomBar;
	public var navPanel: ButtonPanel;
	public var colorField: ColorField;
	
	// Papyrus accessible vars
	public var iMaxBlend: Number = 3;
	public var bConsumeItems: Boolean = true;
	
	// Private vars
	private var _dyeViewX: Number = 0;
	private var _formId: Number = 0;
	private var _savedColor: Number = 0;
			
	private var _updateInterval: Number;
	private var _pendingData: Object = null;
	
	// Controls
	private var _selectColorControl: Object;
	private var _dyeControl: Object;
	private var _acceptControl: Object;
	private var _cancelControl: Object;
		
	public function DyeMenu()
	{
		super();
		GlobalFunc.MaintainTextFormat();
		GlobalFunc.SetLockFunction();
		
		navPanel = bottomBar.buttonPanel;
		
		itemList = itemView.itemList;
		dyeList = dyeView.itemList;		
		dyeView._x = 0;
		dyeView._visible = dyeView.enabled = false;
		dyeList.disableSelection = dyeList.disableInput = true;
		colorField._visible = colorField.enabled = false;
						
		Mouse.addListener(this);
		EventDispatcher.initialize(this);
	}
	
	public function onLoad()
	{
		super.onLoad();
		
		dyeView.maxCount = iMaxBlend;
		dyeView.consume = bConsumeItems;
				
		bottomBar.hidePlayerInfo();
				
		itemList.addEventListener("selectionChange", this, "onSelectionChange");
		itemList.addEventListener("itemPress", this, "onItemPressed");
		itemView.addEventListener("layerPressed", this, "onLayerPressed");
		
		colorField.addEventListener("changeColor", this, "onChangeColor");
		colorField.addEventListener("saveColor", this, "onSaveColor");
		
		dyeView.addEventListener("applyColor", this, "onApplyDyeColor");
		dyeView.addEventListener("changeColor", this, "onChangeDyeColor");
		
		itemView.addEventListener("selectionChange", this, "onEntrySelectionChange");
		dyeList.addEventListener("selectionChange", this, "onDyeSelectionChange");
		
		dyeList.addEventListener("itemPress", this, "onDyePressed");
		dyeList.addEventListener("itemPressAux", this, "onDyeAuxPressed");
		
		/*for(var i = 0; i < 25; i++) {
			var entry: Object = {text: "Item"+i, enabled: true, colors: [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0], internalObject: undefined};
			itemList.entryList.push(entry);
		}
		itemList.requestInvalidate();
		
		var entry: Object = {text: "Rainbow Item", enabled: true, formId: 1, count: 1, fillColor: Math.floor(Math.random()*(1+0xFFFFFFFF-0xFF000000))+0xFF000000, colorized: true};
			dyeList.entryList.push(entry);
		
		for(var i = 0; i < 25; i++) {
			var entry: Object = {text: "Dye Item"+i, enabled: true, formId: 1, count: 5, fillColor: Math.floor(Math.random()*(1+0xFFFFFFFF-0xFF000000))+0xFF000000};
			dyeList.entryList.push(entry);
		}*/
		
		itemList.requestInvalidate();
		dyeList.requestInvalidate();
		FocusHandler.instance.setFocus(itemList, 0);
		
		//SetPlatform(0, false);
	}
	
	public function InitExtensions(): Void
	{
		itemView.Lock("L");
		_dyeViewX = itemView._x;
		dyeView._x = _dyeViewX;
		
		skse.SendModEvent("UIDyeMenu_LoadMenu");
	}
	
	public function SetPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		dyeView.setPlatform(a_platform, a_bPS3Switch);
		colorField.setPlatform(a_platform, a_bPS3Switch);
		bottomBar.setPlatform(a_platform, a_bPS3Switch);
		colorField.SetupButtons();
		
		if(a_platform == 0) {
			_acceptControl = Input.Accept;
			_cancelControl = {name: "Tween Menu", context: Input.CONTEXT_GAMEPLAY};
			_dyeControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_selectColorControl = Input.Wait;
		} else {
			_acceptControl = Input.Accept;
			_cancelControl = Input.Cancel;
			_dyeControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_selectColorControl = Input.YButton;
		}
		
		var leftEdge = Stage.visibleRect.x + Stage.safeRect.x;
		var rightEdge = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
		bottomBar.positionElements(leftEdge, rightEdge);
		updateBottomBar();
	}
	
	private function updateBottomBar(): Void
	{
		navPanel.clearButtons();
		
		if(!itemList.listState.focusEntry)
			navPanel.addButton({text: "$Select Item", controls: _acceptControl});
		else if(itemView.selectedLayer && (!itemView.focusedLayer || itemView.focusedLayer != itemView.selectedLayer))
			navPanel.addButton({text: "$Select Layer", controls: _acceptControl});
		else if(itemView.focusedLayer) {
			navPanel.addButton({text: "$Dye", controls: _dyeControl});
			navPanel.addButton({text: "$Select Dye", controls: _acceptControl});
		}
		
		if(itemList.listState.focusEntry)
			navPanel.addButton({text: "$Cancel", controls: _cancelControl});
		else
			navPanel.addButton({text: "$Exit", controls: _cancelControl});

		
		var dyeItem: Object = dyeList.listState.selectedEntry;
		if(dyeItem.colorized)
			navPanel.addButton({text: "$Choose Color", controls: _selectColorControl});
		
		navPanel.updateButtons(true);
	}
		
	private function closeMenu(): Void
	{
		skse.SendModEvent("UIDyeMenu_CloseMenu");
		//GameDelegate.call("buttonPress", [option]);
		skse.CloseMenu("CustomMenu");
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if(colorField.enabled) {
			return colorField.handleInput(details, pathToFocus);
		}
		if(itemView.handleInput(details, pathToFocus)) {
			return true;
		}
		if(dyeView.handleInput(details, pathToFocus)) {
			return true;
		}
		
		var nextClip = pathToFocus.shift();
		if (nextClip.handleInput(details, pathToFocus))
			return true;
			
		if (GlobalFunc.IsKeyPressed(details)) {
			if(details.navEquivalent == NavigationCode.TAB) {
				if(itemView.itemList.listState.focusEntry) {
					setFocusEntry(undefined);
				} else {
					closeMenu();
				}
			}
		}
		return true;
	}
	
	public function ShowColorField(bShowField: Boolean, initParams: Object): Void
	{
		colorField._visible = colorField.enabled = bShowField;
		colorField.ResetSlider();
		if(bShowField) {
			colorField.initParams = initParams;
			colorField.updateButtons(true);
			FocusHandler.instance.setFocus(colorField.colorSelector, 0);
		} else {
			FocusHandler.instance.setFocus(dyeList, 0);
		}
	}
	
	public function ShowDyePanel(bShowPanel: Boolean): Void
	{
		if(bShowPanel) {
			dyeList.disableSelection = dyeList.disableInput = false;
			itemList.disableSelection = itemList.disableInput = true;
			TweenMin.to(dyeView, 0.5, {autoAlpha: 100, _x: _dyeViewX + itemView._width, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			itemList.disableSelection = itemList.disableInput = false;
			dyeList.disableSelection = dyeList.disableInput = true;
			TweenMin.to(dyeView, 0.5, {autoAlpha: 0, _x: _dyeViewX, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
		
		updateBottomBar();
	}
	
	private function onSelectionChange(event: Object): Void
	{
		var selectedEntry: Object = itemView.entryList[event.index];
		itemList.listState.selectedEntry = selectedEntry;
		itemView.setColorList(selectedEntry.colors);
		updateBottomBar();
	}
	
	private function onDyeSelectionChange(event: Object): Void
	{
		var selectedEntry: Object = dyeView.entryList[event.index];
		dyeList.listState.selectedEntry = selectedEntry;
		updateBottomBar();
	}
	
	private function onEntrySelectionChange(event: Object): Void
	{
		updateBottomBar();
	}
	
	private function onDyeAuxPressed(event: Object): Void
	{
		var pressedEntry: Object = dyeView.entryList[event.index];
		if(pressedEntry.colorized) {
			dyeView.itemList.disableSelection = true;
			colorField.setText(pressedEntry.text);
			colorField.setColor(pressedEntry.fillColor);
			ShowColorField(true, {entry: event.entry, mode: "tint", bCanSwitchMode: false, savedColor: _savedColor});
		}
	}
	
	private function onDyePressed(event: Object): Void
	{
		var pressedEntry: Object = dyeView.entryList[event.index];
		if(dyeView.activeCount >= dyeView.maxCount && !pressedEntry.active)
			return;
		
		if(pressedEntry.active)
			dyeView.deactivate(pressedEntry);
		else
			dyeView.activate(pressedEntry);
		
		dyeList.requestUpdate();
	}
	
	private function onItemPressed(event: Object): Void
	{
		var selectedEntry: Object = itemView.entryList[event.index];
		setFocusEntry(selectedEntry);
		itemView.setColorList(selectedEntry.colors);
	}
	
	public function setFocusEntry(entry: Object)
	{
		if(!entry) {
			var listEntry = itemList.listState.focusEntry;
			var layerId: Number = itemView.focusedLayer.id;
			var color: Number = listEntry.colors[layerId];
			requestUpdate({formId: _formId, object: listEntry.internalObject, maskIndex: layerId, maskColor: color});
		}
		
		itemList.listState.focusEntry = entry;
		itemList.requestUpdate();
		itemList.disableSelection = itemList.disableInput = entry ? true : false;
		
		if(!entry) {
			itemView.setLayerFocused(-1);
			itemView.setLayerSelected(-1);
			dyeList.invalidateSelection();
			ShowDyePanel(false);
		} else {
			itemView.setLayerSelected(0);
			itemView.setLayerFocused(0);
			ShowDyePanel(true);
		}
	}
	
	private function onChangeColor(event: Object): Void
	{
		var listEntry = itemList.listState.focusEntry;
		if(listEntry) {
			event.entry.fillColor = event.color;
			dyeList.requestUpdate();
			dyeView.calculateResult(true);
		}
		
		if(event.closeField) {
			dyeList.disableSelection = false;
			ShowColorField(false);
		}
	}
	
	private function onApplyDyeColor(event: Object): Void
	{
		var listEntry = itemList.listState.focusEntry;
		if(listEntry) {
			if(event.color == 0)
				event.color = null;
				
			if(event.color != null) {
				dyeView.consumeItems();
			}
			
			var layerId = itemView.focusedLayer.id;
			itemView.focusedLayer.setColor(event.color);
			listEntry.colors[layerId] = event.color;
			
			requestUpdate({formId: _formId, object: listEntry.internalObject, maskIndex: layerId, maskColor: event.color});
		}
	}
	
	private function onChangeDyeColor(event: Object): Void
	{
		var listEntry = itemList.listState.focusEntry;
		if(listEntry) {
			if(event.color == 0)
				event.color = null;

			var layerId = itemView.focusedLayer.id;
			requestUpdate({formId: _formId, object: listEntry.internalObject, maskIndex: layerId, maskColor: event.color});
		}
	}
	
	public function requestUpdate(pendingData: Object)
	{
		_pendingData = pendingData;
		if(!_updateInterval) {
			_updateInterval = setInterval(this, "processDataUpdate", 100);
		}
	}
	
	public function processDataUpdate()
	{
		if(_global.skse.plugins.NiOverride.SetItemDyeColor) {
			_global.skse.plugins.NiOverride.SetItemDyeColor(_pendingData.formId, _pendingData.object, _pendingData.maskIndex, _pendingData.maskColor);
		}
		
		_pendingData = null;
		clearInterval(_updateInterval);
		delete _updateInterval;
	}
	
	private function onLayerPressed(event: Object): Void
	{
		var listEntry = itemList.listState.focusEntry;
		if(listEntry) {
			itemView.setLayerFocused(event.entry.id);
		}
		
		updateBottomBar();
	}
	
	private function onSaveColor(event: Object): Void
	{
		_savedColor = event.color;
	}
	
	// Papyrus Functions
	public function setItemSourceForm(a_object: Object): Void
	{
		if(a_object == undefined || a_object.formId == undefined)
			return;
			
		if(!_global.skse.plugins.NiOverride.GetDyeableItems)
			return;
			
		_formId = a_object.formId;
			
		var inventory: Array = _global.skse.plugins.NiOverride.GetDyeableItems(_formId);
		for(var i = 0; i < inventory.length; i++) {
			var entry: Object = {text: inventory[i].name, enabled: true, colors: inventory[i].colors, internalObject: inventory[i]};
			itemList.entryList.push(entry);
		}
		
		itemList.requestInvalidate();
		FocusHandler.instance.setFocus(itemList, 0);
	}
	
	public function setDyeSourceForm(a_object: Object): Void
	{
		if(a_object == undefined || a_object.formId == undefined)
			return;
			
		var inventory: Array = _global.skse.plugins.NiOverride.GetDyeItems(_formId);
		for(var i = 0; i < inventory.length; i++) {
			var entry: Object = {text: inventory[i].name, enabled: true, formId: inventory[i].formId, count: inventory[i].count, fillColor: inventory[i].color, colorized: (inventory[i].color == 0x00FFFFFF ? true : false)};
			dyeList.entryList.push(entry);
		}
		
		dyeList.requestInvalidate();
	}
	
	public function setConsumeItems(a_consume: Boolean): Void
	{
		bConsumeItems = a_consume;
		dyeView.consume = bConsumeItems;
	}
	
	public function setMaxBlending(a_blending: Number): Void
	{
		iMaxBlend = a_blending;
		dyeView.maxCount = iMaxBlend;
		dyeList.requestUpdate();
	}
}
