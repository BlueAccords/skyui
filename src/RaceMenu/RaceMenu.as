import gfx.events.EventDispatcher;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.io.GameDelegate;
import Shared.GlobalFunc;

import skyui.components.SearchWidget;
import skyui.components.list.FilteredEnumeration;
import skyui.components.list.BasicEnumeration;
import skyui.components.list.ScrollingList;
import skyui.components.ButtonPanel;

import skyui.filter.ItemTypeFilter;
import skyui.filter.ItemNameFilter;

import RaceMenuDefines;
import TextEntryField;

class RaceMenu extends MovieClip
{
	/* PRIVATE VARIABLES */
	private var _platform: Number;
	private var _typeFilter: ItemTypeFilter;
	private var _nameFilter: ItemNameFilter;
	private var _playerObject: Object;
	
	/* PUBLIC VARIABLES */
	public var bLimitedMenu: Boolean;
	public var bShowTextEntry: Boolean = false;
	public var playerZoom: Boolean = true;
	
	/* STAGE ELEMENTS */
	public var racePanel: MovieClip;
	public var itemList: ScrollingList;
	public var categoryList: CategoryList;
	public var categoryLabel: TextField;
	public var searchWidget: SearchWidget;
	public var bottomBar: BottomBar;
	public var navPanel: ButtonPanel;
	public var textEntry: TextEntryField;
	public var loadingIcon: MovieClip;
	
	/* GFx Dispatcher Functions */
	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;
	
	public var KEY_CODE_DONE: Number = 19;
		
	function RaceMenu()
	{
		super();
		
		itemList = racePanel.itemList;
		categoryList = racePanel.categoryList;
		categoryLabel = racePanel.categoryLabel;
		searchWidget = racePanel.searchWidget;
		navPanel = bottomBar.buttonPanel;
		
		loadingIcon._visible = false;
		textEntry._visible = false;
		textEntry.enabled = false;
		
		GlobalFunc.MaintainTextFormat();
		GlobalFunc.SetLockFunction();
		
		EventDispatcher.initialize(this);
		
		_typeFilter = new ItemTypeFilter();
		_nameFilter = new ItemNameFilter();
		
		GameDelegate.addCallBack("SetCategoriesList", this, "SetCategoriesList");
		GameDelegate.addCallBack("ShowTextEntry", this, "ShowTextEntry");
		GameDelegate.addCallBack("SetNameText", this, "SetNameText");
		GameDelegate.addCallBack("SetRaceText", this, "SetRaceText");
		GameDelegate.addCallBack("SetRaceList", this, "SetRaceList");
		GameDelegate.addCallBack("SetOptionSliders", this, "SetSliders");
		GameDelegate.addCallBack("ShowTextEntryField", this, "ShowTextEntryField");
		GameDelegate.addCallBack("HideLoadingIcon", this, "HideLoadingIcon");
	}
	
