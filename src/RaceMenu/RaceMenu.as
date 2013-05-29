import gfx.events.EventDispatcher;
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
import skyui.filter.NameFilter;
import skyui.filter.SortFilter;
import skyui.util.GlobalFunctions;
import skyui.util.Debug;
import skyui.defines.Input;

import RaceMenuDefines;
import TextEntryField;
import ColorField;
import MakeupPanel;

class RaceMenu extends MovieClip
{
	/* PRIVATE VARIABLES */
	private var _platform: Number;
	private var _typeFilter: ItemTypeFilter;
	private var _nameFilter: NameFilter;
	private var _sortFilter: SortFilter;
	private var _panelX: Number;
	
	private var _updateInterval: Number;
	private var _pendingData: Object;
		
	private var _raceList: Array;
	
	public var makeupList: Array;
	
	private var ITEMLIST_HEIGHT_FULL = 528;
	private var ITEMLIST_HEIGHT_SHARED = 335;
	
	private var DESCRIPTION_WIDTH_FULL = 405;
	private var DESCRIPTION_WIDTH_SHARED = 262;
	
	/* CONTROLS */
	private var _activateControl: Object;
	private var _acceptControl: Object;
	private var _zoomControl: Object;
	private var _lightControl: Object;
	private var _textureControl: Object;
	private var _searchControl: Object;
	private var _loadPresetControl: Object;
	private var _savePresetControl: Object;
	
	/* PUBLIC VARIABLES */
	public var bLimitedMenu: Boolean;
	public var bPlayerZoom: Boolean = true;
	public var bShowLight: Boolean = true;
	public var bTextEntryMode: Boolean = false;
	public var bMenuInitialized: Boolean = false;
	public var bRaceChanging: Boolean = false;
	
	public var customSliders: Array;
	
	/* STAGE ELEMENTS */
	public var racePanel: MovieClip;
	public var itemList: RaceMenuList;
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
			
