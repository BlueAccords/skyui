import gfx.events.EventDispatcher;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.io.GameDelegate;
import Shared.GlobalFunc;

import skyui.components.list.FilteredEnumeration;
import skyui.components.list.BasicEnumeration;
import skyui.components.list.ButtonEntryFormatter;
import skyui.components.list.ScrollingList;
import skyui.filter.ItemTypeFilter;

import RaceMenuDefines;

class RaceMenu extends MovieClip
{
	/* PRIVATE VARIABLES */
	private var _typeFilter: ItemTypeFilter;
	private var _raceList: Array;
	
	/* STAGE ELEMENTS */
	private var itemList: ScrollingList;
	private var categoryList: CategoryList;
	private var categoryLabel: TextField;
	
	/* CONSTANTS */
	
	
	/* GFx Dispatcher Functions */
	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;
	
	function RaceMenu()
	{
		super();
		GlobalFunc.MaintainTextFormat();
		GlobalFunc.SetLockFunction();
		
		EventDispatcher.initialize(this);
		
		_typeFilter = new ItemTypeFilter();
		_raceList = new Array();
		
		GameDelegate.addCallBack("SetCategoriesList", this, "SetCategoriesList");
		GameDelegate.addCallBack("ShowTextEntry", this, "ShowTextEntry");
		GameDelegate.addCallBack("SetNameText", this, "SetNameText");
		GameDelegate.addCallBack("SetRaceText", this, "SetRaceText");
		GameDelegate.addCallBack("SetRaceList", this, "SetRaceList");
		GameDelegate.addCallBack("SetOptionSliders", this, "SetSliders");
	}
	
