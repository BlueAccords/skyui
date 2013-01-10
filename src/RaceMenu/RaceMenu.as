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
import skyui.filter.ItemNameFilter;
import skyui.filter.ItemSorter;
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
	private var _nameFilter: ItemNameFilter;
	private var _sortFilter: ItemSorter;
	private var _panelX: Number;
	
	private var _updateInterval: Number;
	private var _pendingData: Object;
		
	private var _raceList: Array;
	
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
	public var bMenuInitialized: Boolean = false;
	
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
	
	public var DISPLAY_KEYCODE_DONE: Number = 19;
		
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
		colorField.addEventListener("changeColor", this, "onChangeColor");
		makeupPanel.addEventListener("changeTexture", this, "onChangeTexture");
		
		categoryList.iconArt = ["skyrim", "race", "body", "head", "face", "eyes", "brow", "mouth", "hair", "palette", "face"];
		categoryList.listState.iconSource = "racemenu/racesex_icons.swf";
		
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
		
		_panelX = racePanel._x;

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
			_activateControl = Input.Activate;
			_acceptControl = {keyCode: DISPLAY_KEYCODE_DONE};
			_lightControl = {keyCode: GlobalFunctions.getMappedKey("Sneak", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_zoomControl = {keyCode: GlobalFunctions.getMappedKey("Sprint", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_searchControl = Input.Jump;
			_textureControl = Input.Wait;
		} else {
			_activateControl = Input.Activate;
			_acceptControl = Input.XButton;
			_lightControl = Input.Wait;
			_zoomControl = {keyCode: GlobalFunctions.getMappedKey("Sprint", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
			_textureControl = Input.YButton;
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
				searchWidget.startInput();
				return true;
			} else if (IsBoundKeyPressed(details, _textureControl, _platform) && !bTextEntryMode) {
				var selectedEntry = itemList.listState.selectedEntry;
				if(selectedEntry && selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP) {
					makeupPanel.setTexture(selectedEntry.text, selectedEntry.texture);
					ShowMakeupPanel(true);
					return true;
				}
			} else if (IsBoundKeyPressed(details, _zoomControl, _platform) && !bTextEntryMode) {
				playerZoom = !playerZoom;
				GameDelegate.call("ZoomPC", [playerZoom]);
				updateBottomBar();
				return true;
			} else if(IsBoundKeyPressed(details, _lightControl, _platform) && !bTextEntryMode) {
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
		raceDescription._visible = raceDescription.enabled = bShowDescription;
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
	}
	
	public function ShowMakeupPanel(bShowPanel: Boolean): Void
	{
		makeupPanel._visible = makeupPanel.enabled = bShowPanel;
		if(bShowPanel) {
			makeupPanel.UpdateList();
			makeupPanel.updateButtons(true);
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
			GameDelegate.call("ChangeName", [textEntry.TextInputInstance.text]);
			ShowTextEntry(false);
			ShowRacePanel(false);
			ShowBottomBar(false);
		} else {
			GameDelegate.call("ChangeName", []);
			ShowTextEntry(false);
		}
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
		categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: (_global.skse != undefined), text: "$MAKEUP", flag: RaceMenuDefines.CATEGORY_MAKEUP, enabled: true});
		
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
				colorIndex++;
			}
			
			// Oversliding
			/*if(entryObject.callbackName == "ChangeDoubleMorph") {
				entryObject.sliderMin -= 5;
				entryObject.sliderMax += 5;
			}*/
						
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
		
		itemList.requestInvalidate();
		clearInterval(_updateInterval);
		delete _updateInterval;
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
		itemList.listState.focusEntry = null;
		itemList.selectedIndex = -1;
		GameDelegate.call("PlaySound",["UIMenuFocus"]);
	}
		
	public function onChangeTexture(event: Object): Void
	{
		if(event.texture != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP) {
				if(event.apply) {
					selectedEntry.text = event.displayText;
					selectedEntry.texture = event.texture;
				}
				requestUpdate({type: "makeupTexture", tintType: selectedEntry.tintType, tintIndex: selectedEntry.tintIndex, replacementTexture: event.texture});
			}
			
			if(event.apply)
				itemList.requestUpdate();
		}
		
		if(event.apply)
			ShowMakeupPanel(false);
	}
	
	public function onChangeColor(event: Object): Void
	{
		if(event.color != undefined)
		{
			var selectedEntry = itemList.listState.selectedEntry;
			if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) {
				if(event.apply)
					selectedEntry.fillColor = event.color;
				requestUpdate({type: "sliderColor", slider: selectedEntry, argbColor: event.color});
			} else if(selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP) {
				if(event.apply)
					selectedEntry.fillColor = event.color;
				requestUpdate({type: "makeupColor", tintType: selectedEntry.tintType, tintIndex: selectedEntry.tintIndex, argbColor: event.color});
			}
			
			if(event.apply)
				itemList.requestUpdate();
		}
		
		if(event.apply)
			ShowColorField(false);
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
		var pressedEntry: Object = itemList.entryList[event.index];
		if(pressedEntry != itemList.listState.activeEntry && pressedEntry.type == RaceMenuDefines.ENTRY_TYPE_RACE) {
			itemList.listState.activeEntry = pressedEntry;
			itemList.requestUpdate();
			loadingIcon._visible = true;
			GameDelegate.call("ChangeRace", [pressedEntry.raceID, -1]);
			playerZoom = true; // Reset zoom, this happens when race is changed
		} else if((pressedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR) || (pressedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP) && _global.skse) {
			colorField.setText(pressedEntry.text);
			colorField.setColor(pressedEntry.fillColor);
			ShowColorField(true);
		}/* else {
			itemList.listState.focusEntry = entryObject;
			itemList.requestUpdate();
		}*/
		updateBottomBar();
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
		navPanel.addButton({text: "$Done", controls: _acceptControl});
		if(_platform == 0) {
			navPanel.addButton({text: "$Search", controls: _searchControl});
		}
		navPanel.addButton({text: playerZoom ? "$Zoom Out" : "$Zoom In", controls: _zoomControl});
		
		if(_global.skse)
			navPanel.addButton({text: bShowLight ? "$Light Off" : "$Light On", controls: _lightControl});
		
		if(itemList.listState.selectedEntry != itemList.listState.activeEntry && itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_RACE) {
			navPanel.addButton({text: "$Change Race", controls: _activateControl});
		} else if(itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_COLOR && _global.skse) {
			navPanel.addButton({text: "$Choose Color", controls: _activateControl});
		} else if(itemList.listState.selectedEntry.filterFlag & RaceMenuDefines.CATEGORY_MAKEUP && _global.skse) {
			navPanel.addButton({text: "$Choose Color", controls: _activateControl});
			navPanel.addButton({text: "$Choose Texture", controls: _textureControl});
		}
		
		navPanel.updateButtons(true);		
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
				makeupPanel.AddMakeup(warpaintParams[0], warpaintParams[1]);
			}
		}
	}
	
	public function RSM_AddTints()
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
		
		SetSliderColors(tintTypes, tintColors);
		SetMakeup(tintTypes, tintColors, tintTextures, RaceMenuDefines.TINT_TYPE_WARPAINT);
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
