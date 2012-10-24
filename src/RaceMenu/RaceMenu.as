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
import ColorField;

class RaceMenu extends MovieClip
{
	/* PRIVATE VARIABLES */
	private var _platform: Number;
	private var _typeFilter: ItemTypeFilter;
	private var _nameFilter: ItemNameFilter;
	private var _playerObject: Object;
	private var _acceptControl: Object;
	private var updateInterval: Number;
	
	/* PUBLIC VARIABLES */
	public var bLimitedMenu: Boolean;
	public var playerZoom: Boolean = true;
	public var customSliders: Array;
	
	public var savedPresets: Array;
	public var savedMorphs: Array;
	
	/* STAGE ELEMENTS */
	public var racePanel: MovieClip;
	public var itemList: ScrollingList;
	public var categoryList: CategoryList;
	public var categoryLabel: TextField;
	public var raceDescription: TextField;
	public var searchWidget: SearchWidget;
	public var bottomBar: BottomBar;
	public var navPanel: ButtonPanel;
	public var textEntry: TextEntryField;
	public var loadingIcon: MovieClip;
	public var colorField: ColorField;
	
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
		
		customSliders = new Array();
		savedPresets = new Array();
		savedMorphs = new Array();
		
		loadingIcon._visible = false;
		textEntry._visible = false;
		textEntry.enabled = false;
		
		ShowRaceDescription(false);
		ShowColorField(false);
		
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
		colorField.addEventListener("setColor", this, "onSetColor");
		colorField.addEventListener("changeColor", this, "onChangeColor");
		
