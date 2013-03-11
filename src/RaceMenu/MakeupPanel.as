import gfx.events.EventDispatcher;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;
import Shared.GlobalFunc;
import gfx.io.GameDelegate;

import skyui.components.SearchWidget;
import skyui.components.list.FilteredEnumeration;
import skyui.components.list.ScrollingList;
import skyui.components.ButtonPanel;
import skyui.filter.SortFilter;
import skyui.filter.NameFilter;
import skyui.defines.Input;
import skyui.util.GlobalFunctions;

class MakeupPanel extends MovieClip
{
	public var buttonPanel: ButtonPanel;
	public var makeupList: MakeupList;
	public var searchWidget: SearchWidget;
	public var bTextEntryMode: Boolean = false;
	
	private var _acceptButton: Object;
	private var _cancelButton: Object;
	
	private var _sortFilter: SortFilter;
	private var _nameFilter: NameFilter;
	
	private var _platform: Number;
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
		
		_sortFilter = new SortFilter();
		_nameFilter = new NameFilter();
		
		GlobalFunc.MaintainTextFormat();
		GlobalFunc.SetLockFunction();
		
		EventDispatcher.initialize(this);
	}
	
	private function onLoad()
	{
		super.onLoad();

		var listEnumeration = new FilteredEnumeration(makeupList.entryList);
		listEnumeration.addFilter(_sortFilter);
		listEnumeration.addFilter(_nameFilter);
		makeupList.listEnumeration = listEnumeration;
		
		_sortFilter.setSortBy(["text"], [0]);
		_sortFilter.addEventListener("filterChange", this, "onFilterChange");
		_nameFilter.addEventListener("filterChange", this, "onFilterChange");
		
		makeupList.addEventListener("itemPress", this, "onItemPress");
		makeupList.addEventListener("selectionChange", this, "onSelectionChanged");
		
		searchWidget.addEventListener("inputStart", this, "onSearchInputStart");
		searchWidget.addEventListener("inputEnd", this, "onSearchInputEnd");
		searchWidget.addEventListener("inputChange", this, "onSearchInputChange");
		searchWidget.gotoAndStop("Double");
		
		// Test Code
		/*for(var i = 0; i < 50; i++) {
			AddMakeup("Texture" + i, "Actor\\Texture_" + i + ".dds");
		}
		InvalidateList();*/
	}
	
	private function onSearchInputStart(event: Object): Void
	{
		bTextEntryMode = true;
		makeupList.disableSelection = makeupList.disableInput = true;
		_nameFilter.filterText = "";
	}

	private function onSearchInputChange(event: Object)
	{
		_nameFilter.filterText = event.data;
	}

	private function onSearchInputEnd(event: Object)
	{
		makeupList.disableSelection = makeupList.disableInput = false;
		_nameFilter.filterText = event.data;
		bTextEntryMode = false;
	}
	
	private function onFilterChange(): Void
	{
		makeupList.requestInvalidate();
	}
	
	public function clearFilter(): Void
	{
		searchWidget.endInput();
		_nameFilter.filterText = "";
	}
	
	public function InvalidateList(): Void
	{
		makeupList.InvalidateData();
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
		if (GlobalFunc.IsKeyPressed(details) && !bTextEntryMode) {
			if(details.navEquivalent == NavigationCode.ENTER || details.skseKeycode == GlobalFunctions.getMappedKey("Activate", Input.CONTEXT_GAMEPLAY, _platform != 0)) {
				onAccept();
				bHandledInput = true;
			} else if(details.navEquivalent == NavigationCode.TAB || details.skseKeycode == GlobalFunctions.getMappedKey("Cancel", Input.CONTEXT_GAMEPLAY, _platform != 0)) {
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
	
	public function updateButtons(bInstant: Boolean)
	{
		buttonPanel.updateButtons(bInstant);
	}
	
	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		_platform = a_platform;
		if(a_platform == 0) {
			_acceptButton = Input.Accept;
			_cancelButton = {name: "Tween Menu", context: Input.CONTEXT_GAMEPLAY};
		} else {
			_acceptButton = Input.Accept;
			_cancelButton = Input.Cancel;
		}
		buttonPanel.setPlatform(a_platform, a_bPS3Switch);
	}
	
	public function setSelectedEntry(a_texture: String): Void
	{
		for(var i = 0; i < makeupList.entryList.length; i++) {
			if(makeupList.entryList[i].texture == a_texture) {
				makeupList.selectedIndex = i;
				break;
			}
		}
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
			dispatchEvent({type: "changeTexture", texture: entryObject.texture, displayText: entryObject.displayText, apply: true});
		}
	}
	
	public function onAccept(): Void
	{
		var selectedEntry = makeupList.listState.selectedEntry;
		if(selectedEntry) {
			dispatchEvent({type: "changeTexture", texture: selectedEntry.texture, displayText: selectedEntry.displayText, apply: true});
		}
	}

	public function onCancel(): Void
	{
		dispatchEvent({type: "changeTexture", texture: _currentTexture, displayText: _currentDisplayText, apply: true});
	}
	
	public function onSelectionChanged(event: Object): Void
	{
		makeupList.listState.selectedEntry = makeupList.entryList[event.index];
		if(makeupList.listState.selectedEntry) {
			dispatchEvent({type: "changeTexture", texture: makeupList.listState.selectedEntry.texture, displayText: makeupList.listState.selectedEntry.displayText, apply: false});
		}
		GameDelegate.call("PlaySound",["UIMenuFocus"]);
	}
}
