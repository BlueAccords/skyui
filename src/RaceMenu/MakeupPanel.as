import gfx.events.EventDispatcher;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;
import Shared.GlobalFunc;
import gfx.io.GameDelegate;

import skyui.components.list.FilteredEnumeration;
import skyui.components.list.ScrollingList;

import skyui.components.ButtonPanel;

import skyui.filter.ItemSorter;

class MakeupPanel extends MovieClip
{
	public var buttonPanel: ButtonPanel;
	public var makeupList: ScrollingList;
	private var _acceptButton: Object;
	private var _cancelButton: Object;
	private var _sortFilter: ItemSorter;
	
	private var _currentTexture: String;
	private var _currentDisplayText: String;
	
	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;
	
	function MakeupPanel()
	{
		super();
		
		_sortFilter = new ItemSorter();
		
		GlobalFunc.MaintainTextFormat();
		GlobalFunc.SetLockFunction();
		
		EventDispatcher.initialize(this);
	}
	
	private function onLoad()
	{
		super.onLoad();

		var listEnumeration = new FilteredEnumeration(makeupList.entryList);
		listEnumeration.addFilter(_sortFilter);
		makeupList.listEnumeration = listEnumeration;
		
		_sortFilter.setSortBy(["text"], [0]);
		_sortFilter.addEventListener("filterChange", this, "onFilterChange");
		
		makeupList.addEventListener("itemPress", this, "onItemPress");
		makeupList.addEventListener("selectionChange", this, "onSelectionChanged");
	}
	
	public function onFilterChange(): Void
	{
		makeupList.requestInvalidate();
	}
	
	public function UpdateList(): Void
	{
		makeupList.requestInvalidate();
	}
		
	public function AddMakeup(a_name: String, a_texture: String)
	{
		var makeupObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_MAKEUP, text: a_name, texture: a_texture, filterFlag: 1, enabled: true};
						
		// Strip Path and extension
		var slashIndex: Number = -1;
		for(var k = a_texture.length - 1; k > 0; k--) {
			if(a_texture.charAt(k) == "\\" || a_texture.charAt(k) == "/") {
				slashIndex = k;
				break;
			}
		}
		var formatIndex: Number = a_texture.lastIndexOf(".dds");
		if(formatIndex == -1)
			formatIndex = a_texture.length;
		
		var displayText: String = a_texture.substring(slashIndex + 1, formatIndex);
		makeupObject.displayText = displayText;
		makeupList.entryList.push(makeupObject);
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details)) {
			if(details.navEquivalent == NavigationCode.ENTER) {
				onAccept();
				bHandledInput = true;
			} else if(details.navEquivalent == NavigationCode.TAB) {
				onCancel();
				bHandledInput = true;
			}
		}
		
		if(!bHandledInput) {
			var nextClip = pathToFocus.shift();
			bHandledInput = nextClip.handleInput(details, pathToFocus);
		}

		return bHandledInput;
	}
	
	public function SetupButtons(): Void
	{
		buttonPanel.clearButtons();
		var acceptButton: MovieClip = buttonPanel.addButton({text: "$Accept", controls: _acceptButton});
		var cancelButton: MovieClip = buttonPanel.addButton({text: "$Cancel", controls: _cancelButton});
		acceptButton.addEventListener("click", this, "onAccept");
		cancelButton.addEventListener("click", this, "onCancel");
		buttonPanel.updateButtons(true);
	}
	
	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		if(a_platform == 0) {
			_acceptButton = InputDefines.Accept;
			_cancelButton = InputDefines.Tab;
		} else {
			_acceptButton = InputDefines.Accept;
			_cancelButton = InputDefines.Cancel;
		}
		buttonPanel.setPlatform(a_platform, a_bPS3Switch);
	}
	
	public function setTexture(a_displayText:String, a_texture: String): Void
	{
		_currentDisplayText = a_displayText;
		_currentTexture = a_texture;
	}
	
	public function onItemPress(event: Object): Void
	{
		var entryObject: Object = makeupList.entryList[event.index];
		if(entryObject) {
			dispatchEvent({type: "setTexture", texture: entryObject.texture, displayText: entryObject.displayText});
		}
	}
	
	public function onAccept(): Void
	{
		var selectedEntry = makeupList.listState.selectedEntry;
		if(selectedEntry) {
			dispatchEvent({type: "setTexture", texture: selectedEntry.texture, displayText: selectedEntry.displayText});
		}
	}

	public function onCancel(): Void
	{
		dispatchEvent({type: "setTexture", texture: _currentTexture, displayText: _currentDisplayText});
	}
	
	public function onSelectionChanged(event: Object): Void
	{
		makeupList.listState.selectedEntry = makeupList.entryList[event.index];
		if(makeupList.listState.selectedEntry) {
			dispatchEvent({type: "changeTexture", texture: makeupList.listState.selectedEntry.texture, displayText: makeupList.listState.selectedEntry.displayText});
		}
		GameDelegate.call("PlaySound",["UIMenuFocus"]);
	}
}