	private function onLoad()
	{
		super.onLoad();
				
		bottomBar.hidePlayerInfo();
		var pInfo = bottomBar.attachMovie("PlayerInfo", "playerInfo", bottomBar.getNextHighestDepth());
		pInfo._y = 25;
		
		categoryList.listEnumeration = new BasicEnumeration(categoryList.entryList);
		
		var listEnumeration = new FilteredEnumeration(itemList.entryList);
		listEnumeration.addFilter(_typeFilter);
		listEnumeration.addFilter(_nameFilter);
		itemList.listEnumeration = listEnumeration;
		
		_typeFilter.addEventListener("filterChange", this, "onFilterChange");
		_nameFilter.addEventListener("filterChange", this, "onFilterChange");
		
		itemList.addEventListener("itemPress", this, "onItemPress");
		itemList.addEventListener("selectionChange", this, "onSelectionChange");
		categoryList.addEventListener("itemPress", this, "onCategoryPress");
		
		searchWidget.addEventListener("inputStart", this, "onSearchInputStart");
		searchWidget.addEventListener("inputEnd", this, "onSearchInputEnd");
		searchWidget.addEventListener("inputChange", this, "onSearchInputChange");
		
		textEntry.addEventListener("nameChange", this, "onNameChange");
		
		categoryList.iconArt = ["skyrim", "race", "body", "head", "face", "eyes", "brow", "mouth", "hair", "palette"];
		categoryList.listState.iconSource = "skyui/racesex_icons.swf";
		
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: true, filterFlag: 1, text: "$ALL", flag: 508, savedItemIndex: -1, enabled: true});
		
		// Test Code
		/*categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "RACE", flag: RaceMenuDefines.CATEGORY_RACE, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "BODY", flag: RaceMenuDefines.CATEGORY_BODY, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "HEAD", flag: RaceMenuDefines.CATEGORY_HEAD, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "FACE", flag: RaceMenuDefines.CATEGORY_FACE, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "EYES", flag: RaceMenuDefines.CATEGORY_EYES, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "BROW", flag: RaceMenuDefines.CATEGORY_BROW, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "MOUTH", flag: RaceMenuDefines.CATEGORY_MOUTH, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "HAIR", flag: RaceMenuDefines.CATEGORY_HAIR, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$COLORS", flag: RaceMenuDefines.CATEGORY_COLOR, savedItemIndex: -1, enabled: true});
		categoryList.requestInvalidate();
		categoryList.onItemPress(0, 0);
		
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Argonian", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 0, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Breton", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Dark Elf", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 2, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "High Elf", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 3, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Imperial", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 4, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Khajiit", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 5, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Nord", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 6, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Orc", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 7, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Redguard", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 8, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Wood Elf", filterFlag: RaceMenuDefines.CATEGORY_RACE, equipState: 0, raceID: 9, enabled: true});
		
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Sex", filterFlag: 4, callbackName: "ChangeSex", sliderMin: 0, sliderMax: 1, sliderID: -1, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Presets", filterFlag: 4, callbackName: "ChangeHeadPreset", sliderMin: 0, sliderMax: 0, sliderID: 0, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Skin Tone", filterFlag: 4 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 2892, sliderID: 1, position: 2885, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Weight", filterFlag: 4, callbackName: "ChangeWeight", sliderMin: 0, sliderMax: 1, sliderID: 2, position: 0, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Complexion", filterFlag: 8, callbackName: "ChangeFaceDetails", sliderMin: 0, sliderMax: 5, sliderID: 3, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Dirt", filterFlag: 8, callbackName: "ChangeMask", sliderMin: -1, sliderMax: 2, sliderID: 4, position: -1, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Dirt Color", filterFlag: 8 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeMaskColor", sliderMin: 1, sliderMax: 4, sliderID: 5, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Scars", filterFlag: 8, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 12, sliderID: 6, position: 7, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "War Paint", filterFlag: 8, callbackName: "ChangeMask", sliderMin: -1, sliderMax: 14, sliderID: 7, position: -1, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "War Paint Color", filterFlag: 8 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeMaskColor", sliderMin: 1, sliderMax: 23, sliderID: 8, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Hair", filterFlag: 256, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 69, sliderID: 9, position: 10, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Facial Hair", filterFlag: 256, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 45, sliderID: 10, position: 41, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Hair Color", filterFlag: 256 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeHairColorPreset", sliderMin: 0, sliderMax: 6594, sliderID: 11, position: 6578, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Shape", filterFlag: 32, callbackName: "ChangePreset", sliderMin: 0, sliderMax: 37, sliderID: 12, position: 1, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Color", filterFlag: 32, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 1, sliderID: 13, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Height", filterFlag: 32, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 14, position: 0.5, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Width", filterFlag: 32, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 15, position: -0.059999998658895, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Depth", filterFlag: 32, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 16, position: -0.63999998569489, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eyeliner Color", filterFlag: 32 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 3, sliderID: 17, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Shadow", filterFlag: 32 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 7, sliderID: 18, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Tint", filterFlag: 32 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 7, sliderID: 19, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Brow Type", filterFlag: 64, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 11, sliderID: 20, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Brow Height", filterFlag: 64, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 21, position: -1, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Brow Width", filterFlag: 64, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 22, position: -0.10000000149012, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Brow Forward", filterFlag: 64, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 23, position: -0.10000000149012, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Nose Type", filterFlag: 16, callbackName: "ChangePreset", sliderMin: 0, sliderMax: 30, sliderID: 24, position: 4, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Nose Height", filterFlag: 16, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 25, position: 0.10000000149012, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Nose Length", filterFlag: 16, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 26, position: 0.10000000149012, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Jaw Width", filterFlag: 16, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 27, position: -1, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Jaw Height", filterFlag: 16, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 28, position: 0.079999998211861, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Jaw Forward", filterFlag: 16, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 29, position: 0.03999999910593, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Cheekbone Height", filterFlag: 16, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 30, position: 0.019999999552965, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Cheekbone Width", filterFlag: 16, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 31, position: 0.5, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Cheek Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 6, sliderID: 32, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Laugh Lines", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 3, sliderID: 33, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Cheek Color Lower", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 6, sliderID: 34, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Nose Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 5, sliderID: 35, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 4, sliderID: 36, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Neck Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 4, sliderID: 37, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Forehead Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 3, sliderID: 38, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Mouth Shape", filterFlag: 128, callbackName: "ChangePreset", sliderMin: 0, sliderMax: 30, sliderID: 39, position: 19, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Mouth Height", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 40, position: 0.66000002622604, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Mouth Forward", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 41, position: 0.15999999642372, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Width", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 42, position: -0.34000000357628, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Length", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 43, position: -0.40000000596046, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Forward", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 44, position: 0.18000000715256, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Lip Color", filterFlag: 128 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 7, sliderID: 45, position: 0, interval: 1, enabled: true});
		*/
		categoryList.requestInvalidate();
		categoryList.onItemPress(0, 0);
		itemList.requestInvalidate();
		
		FocusHandler.instance.setFocus(itemList, 0);
		
		// Test Code
		InitExtensions();
	}
	
	public function InitExtensions()
	{
		_root.RaceMenuInstance.racePanel.Lock("L");
		bottomBar["playerInfo"].Lock("R");
	}
	
	public function SetPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		_platform = a_platform;
		_global.skyui.a_platform = 0;
		
		textEntry.setPlatform(a_platform, a_bPS3Switch);
		textEntry.SetupButtons();
		textEntry.TextInputInstance.maxChars = 26;
		
		bottomBar.setPlatform(a_platform, a_bPS3Switch);
		var leftEdge = Stage.visibleRect.x + Stage.safeRect.x;
		var rightEdge = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
		bottomBar.positionElements(leftEdge, rightEdge);
		updateBottomBar();
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		var nextClip = pathToFocus.shift();
		if (nextClip.handleInput(details, pathToFocus)) {
			return true;
		}
		
		var bHandledInput: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.control == InputDefines.Jump.name) {
				searchWidget.startInput();
				return true;
			} else if (details.control == InputDefines.Sprint.name) {
				playerZoom = !playerZoom;
				GameDelegate.call("ZoomPC", [playerZoom]);
				updateBottomBar();
				return true;
			}			
			if (details.navEquivalent == NavigationCode.LEFT || details.navEquivalent == NavigationCode.RIGHT || details.navEquivalent == NavigationCode.GAMEPAD_R1 || details.navEquivalent == NavigationCode.GAMEPAD_L1) {
				var SelectedEntry = itemList.listState.selectedEntry;
				var SelectedSlider = itemList.selectedClip.SliderInstance;
				if ((details.navEquivalent == NavigationCode.LEFT && SelectedEntry.position > SelectedEntry.sliderMin) || 
					(details.navEquivalent == NavigationCode.RIGHT && SelectedEntry.position < SelectedEntry.sliderMax) || 
					(details.navEquivalent == NavigationCode.GAMEPAD_L1 && SelectedEntry.position > SelectedEntry.sliderMin) || 
					(details.navEquivalent == NavigationCode.GAMEPAD_R1 && SelectedEntry.position < SelectedEntry.sliderMax)) {
					bHandledInput = SelectedSlider.handleInput(details, pathToFocus);
				}
				itemList.UpdateList();
			}
		}
		
		if(bHandledInput) {
			return bHandledInput;
		}
				
		return false;
	}
	
	public function ShowTextEntry(abShowTextEntry: Boolean): Void
	{
		bShowTextEntry = abShowTextEntry;
	}
	
	public function ShowTextEntryField(): Void
	{
		if (bShowTextEntry) {
			textEntry.TextInputInstance.text = "";
			textEntry.TextInputInstance.focused = true;
			textEntry._visible = true;
			textEntry.enabled = true;
			GameDelegate.call("SetAllowTextInput", []);
			return;
		}
		GameDelegate.call("ShowVirtualKeyboard", []);
	}
	
	public function onNameChange(event: Object): Void
	{
		if (event.nameChanged == true) {
			GameDelegate.call("ChangeName", [textEntry.TextInputInstance.text]);
		} else {
			GameDelegate.call("ChangeName", []);
		}
		
		textEntry._visible = false;
		textEntry.enabled = false;
	}
	
	public function HideLoadingIcon(): Void
	{
		loadingIcon._visible = false;
	}
	
	public function SetNameText(astrPlayerName: String): Void
	{
		bottomBar["playerInfo"].PlayerName.SetText(astrPlayerName);
	}

	public function SetRaceText(astrPlayerRace: String): Void
	{
		bottomBar["playerInfo"].PlayerRace.SetText(astrPlayerRace);
	}
	
	private function SetCategoriesList(): Void
	{
		categoryList.entryList.splice(1, categoryList.entryList.length - 1);
		
		for (var i: Number = 0; i < arguments.length; i += RaceMenuDefines.CAT_STRIDE) {
			var entryObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: arguments[i + RaceMenuDefines.CAT_TEXT].toUpperCase(), flag: arguments[i + RaceMenuDefines.CAT_FLAG], enabled: true};
			if(bLimitedMenu && entryObject.flag == RaceMenuDefines.CATEGORY_RACE) {
				entryObject.filterFlag = 0;
			}
			categoryList.entryList.push(entryObject);
		}
		
		// Add the new color category
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$COLORS", flag: RaceMenuDefines.CATEGORY_COLOR, enabled: true});
		
		categoryList.requestInvalidate();
	}

	private function SetRaceList(): Void
	{		
		if(itemList.entryList.length > 0) {
			for(var k: Number = itemList.entryList.length; k >= 0; k--) {
				if(itemList.entryList[k].type == RaceMenuDefines.ENTRY_TYPE_RACE)
					itemList.entryList.splice(k, 1);
			}
		}
		
		var id = 0;
		for (var i: Number = 0; i < arguments.length; i += RaceMenuDefines.RACE_STRIDE, id++) {
			var entryObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_RACE, text: arguments[i + RaceMenuDefines.RACE_NAME], filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: arguments[i + RaceMenuDefines.RACE_DESCRIPTION].length <= 0 ? "No race description for " + arguments[i + RaceMenuDefines.RACE_NAME] : arguments[i + RaceMenuDefines.RACE_DESCRIPTION], equipState: arguments[i + RaceMenuDefines.RACE_EQUIPSTATE], raceID: id, enabled: true};
			if (entryObject.equipState > 0) {
				SetRaceText(entryObject.text);
			}
			itemList.entryList.push(entryObject);
		}
		
		itemList.InvalidateData();
	}

	private function SetSliders(): Void
	{
		if(itemList.entryList.length > 0) {
			for(var k: Number = itemList.entryList.length; k >= 0; k--) {
				if(itemList.entryList[k].type == RaceMenuDefines.ENTRY_TYPE_SLIDER)
					itemList.entryList.splice(k, 1);
			}
		}
		
		for (var i: Number = 0; i < arguments.length; i += RaceMenuDefines.SLIDER_STRIDE) {
			var entryObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: arguments[i + RaceMenuDefines.SLIDER_NAME], filterFlag: arguments[i + RaceMenuDefines.SLIDER_FILTERFLAG], callbackName: arguments[i + RaceMenuDefines.SLIDER_CALLBACKNAME], sliderMin: arguments[i + RaceMenuDefines.SLIDER_MIN], sliderMax: arguments[i + RaceMenuDefines.SLIDER_MAX], sliderID: arguments[i + RaceMenuDefines.SLIDER_ID], position: arguments[i + RaceMenuDefines.SLIDER_POSITION], interval: arguments[i + RaceMenuDefines.SLIDER_INTERVAL], enabled: true};
			
			// Add new category
			if(entryObject.callbackName == "ChangeTintingMask" || entryObject.callbackName == "ChangeMaskColor" || entryObject.callbackName == "ChangeHairColorPreset") {
				entryObject.filterFlag += RaceMenuDefines.CATEGORY_COLOR;
			}
			
			// Oversliding
			if(entryObject.callbackName == "ChangeDoubleMorph") {
				entryObject.sliderMin -= 10;
				entryObject.sliderMax += 10;
			}
			itemList.entryList.push(entryObject);
		}
		
		itemList.requestInvalidate();
	}
	
	public function onFilterChange(): Void
	{
		itemList.requestInvalidate();
	}
	
	private function onSearchInputStart(event: Object): Void
	{
		categoryList.disableSelection = categoryList.disableInput = true;
		itemList.disableSelection = itemList.disableInput = true
		_nameFilter.filterText = "";
	}

	private function onSearchInputChange(event: Object)
	{
		_nameFilter.filterText = event.data;
	}

	private function onSearchInputEnd(event: Object)
	{
		categoryList.disableSelection = categoryList.disableInput = false;
		itemList.disableSelection = itemList.disableInput = false;
		_nameFilter.filterText = event.data;
	}
	
	public function onCategoryPress(a_event: Object): Void
	{
		if (categoryList.selectedEntry != undefined) {
			_typeFilter.changeFilterFlag(categoryList.selectedEntry.flag);
			categoryLabel.textField.text = categoryList.selectedEntry.text;
		}
	}
	
	public function onItemColor(a_entry: Object): Void
	{
		// Do nothing yet
	}
	
	private function onItemPress(event: Object): Void
	{
		var entryObject: Object = itemList.entryList[event.index];
		if(entryObject != itemList.listState.activeEntry && entryObject.type == RaceMenuDefines.ENTRY_TYPE_RACE) {
			itemList.listState.activeEntry = entryObject;
			itemList.requestUpdate();
			loadingIcon._visible = true;
			GameDelegate.call("ChangeRace", [entryObject.raceID, -1]);
			playerZoom = true; // Reset zoom, this happens when race is changed
		}
		updateBottomBar();
	}
	
	private function onSelectionChange(event: Object): Void
	{
		itemList.listState.selectedEntry = itemList.entryList[event.index];
		updateBottomBar();
	}
	
	private function updateBottomBar(): Void
	{
		navPanel.clearButtons();
		navPanel.addButton({text: "$Done", controls: {keyCode: KEY_CODE_DONE}});
		if(itemList.listState.selectedEntry != itemList.listState.activeEntry && itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_RACE) {
			navPanel.addButton({text: "$Change Race", controls: InputDefines.Activate});
		} else if(itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
			navPanel.addButton({text: "$Choose Color", controls: InputDefines.Activate});
		}
		navPanel.addButton({text: "$Search", controls: InputDefines.Jump});
		navPanel.addButton({text: playerZoom ? "$Zoom Out" : "$Zoom In", controls: InputDefines.Sprint});
		navPanel.updateButtons(true);
	}
}
