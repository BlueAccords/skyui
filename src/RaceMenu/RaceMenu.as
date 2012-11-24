﻿import gfx.events.EventDispatcher;
import gfx.managers.FocusHandler;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.io.GameDelegate;
import Shared.GlobalFunc;

import com.greensock.TweenLite;
import com.greensock.OverwriteManager;
import com.greensock.easing.Linear;

import skyui.components.SearchWidget;
import skyui.components.list.FilteredEnumeration;
import skyui.components.list.BasicEnumeration;
import skyui.components.list.ScrollingList;
import skyui.components.ButtonPanel;

import skyui.filter.ItemTypeFilter;
import skyui.filter.ItemNameFilter;
import skyui.filter.ItemSorter;
import skyui.util.Debug;

import RaceMenuDefines;
import TextEntryField;
import ColorField;
import MakeupPanel;

class RaceMenu extends MovieClip
{
	/* PRIVATE VARIABLES */
	private var _platform: Number;
	private var _typeFilter: ItemTypeFilter;
	private var _nameFilter: ItemNameFilter;
	private var _sortFilter: ItemSorter;
	private var _playerObject: Object;
	
	private var updateInterval: Number;
	private var _tintTypes: Array;
	private var _tintColors: Array;
	private var _tintTextures: Array;
	private var _makeupNames: Array;
	private var _makeupTextures: Array;
	private var _raceList: Array;
	private var _extendIndex: Number = 0;
	
	/* CONTROLS */
	private var _activateControl: Object;
	private var _acceptControl: Object;
	private var _zoomControl: Object;
	private var _lightControl: Object;
	private var _textureControl: Object;
	private var _searchControl: Object;
	
	/* PUBLIC VARIABLES */
	public var bLimitedMenu: Boolean;
	public var playerZoom: Boolean = true;
	public var bShowLight: Boolean = true;
	public var bTextEntryMode: Boolean = false;
	public var bExtendRaceMode: Boolean = false;
	public var bSlidersInitialized: Boolean = false;
	
	public var customSliders: Array;
	
	/* STAGE ELEMENTS */
	public var racePanel: MovieClip;
	public var itemList: ScrollingList;
	public var categoryList: CategoryList;
	public var categoryLabel: TextField;
	public var searchWidget: SearchWidget;
	
	public var bottomBar: BottomBar;
	public var navPanel: ButtonPanel;
	
	public var raceDescription: MovieClip;
	public var textEntry: TextEntryField;
	public var loadingIcon: MovieClip;
	public var colorField: ColorField;
	
	public var bonusPanel: MovieClip;
	public var bonusList: ScrollingList;
	
	public var makeupPanel: MakeupPanel;
	
	/* GFx Dispatcher Functions */
	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;
	
	public var DISPLAY_KEYCODE_TEXTURE: Number = 20;
	public var DISPLAY_KEYCODE_DONE: Number = 19;
	public var DISPLAY_KEYCODE_LIGHT: Number = 38;
	public var DISPLAY_KEYCODE_SEARCH: Number = 57;
	
	public var DISPLAY_GAMEPAD_L1: Number = 274;
	public var DISPLAY_GAMEPAD_R1: Number = 275;
	public var DISPLAY_GAMEPAD_Y: Number = 279;
	