	private function onLoad()
	{
		super.onLoad();
		_global.skyui.platform = 0;
		
		categoryList.listEnumeration = new BasicEnumeration(categoryList.entryList);
		
		var listEnumeration = new FilteredEnumeration(itemList.entryList);
		listEnumeration.addFilter(_typeFilter);
		itemList.listEnumeration = listEnumeration;
		
		_typeFilter.addEventListener("filterChange", this, "onFilterChange");
		itemList.addEventListener("itemPress", this, "onItemPress");
		itemList.addEventListener("selectionChange", this, "onSelectionChange");
		categoryList.addEventListener("itemPress", this, "onCategoryPress");
		
		categoryList.iconArt = ["skyrim", "race", "body", "head", "face", "eyes", "brow", "mouth", "hair"];
		categoryList.listState.iconSource = "skyui/racesex_icons.swf";
		
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: true, filterFlag: 1, text: "$ALL", flag: 508, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "RACE", flag: RaceMenuDefines.CATEGORY_RACE, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "BODY", flag: RaceMenuDefines.CATEGORY_BODY, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "HEAD", flag: RaceMenuDefines.CATEGORY_HEAD, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "FACE", flag: RaceMenuDefines.CATEGORY_FACE, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "EYES", flag: RaceMenuDefines.CATEGORY_EYES, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "BROW", flag: RaceMenuDefines.CATEGORY_BROW, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "MOUTH", flag: RaceMenuDefines.CATEGORY_MOUTH, savedItemIndex: -1, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "HAIR", flag: RaceMenuDefines.CATEGORY_HAIR, savedItemIndex: -1, enabled: true});
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
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Skin Tone", filterFlag: 4, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 2892, sliderID: 1, position: 2885, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Weight", filterFlag: 4, callbackName: "ChangeWeight", sliderMin: 0, sliderMax: 1, sliderID: 2, position: 0, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Complexion", filterFlag: 8, callbackName: "ChangeFaceDetails", sliderMin: 0, sliderMax: 5, sliderID: 3, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Dirt", filterFlag: 8, callbackName: "ChangeMask", sliderMin: -1, sliderMax: 2, sliderID: 4, position: -1, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Dirt Color", filterFlag: 8, callbackName: "ChangeMaskColor", sliderMin: 1, sliderMax: 4, sliderID: 5, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Scars", filterFlag: 8, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 12, sliderID: 6, position: 7, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "War Paint", filterFlag: 8, callbackName: "ChangeMask", sliderMin: -1, sliderMax: 14, sliderID: 7, position: -1, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "War Paint Color", filterFlag: 8, callbackName: "ChangeMaskColor", sliderMin: 1, sliderMax: 23, sliderID: 8, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Hair", filterFlag: 256, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 69, sliderID: 9, position: 10, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Facial Hair", filterFlag: 256, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 45, sliderID: 10, position: 41, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Hair Color", filterFlag: 256, callbackName: "ChangeHairColorPreset", sliderMin: 0, sliderMax: 6594, sliderID: 11, position: 6578, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Shape", filterFlag: 32, callbackName: "ChangePreset", sliderMin: 0, sliderMax: 37, sliderID: 12, position: 1, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Color", filterFlag: 32, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 1, sliderID: 13, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Height", filterFlag: 32, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 14, position: 0.5, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Width", filterFlag: 32, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 15, position: -0.059999998658895, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Depth", filterFlag: 32, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 16, position: -0.63999998569489, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eyeliner Color", filterFlag: 32, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 3, sliderID: 17, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Shadow", filterFlag: 32, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 7, sliderID: 18, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Tint", filterFlag: 32, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 7, sliderID: 19, position: 0, interval: 1, enabled: true});
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
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Cheek Color", filterFlag: 16, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 6, sliderID: 32, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Laugh Lines", filterFlag: 16, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 3, sliderID: 33, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Cheek Color Lower", filterFlag: 16, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 6, sliderID: 34, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Nose Color", filterFlag: 16, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 5, sliderID: 35, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Color", filterFlag: 16, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 4, sliderID: 36, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Neck Color", filterFlag: 16, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 4, sliderID: 37, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Forehead Color", filterFlag: 16, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 3, sliderID: 38, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Mouth Shape", filterFlag: 128, callbackName: "ChangePreset", sliderMin: 0, sliderMax: 30, sliderID: 39, position: 19, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Mouth Height", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 40, position: 0.66000002622604, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Mouth Forward", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 41, position: 0.15999999642372, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Width", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 42, position: -0.34000000357628, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Length", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 43, position: -0.40000000596046, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Forward", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 44, position: 0.18000000715256, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Lip Color", filterFlag: 128, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 7, sliderID: 45, position: 0, interval: 1, enabled: true});
		itemList.requestInvalidate();
		
		FocusHandler.instance.setFocus(itemList, 0);
	}
	
	public function InitExtensions()
	{
		_root.RaceMenuInstance.Lock("L");
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput = false;
				
		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.LEFT || details.navEquivalent == NavigationCode.RIGHT || details.navEquivalent == NavigationCode.GAMEPAD_R1 || details.navEquivalent == NavigationCode.GAMEPAD_L1) {
				var SelectedEntry = itemList.listState.selectedEntry;
				var SelectedSlider = itemList.selectedClip.SliderInstance;
				if (details.navEquivalent == NavigationCode.LEFT && SelectedEntry.position > SelectedEntry.sliderMin) {
					bHandledInput = SelectedSlider.handleInput(details, pathToFocus);
				} else if (details.navEquivalent == NavigationCode.RIGHT && SelectedEntry.position < SelectedEntry.sliderMax) {
					bHandledInput = SelectedSlider.handleInput(details, pathToFocus);
				} else if (details.navEquivalent == NavigationCode.GAMEPAD_L1 && SelectedEntry.position > SelectedEntry.sliderMin) {
					bHandledInput = SelectedSlider.handleInput(details, pathToFocus);
				} else if (details.navEquivalent == NavigationCode.GAMEPAD_R1 && SelectedEntry.position < SelectedEntry.sliderMax) {
					bHandledInput = SelectedSlider.handleInput(details, pathToFocus);
				}

				itemList.UpdateList();
			} else if(details.navEquivalent == NavigationCode.TAB) {
				categoryList.moveSelectionRight();
			} else if(details.navEquivalent == NavigationCode.SHIFT_TAB) {
				categoryList.moveSelectionLeft();
			} else if(details.navEquivalent == NavigationCode.ENTER) {
				onItemPress(itemList.selectedIndex);
			} /*else if(details.navEquivalent == NavigationCode.TAB) {
				testZoom = !testZoom;
				GameDelegate.call("ZoomPC", [testZoom]);
			}*/
		}
		
		if (pathToFocus[0].handleInput(details, pathToFocus.slice(1)))
			return true;
				
		return bHandledInput;
	}
	
	private function SetCategoriesList(): Void
	{
		categoryList.entryList.splice(1, categoryList.entryList.length - 1);
		
		for (var i: Number = 0; i < arguments.length; i += RaceMenuDefines.CAT_STRIDE) {
			var entryObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: arguments[i + RaceMenuDefines.CAT_TEXT].toUpperCase(), flag: arguments[i + RaceMenuDefines.CAT_FLAG], savedItemIndex: -1, enabled: true};
			categoryList.entryList.push(entryObject);
		}
		
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
			itemList.entryList.push(entryObject);
		}
		
		itemList.requestInvalidate();
	}
	
	public function onFilterChange(): Void
	{
		itemList.requestInvalidate();
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
		trace(a_entry);
	}
	
	private function onItemPress(a_entry: Object): Void
	{
		// Do something for a press
		var entryObject: Object = itemList.entryList[a_entry];
		if(entryObject != itemList.listState.activeEntry && entryObject.type == RaceMenuDefines.ENTRY_TYPE_RACE) {
			itemList.listState.activeEntry = entryObject;
			itemList.requestUpdate();
			GameDelegate.call("ChangeRace", [entryObject.raceID, -1]);
		}
	}
	
	private function onSelectionChange(event: Object): Void
	{
		itemList.listState.selectedEntry = itemList.entryList[event.index];
		//FocusHandler.instance.setFocus(itemList.listState.activeEntry.handler);
	}
}
