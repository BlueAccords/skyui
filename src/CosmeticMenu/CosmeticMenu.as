﻿import gfx.ui.InputDetails;
import Shared.GlobalFunc;
import skyui.util.GlobalFunctions;
import skyui.defines.Input;

class CosmeticMenu extends MovieClip
{
	private var _movieLoader: MovieClipLoader;
	private var _raceMenuContainer: MovieClip;
	
	static var COSMETIC_CATEGORY_WARPAINT: Number = 1;
	static var COSMETIC_CATEGORY_BODYPAINT: Number = 2;
	static var COSMETIC_CATEGORY_HANDPAINT: Number = 4;
	static var COSMETIC_CATEGORY_FEETPAINT: Number = 8;
	
	public var RaceMenuInstance: MovieClip;
	
	function CosmeticMenu()
	{
		super();
		_movieLoader = new MovieClipLoader();
	}
	
	function onLoad()
	{
		super.onLoad();
		
		_raceMenuContainer = this.createEmptyMovieClip("RaceMenuContainer", this.getNextHighestDepth());
		_movieLoader.loadClip("racesex_menu.swf", _raceMenuContainer);
		_movieLoader.addListener(this);
	}
	
	private function onLoadInit(a_clip: MovieClip): Void
	{
		if(a_clip == _raceMenuContainer) {
			_global.eventPrefix = "TTM_";
			
			RaceMenuInstance = _raceMenuContainer.RaceSexMenuBaseInstance.RaceSexPanelsInstance;
			if(RaceMenuInstance.RACEMENU_VERSION_IDX < 1) {
				_movieLoader.unloadClip(a_clip);
				_root.MessageMenu._visible = true;
				_root.MessageMenu.enabled = true;
				_root.MessageMenu.MessageText.text = "RaceMenu version incompatible.";
				return;
			}
			
			RaceMenuInstance.racePanel.tintCount._visible = false;
			RaceMenuInstance.handleInput = function(details: InputDetails, pathToFocus: Array): Boolean
			{
				// Consume input when these windows are open
				if(this.colorField._visible) {
					return this.colorField.handleInput(details, pathToFocus);
				} else if(this.textEntry._visible) {
					return this.textEntry.handleInput(details, pathToFocus);
				} else if(this.makeupPanel._visible) {
					return this.makeupPanel.handleInput(details, pathToFocus);
				}
					
				if (GlobalFunc.IsKeyPressed(details)) {
					if (this.IsBoundKeyPressed(details, this._searchControl, this._platform) && this._platform == 0) {
						this.onSearchClicked();
						return true;
					} else if (this.IsBoundKeyPressed(details, this._acceptControl, this._platform)) {
						this.onDoneClicked();
						return true;
					}
				}
				
				if(this.itemList.handleInput(details, pathToFocus)) {
					return true;
				}
				
				if(this.categoryList.handleInput(details, pathToFocus)) {
					return true;
				}
								
				return false;
			}
			
			RaceMenuInstance.SetPlatform = function(a_platform: Number, a_bPS3Switch: Boolean): Void
			{
				this._platform = a_platform;
				this.textEntry.setPlatform(a_platform, a_bPS3Switch);
				this.bottomBar.setPlatform(a_platform, a_bPS3Switch);
				this.colorField.setPlatform(a_platform, a_bPS3Switch);
				this.makeupPanel.setPlatform(a_platform, a_bPS3Switch);
				
				if(this._platform == 0) {
					this._activateControl = Input.Activate;
					this._acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
					this._lightControl = {keyCode: GlobalFunctions.getMappedKey("Sneak", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
					this._zoomControl = {keyCode: GlobalFunctions.getMappedKey("Sprint", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
					this._searchControl = Input.Jump;
					this._textureControl = Input.Wait;
					this._savePresetControl = {keyCode: GlobalFunctions.getMappedKey("Quicksave", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
					this._loadPresetControl = {keyCode: GlobalFunctions.getMappedKey("Quickload", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
					this._exportHeadControl =  {keyCode: GlobalFunctions.getMappedKey("Shout", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
				} else {
					this._activateControl = Input.Activate;
					this._acceptControl = {keyCode: GlobalFunctions.getMappedKey("Ready Weapon", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
					this._lightControl = Input.Wait;
					this._zoomControl = {keyCode: GlobalFunctions.getMappedKey("Sprint", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
					this._textureControl = Input.YButton;
					this._searchControl = null;
					this._savePresetControl = {keyCode: GlobalFunctions.getMappedKey("Toggle POV", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
					this._loadPresetControl = {keyCode: GlobalFunctions.getMappedKey("Sneak", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
					this._exportHeadControl =  {keyCode: GlobalFunctions.getMappedKey("Shout", Input.CONTEXT_GAMEPLAY, a_platform != 0)};
				}
				
				this.textEntry.TextInputInstance.maxChars = 26;
				this.textEntry.SetupButtons();
				this.colorField.SetupButtons();
				this.makeupPanel.SetupButtons();
				
				var leftEdge = Stage.visibleRect.x + Stage.safeRect.x;
				var rightEdge = Stage.visibleRect.x + Stage.visibleRect.width - Stage.safeRect.x;
				this.bottomBar.positionElements(leftEdge, rightEdge);
				this.updateBottomBar();
			}
			
			RaceMenuInstance.updateBottomBar = function(): Void
			{
				this.navPanel.clearButtons();
				this.navPanel.addButton({text: "$Done", controls: this._acceptControl}).addEventListener("click", this, "onDoneClicked");
				if(this._platform == 0) {
					this.navPanel.addButton({text: "$Search", controls: this._searchControl}).addEventListener("click", this, "onSearchClicked");
				}

				var selectedEntry = this.itemList.listState.selectedEntry;
				if(selectedEntry.isColorEnabled())
					this.navPanel.addButton({text: "$Choose Color", controls: this._activateControl}).addEventListener("click", this, "onChooseColorClicked");
				if(selectedEntry.GetTextureList(this))
					this.navPanel.addButton({text: "$Choose Texture", controls: this._textureControl}).addEventListener("click", this, "onChooseTextureClicked");
						
				this.navPanel.updateButtons(true);		
			}
						
			RaceMenuInstance.onDoneClicked = function(): Void
			{
				skse.SendModEvent("UICosmeticMenu_CloseMenu");
				gfx.io.GameDelegate.call("buttonPress", [1]);
			}
		}
		
		skse.SendModEvent("UICosmeticMenu_LoadMenu");
	}
	
	public function TTM_ShowCategories(a_categories: Number): Void
	{
		if(a_categories > 0) {
			RaceMenuInstance.categoryList.iconArt.splice(0, RaceMenuInstance.categoryList.iconArt.length);
			RaceMenuInstance.categoryList.entryList.splice(0, RaceMenuInstance.categoryList.entryList.length);
		}
				
		if((a_categories & COSMETIC_CATEGORY_WARPAINT) == COSMETIC_CATEGORY_WARPAINT) {
			RaceMenuInstance.categoryList.iconArt.push("face");
			RaceMenuInstance.categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: (_global.skse != undefined), text: "$MAKEUP", flag: RaceMenuDefines.CATEGORY_WARPAINT, enabled: true});
			RaceMenuInstance.racePanel.tintCount._visible = true;
		}
		
		if(_global.skse.plugins.NiOverride) {
			if((a_categories & COSMETIC_CATEGORY_BODYPAINT) == COSMETIC_CATEGORY_BODYPAINT) {
				RaceMenuInstance.categoryList.iconArt.push("body");
				RaceMenuInstance.categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$BODY PAINT", flag: RaceMenuDefines.CATEGORY_BODYPAINT, enabled: true});
			}
			if((a_categories & COSMETIC_CATEGORY_HANDPAINT) == COSMETIC_CATEGORY_HANDPAINT) {
				RaceMenuInstance.categoryList.iconArt.push("hand");
				RaceMenuInstance.categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$HAND PAINT", flag: RaceMenuDefines.CATEGORY_HANDPAINT, enabled: true});
			}
			if((a_categories & COSMETIC_CATEGORY_FEETPAINT) == COSMETIC_CATEGORY_FEETPAINT) {
				RaceMenuInstance.categoryList.iconArt.push("feet");
				RaceMenuInstance.categoryList.entryList.push({type: RaceMenuDefines.ENTRY_TYPE_CAT, bDontHide: false, filterFlag: 1, text: "$FOOT PAINT", flag: RaceMenuDefines.CATEGORY_FEETPAINT, enabled: true});
			}
		}
		
		RaceMenuInstance.categoryList.InvalidateData();
		RaceMenuInstance.categoryList.onItemPress(0, 0);
	}
}