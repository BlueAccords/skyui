﻿import Shared.GlobalFunc;
import gfx.io.GameDelegate;
import gfx.ui.NavigationCode;

import skyui.components.list.ListLayoutManager;
import skyui.components.list.TabularList;
import skyui.props.PropertyDataExtender;
import skyui.util.Defines;

import mx.data.binding.ObjectDumper;

class MagicMenuExt extends ItemMenu
{
  /* PRIVATE VARIABLES */
  
	private var _hideButtonFlag: Number = 0;
	private var _bMenuClosing: Boolean = false;

	private var _magicButtonArt: Object;
	private var _categoryListIconArt: Array;
	
	private var CATEGORY_ALL: Number = 0;
	private var CATEGORY_ALTERATION: Number = 1;
	private var CATEGORY_ILLUSION: Number = 2;
	private var CATEGORY_DESTRUCTION: Number = 3;
	private var CATEGORY_CONJURATION: Number = 4;
	private var CATEGORY_RESTORATION: Number = 5;
	private var CATEGORY_SHOUTS: Number = 6;
	private var CATEGORY_POWERS: Number = 7;
	private var CATEGORY_ACTIVE_EFFECTS: Number = 8;
	private var CATEGORY_END: Number = 9;
	
	
  /* PROPERTIES */
  
	public var hideButtonFlag: Number;
	

  /* CONSTRUCTORS */

	public function MagicMenuExt()
	{
		super();
		_magicButtonArt = [{PCArt:"Tab",XBoxArt:"360_B", PS3Art:"PS3_B"}];
		_categoryListIconArt = ["mag_all", "mag_alteration", "mag_illusion",
							   "mag_destruction", "mag_conjuration", "mag_restoration", "mag_shouts",
							   "mag_powers", "mag_activeeffects"];
		_visible = false;
	}
	
	
	/* PUBLIC FUNCTIONS */
	public function InitExtensions(): Void
	{		
		super.InitExtensions();
						
		bottomBar.SetGiftInfo(0);
		bottomBar.SetButtonsArt(_magicButtonArt);
		
		// Initialize menu-specific list components
		var categoryList: CategoryList = inventoryLists.categoryList;
		categoryList.iconArt = _categoryListIconArt;
		
		var itemList: TabularList = inventoryLists.itemList;		
		var entryFormatter = new InventoryEntryFormatter(itemList);
		entryFormatter.maxTextLength = 80;
		itemList.entryFormatter = entryFormatter;
		itemList.addDataProcessor(new MagicExtDataExtender());
		itemList.addDataProcessor(new PropertyDataExtender('magicProperties', 'magicIcons', 'magicCompoundProperties', 'translateProperties'));
		itemList.layout = ListLayoutManager.instance.getLayoutByName("MagicListLayout");
		
		inventoryLists.categoryList.entryList.push({bDontHide: true, filterFlag: 0, flag: Defines.FLAG_MAGIC_ALL, text: "$ALL"});
		inventoryLists.categoryList.entryList.push({bDontHide: false, filterFlag: 0, flag: Defines.FLAG_MAGIC_ALTERATION, text: "$ALTERATION"});
		inventoryLists.categoryList.entryList.push({bDontHide: false, filterFlag: 0, flag: Defines.FLAG_MAGIC_ILLUSION, text: "$ILLUSION"});
		inventoryLists.categoryList.entryList.push({bDontHide: false, filterFlag: 0, flag: Defines.FLAG_MAGIC_DESTRUCTION, text: "$DESTRUCTION"});
		inventoryLists.categoryList.entryList.push({bDontHide: false, filterFlag: 0, flag: Defines.FLAG_MAGIC_CONJURATION, text: "$CONJURATION"});
		inventoryLists.categoryList.entryList.push({bDontHide: false, filterFlag: 0, flag: Defines.FLAG_MAGIC_RESTORATION, text: "$RESTORATION"});
		inventoryLists.categoryList.entryList.push({bDontHide: false, filterFlag: 0, flag: Defines.FLAG_MAGIC_SHOUTS, text: "$SHOUTS"});
		inventoryLists.categoryList.entryList.push({bDontHide: false, filterFlag: 0, flag: Defines.FLAG_MAGIC_POWERS, text: "$POWERS"});
		inventoryLists.categoryList.entryList.push({bDontHide: false, filterFlag: 0, flag: Defines.FLAG_MAGIC_ACTIVE_EFFECT, text: "$ACTIVE EFFECTS"});
		inventoryLists.categoryList.InvalidateData();
		_visible = true;
	}
	