	public var KEYCODE_T: Number = 84;
	public var KEYCODE_L: Number = 76;
	public var KEYCODE_SPACE: Number = 32;
	
		
	function RaceMenu()
	{
		super();
		
		itemList = racePanel.itemList;
		categoryList = racePanel.categoryList;
		categoryLabel = racePanel.categoryLabel;
		searchWidget = racePanel.searchWidget;
		navPanel = bottomBar.buttonPanel;
		bonusList = bonusPanel.bonusList;
		
		customSliders = new Array();
		
		_tintTypes = new Array();
		_tintColors = new Array();
		_tintTextures = new Array();
		_makeupNames = new Array();
		_makeupTextures = new Array();
		_raceList = new Array();
		
		loadingIcon._visible = false;
		textEntry._visible = false;
		textEntry.enabled = false;
		
		ShowRaceBonuses(null, false);
		ShowRaceDescription(false);
		ShowColorField(false);
		ShowMakeupPanel(false);
		
		GlobalFunc.MaintainTextFormat();
		GlobalFunc.SetLockFunction();
		
		EventDispatcher.initialize(this);
		
		_typeFilter = new ItemTypeFilter();
		_nameFilter = new ItemNameFilter();
		_sortFilter = new ItemSorter();
		
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
		
		raceDescription.textField.textAutoSize = "shrink";
		bottomBar.hidePlayerInfo();
		var pInfo = bottomBar.attachMovie("PlayerInfo", "playerInfo", bottomBar.getNextHighestDepth());
		pInfo._y = 25;
		
		var bonusEnumeration = new FilteredEnumeration(bonusList.entryList);
		bonusEnumeration.addFilter(_sortFilter);
		bonusList.listEnumeration = bonusEnumeration;
		
		categoryList.listEnumeration = new BasicEnumeration(categoryList.entryList);
		
		var listEnumeration = new FilteredEnumeration(itemList.entryList);
		listEnumeration.addFilter(_typeFilter);
		listEnumeration.addFilter(_nameFilter);
		itemList.listEnumeration = listEnumeration;

		_sortFilter.addEventListener("filterChange", this, "onBonusFilterChange");
		_typeFilter.addEventListener("filterChange", this, "onFilterChange");
		_nameFilter.addEventListener("filterChange", this, "onFilterChange");
		
		itemList.addEventListener("itemPress", this, "onItemPress");
		itemList.addEventListener("selectionChange", this, "onSelectionChange");
		categoryList.addEventListener("itemPress", this, "onCategoryPress");
		categoryList.addEventListener("selectionChange", this, "onCategoryChange");
		
		searchWidget.addEventListener("inputStart", this, "onSearchInputStart");
		searchWidget.addEventListener("inputEnd", this, "onSearchInputEnd");
		searchWidget.addEventListener("inputChange", this, "onSearchInputChange");
		
		textEntry.addEventListener("nameChange", this, "onNameChange");
		colorField.addEventListener("setColor", this, "onSetColor");
		colorField.addEventListener("changeColor", this, "onChangeColor");
		makeupPanel.addEventListener("setTexture", this, "onSetTexture");
		makeupPanel.addEventListener("changeTexture", this, "onChangeTexture");
		
		categoryList.iconArt = ["skyrim", "race", "body", "head", "face", "eyes", "brow", "mouth", "hair", "palette", ""];
		categoryList.listState.iconSource = "skyui/racesex_icons.swf";
		
		_sortFilter.setSortBy(["text"], [0]);
				
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: true, filterFlag: 1, text: "$ALL", flag: 508, savedItemIndex: -1, enabled: true});
		/*
		_raceList.push({skillBonuses: [{skill: 10, bonus: 11},
									   {skill: 11, bonus: 11},
									   {skill: 12, bonus: 11},
									   {skill: 13, bonus: 11},
									   {skill: 14, bonus: 11},
									   {skill: 15, bonus: 11},
									   {skill: 16, bonus: 11}
									   ]});
		
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
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$MAKEUP", flag: RaceMenuDefines.CATEGORY_MAKEUP, savedItemIndex: -1, enabled: true});
		categoryList.requestInvalidate();
		categoryList.onItemPress(0, 0);
		
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Argonian", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "This reptilian race, well-suited for the treacherous swamps of their Black Marsh homeland, has developed a natural resistance to diseases and the ability to breathe underwater. They can call upon the Histskin to regenerate health very quickly.", equipState: 0, raceID: 0, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Breton", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "In addition to their quick and perceptive grasp of spellcraft, even the humblest of High Rock's Bretons can boast a resistance to magic. Bretons can call upon the Dragonskin power to absorb spells.", equipState: 0, raceID: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Dark Elf", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "Also known as \"Dunmer\" in their homeland of Morrowind, dark elves are noted for their stealth and magic skills. They are naturally resistant to fire and can call upon their Ancestor's Wrath to surround themselves in fire.", equipState: 0, raceID: 2, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "High Elf", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "Also known as \"Altmer\" in their homeland of Summerset Isle, the high elves are the most strongly gifted in the arcane arts of all the races. They can call upon their Highborn power to regenerate Magicka quickly.", equipState: 0, raceID: 3, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Imperial", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "Natives of Cyrodiil, they have proved to be shrewd diplomats and traders. They are skilled with combat and magic. Anywhere gold coins might be found, Imperials always seem to find a few more. They can call upon the Voice of the Emperor to calm an enemy.", equipState: 0, raceID: 4, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Khajiit", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "Hailing from the province of Elsweyr, they are intelligent, quick, and agile.  They make excellent thieves due to their natural stealthiness. All Khajiit can see in the dark at will and have unarmed claw attacks.", equipState: 0, raceID: 5, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Nord", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "Citizens of Skyrim, they are a tall and fair-haired people.  Strong and hardy, Nords are famous for their resistance to cold and their talent as warriors. They can use a Battlecry to make opponents flee.", equipState: 0, raceID: 6, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Orc", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "The people of the Wrothgarian and Dragontail Mountains, Orcish smiths are prized for their craftsmanship. Orc troops in Heavy Armor are among the finest in the Empire, and are fearsome when using their Berserker Rage.", equipState: 0, raceID: 7, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Redguard", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "The most naturally talented warriors in Tamriel, the Redguards of Hammerfell have a hardy constitution and a natural resistance to poison. They can call upon an Adrenaline Rush in combat.", equipState: 0, raceID: 8, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "Wood Elf", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "The clanfolk of the Western Valenwood forests, also known as \"Bosmer.\" Wood elves make good scouts and thieves, and there are no finer archers in all of Tamriel. They have natural resistances to both poisons and diseases. They can Command Animals to fight for them.", equipState: 0, raceID: 9, enabled: true});
		
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
		
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_MAKEUP, text: "MyNigga", texture: "actors\\character\\Character assets\\tintmasks\\femalenordeyelinerstyle_01.dds", filterFlag: RaceMenuDefines.CATEGORY_MAKEUP, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_MAKEUP, text: "MyNigga2", texture: "actors/character/Character assets/tintmasks/femalenordeyelinerstyle_01.dds", filterFlag: RaceMenuDefines.CATEGORY_MAKEUP, enabled: true});
		*/
		categoryList.requestInvalidate();
		categoryList.onItemPress(0, 0);
		itemList.requestInvalidate();
		
		FocusHandler.instance.setFocus(itemList, 0);
		
		// Test Code
		//InitExtensions();
		//SetPlatform(1, false);
		
		/*for(var i = 0; i < 50; i++) {
			RSM_AddMakeup("Test " + i, "Texture1");
		}
		ShowMakeupPanel(true);*/
	}
	
	public function InitExtensions()
	{
		racePanel.Lock("L");
		bottomBar["playerInfo"].Lock("R");

		raceDescription._x = racePanel._x + raceDescription._width / 2 + racePanel._width + 15;
		raceDescription._y = bottomBar._y - raceDescription._height / 2 - 15;
		
		bonusPanel._x = raceDescription._x + bonusPanel._width / 2 + raceDescription._width / 2 + 15;
		bonusPanel._y = raceDescription._y;
		
		colorField._x = racePanel._x + racePanel._width / 2;
		makeupPanel._x = racePanel._x + racePanel._width / 2;
	}
	
	public function SetPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		_platform = a_platform;
		textEntry.setPlatform(a_platform, a_bPS3Switch);
		bottomBar.setPlatform(a_platform, a_bPS3Switch);
		colorField.setPlatform(a_platform, a_bPS3Switch);
		makeupPanel.setPlatform(a_platform, a_bPS3Switch);
		
		if(_platform == 0) {
			_activateControl = InputDefines.Activate;
			_acceptControl = {keyCode: DISPLAY_KEYCODE_DONE};
			_lightControl = {keyCode: DISPLAY_KEYCODE_LIGHT};
			_zoomControl = InputDefines.Sprint;
			_searchControl = {keyCode: DISPLAY_KEYCODE_SEARCH};
			_textureControl = {keyCode: DISPLAY_KEYCODE_TEXTURE};
		} else {
			_activateControl = InputDefines.Activate;
			_acceptControl = InputDefines.XButton;
			_lightControl = {keyCode: DISPLAY_GAMEPAD_R1};
			_zoomControl = {keyCode: DISPLAY_GAMEPAD_L1};
			_textureControl = {keyCode: DISPLAY_GAMEPAD_Y};
			_searchControl = null;
		}
		
		textEntry.TextInputInstance.maxChars = 26;
		textEntry.SetupButtons();
		colorField.SetupButtons();
		makeupPanel.SetupButtons();
		
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
		} else if(makeupPanel._visible) {
			return makeupPanel.handleInput(details, pathToFocus);
		}
		
		var nextClip = pathToFocus.shift();
		if (nextClip.handleInput(details, pathToFocus)) {
			return true;
		}
				
		var bHandledInput: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details)) {
			
			if (details.code == KEYCODE_SPACE) {
				searchWidget.startInput();
				return true;
			} else if ((details.code == KEYCODE_T || details.navEquivalent == NavigationCode.GAMEPAD_Y) && !bTextEntryMode) {
				var SelectedEntry = itemList.listState.selectedEntry;
				makeupPanel.setTexture(SelectedEntry.text, SelectedEntry.texture);
				ShowMakeupPanel(true);
				return true;
			} else if ((details.control == InputDefines.Sprint.name || details.navEquivalent == NavigationCode.GAMEPAD_L1) && !bTextEntryMode) {
				playerZoom = !playerZoom;
				GameDelegate.call("ZoomPC", [playerZoom]);
				updateBottomBar();
				return true;
			} else if((details.code == KEYCODE_L || details.navEquivalent == NavigationCode.GAMEPAD_R1) && !bTextEntryMode) {
				bShowLight = !bShowLight;
				skse.SendModEvent("RSM_ToggleLight", "", Number(bShowLight));
				updateBottomBar();
				return true;
			} else if((details.navEquivalent == NavigationCode.GAMEPAD_L3) && !bTextEntryMode) {
				skse.SendModEvent("RSM_RequestLoadClipboard");
				return true;
			} else if((details.navEquivalent == NavigationCode.GAMEPAD_R3) && !bTextEntryMode) {
				skse.SendModEvent("RSM_RequestSaveClipboard");
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
			TweenLite.to(racePanel, 0.25, {_alpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			categoryList.disableSelection = categoryList.disableInput = false;
			itemList.disableSelection = itemList.disableInput = false;
			FocusHandler.instance.setFocus(itemList, 0);
			TweenLite.to(racePanel, 0.25, {_alpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	// No idea why they have two of these
	public function ShowTextEntryField(): Void
	{
		if (textEntry.enabled) {
			textEntry.TextInputInstance.text = bottomBar["playerInfo"].PlayerName.text;
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
			TweenLite.to(racePanel, 0.25, {_alpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			categoryList.disableSelection = categoryList.disableInput = false;
			itemList.disableSelection = itemList.disableInput = false;
			FocusHandler.instance.setFocus(itemList, 0);
			TweenLite.to(racePanel, 0.25, {_alpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function ShowRaceDescription(bShowDescription: Boolean): Void
	{
		raceDescription._visible = raceDescription.enabled = bShowDescription;
	}
	
	public function ShowRaceBonuses(a_race: Object, bShowBonuses: Boolean): Void
	{
		bonusPanel._visible = bonusPanel.enabled = bShowBonuses;
		if(bShowBonuses) {
			bonusList.entryList.splice(0, bonusList.entryList.length);
			for(var i = 0; i < a_race.skillBonuses.length; i++) {
				var skillId: Number = a_race.skillBonuses[i].skill;
				var skillBonus: Number = a_race.skillBonuses[i].bonus;
				
				if(skillId == RaceMenuDefines.ACTORVALUE_NONE || skillBonus == 0)
					continue;
					
				bonusList.entryList.push({text: GetActorValueText(skillId), value: skillBonus});
			}
			
			if(bonusList.entryList.length == 0 || a_race == undefined) {
				bonusPanel._visible = bonusPanel.enabled = false;
			}
			
			bonusList.requestInvalidate();
		}
	}
	
	public function ShowMakeupPanel(bShowPanel: Boolean): Void
	{
		makeupPanel._visible = makeupPanel.enabled = bShowPanel;
		if(bShowPanel) {
			makeupPanel.UpdateList();
			categoryList.disableSelection = categoryList.disableInput = true;
			itemList.disableSelection = itemList.disableInput = true;
			FocusHandler.instance.setFocus(makeupPanel.makeupList, 0);
			TweenLite.to(racePanel, 0.25, {_alpha: 0, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			categoryList.disableSelection = categoryList.disableInput = false;
			itemList.disableSelection = itemList.disableInput = false;
			FocusHandler.instance.setFocus(itemList, 0);
			TweenLite.to(racePanel, 0.25, {_alpha: 100, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
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
		// Remove all categories except for All
		categoryList.entryList.splice(1, categoryList.entryList.length - 1);
		
		for (var i: Number = 0; i < arguments.length; i += RaceMenuDefines.CAT_STRIDE) {
			var entryObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: arguments[i + RaceMenuDefines.CAT_TEXT].toUpperCase(), flag: arguments[i + RaceMenuDefines.CAT_FLAG], enabled: true};			
			if(bLimitedMenu && entryObject.flag & RaceMenuDefines.CATEGORY_RACE) {
				entryObject.filterFlag = 0;
			}
			categoryList.entryList.push(entryObject);
		}
		
		// Add the new categories
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$COLORS", flag: RaceMenuDefines.CATEGORY_COLOR, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$MAKEUP", flag: RaceMenuDefines.CATEGORY_MAKEUP, enabled: true});
		
		categoryList.requestInvalidate();
	}

	private function SetRaceList(): Void
	{	
		// Remove only Race types
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
		// Remove only Slider types
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
			/*if(entryObject.callbackName == "ChangeDoubleMorph") {
				entryObject.sliderMin -= 5;
				entryObject.sliderMax += 5;
			}*/
						
			itemList.entryList.push(entryObject);
		}
		
		if(!bSlidersInitialized) {
			skse.SendModEvent("RSM_Initialized");
			bSlidersInitialized = true;
		} else {
			skse.SendModEvent("RSM_Reinitialized");
		}
		
		skse.SendModEvent("RSM_RequestCustomContent");
		
		itemList.requestInvalidate();
	}
	
	public function SetMakeup(a_types: Array, a_colors: Array, a_textures: Array, a_tintType: Number): Void
	{
		// Remove only Makeup types
		if(itemList.entryList.length > 0) {
			for(var k: Number = itemList.entryList.length; k >= 0; k--) {
				if(itemList.entryList[k].type == RaceMenuDefines.ENTRY_TYPE_MAKEUP)
					itemList.entryList.splice(k, 1);
			}
		}
		
		var tintIndex: Number = 0;
		for(var i = 0; i < a_types.length; i++) {
			var nTintType: Number = a_types[i];
			var nTintTexture: String = a_textures[i];
			var nTintIndex: Number = tintIndex;
			var nTintColor: Number = a_colors[i];
			if(nTintType == a_tintType) {
				++tintIndex;
			} else {
				tintIndex = 0;
				continue;
			}
			
			// Strip Path and extension
			var slashIndex: Number = -1;
			for(var k = nTintTexture.length - 1; k > 0; k--) {
				if(nTintTexture.charAt(k) == "\\" || nTintTexture.charAt(k) == "/") {
					slashIndex = k;
					break;
				}
			}
			var formatIndex: Number = nTintTexture.lastIndexOf(".dds");
			if(formatIndex == -1)
				formatIndex = nTintTexture.length;
			
			var displayText: String = nTintTexture.substring(slashIndex + 1, formatIndex);
			itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_MAKEUP, text: displayText, texture: nTintTexture, tintType: nTintType, tintIndex: nTintIndex, fillColor: nTintColor, filterFlag: RaceMenuDefines.CATEGORY_MAKEUP, enabled: true});
		}
		
		itemList.requestInvalidate();
	}
	
	public function onBonusFilterChange(): Void
	{
		bonusList.requestInvalidate();
	}
	
	public function onFilterChange(): Void
	{
		itemList.requestInvalidate();
	}
	
	private function onSearchInputStart(event: Object): Void
	{
		bTextEntryMode = true;
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
		bTextEntryMode = false;
	}
	
	public function onCategoryPress(a_event: Object): Void
	{
		if (categoryList.selectedEntry != undefined) {
			_typeFilter.changeFilterFlag(categoryList.selectedEntry.flag);
			categoryLabel.textField.text = categoryList.selectedEntry.text;
		}
	}
	
	public function onCategoryChange(a_event: Object): Void
	{
		GameDelegate.call("PlaySound",["UIMenuFocus"]);
	}
		
	public function onSetTexture(event: Object): Void
	{
		if(event.texture != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP) {
				selectedEntry.text = event.displayText;
				selectedEntry.texture = event.texture;
				if(!updateInterval) {
					updateInterval = setInterval(this, "doUpdateMakeupTexture", 100, selectedEntry.tintType, selectedEntry.tintIndex, event.texture);
				}
			}
			
			itemList.requestUpdate();
		}
		
		ShowMakeupPanel(false);
	}
	
	public function onChangeTexture(event: Object): Void
	{
		if(event.texture != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP) {
				if(!updateInterval) {
					updateInterval = setInterval(this, "doUpdateMakeupTexture", 100, selectedEntry.tintType, selectedEntry.tintIndex, event.texture);
				}
			}
		}
	}
	
	public function onSetColor(event: Object): Void
	{
		if(event.color != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
				selectedEntry.fillColor = event.color;
				if(!updateInterval) {
					updateInterval = setInterval(this, "doUpdateSliderColor", 100, selectedEntry.sliderID, event.color);
				}
			} else if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP) {
				selectedEntry.fillColor = event.color;
				if(!updateInterval) {
					updateInterval = setInterval(this, "doUpdateMakeupColor", 100, selectedEntry.tintType, selectedEntry.tintIndex, event.color);
				}
			}
			
			itemList.requestUpdate();
		}
		
		ShowColorField(false);
	}
	
	public function onChangeColor(event: Object): Void
	{
		if(event.color != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
				if(!updateInterval) {
					updateInterval = setInterval(this, "doUpdateSliderColor", 100, selectedEntry.sliderID, event.color);
				}
			} else if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP) {
				if(!updateInterval) {
					updateInterval = setInterval(this, "doUpdateMakeupColor", 100, selectedEntry.tintType, selectedEntry.tintIndex, event.color);
				}
			}
		}
	}
	
	public function doUpdateMakeupTexture(tintType: Number, tintIndex: Number, replacementTexture: String): Void
	{
		SendPlayerTexture(tintType, tintIndex, replacementTexture);
		clearInterval(updateInterval);
		delete updateInterval;
	}
	
	public function doUpdateMakeupColor(tintType: Number, tintIndex: Number, argbColor: Number): Void
	{
		SendPlayerTint(tintType, tintIndex, argbColor);
		clearInterval(updateInterval);
		delete updateInterval;
	}
	
	public function doUpdateSliderColor(sliderID: Number, argbColor: Number): Void
	{
		setPlayerColor(sliderID, argbColor);
		clearInterval(updateInterval);
		delete updateInterval;
	}
	
	// This function is a mess right now
	public function setPlayerColor(sliderID: Number, argbColor: Number): Void
	{
		var tintType: Number = -1;
		var tintIndex: Number = 0;
		var isFemale: Number = skse.GetPlayerSex();
		
		if(sliderID == undefined) {
			Debug.log("RSM Warning: Invalid sliderID.");
			return;
		}
		
		if(argbColor == undefined) {
			Debug.log("RSM Warning: Invalid color.");
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
		
		SendPlayerTint(tintType, tintIndex, argbColor);
	}
	
	private function SendPlayerTexture(tintType: Number, tintIndex: Number, replacementTexture: String)
	{
		skse.SendModEvent("RSM_TintTextureChange", replacementTexture, tintType * 1000 + tintIndex);
	}
	
	private function SendPlayerTint(tintType: Number, tintIndex: Number, argbColor: Number)
	{
		if(tintType == RaceMenuDefines.TINT_TYPE_HAIR) {
			skse.SendModEvent("RSM_HairColorChange", Number(argbColor).toString(), 0);
		} else if(tintType != -1) {
			skse.SendModEvent("RSM_TintColorChange", Number(argbColor).toString(), tintType * 1000 + tintIndex);
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
		} else if((entryObject.filterFlag & RaceMenuDefines.CATEGORY_COLOR) || (entryObject.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP)) {
			colorField.setText(entryObject.text);
			colorField.setColor(entryObject.fillColor);
			ShowColorField(true);
		}
		updateBottomBar();
	}
	
	private function onSelectionChange(event: Object): Void
	{
		itemList.listState.selectedEntry = itemList.entryList[event.index];
		if(itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_RACE) {
			raceDescription.textField.SetText(itemList.listState.selectedEntry.raceDescription);
			ShowRaceDescription(true);
			ShowRaceBonuses(_raceList[itemList.listState.selectedEntry.raceID], true);
		} else {
			ShowRaceBonuses(null, false);
			ShowRaceDescription(false);
			raceDescription.textField.SetText("");
		}
		GameDelegate.call("PlaySound",["UIMenuFocus"]);
		updateBottomBar();
	}
	
	private function updateBottomBar(): Void
	{
		navPanel.clearButtons();
		navPanel.addButton({text: "$Done", controls: _acceptControl});
		if(_platform == 0) {
			navPanel.addButton({text: "$Search", controls: _searchControl});
		} else {
			navPanel.addButton({text: "$Change Category", controls: InputDefines.Equip});
		}
		navPanel.addButton({text: playerZoom ? "$Zoom Out" : "$Zoom In", controls: _zoomControl});
		navPanel.addButton({text: bShowLight ? "$Light Off" : "$Light On", controls: _lightControl});
		
		if(itemList.listState.selectedEntry != itemList.listState.activeEntry && itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_RACE) {
			navPanel.addButton({text: "$Change Race", controls: _activateControl});
		} else if(itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
			navPanel.addButton({text: "$Choose Color", controls: _activateControl});
		} else if(itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP) {
			navPanel.addButton({text: "$Choose Color", controls: _activateControl});
			navPanel.addButton({text: "$Choose Texture", controls: _textureControl});
		}
		
		navPanel.updateButtons(true);
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
				return itemList.entryList[i];
			}
		}
		
		return null;
	}
	
	private function GetActorValueText(a_actorValue: Number): String
	{
		for(var i = 0; i < RaceMenuDefines.ACTORVALUE_MAP.length; i++)
		{
			if(RaceMenuDefines.ACTORVALUE_MAP[i].value == a_actorValue)
				return RaceMenuDefines.ACTORVALUE_MAP[i].text;
		}
		
		return "UNKAV " + a_actorValue;
	}
	
	private function SetSliderColors(a_update: Boolean): Void
	{
		var typesSet: Array = new Array();
		for(var i = 0; i < _tintTypes.length; i++) {
			if(_tintTypes[i] != 0 && _tintColors[i] != 0) {
				var skipType: Boolean = false;
				for(var k = 0; k < typesSet.length; k++) {
					if(typesSet[k] == _tintTypes[i]) {
						skipType = true;
						break;
					}
				}
				
				// Type was already found and the target value has no alpha
				if(skipType && _tintColors[i] <= 0x00FFFFFF)
					continue;
				
				var slider: Object = GetSliderByType(_tintTypes[i]);
				if(slider) {
					slider.fillColor = _tintColors[i];
					if(!skipType)
						typesSet.push(_tintTypes[i]);
				}
			}
		}
		
		if(a_update) {
			itemList.requestUpdate();
		}
	}
	
	/* PAPYRUS INTERFACE */
	public function RSM_AddSlider(a_name: String, a_section: String, a_callback: String, a_sliderMin: String, a_sliderMax: String, a_position: String, a_interval: String)
	{
		var newSliderID = customSliders.length + RaceMenuDefines.CUSTOM_SLIDER_OFFSET;
		var sliderObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: a_name, filterFlag: Number(a_section), callbackName: a_callback, sliderMin: Number(a_sliderMin), sliderMax: Number(a_sliderMax), sliderID: newSliderID, position: Number(a_position), interval: Number(a_interval), enabled: true};
		customSliders.push(sliderObject);
		itemList.entryList.push(sliderObject);
		itemList.requestInvalidate();
	}
	
	public function RSM_BeginMakeup()
	{
		_makeupNames.splice(0, _makeupNames.length);
		_makeupTextures.splice(0, _makeupTextures.length);
	}
	
	public function RSM_AddMakeupNames()
	{
		_makeupNames = _makeupNames.concat(arguments);
	}
	
	public function RSM_AddMakeupTextures()
	{
		_makeupTextures = _makeupTextures.concat(arguments);
	}
		
	public function RSM_EndMakeup()
	{
		for(var i = 0; i < _makeupNames.length; i++)
		{
			if(_makeupNames[i] != "" && _makeupTextures[i] != "") {
				makeupPanel.AddMakeup(_makeupNames[i], _makeupTextures[i]);
			}
		}
	}
		
	public function RSM_BeginSettings()
	{
		_tintTypes.splice(0, _tintTypes.length);
		_tintColors.splice(0, _tintColors.length);
		_tintTextures.splice(0, _tintTextures.length);
	}
	
	public function RSM_AddTintTypes()
	{
		_tintTypes = _tintTypes.concat(arguments);
	}
	
	public function RSM_AddTintColors()
	{
		_tintColors = _tintColors.concat(arguments);
	}
	
	public function RSM_AddTintTextures()
	{
		_tintTextures = _tintTextures.concat(arguments);
	}
	
	public function RSM_EndSettings()
	{
		SetSliderColors(false);
		SetMakeup(_tintTypes, _tintColors, _tintTextures, RaceMenuDefines.TINT_TYPE_WARPAINT);
	}
	
	public function RSM_BeginExtend()
	{
		bExtendRaceMode = true;
	}
	
	public function RSM_ExtendRace(a_object: Object)
	{
		if(a_object.formId != undefined) {
			skse.ExtendForm(a_object.formId, a_object, true, false);
		}
		_raceList.push(a_object);
	}
	
	public function RSM_EndExtend()
	{
		bExtendRaceMode = false;
	}
	
	/* Clipboard functions */
	public function RSM_SaveClipboard()
	{
		var outputString: String = "";
		for(var i = 0; i < arguments.length; i++) {
			outputString += "" + ((arguments[i]*100|0)/100) + "";
			
			if(i < arguments.length - 1) {
				outputString += ",";
			}
		}
		skse.SetClipboardData(outputString);
	}
	
	public function RSM_LoadClipboard()
	{
		var clipboardData: String = skse.GetClipboardData();
		var sliderArray: Array = clipboardData.split(',');
		
		for(var i = 0; i < sliderArray.length; i++) {
			skse.SendModEvent("RSM_ClipboardData", Number(i).toString(), Number(sliderArray[i]));
		}
		skse.SendModEvent("RSM_ClipboardFinished");
	}
	
	public function RSM_ToggleLoader(a_toggle: Boolean)
	{
		loadingIcon._visible = a_toggle;
	}
}