	function RaceMenu()
	{
		super();
		_global.tintCount = 0;
		_global.maxTints = RaceMenuDefines.MAX_TINTS;
		
		itemList = racePanel.itemList;
		categoryList = racePanel.categoryList;
		categoryLabel = racePanel.categoryLabel;
		searchWidget = racePanel.searchWidget;
		navPanel = bottomBar.buttonPanel;
		bonusList = raceDescription.bonusList;
		bonusPanel = bonusList;
		
		customSliders = new Array();
				
		_raceList = new Array();
		makeupList = new Array();
		makeupList.push(new Array()); // War Paint
		makeupList.push(new Array()); // Body Paint
		makeupList.push(new Array()); // Hand Paint
		makeupList.push(new Array()); // Feet Paint
		
		loadingIcon._visible = false;
		textEntry._visible = false;
		textEntry.enabled = false;
				
		GlobalFunc.MaintainTextFormat();
		GlobalFunc.SetLockFunction();
		
		EventDispatcher.initialize(this);
		
		_typeFilter = new ItemTypeFilter();
		_nameFilter = new NameFilter();
		_sortFilter = new SortFilter();
		
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
		
		ShowRaceBonuses(null, false);
		ShowRaceDescription(false);
		ShowColorField(false);
		ShowMakeupPanel(false);
		
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
		itemList.addEventListener("itemPressSecondary", this, "onItemPressSecondary");
		itemList.addEventListener("selectionChange", this, "onSelectionChange");
		categoryList.addEventListener("itemPress", this, "onCategoryPress");
		categoryList.addEventListener("selectionChange", this, "onCategoryChange");
		
		searchWidget.addEventListener("inputStart", this, "onSearchInputStart");
		searchWidget.addEventListener("inputEnd", this, "onSearchInputEnd");
		searchWidget.addEventListener("inputChange", this, "onSearchInputChange");
		
		textEntry.addEventListener("nameChange", this, "onNameChange");
		colorField.addEventListener("changeColor", this, "onChangeColor");
		makeupPanel.addEventListener("changeTexture", this, "onChangeTexture");
		
		// categoryList.iconArt = ["skyrim", "race", "body", "head", "face", "eyes", "brow", "mouth", "hair", "palette", "face", "skyrim"];
		categoryList.iconArt = ["skyrim", "race", "body", "head", "face", "eyes", "brow", "mouth", "hair"];
		categoryList.listState.iconSource = "racemenu/racesex_icons.swf";
		
		_sortFilter.setSortBy(["text"], [0]);
		
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: true, filterFlag: 1, text: "$ALL", flag: 508, savedItemIndex: -1, enabled: true});
		/*
		_raceList.push({skillBonuses: [{skill: 10, bonus: 255},
									   {skill: 11, bonus: 176},
									   {skill: 12, bonus: 45},
									   {skill: 13, bonus: 766},
									   {skill: 14, bonus: 465},
									   {skill: 15, bonus: 122},
									   {skill: 16, bonus: 11}
									   ]});
		
		// Test Code
		_global.skse = new Array();
				
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
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "TestRace1", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "TestRace1", equipState: 0, raceID: 10, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "TestRace2", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "TestRace2", equipState: 0, raceID: 11, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "TestRace3", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "TestRace3", equipState: 0, raceID: 12, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "TestRace4", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "TestRace4", equipState: 0, raceID: 13, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_RACE, text: "TestRace5", filterFlag: RaceMenuDefines.CATEGORY_RACE, raceDescription: "TestRace5", equipState: 0, raceID: 14, enabled: true});
		
		
		var isEnabled: Function = function(): Boolean { return true; }
		var colorIndex: Number = 0;	
		
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Sex", filterFlag: 4, callbackName: "ChangeSex", sliderMin: 0, sliderMax: 1, sliderID: -1, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Presets", filterFlag: 4, callbackName: "ChangeHeadPreset", sliderMin: 0, sliderMax: 0, sliderID: 0, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Skin Tone", filterFlag: 4 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 2892, sliderID: 1, position: 2885, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Weight", filterFlag: 4, callbackName: "ChangeWeight", sliderMin: 0, sliderMax: 1, sliderID: 2, position: 0, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Complexion", filterFlag: 8, callbackName: "ChangeFaceDetails", sliderMin: 0, sliderMax: 5, sliderID: 3, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Dirt", filterFlag: 8, callbackName: "ChangeMask", sliderMin: -1, sliderMax: 2, sliderID: 4, position: -1, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Dirt Color", filterFlag: 8 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeMaskColor", sliderMin: 1, sliderMax: 4, sliderID: 5, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Scars", filterFlag: 8, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 12, sliderID: 6, position: 7, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "War Paint", filterFlag: 8, callbackName: "ChangeMask", sliderMin: -1, sliderMax: 14, sliderID: 7, position: -1, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "War Paint Color", filterFlag: 8 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeMaskColor", sliderMin: 1, sliderMax: 23, sliderID: 8, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Hair", filterFlag: 256, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 69, sliderID: 9, position: 10, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Facial Hair", filterFlag: 256, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 45, sliderID: 10, position: 41, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Hair Color", filterFlag: 256 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeHairColorPreset", sliderMin: 0, sliderMax: 6594, sliderID: 11, position: 6578, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Shape", filterFlag: 32, callbackName: "ChangePreset", sliderMin: 0, sliderMax: 37, sliderID: 12, position: 1, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Color", filterFlag: 32, callbackName: "ChangeHeadPart", sliderMin: 0, sliderMax: 1, sliderID: 13, position: 0, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Height", filterFlag: 32, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 14, position: 0.5, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Width", filterFlag: 32, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 15, position: -0.059999998658895, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Depth", filterFlag: 32, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 16, position: -0.63999998569489, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eyeliner Color", filterFlag: 32 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 3, sliderID: 17, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Shadow", filterFlag: 32 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 7, sliderID: 18, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Eye Tint", filterFlag: 32 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 7, sliderID: 19, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
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
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Cheek Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 6, sliderID: 32, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Laugh Lines", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 3, sliderID: 33, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Cheek Color Lower", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 6, sliderID: 34, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Nose Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 5, sliderID: 35, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 4, sliderID: 36, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Neck Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 4, sliderID: 37, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Forehead Color", filterFlag: 16 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 3, sliderID: 38, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Mouth Shape", filterFlag: 128, callbackName: "ChangePreset", sliderMin: 0, sliderMax: 30, sliderID: 39, position: 19, interval: 1, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Mouth Height", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 40, position: 0.66000002622604, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Mouth Forward", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 41, position: 0.15999999642372, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Width", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 42, position: -0.34000000357628, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Length", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 43, position: -0.40000000596046, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Chin Forward", filterFlag: 128, callbackName: "ChangeDoubleMorph", sliderMin: -1, sliderMax: 1, sliderID: 44, position: 0.18000000715256, interval: 0.10000000149012, enabled: true});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: "Lip Color", filterFlag: 128 + RaceMenuDefines.CATEGORY_COLOR, callbackName: "ChangeTintingMask", sliderMin: 0, sliderMax: 7, sliderID: 45, position: 0, interval: 1, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_MAKEUP, text: "MyNigga", texture: "actors\\character\\Character assets\\tintmasks\\femalenordeyelinerstyle_01.dds", filterFlag: RaceMenuDefines.CATEGORY_MAKEUP, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, isTextureEnabled: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
		itemList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_MAKEUP, text: "MyNigga2", texture: "actors/character/Character assets/tintmasks/femalenordeyelinerstyle_01.dds", filterFlag: RaceMenuDefines.CATEGORY_MAKEUP, enabled: true, isColorEnabled: isEnabled, hasColor: isEnabled, isTextureEnabled: isEnabled, tintType: RaceMenuDefines.TINT_MAP[colorIndex++]});
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
		racePanel.Lock("L");
		raceDescription.Lock("L");
		bottomBar["playerInfo"].Lock("R");
		
		_panelX = racePanel._x;

		//raceDescription._x = racePanel._x + raceDescription._width / 2 + racePanel._width + 15;
		//raceDescription._y = bottomBar._y - raceDescription._height / 2 - 15;
		
		//bonusPanel._x = racePanel._x + bonusPanel._width / 2 + racePanel._width + 10;
		//bonusPanel._y = bottomBar._y - bonusPanel._height / 2 - 10;
		
		//bonusPanel._x = raceDescription._x + bonusPanel._width / 2 + raceDescription._width / 2 + 15;
		//bonusPanel._y = raceDescription._y;
		
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
			_activateControl = Input.Activate;
			_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_lightControl = {keyCode: GlobalFunctions.getMappedKey("Sneak", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_zoomControl = {keyCode: GlobalFunctions.getMappedKey("Sprint", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_searchControl = Input.Jump;
			_textureControl = Input.Wait;
			_savePresetControl = {keyCode: GlobalFunctions.getMappedKey("Quicksave", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_loadPresetControl = {keyCode: GlobalFunctions.getMappedKey("Quickload", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
		} else {
			_activateControl = Input.Activate;
			_acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_lightControl = Input.Wait;
			_zoomControl = {keyCode: GlobalFunctions.getMappedKey("Sprint", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_textureControl = Input.YButton;
			_searchControl = null;
			_savePresetControl = {keyCode: GlobalFunctions.getMappedKey("Toggle POV", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_loadPresetControl = {keyCode: GlobalFunctions.getMappedKey("Sneak", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
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
	
	public function IsBoundKeyPressed(details: InputDetails, boundKey: Object, platform: Number): Boolean
	{
		return ((details.control && details.control == boundKey.name) || (details.skseKeycode && boundKey.name && boundKey.context && details.skseKeycode == GlobalFunctions.getMappedKey(boundKey.name, Number(boundKey.context), platform != 0)) || (details.skseKeycode && details.skseKeycode == boundKey.keyCode));
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
			
		if (GlobalFunc.IsKeyPressed(details)) {
			if (IsBoundKeyPressed(details, _searchControl, _platform) && _platform == 0) {
				onSearchClicked();
				return true;
			} else if (IsBoundKeyPressed(details, _zoomControl, _platform) && !bTextEntryMode) {
				onZoomClicked();
				return true;
			} else if(IsBoundKeyPressed(details, _lightControl, _platform) && !bTextEntryMode) {
				onLightClicked();
				return true;
			} else if(IsBoundKeyPressed(details, _loadPresetControl, _platform) && !bTextEntryMode) {
				onLoadPresetClicked();
				return true;
			} else if(IsBoundKeyPressed(details, _savePresetControl, _platform) && !bTextEntryMode) {
				onSavePresetClicked();
				return true;
			}
		}
		
		if(itemList.handleInput(details, pathToFocus)) {
			return true;
		}
		
		if(categoryList.handleInput(details, pathToFocus)) {
			return true;
		}
		
		/*var nextClip = pathToFocus.shift();
		if (nextClip.handleInput(details, pathToFocus)) {
			return true;
		}*/
		
		return false;
	}
	
	/* Component Toggles */
	public function ShowTextEntry(abShowTextEntry: Boolean): Void
	{
		itemList.invalidateSelection();
		textEntry._visible = textEntry.enabled = abShowTextEntry;
		if(abShowTextEntry) {
			if(colorField._visible) {
				ShowColorField(false);
			} else if(makeupPanel._visible) {
				ShowMakeupPanel(false);
			}
			textEntry.updateButtons(true);
			FocusHandler.instance.setFocus(textEntry, 0);
		} else {
			FocusHandler.instance.setFocus(itemList, 0);
		}
		
		ShowRacePanel(!abShowTextEntry);
		ShowBottomBar(!abShowTextEntry);
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
		GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
	}
	
	public function ShowColorField(bShowField: Boolean): Void
	{
		colorField._visible = colorField.enabled = bShowField;
		colorField.ResetSlider();
		if(bShowField) {
			colorField.updateButtons(true);
			FocusHandler.instance.setFocus(colorField.colorSelector, 0);
		} else {
			FocusHandler.instance.setFocus(itemList, 0);
		}
		ShowRacePanel(!bShowField);
		ShowBottomBar(!bShowField);
	}
	
	public function ShowRaceDescription(bShowDescription: Boolean): Void
	{
		var toggled: Boolean = (raceDescription._visible != bShowDescription);
		raceDescription._visible = raceDescription.enabled = bShowDescription;
		if(bShowDescription) {
			itemList.listHeight = ITEMLIST_HEIGHT_SHARED;
		} else {
			itemList.listHeight = ITEMLIST_HEIGHT_FULL;
		}
		
		if(toggled) {
			itemList.requestInvalidate();
		}
	}
	
	public function ShowRaceBonuses(a_race: Object, bShowBonuses: Boolean): Void
	{
		bonusPanel._visible = bonusPanel.enabled = (bShowBonuses && _global.skse);
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
		if(bonusPanel._visible) {
			raceDescription.textField._width = DESCRIPTION_WIDTH_SHARED;
		} else {
			raceDescription.textField._width = DESCRIPTION_WIDTH_FULL;
		}
	}
	
	public function ShowMakeupPanel(bShowPanel: Boolean): Void
	{
		makeupPanel._visible = makeupPanel.enabled = bShowPanel;
		if(bShowPanel) {
			FocusHandler.instance.setFocus(makeupPanel.makeupList, 0);
		} else {
			FocusHandler.instance.setFocus(itemList, 0);
		}
		
		ShowRacePanel(!bShowPanel);
		ShowBottomBar(!bShowPanel);
	}
	
	public function ShowRacePanel(bShowPanel: Boolean): Void
	{
		if(bShowPanel) {
			categoryList.disableSelection = categoryList.disableInput = false;
			itemList.disableSelection = itemList.disableInput = false;
			searchWidget.isDisabled = false;
			TweenLite.to(racePanel, 0.5, {_alpha: 100, _x: _panelX, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			categoryList.disableSelection = categoryList.disableInput = true;
			itemList.disableSelection = itemList.disableInput = true;
			searchWidget.isDisabled = true;
			TweenLite.to(racePanel, 0.5, {_alpha: 0, _x: -478, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function ShowBottomBar(bShowBottomBar: Boolean): Void
	{
		if(bShowBottomBar) {
			TweenLite.to(bottomBar, 0.5, {_alpha: 100, _y: 645, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		} else {
			TweenLite.to(bottomBar, 0.5, {_alpha: 0, _y: 745, overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		}
	}
	
	public function onNameChange(event: Object): Void
	{
		if (event.nameChanged == true) {
			/* ECE Compatibility Start */
			if(_global.skse.plugins.ExCharGen) {
				if(_global.skse.plugins.ExCharGen.SaveSliderData != undefined)
					_global.skse.plugins.ExCharGen.SaveSliderData();
			}
			/* ECE Compatibility End */
			GameDelegate.call("ChangeName", [textEntry.TextInputInstance.text]);
			ShowTextEntry(false);
			ShowRacePanel(false);
			ShowBottomBar(false);
		} else {
			GameDelegate.call("ChangeName", []);
			ShowTextEntry(false);
		}
		
		GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
	}
	
	public function HideLoadingIcon(): Void
	{
		loadingIcon._visible = false;
		if(bRaceChanging) {
			skse.SendModEvent("RSM_RaceChanged");
			bRaceChanging = false;
		}
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
		categoryList.iconArt = ["skyrim", "race", "body", "head", "face", "eyes", "brow", "mouth", "hair"];
		categoryList.entryList.splice(1, categoryList.entryList.length - 1);
		
		var categoryCount: Number = 1;
		for (var i: Number = 0; i < arguments.length; i += RaceMenuDefines.CAT_STRIDE) {
			var entryObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: arguments[i + RaceMenuDefines.CAT_TEXT].toUpperCase(), flag: arguments[i + RaceMenuDefines.CAT_FLAG], enabled: true};			
			if(bLimitedMenu && entryObject.flag & RaceMenuDefines.CATEGORY_RACE) {
				entryObject.filterFlag = 0;
			}
			categoryList.entryList.push(entryObject);
			categoryCount++;
		}
		
		if(categoryCount > categoryList.iconArt.length) {
			for(var i = 0; i < categoryCount - categoryList.iconArt.length; i++)
				categoryList.iconArt.push("skyrim");
		}
		
		categoryList.iconArt.push("palette");
		categoryList.iconArt.push("face");
		
		// Add the new categories
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$COLORS", flag: RaceMenuDefines.CATEGORY_COLOR, enabled: true});
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: (_global.skse != undefined), text: "$MAKEUP", flag: RaceMenuDefines.CATEGORY_WARPAINT, enabled: true});
		
		if(_global.skse.plugins.NiOverride) {
			categoryList.iconArt.push("body");
			categoryList.iconArt.push("hand");
			categoryList.iconArt.push("feet");
			categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$BODY PAINT", flag: RaceMenuDefines.CATEGORY_BODYPAINT, enabled: true});
			categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$HAND PAINT", flag: RaceMenuDefines.CATEGORY_HANDPAINT, enabled: true});
			categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$FOOT PAINT", flag: RaceMenuDefines.CATEGORY_FEETPAINT, enabled: true});
			categoryList.iconSize = 28;
		}
		
		if(_global.skse.plugins.ExCharGen) {
			categoryList.iconArt.push("skyrim");
			categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$ENHANCED", flag: RaceMenuDefines.CATEGORY_ECE, enabled: true});
		}
		
		for(var i = 0; i < categoryList.iconArt.length; i++)
			skse.Log(categoryList.iconArt[i]);
		
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
		
		var colorIndex: Number = 0;
		for (var i: Number = 0; i < arguments.length; i += RaceMenuDefines.SLIDER_STRIDE) {
			var entryObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: arguments[i + RaceMenuDefines.SLIDER_NAME], filterFlag: arguments[i + RaceMenuDefines.SLIDER_FILTERFLAG], callbackName: arguments[i + RaceMenuDefines.SLIDER_CALLBACKNAME], sliderMin: arguments[i + RaceMenuDefines.SLIDER_MIN], sliderMax: arguments[i + RaceMenuDefines.SLIDER_MAX], sliderID: arguments[i + RaceMenuDefines.SLIDER_ID], position: arguments[i + RaceMenuDefines.SLIDER_POSITION], interval: arguments[i + RaceMenuDefines.SLIDER_INTERVAL], enabled: true};
						
			// Add new category
			if(entryObject.callbackName == "ChangeTintingMask" || entryObject.callbackName == "ChangeMaskColor" || entryObject.callbackName == "ChangeHairColorPreset") {
				entryObject.filterFlag += RaceMenuDefines.CATEGORY_COLOR;
				entryObject.tintType = RaceMenuDefines.TINT_MAP[colorIndex];
				entryObject.isColorEnabled = function(): Boolean
				{
					return (_global.skse && (_global.tintCount < _global.maxTints || (this.fillColor >>> 24) != 0 || this.tintType == RaceMenuDefines.TINT_TYPE_HAIR)) || !_global.skse;
				}
				entryObject.hasColor = function(): Boolean { return true; }
				colorIndex++;
			} else {
				entryObject.hasColor = function(): Boolean { return false; }
			}
			if(entryObject.callbackName == "ChangeWeight") {
				entryObject.interval = 0.01;
			}
			
			entryObject.GetTextureList = function(raceMenu: Object): Array { return null; }
			
			itemList.entryList.push(entryObject);
		}
				
		if(!_updateInterval) {
			_updateInterval = setInterval(this, "InitializeSliders", 500);
		}
	}
	
	public function InitializeSliders()
	{
		if(!bMenuInitialized) {
			skse.SendModEvent("RSM_Initialized");
			bMenuInitialized = true;
		} else {
			skse.SendModEvent("RSM_Reinitialized");
		}
		
		skse.SendModEvent("RSM_RequestSliders");
		
		/* ECE Compatibility Start */
		var ECECharGen: Object = _global.skse.plugins.ExCharGen;
		if(ECECharGen) {
			var raceArray: Array = new Array();
			var extraSliders: Array = new Array();
			var sliderValues: Array = new Array();
			
			ECECharGen.itemList = this.itemList;
			ECECharGen.sliders = new Array();
			ECECharGen.GetPlayerRaceName(raceArray);
			ECECharGen.raceName = raceArray[0].text;
			ECECharGen.GetList(ECECharGen.raceName, extraSliders, 10000);
			
			for(var i = 0; i < extraSliders.length; i++) {
				if(extraSliders[i].type >= 0 && extraSliders[i].type <= 4) {
					if(extraSliders[i].text == undefined)
						continue;
					
					var newSliderID = ECECharGen.sliders.length + RaceMenuDefines.ECE_SLIDER_OFFSET;
					var sliderObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: extraSliders[i].text, filterFlag: RaceMenuDefines.CATEGORY_ECE, callbackName: "ChangeDoubleMorph", sliderMin: extraSliders[i].sliderMin, sliderMax: extraSliders[i].sliderMax, sliderID: newSliderID, position: 0, interval: extraSliders[i].interval, uniqueID: extraSliders[i].uniqueID, ECESlider: true, enabled: true};
					ECECharGen.sliders.push(sliderObject);
					itemList.entryList.push(sliderObject);
				}
			}
			
			ECECharGen.slotNumber = 0;
			ECECharGen.GetSlotData(ECECharGen.raceName, ECECharGen.slotNumber, sliderValues);
			for(var i = 0; i < ECECharGen.sliders.length; i++) {
				for(var k = 0; k < sliderValues.length; k++) {
					if(ECECharGen.sliders[i].uniqueID == sliderValues[k].uniqueID) {
						ECECharGen.sliders[i].position = sliderValues[k].position;
						continue;
					}
				}
			}
			
			ECECharGen.UpdateMorphs = function()
			{
				var info: Array = new Array();
				for(var i = 0; i < this.sliders.length; i++) {
					info.push(this.sliders[i].uniqueID);
					info.push(this.sliders[i].position);
				}
				
				this.SetPlayerPreset(0, 33);
				
				if(this.slotNumber > 0) {
					this.SetMergedMorphs(this.raceName, info, this.slotNumber);
				}
				
				this.SetMergedMorphsMemory(this.raceName, info, this.slotNumber);
			}
			ECECharGen.LoadSliderData = function()
			{
				_global.skse.SendModEvent("ExCharGen_GetSliderPos");
			}
			ECECharGen.SaveSliderData = function()
			{
				var str: String = "version,2,"; // slider version.
				for (var i: Number = 0; i < this.sliders.length; i++) {
					str += this.sliders[i].uniqueID + "," + this.sliders[i].position + ",";
				}
				str = str.substr(0, str.length - 1);
				_global.skse.SendModEvent("ExCharGen_SetSliderPos", str);
			}
			this["ExCharGenGetListCallback"] = function(str: String)
			{
				var ECECharGen: Object = _global.skse.plugins.ExCharGen;
				if(ECECharGen) {
					var sliderParams: Array = str.split(",");
					sliderParams.splice(0, 2);
					for(var i = 0; i < sliderParams.length; i += 2) {
						var uniqueID: Number = Number(sliderParams[i]);
						var position: Number = Number(sliderParams[i + 1]);
						for(var k = 0; k < ECECharGen.sliders.length; k++) {
							if(ECECharGen.sliders[k].uniqueID == uniqueID) {
								ECECharGen.sliders[k].position = position;
								break;
							}
						}
					}
				}
				
				ECECharGen.itemList.requestUpdate();
			}
			
			ECECharGen.LoadSliderData();
		}
		/* ECE Compatibility End */
		
		itemList.requestInvalidate();
		clearInterval(_updateInterval);
		delete _updateInterval;
	}
	
	public function SetMakeup(a_types: Array, a_colors: Array, a_textures: Array, a_tintType: Number, a_categoryFilter: Number, a_makeupType: Number, a_entryType: Number): Void
	{
		// Remove only Makeup types
		if(itemList.entryList.length > 0) {
			for(var k: Number = itemList.entryList.length; k >= 0; k--) {
				if(itemList.entryList[k].type == a_entryType)
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
			
			var entryObject: Object = {type: a_entryType, listType: a_makeupType, text: displayText, texture: nTintTexture, tintType: nTintType, tintIndex: nTintIndex, fillColor: nTintColor, filterFlag: a_categoryFilter, enabled: true};
			entryObject.isColorEnabled = function(tintColors: Number): Boolean
			{
				return (_global.skse && (_global.tintCount < _global.maxTints || (this.fillColor >>> 24) != 0));
			}
			entryObject.GetTextureList = function(raceMenu: Object): Array { return raceMenu.makeupList[this.listType]; }
			entryObject.hasColor = function(): Boolean { return true; }
			
			itemList.entryList.push(entryObject);
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
		itemList.listState.focusEntry = null;
		itemList.selectedIndex = -1;
		//GameDelegate.call("PlaySound",["UIMenuFocus"]);
		GameDelegate.call("PlaySound", ["UIMenuPrevNext"]);
	}
		
	public function onChangeTexture(event: Object): Void
	{
		if(event.texture != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(isMakeup(selectedEntry.tintType)) {
				if(event.apply) {
					selectedEntry.text = event.displayText;
					selectedEntry.texture = event.texture;
				}
				requestUpdate({type: "makeupTexture", tintType: selectedEntry.tintType, tintIndex: selectedEntry.tintIndex, replacementTexture: event.texture});
			}
			
			if(event.apply)
				itemList.requestUpdate();
		}
		
		if(event.apply) {
			ShowMakeupPanel(false);
			GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
		}
	}
	
	public function onChangeColor(event: Object): Void
	{
		if(event.color != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
				if(event.apply) {
					// Update Tint Count
					if(selectedEntry.tintType != RaceMenuDefines.TINT_TYPE_HAIR && (selectedEntry.fillColor >>> 24) == 0 && (event.color >>> 24) != 0) {
						_global.tintCount++;
						UpdateTintCount();
					} else if(selectedEntry.tintType != RaceMenuDefines.TINT_TYPE_HAIR && (selectedEntry.fillColor >>> 24) != 0 && (event.color >>> 24) == 0) {
						_global.tintCount--;
						UpdateTintCount();
					}
					selectedEntry.fillColor = event.color;
				}
				requestUpdate({type: "sliderColor", slider: selectedEntry, argbColor: event.color});
			} else if(isMakeup(selectedEntry.tintType)) {
				if(event.apply) {
					// Update Tint Count
					if(selectedEntry.tintType != RaceMenuDefines.TINT_TYPE_HAIR && (selectedEntry.fillColor >>> 24) == 0 && (event.color >>> 24) != 0) {
						_global.tintCount++;
						UpdateTintCount();
					} else if(selectedEntry.tintType != RaceMenuDefines.TINT_TYPE_HAIR && (selectedEntry.fillColor >>> 24) != 0 && (event.color >>> 24) == 0) {
						_global.tintCount--;
						UpdateTintCount();
					}
					selectedEntry.fillColor = event.color;
				}
				requestUpdate({type: "makeupColor", tintType: selectedEntry.tintType, tintIndex: selectedEntry.tintIndex, argbColor: event.color});
			}
			
			if(event.apply)
				itemList.requestUpdate();
		}
		
		if(event.apply) {
			ShowColorField(false);
			GameDelegate.call("PlaySound", ["UIMenuBladeCloseSD"]);
		}
	}
	
	public function isMakeup(tintType: Number): Boolean
	{
		return tintType == RaceMenuDefines.TINT_TYPE_WARPAINT || isOverlayType(tintType);
	}
	
	public function isOverlayType(tintType: Number): Boolean
	{
		return (tintType == RaceMenuDefines.TINT_TYPE_BODYPAINT ||
				  tintType == RaceMenuDefines.TINT_TYPE_HANDPAINT ||
				  tintType == RaceMenuDefines.TINT_TYPE_FEETPAINT);
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
		switch(_pendingData.type) {
			case "makeupTexture":
			SendPlayerTexture(_pendingData.tintType, _pendingData.tintIndex, _pendingData.replacementTexture);
			break;
			case "makeupColor":
			SendPlayerTint(_pendingData.tintType, _pendingData.tintIndex, _pendingData.argbColor);
			break;
			case "sliderColor":
			SendPlayerTintBySlider(_pendingData.slider, _pendingData.argbColor);
			break;
		}
				
		clearInterval(_updateInterval);
		delete _updateInterval;
		delete _pendingData;
	}
	
	// This function is a mess right now
	public function SendPlayerTintBySlider(slider: Object, argbColor: Number): Void
	{
		var tintType: Number = slider.tintType;
		var tintIndex: Number = 0;
		
		if(argbColor == undefined) {
			Debug.log("RSM Warning: Invalid color.");
			return;
		}
						
		// Apply warpaint color based on warpaint slider value
		if(tintType == RaceMenuDefines.TINT_TYPE_WARPAINT) {
			for(var i: Number = 0; i < itemList.entryList.length; i++) {
				if(itemList.entryList[i].sliderID == RaceMenuDefines.STATIC_SLIDER_WARPAINT) {
					tintIndex = itemList.entryList[i].position;
					break;
				}
			}
		}
		
		// Apply dirt color based on dirt slider value
		if(tintType == RaceMenuDefines.TINT_TYPE_DIRT) {
			for(var i: Number = 0; i < itemList.entryList.length; i++) {
				if(itemList.entryList[i].sliderID == RaceMenuDefines.STATIC_SLIDER_DIRT) {
					tintIndex = itemList.entryList[i].position;
					break;
				}
			}
		}
		
		SendPlayerTint(tintType, tintIndex, argbColor);
	}
	
	private function SendPlayerTexture(tintType: Number, tintIndex: Number, replacementTexture: String)
	{
		if(isOverlayType(tintType)) {
			skse.SendModEvent("RSM_OverlayTextureChange", replacementTexture, tintType * 1000 + tintIndex);
		} else {
			skse.SendModEvent("RSM_TintTextureChange", replacementTexture, tintType * 1000 + tintIndex);
		}
	}
	
	private function SendPlayerTint(tintType: Number, tintIndex: Number, argbColor: Number)
	{
		if(tintType == RaceMenuDefines.TINT_TYPE_HAIR) {
			skse.SendModEvent("RSM_HairColorChange", Number(argbColor).toString(), 0);
		} else if(isOverlayType(tintType)) {
			skse.SendModEvent("RSM_OverlayColorChange", Number(argbColor).toString(), tintType * 1000 + tintIndex);
		} else if(tintType != -1) {
			skse.SendModEvent("RSM_TintColorChange", Number(argbColor).toString(), tintType * 1000 + tintIndex);
		}
	}
	
	private function onItemPress(event: Object): Void
	{
		var pressedEntry: Object = itemList.entryList[event.index];
		if(pressedEntry != itemList.listState.activeEntry && pressedEntry.type == RaceMenuDefines.ENTRY_TYPE_RACE) {
			itemList.listState.activeEntry = pressedEntry;
			itemList.requestUpdate();
			loadingIcon._visible = true;
			GameDelegate.call("ChangeRace", [pressedEntry.raceID, -1]);
			bRaceChanging = true;
			bPlayerZoom = true; // Reset zoom, this happens when race is changed
			updateBottomBar();
		} else if(pressedEntry.isColorEnabled()) {
			colorField.setText(pressedEntry.text);
			colorField.setColor(pressedEntry.fillColor);
			GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
			ShowColorField(true);
		}/* else {
			itemList.listState.focusEntry = entryObject;
			itemList.requestUpdate();
		}*/
	}
	
	private function onItemPressSecondary(event: Object): Void
	{
		var pressedEntry: Object = itemList.entryList[event.index];
		var textureList: Array = pressedEntry.GetTextureList(this);
		if(textureList) {
			makeupPanel.clearFilter();
			makeupPanel.setMakeupList(textureList);
			makeupPanel.updateButtons(true);
			makeupPanel.setSelectedEntry(pressedEntry.texture);
			makeupPanel.setTexture(pressedEntry.text, pressedEntry.texture);
			GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
			ShowMakeupPanel(true);
		}
	}
	
	private function onSelectionChange(event: Object): Void
	{
		var selectedEntry: Object = itemList.entryList[event.index];
		itemList.listState.selectedEntry = selectedEntry;
		if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_RACE) {
			raceDescription.textField.SetText(selectedEntry.raceDescription);
			ShowRaceDescription(true);
			ShowRaceBonuses(_raceList[selectedEntry.raceID], true);
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
		navPanel.addButton({text: "$Done", controls: _acceptControl}).addEventListener("click", this, "onDoneClicked");
		if(_platform == 0) {
			navPanel.addButton({text: "$Search", controls: _searchControl}).addEventListener("click", this, "onSearchClicked");
		}
		navPanel.addButton({text: bPlayerZoom ? "$Zoom Out" : "$Zoom In", controls: _zoomControl}).addEventListener("click", this, "onZoomClicked");
		
		if(_global.skse)
			navPanel.addButton({text: bShowLight ? "$Light Off" : "$Light On", controls: _lightControl}).addEventListener("click", this, "onLightClicked");
		
		var selectedEntry = itemList.listState.selectedEntry;
		if(selectedEntry != itemList.listState.activeEntry && selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_RACE)
			navPanel.addButton({text: "$Change Race", controls: _activateControl}).addEventListener("click", this, "onChangeRaceClicked");
		if(selectedEntry.isColorEnabled())
			navPanel.addButton({text: "$Choose Color", controls: _activateControl}).addEventListener("click", this, "onChooseColorClicked");
		if(selectedEntry.GetTextureList(this))
			navPanel.addButton({text: "$Choose Texture", controls: _textureControl}).addEventListener("click", this, "onChooseTextureClicked");
			
		navPanel.addButton({text: "$Load Preset", controls: _loadPresetControl}).addEventListener("click", this, "onLoadPresetClicked");
		navPanel.addButton({text: "$Save Preset", controls: _savePresetControl}).addEventListener("click", this, "onSavePresetClicked");
		
		navPanel.updateButtons(true);		
	}
	
	private function onDoneClicked(): Void
	{
		if(colorField._visible || textEntry._visible || makeupPanel._visible)
			return;
		
		GameDelegate.call("ConfirmDone", []);
	}
	
	private function onSearchClicked(): Void
	{
		if(colorField._visible || textEntry._visible || makeupPanel._visible)
			return;
		
		searchWidget.startInput();
	}
	
	private function onZoomClicked(): Void
	{
		if(colorField._visible || textEntry._visible || makeupPanel._visible)
			return;
		
		bPlayerZoom = !bPlayerZoom;
		GameDelegate.call("ZoomPC", [bPlayerZoom]);
		updateBottomBar();
	}
	
	private function onLightClicked(): Void
	{
		if(colorField._visible || textEntry._visible || makeupPanel._visible)
			return;
		
		bShowLight = !bShowLight;
		skse.SendModEvent("RSM_ToggleLight", "", Number(bShowLight));
		updateBottomBar();
	}
	
	private function onChangeRaceClicked(): Void
	{
		if(colorField._visible || textEntry._visible || makeupPanel._visible)
			return;
		
		var selectedEntry = itemList.listState.selectedEntry
		if(selectedEntry) {
			itemList.listState.activeEntry = selectedEntry;
			itemList.requestUpdate();
			loadingIcon._visible = true;
			GameDelegate.call("ChangeRace", [selectedEntry.raceID, -1]);
			bRaceChanging = true;
			bPlayerZoom = true; // Reset zoom, this happens when race is changed
			updateBottomBar();
		}
	}
	
	private function onChooseColorClicked(): Void
	{
		if(colorField._visible || textEntry._visible || makeupPanel._visible)
			return;
		
		var selectedEntry = itemList.listState.selectedEntry;
		if(selectedEntry.isColorEnabled()) {
			colorField.setText(selectedEntry.text);
			colorField.setColor(selectedEntry.fillColor);
			GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
			ShowColorField(true);
		}
	}
	
	private function onChooseTextureClicked(): Void
	{
		if(colorField._visible || textEntry._visible || makeupPanel._visible)
			return;
		
		var selectedEntry = itemList.listState.selectedEntry;
		var textureList: Array = selectedEntry.GetTextureList(this);
		if(textureList) {
			makeupPanel.clearFilter();
			makeupPanel.setMakeupList(textureList);
			makeupPanel.updateButtons(true);
			makeupPanel.setSelectedEntry(selectedEntry.texture);
			makeupPanel.setTexture(selectedEntry.text, selectedEntry.texture);
			GameDelegate.call("PlaySound", ["UIMenuBladeOpenSD"]);
			ShowMakeupPanel(true);
		}
	}
	
	private function onSavePresetClicked(): Void
	{
		skse.SendModEvent("RSM_RequestSaveClipboard");
	}
	
	private function onLoadPresetClicked(): Void
	{
		skse.SendModEvent("RSM_RequestLoadClipboard");
	}
	
	private function GetSliderByType(tintType: Number): Object
	{
		for(var i = 0; i < itemList.entryList.length; i++)
		{
			if(itemList.entryList[i].tintType == tintType) {
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
	
	private function SetSliderColors(tintTypes: Array, tintColors: Array): Void
	{
		var typesSet: Array = new Array();
		for(var i = 0; i < tintTypes.length; i++) {
			if(tintTypes[i] != 0 && tintColors[i] != 0) {
				var skipType: Boolean = false;
				for(var k = 0; k < typesSet.length; k++) {
					if(typesSet[k] == tintTypes[i]) {
						skipType = true;
						break;
					}
				}
				
				// Type was already found and the target value has no alpha
				if(skipType && tintColors[i] <= 0x00FFFFFF)
					continue;
				
				var slider: Object = GetSliderByType(tintTypes[i]);
				if(slider) {
					slider.fillColor = tintColors[i];
					if(!skipType)
						typesSet.push(tintTypes[i]);
				}
			}
		}
	}
	
	private function UpdateTintCount(): Void
	{
		racePanel.tintCount.text = "(" + _global.tintCount + "/" + _global.maxTints + ")";
	}
	
	public function AddMakeup(a_type: Number, a_array: Array, a_name: String, a_texture: String)
	{
		var makeupObject: Object = {type: a_type, text: a_name, texture: a_texture, filterFlag: 1, enabled: true};
				
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
		
		a_array.push(makeupObject);
	}
	
	/* PAPYRUS INTERFACE */
	public function RSM_AddSliders()
	{
		for(var i = 0; i < arguments.length; i++)
		{
			var sliderParams: Array = arguments[i].split(";;");
			if(sliderParams[0] != "") {
				var newSliderID = customSliders.length + RaceMenuDefines.CUSTOM_SLIDER_OFFSET;
				var sliderObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: sliderParams[0], filterFlag: Number(sliderParams[1]), callbackName: sliderParams[2], sliderMin: Number(sliderParams[3]), sliderMax: Number(sliderParams[4]), sliderID: newSliderID, position: Number(sliderParams[6]), interval: Number(sliderParams[5]), enabled: true};
				customSliders.push(sliderObject);
				itemList.entryList.push(sliderObject);
				itemList.requestInvalidate();
			}
		}
	}
	
	public function RSM_SetSliderParameters()
	{
		for(var i = 0; i < customSliders.length; i++) {
			if(customSliders[i].callbackName.toLower() == arguments[0].toLower()) {
				customSliders[i].sliderMin = Number(arguments[1]);
				customSliders[i].sliderMax = Number(arguments[2]);
				customSliders[i].interval = Number(arguments[3]);
				customSliders[i].position = Number(arguments[4]);
				itemList.requestUpdate();
				break;
			}
		}
	}

	public function RSM_AddWarpaints()
	{
		for(var i = 0; i < arguments.length; i++)
		{
			var warpaintParams: Array = arguments[i].split(";;");
			if(warpaintParams[0] != "" && warpaintParams[1] != "") {
				var a_name: String = warpaintParams[0];
				var a_texture: String = warpaintParams[1];
				
				AddMakeup(RaceMenuDefines.ENTRY_TYPE_WARPAINT, makeupList[RaceMenuDefines.PAINT_FACE], a_name, a_texture);
			}
		}
	}
	
	public function RSM_AddBodyPaints()
	{
		for(var i = 0; i < arguments.length; i++)
		{
			var bodypaintParams: Array = arguments[i].split(";;");
			if(bodypaintParams[0] != "" && bodypaintParams[1] != "") {
				var a_name: String = bodypaintParams[0];
				var a_texture: String = bodypaintParams[1];
				
				AddMakeup(RaceMenuDefines.ENTRY_TYPE_BODYPAINT, makeupList[RaceMenuDefines.PAINT_BODY], a_name, a_texture);
			}
		}
	}
	
	public function RSM_AddHandPaints()
	{
		for(var i = 0; i < arguments.length; i++)
		{
			var handpaintParams: Array = arguments[i].split(";;");
			if(handpaintParams[0] != "" && handpaintParams[1] != "") {
				var a_name: String = handpaintParams[0];
				var a_texture: String = handpaintParams[1];
				
				AddMakeup(RaceMenuDefines.ENTRY_TYPE_HANDPAINT, makeupList[RaceMenuDefines.PAINT_HAND], a_name, a_texture);
			}
		}
	}
	
	public function RSM_AddFeetPaints()
	{
		for(var i = 0; i < arguments.length; i++)
		{
			var feetpaintParams: Array = arguments[i].split(";;");
			if(feetpaintParams[0] != "" && feetpaintParams[1] != "") {
				var a_name: String = feetpaintParams[0];
				var a_texture: String = feetpaintParams[1];
				
				AddMakeup(RaceMenuDefines.ENTRY_TYPE_FEETPAINT, makeupList[RaceMenuDefines.PAINT_FEET], a_name, a_texture);
			}
		}
	}
	
	public function RSM_AddTints()
	{
		var tintTypes = new Array();
		var tintColors = new Array();
		var tintTextures = new Array();
		
		_global.tintCount = 0;
		for(var i = 0; i < arguments.length; i++)
		{		
			var tintParams: Array = arguments[i].split(";;");
			if(Number(tintParams[0]) != 0 || Number(tintParams[1]) != 0 || tintParams[2] != "") {
				tintTypes.push(Number(tintParams[0]));
				tintColors.push(Number(tintParams[1]));
				tintTextures.push(tintParams[2]);
				
				// Tint has a color
				if(Number(tintParams[0]) != RaceMenuDefines.TINT_TYPE_HAIR && (Number(tintParams[1]) >>> 24) > 0) {
					_global.tintCount++;
				}
			}
		}
		UpdateTintCount();
		
		SetSliderColors(tintTypes, tintColors);
		
		var tintType: Number = RaceMenuDefines.TINT_TYPE_WARPAINT;
		var category: Number = RaceMenuDefines.CATEGORY_WARPAINT;
		var listIndex: Number = RaceMenuDefines.PAINT_FACE;
		var entryType: Number = RaceMenuDefines.ENTRY_TYPE_WARPAINT;
		SetMakeup(tintTypes, tintColors, tintTextures, tintType, category, listIndex, entryType);
		delete tintTypes;
		delete tintColors;
		delete tintTextures;
	}
	
	public function RSM_AddBodyTints()
	{
		var tintTypes = new Array();
		var tintColors = new Array();
		var tintTextures = new Array();
		
		for(var i = 0; i < arguments.length; i++)
		{		
			var tintParams: Array = arguments[i].split(";;");
			if(Number(tintParams[0]) != 0 || Number(tintParams[1]) != 0 || tintParams[2] != "") {
				tintTypes.push(Number(tintParams[0]));
				tintColors.push(Number(tintParams[1]));
				tintTextures.push(tintParams[2]);
			}
		}
		
		var tintType: Number = RaceMenuDefines.TINT_TYPE_BODYPAINT;
		var category: Number = RaceMenuDefines.CATEGORY_BODYPAINT;
		var listIndex: Number = RaceMenuDefines.PAINT_BODY;
		var entryType: Number = RaceMenuDefines.ENTRY_TYPE_BODYPAINT;
		SetMakeup(tintTypes, tintColors, tintTextures, tintType, category, listIndex, entryType);
		delete tintTypes;
		delete tintColors;
		delete tintTextures;
	}
	
	public function RSM_AddHandTints()
	{
		var tintTypes = new Array();
		var tintColors = new Array();
		var tintTextures = new Array();
		
		for(var i = 0; i < arguments.length; i++)
		{		
			var tintParams: Array = arguments[i].split(";;");
			if(Number(tintParams[0]) != 0 || Number(tintParams[1]) != 0 || tintParams[2] != "") {
				tintTypes.push(Number(tintParams[0]));
				tintColors.push(Number(tintParams[1]));
				tintTextures.push(tintParams[2]);
			}
		}
		
		var tintType: Number = RaceMenuDefines.TINT_TYPE_HANDPAINT;
		var category: Number = RaceMenuDefines.CATEGORY_HANDPAINT;
		var listIndex: Number = RaceMenuDefines.PAINT_HAND;
		var entryType: Number = RaceMenuDefines.ENTRY_TYPE_HANDPAINT;
		SetMakeup(tintTypes, tintColors, tintTextures, tintType, category, listIndex, entryType);
		delete tintTypes;
		delete tintColors;
		delete tintTextures;
	}
	
	public function RSM_AddFeetTints()
	{
		var tintTypes = new Array();
		var tintColors = new Array();
		var tintTextures = new Array();
		
		for(var i = 0; i < arguments.length; i++)
		{		
			var tintParams: Array = arguments[i].split(";;");
			if(Number(tintParams[0]) != 0 || Number(tintParams[1]) != 0 || tintParams[2] != "") {
				tintTypes.push(Number(tintParams[0]));
				tintColors.push(Number(tintParams[1]));
				tintTextures.push(tintParams[2]);
			}
		}
		
		var tintType: Number = RaceMenuDefines.TINT_TYPE_FEETPAINT;
		var category: Number = RaceMenuDefines.CATEGORY_FEETPAINT;
		var listIndex: Number = RaceMenuDefines.PAINT_FEET;
		var entryType: Number = RaceMenuDefines.ENTRY_TYPE_FEETPAINT;
		SetMakeup(tintTypes, tintColors, tintTextures, tintType, category, listIndex, entryType);
		delete tintTypes;
		delete tintColors;
		delete tintTextures;
	}
	
	public function RSM_ExtendRace(a_object: Object)
	{
		if(a_object.formId != undefined) {
			skse.ExtendForm(a_object.formId, a_object, true, false);
		}
		_raceList.push(a_object);
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