	private function CreateItemInfo(spell: Object): Object
	{
		var itemInfo = new Object();
		
		itemInfo.spellCost = spell.trueCost;
		itemInfo.castTime = spell.castTime;
				
		switch(spell.subType) {
			case Defines.SPELL_TYPE_ALTERATION:
			itemInfo.magicSchoolName = "$Alteration";
			itemInfo.type = InventoryDefines.ICT_SPELL;
			break;
			case Defines.SPELL_TYPE_CONJURATION:
			itemInfo.magicSchoolName = "$Conjuration";
			itemInfo.type = InventoryDefines.ICT_SPELL;
			break;
			case Defines.SPELL_TYPE_DESTRUCTION:
			itemInfo.magicSchoolName = "$Destruction";
			itemInfo.type = InventoryDefines.ICT_SPELL;
			break;
			case Defines.SPELL_TYPE_ILLUSION:
			itemInfo.magicSchoolName = "$Illusion";
			itemInfo.type = InventoryDefines.ICT_SPELL;
			break;
			case Defines.SPELL_TYPE_RESTORATION:
			itemInfo.magicSchoolName = "$Restoration";
			itemInfo.type = InventoryDefines.ICT_SPELL;
			break;
			default:
			itemInfo.type = InventoryDefines.ICT_SPELL_DEFAULT;
			break;
		}
				
		if(spell.castType == 0 || spell.isActive) { // Effect
			itemInfo.name = spell.spellName;
			itemInfo.negativeEffect = ((spell.effectFlags & 0x04) == 0x04); // Detrimental
			
			if(spell.duration > spell.elapsed) { // Remaining time
				itemInfo.timeRemaining = spell.duration - spell.elapsed;
			}
			
			itemInfo.type = InventoryDefines.ICT_ACTIVE_EFFECT;
		} else {
			switch(spell.skillLevel) {
				case 0:		itemInfo.castLevel = "$Novice";		break;
				case 25:	itemInfo.castLevel = "$Apprentice";	break;
				case 50:	itemInfo.castLevel = "$Adept";		break;
				case 75:	itemInfo.castLevel = "$Expert";		break;
				case 100:	itemInfo.castLevel = "$Master";	break;
			}
		}
		
		if(spell.words != undefined) { // Shout
			itemInfo.spellCost = "";
			for(var i = 0; i < spell.words.length; i++) {
				itemInfo.spellCost += spell.words[i].recoveryTime;
				if(i < spell.words.length - 1)
					itemInfo.spellCost += " , ";

				itemInfo["dragonWord" + i] = spell.words[i].word;
				itemInfo["word" + i] = spell.words[i].fullName;
				itemInfo["unlocked" + i] = true;
			}
			itemInfo.type = InventoryDefines.ICT_SHOUT;
		}
		
		return itemInfo;
	}
	
	private function DeflateSpellData(entry: Object, spell: Object): Void
	{
		entry.count = 1;
		entry.enabled = true;
		entry.equipState = 0;
		entry.favorite = 0;
		
		entry.text = spell.spellName;
		entry.itemInfo = CreateItemInfo(spell);
		
		entry.filterFlag = Defines.FLAG_MAGIC_POWERS;
		
		switch(spell.subType) {
			case Defines.SPELL_TYPE_ALTERATION:		entry.filterFlag = Defines.FLAG_MAGIC_ALTERATION;	break;
			case Defines.SPELL_TYPE_CONJURATION:	entry.filterFlag = Defines.FLAG_MAGIC_CONJURATION;	break;
			case Defines.SPELL_TYPE_DESTRUCTION:	entry.filterFlag = Defines.FLAG_MAGIC_DESTRUCTION;	break;
			case Defines.SPELL_TYPE_ILLUSION:		entry.filterFlag = Defines.FLAG_MAGIC_ILLUSION;		break;
			case Defines.SPELL_TYPE_RESTORATION:	entry.filterFlag = Defines.FLAG_MAGIC_RESTORATION;	break;
		}
		
		if(spell.spellType == 2) {
			entry.filterFlag = Defines.FLAG_MAGIC_POWERS;
		}
		
		if(spell.castType == 0 || spell.isActive) { // Effect
			entry.text = spell.effectName;
			entry.filterFlag = Defines.FLAG_MAGIC_ACTIVE_EFFECT;
		}
		
		if(spell.words != undefined) { // Shout
			entry.text = spell.fullName;
			entry.filterFlag = Defines.FLAG_MAGIC_SHOUTS;
		}
		
		// Hidden in UI
		if((spell.effectFlags & 0x8000) == 0x8000) {
			entry.filterFlag = 0;
			entry.enabled = false;
		}
		
		if(entry.filterFlag != 0) {
			inventoryLists.categoryList.entryList[CATEGORY_ALL].filterFlag = 1;
			switch(entry.filterFlag) {
				case Defines.FLAG_MAGIC_ALTERATION: 	inventoryLists.categoryList.entryList[CATEGORY_ALTERATION].filterFlag = 1; break;
				case Defines.FLAG_MAGIC_ILLUSION: 		inventoryLists.categoryList.entryList[CATEGORY_ILLUSION].filterFlag = 1; break;
				case Defines.FLAG_MAGIC_DESTRUCTION: 	inventoryLists.categoryList.entryList[CATEGORY_DESTRUCTION].filterFlag = 1; break;
				case Defines.FLAG_MAGIC_CONJURATION: 	inventoryLists.categoryList.entryList[CATEGORY_CONJURATION].filterFlag = 1; break;
				case Defines.FLAG_MAGIC_RESTORATION: 	inventoryLists.categoryList.entryList[CATEGORY_RESTORATION].filterFlag = 1; break;
				case Defines.FLAG_MAGIC_SHOUTS: 		inventoryLists.categoryList.entryList[CATEGORY_SHOUTS].filterFlag = 1; break;
				case Defines.FLAG_MAGIC_POWERS: 		inventoryLists.categoryList.entryList[CATEGORY_POWERS].filterFlag = 1; break;
				case Defines.FLAG_MAGIC_ACTIVE_EFFECT: 	inventoryLists.categoryList.entryList[CATEGORY_ACTIVE_EFFECTS].filterFlag = 1; break;
			}
		}
	}
	