		categoryList.iconArt = ["skyrim", "race", "body", "head", "face", "eyes", "brow", "mouth", "hair", "palette"];
		categoryList.listState.iconSource = "skyui/racesex_icons.swf";
		
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: true, filterFlag: 1, text: "$ALL", flag: 508, savedItemIndex: -1, enabled: true});
		/*
		// Test Code
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "RACE", flag: RaceMenuDefines.CATEGORY_RACE, savedItemIndex: -1, enabled: true});
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
		//InitExtensions();
		//SetPlatform(1, false);
	}
	
	public function InitExtensions()
	{
		_root.RaceSexMenuBaseInstance.RaceSexPanelsInstance.racePanel.Lock("L");
		bottomBar["playerInfo"].Lock("R");
		
		raceDescription._x = _root.RaceMenuInstance.racePanel._x + _root.RaceMenuInstance.racePanel.width;
		raceDescription.width = (Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x) - raceDescription._x;
		
		skse.Log("Extensions initialized");
	}
	
	public function SetPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		_platform = a_platform;
		textEntry.setPlatform(a_platform, a_bPS3Switch);
		bottomBar.setPlatform(a_platform, a_bPS3Switch);
		colorField.setPlatform(a_platform, a_bPS3Switch);
		
		if(_platform == 0) {
			_acceptControl = {keyCode: KEY_CODE_DONE};
		} else {
			_acceptControl = InputDefines.XButton;
		}
		
		textEntry.TextInputInstance.maxChars = 26;
		textEntry.SetupButtons();
		colorField.SetupButtons();
		
		var leftEdge = Stage.visibleRect.x + Stage.safeRect.x;
		var rightEdge = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
		bottomBar.positionElements(leftEdge, rightEdge);
		updateBottomBar();
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		// Consume input when these windows are open
		if(colorField._visible) {
			return colorField.handleInput(details, pathToFocus);
		} else if(textEntry._visible) {
			return textEntry.handleInput(details, pathToFocus);
		}
		
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
			
			if (details.navEquivalent == NavigationCode.LEFT || details.navEquivalent == NavigationCode.RIGHT) {
				var SelectedEntry = itemList.listState.selectedEntry;
				var SelectedSlider = itemList.selectedClip.SliderInstance;
				if ((details.navEquivalent == NavigationCode.LEFT && SelectedEntry.position > SelectedEntry.sliderMin) || 
					(details.navEquivalent == NavigationCode.RIGHT && SelectedEntry.position < SelectedEntry.sliderMax)) {
					bHandledInput = SelectedSlider.handleInput(details, pathToFocus);
				}
				itemList.UpdateList();
			} else if(details.navEquivalent === NavigationCode.GAMEPAD_L2) {
				categoryList.moveSelectionLeft();
			} else if(details.navEquivalent === NavigationCode.GAMEPAD_R2) {
				categoryList.moveSelectionRight();
			}			
		}
				
		return bHandledInput;
	}
	
	/* Component Toggles */
	public function ShowTextEntry(abShowTextEntry: Boolean): Void
	{
		textEntry._visible = textEntry.enabled = abShowTextEntry;
		if(abShowTextEntry) {
			ShowColorField(false);
			categoryList.disableSelection = categoryList.disableInput = true;
			itemList.disableSelection = itemList.disableInput = true;
			FocusHandler.instance.setFocus(textEntry, 0);
		} else {
			categoryList.disableSelection = categoryList.disableInput = false;
			itemList.disableSelection = itemList.disableInput = false;
			FocusHandler.instance.setFocus(itemList, 0);
		}
	}
	
	// No idea why they have two of these
	public function ShowTextEntryField(): Void
	{
		if (textEntry.enabled) {
			textEntry.TextInputInstance.text = "";
			textEntry.TextInputInstance.focused = true;
			GameDelegate.call("SetAllowTextInput", []);
			return;
		}
		GameDelegate.call("ShowVirtualKeyboard", []);
	}
	
	public function ShowColorField(bShowField: Boolean): Void
	{
		colorField._visible = colorField.enabled = bShowField;
		if(bShowField) {
			colorField.ResetSlider();
			categoryList.disableSelection = categoryList.disableInput = true;
			itemList.disableSelection = itemList.disableInput = true;
			FocusHandler.instance.setFocus(colorField.colorSelector, 0);
		} else {
			categoryList.disableSelection = categoryList.disableInput = false;
			itemList.disableSelection = itemList.disableInput = false;
			FocusHandler.instance.setFocus(itemList, 0);
		}
	}
	
	public function ShowRaceDescription(bShowDescription: Boolean): Void
	{
		raceDescription._visible = colorField.enabled = bShowDescription;
	}
		
	public function onNameChange(event: Object): Void
	{
		if (event.nameChanged == true) {
			GameDelegate.call("ChangeName", [textEntry.TextInputInstance.text]);
		} else {
			GameDelegate.call("ChangeName", []);
		}
		
		ShowTextEntry(false);
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
			if(bLimitedMenu && entryObject.flag & RaceMenuDefines.CATEGORY_RACE) {
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
				itemList.listState.activeEntry = entryObject;
				SetRaceText(entryObject.text);
			}

			itemList.entryList.push(entryObject);
		}
		
		itemList.requestInvalidate();
	}

	private function SetSliders(): Void
	{
		if(itemList.entryList.length > 0) {
			for(var k: Number = itemList.entryList.length; k >= 0; k--) {
				if(itemList.entryList[k].type == RaceMenuDefines.ENTRY_TYPE_SLIDER)
					itemList.entryList.splice(k, 1);
			}
		}
		
		savedPresets.splice(0, savedPresets.length);
		savedMorphs.splice(0, savedMorphs.length);
		
		for (var i: Number = 0; i < arguments.length; i += RaceMenuDefines.SLIDER_STRIDE) {
			var entryObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: arguments[i + RaceMenuDefines.SLIDER_NAME], filterFlag: arguments[i + RaceMenuDefines.SLIDER_FILTERFLAG], callbackName: arguments[i + RaceMenuDefines.SLIDER_CALLBACKNAME], sliderMin: arguments[i + RaceMenuDefines.SLIDER_MIN], sliderMax: arguments[i + RaceMenuDefines.SLIDER_MAX], sliderID: arguments[i + RaceMenuDefines.SLIDER_ID], position: arguments[i + RaceMenuDefines.SLIDER_POSITION], interval: arguments[i + RaceMenuDefines.SLIDER_INTERVAL], enabled: true};
			
			// Add new category
			if(entryObject.callbackName == "ChangeTintingMask" || entryObject.callbackName == "ChangeMaskColor" || entryObject.callbackName == "ChangeHairColorPreset") {
				entryObject.filterFlag += RaceMenuDefines.CATEGORY_COLOR;
			}
			
			// Oversliding
			/*if(entryObject.callbackName == "ChangeDoubleMorph") {
				entryObject.sliderMin -= 5;
				entryObject.sliderMax += 5;
			}*/
			
			if(entryObject.callbackName == "ChangePreset") {
				savedPresets.push(entryObject);
			} else if(entryObject.callbackName == "ChangeDoubleMorph") {
				savedMorphs.push(entryObject);
			}
			
			skse.Log("Slider Loaded: " + entryObject.text + " ID: " + entryObject.sliderID);
			itemList.entryList.push(entryObject);
		}
				
		skse.SendModEvent("RSM_LoadSliders");
		
		itemList.requestInvalidate();
	}
	
	public function onFilterChange(): Void
	{
		itemList.requestInvalidate();
	}
	
	private function onSearchInputStart(event: Object): Void
	{
		categoryList.disableSelection = categoryList.disableInput = true;
		itemList.disableSelection = itemList.disableInput = true;
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
			GameDelegate.call("PlaySound",["UIMenuFocus"]);
		}
	}
	
	public function onSetColor(event: Object): Void
	{
		if(event.color != -1 && event.color != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
				selectedEntry.fillColor = event.color;
			
				if(!updateInterval) {
					updateInterval = setInterval(this, "doUpdateColor", 100, selectedEntry.sliderID, event.color);
				}
			}
			
			itemList.requestUpdate();
		}
		
		ShowColorField(false);
	}
	
	public function onChangeColor(event: Object): Void
	{
		if(event.color != -1 && event.color != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
				if(!updateInterval) {
					updateInterval = setInterval(this, "doUpdateColor", 100, selectedEntry.sliderID, event.color);
				}
			}
		}
	}
	
	public function doUpdateColor(sliderID: Number, appliedColor: Number): Void
	{
		setPlayerColor(sliderID, appliedColor);
		clearInterval(updateInterval);
		delete updateInterval;
	}
	
	// This function is a mess right now
	public function setPlayerColor(sliderID: Number, appliedColor: Number): Void
	{
		var tintType: Number = -1;
		var tintIndex: Number = 0;
		var isFemale: Number = skse.GetPlayerSex();
		
		if(sliderID == undefined) {
			skyui.util.Debug.log("RSM Warning: Invalid sliderID.");
			return;
		}
		
		if(appliedColor == undefined) {
			skyui.util.Debug.log("RSM Warning: Invalid color.");
			return;
		}
		
		// Get the tintType by sliderID
		for(var i = 0; i < RaceMenuDefines.SLIDER_MAP[isFemale].length; i++)
		{
			var searchID: Number = RaceMenuDefines.SLIDER_MAP[isFemale][i].sliderID;
			if(searchID == sliderID) {
				tintType = RaceMenuDefines.SLIDER_MAP[isFemale][i].tintType;
				break;
			}
		}
				
		// Apply warpaint color based on warpaint slider value
		if(tintType == RaceMenuDefines.TINT_TYPE_WARPAINT) {
			for(var i: Number = 0; i < itemList.entryList.length; i++) {
				var a_wpEntry: Object = itemList.entryList[i];
				var searchID: Number = RaceMenuDefines.STATIC_SLIDER_WARPAINT;
				if(a_wpEntry.sliderID == searchID) {
					tintIndex = a_wpEntry.position;
					break;
				}
			}
		}
		
		// Apply dirt color based on dirt slider value
		if(tintType == RaceMenuDefines.TINT_TYPE_DIRT) {
			for(var i: Number = 0; i < itemList.entryList.length; i++) {
				var a_wpEntry: Object = itemList.entryList[i];
				var searchID: Number = RaceMenuDefines.STATIC_SLIDER_DIRT;
				if(a_wpEntry.sliderID == searchID) {
					tintIndex = a_wpEntry.position;
					break;
				}
			}
		}
						
		var tintColor: Number = appliedColor;
		
		if(tintType == 128) {
			skse.SendModEvent("RSM_OnHairColorChange", "", tintColor);
		} else if(tintType != -1) {
			skse.SendModEvent("RSM_OnTintColorChange", Number(tintType * 1000 + tintIndex).toString(), tintColor);
		}
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
		} else if(entryObject.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
			colorField.setColor(entryObject.fillColor);
			ShowColorField(true);
		}
		updateBottomBar();
	}
	
	private function onSelectionChange(event: Object): Void
	{
		itemList.listState.selectedEntry = itemList.entryList[event.index];
		if(itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_RACE) {
			ShowRaceDescription(true);
			raceDescription.SetText(itemList.listState.selectedEntry.raceDescription);
		} else {
			ShowRaceDescription(false);
			raceDescription.SetText("");
		}
		GameDelegate.call("PlaySound",["UIMenuFocus"]);
		updateBottomBar();
	}
	
	private function updateBottomBar(): Void
	{
		navPanel.clearButtons();
		navPanel.addButton({text: "$Done", controls: _acceptControl});
		if(_platform == 0) {
			navPanel.addButton({text: "$Search", controls: InputDefines.Jump});
		} else {
			navPanel.addButton({text: "$Change Category", controls: InputDefines.Equip});
		}
		navPanel.addButton({text: playerZoom ? "$Zoom Out" : "$Zoom In", controls: InputDefines.Sprint});
		
		if(itemList.listState.selectedEntry != itemList.listState.activeEntry && itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_RACE) {
			navPanel.addButton({text: "$Change Race", controls: InputDefines.Activate});
		} else if(itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
			navPanel.addButton({text: "$Choose Color", controls: InputDefines.Activate});
		}
		
		navPanel.updateButtons(true);
	}
	
	/* Clipboard functions */
	private function saveSlidersToClipboard(): Void
	{
		var outputString: String = "";
		var totalSettings = savedPresets.length + savedMorphs.length;
		var k = 0;
		for(var i = 0; i < savedPresets.length; i++, k++) {
			outputString += "" + (((savedPresets[i].position * 100)|0)/100) + "";
			
			if(k < totalSettings - 1) {
				outputString += ",";
			}
		}
		
		for(var i = 0; i < savedMorphs.length; i++, k++) {
			outputString += "" + (((savedMorphs[i].position * 100)|0)/100) + "";
			
			if(k < totalSettings - 1) {
				outputString += ",";
			}
		}
		
		skse.SetClipboardData(outputString);
	}
	
	private function loadSlidersFromClipboard(): Void
	{
		var clipboardData: String = skse.GetClipboardData();
		var sliderArray: Array = clipboardData.split(',');
		var totalSettings = savedPresets.length + savedMorphs.length;
		
		// Load Presets
		for(var i = 0; i < savedPresets.length; i++) {
			if(savedPresets[i] != undefined && sliderArray[i] != undefined) {
				savedPresets[i].position = Number(sliderArray[i]);
				GameDelegate.call(savedPresets[i].callbackName, [savedPresets[i].position, savedPresets[i].sliderID]);
			} else {
				skse.Log("No data for preset: " + savedPresets[i].text);
			}
		}
		
		// Load Morphs
		var k = 0;
		for(var i = savedPresets.length; i < totalSettings; i++, k++) {
			if(savedMorphs[k] != undefined && sliderArray[i] != undefined) {
				savedMorphs[k].position = Number(sliderArray[i]);
				GameDelegate.call(savedMorphs[k].callbackName, [savedMorphs[k].position, savedMorphs[k].sliderID]);
			} else {
				skse.Log("No data for morph: " + savedMorphs[k].text);
			}
		}
		
		itemList.requestUpdate();
	}
	
	private function GetSliderByType(tintType: Number): Object
	{
		var isFemale: Number = skse.GetPlayerSex();
		var sliderID: Number;
		
		for(var i = 0; i < RaceMenuDefines.SLIDER_MAP[isFemale].length; i++)
		{
			if(RaceMenuDefines.SLIDER_MAP[isFemale][i].tintType == tintType) {
				var foundID: Number = RaceMenuDefines.SLIDER_MAP[isFemale][i].sliderID;
				sliderID = foundID;
				break;
			}
		}

		if(sliderID == undefined)
			return null;
		
		for(var i = 0; i < itemList.entryList.length; i++)
		{
			if(itemList.entryList[i].sliderID == sliderID) {
				skse.Log("Found Slider: " + sliderID + " for " + tintType + " : " + itemList.entryList[i].text);
				return itemList.entryList[i];
			}
		}
		
		return null;
	}
	
	/* PAPYRUS INTERFACE */
	public function RSM_AddSlider(a_name: String, a_section: String, a_callback: String, a_sliderMin: String, a_sliderMax: String, a_position: String, a_interval: String)
	{
		var newSliderID = customSliders.length + 1000;
		var sliderObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: a_name, filterFlag: Number(a_section), callbackName: a_callback, sliderMin: Number(a_sliderMin), sliderMax: Number(a_sliderMax), sliderID: newSliderID, position: Number(a_position), interval: Number(a_interval), enabled: true};
		customSliders.push(sliderObject);
		itemList.entryList.push(sliderObject);
		itemList.requestInvalidate();
	}
	
	public function RSM_LoadColors()
	{
		for(var i = 0; i < arguments.length; i += 2)
		{
			var tintType: Number = arguments[i];
			var tintColor: Number = arguments[i + 1];
			
			if(tintType != 0 && tintColor != 0) {
				var slider: Object = GetSliderByType(tintType);
				if(slider) {
					slider.fillColor = tintColor & 0x00FFFFFF;
				}
				
				skse.Log("Loading Tint: " + tintType + " Color: " + tintColor);
			}
		}
		
		itemList.requestUpdate();
	}
}