	public function SetMagicMenuExtActor(aObject: Object): Void
	{
		skse.ExtendForm(aObject.formId, aObject, true, true);
		var spells: Array = new Array();
		spells = spells.concat(aObject.race.spells, aObject.actorBase.spells, aObject.spells);
		var shouts: Array = new Array();
		shouts = shouts.concat(aObject.race.shouts, aObject.actorBase.shouts, aObject.shouts);
		var effects: Array = aObject.activeEffects;

		for(var i = 0; i < spells.length; i++)
		{
			var entry: Object = spells[i];
			DeflateSpellData(entry, spells[i]);
			inventoryLists.itemList.entryList.push(entry);
			skse.Log(ObjectDumper.toString(entry));
		}
		
		for(var i = 0; i < shouts.length; i++)
		{
			var entry: Object = shouts[i];
			DeflateSpellData(entry, shouts[i]);
			inventoryLists.itemList.entryList.push(entry);
			skse.Log(ObjectDumper.toString(entry));
		}
		
		for(var i = 0; i < effects.length; i++)
		{
			effects[i].isActive = true;
			var entry: Object = effects[i];
			DeflateSpellData(entry, effects[i]);
			inventoryLists.itemList.entryList.push(entry);
			skse.Log(ObjectDumper.toString(entry));
		}
		
		inventoryLists.categoryList.InvalidateData();
		inventoryLists.categoryList.onItemPress(CATEGORY_ALL, 0);			
		inventoryLists.itemList.InvalidateData();
	}

	// @GFx
	public function handleInput(details, pathToFocus): Boolean
	{
		if (bFadedIn && ! pathToFocus[0].handleInput(details,pathToFocus.slice(1))) {
			if (Shared.GlobalFunc.IsKeyPressed(details)) {
				if (details.navEquivalent == NavigationCode.TAB) {
					startMenuFade();
					GameDelegate.call("CloseTweenMenu",[]);
				}
			}
		}
		return true;
	}

	// @override ItemMenu
	public function onExitMenuRectClick(): Void
	{
		onFadeCompletion();
	}

	public function onFadeCompletion(): Void
	{
		if (_bMenuClosing) {
			GameDelegate.call("CloseMenu",[]);
			GameDelegate.call("buttonPress",[1]);
		}
	}

	// @override ItemMenu
	public function onShowItemsList(event: Object): Void
	{
		super.onShowItemsList(event);
		
		if (event.index != -1)
			updateButtonText();
	}

	// @override ItemMenu
	public function onItemHighlightChange(event: Object)
	{
		super.onItemHighlightChange(event);
		
		if (event.index != -1)
			updateButtonText();
	}

	// @API
	public function DragonSoulSpent(): Void
	{
		// Do nothing
	}


	// @override ItemMenu
	public function onHideItemsList(event: Object): Void
	{
		super.onHideItemsList(event);
	}
	
	// @API
	public function AttemptEquip(a_slot: Number): Void
	{
		// Do nothing
	}

	// @override ItemMenu
	public function onItemSelect(event: Object): Void
	{
		if (event.entry.enabled) {
			if (event.keyboardOrMouse != 0)
				GameDelegate.call("ItemSelect",[]);
			return;
		}
	}
	
	// currently only used for controller users when pressing the BACK button
	private function openInventoryMenu(): Void
	{
		GameDelegate.call("CloseMenu",[]);
		GameDelegate.call("CloseTweenMenu",[]);
		//skse.OpenMenu("Inventory Menu");
	}
	
	
  /* PRIVATE FUNCTIONS */
	
	private function updateButtonText(): Void
	{
		bottomBar.SetButtonText("$Exit",0);
	}
	
	private function startMenuFade(): Void
	{
		inventoryLists.hideCategoriesList();
		ToggleMenuFade();
		_bMenuClosing = true;
	}
}