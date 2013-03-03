import Shared.GlobalFunc;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import gfx.events.EventDispatcher;
import gfx.managers.FocusHandler;

import skyui.defines.Input;
import skyui.components.list.BasicEnumeration;
import skyui.components.list.ScrollingList;

class StyleMenu extends MovieClip
{
	private var _platform: Number;
	private var styleTable: MultiColumnScrollingList;
	
	private var _parentMenu: MovieClip;
	private var _parentHandleInput: Function;
	private var _parentSetPlatform: Function;
	
	/* GFx Dispatcher Functions */
	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;
	
	public function StyleMenu()
	{
		super();
		
		GlobalFunc.MaintainTextFormat();
		EventDispatcher.initialize(this);
	}
	
	private function onLoad()
	{
		super.onLoad();
		
		_parentMenu = _root.DialogueMenu_mc;
		_parentHandleInput = _parentMenu.handleInput;
		_parentSetPlatform = _parentMenu.setPlatform;
		
		_parentMenu.setPlatform = setPlatform_Hook;
		_parentMenu.handleInput = handleInput_Hook;
		
		styleTable.listEnumeration = new BasicEnumeration(styleTable.entryList);
		styleTable.addEventListener("itemPress", this, "onStylePress");
		styleTable.addEventListener("selectionChange", this, "onStyleChange");

		for(var i = 0; i < 40; i++) {
			styleTable.entryList.push({text: "Text" + i, flags: 0, editorId: "Style" + i, value: "(" + (Math.floor(Math.random()*(1+999-100))+100) + ")"});
		}

		styleTable.InvalidateData();
		
		FocusHandler.instance.setFocus(styleTable, 0);
	}
	
	// Hooks
	public function setPlatform_Hook(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		_root.StyleMenu.setPlatform(a_platform, a_bPS3Switch);
	}
	
	public function handleInput_Hook(details: InputDetails, pathToFocus: Array): Boolean
	{
		return _root.StyleMenu.handleInput(details, pathToFocus);
	}
	
	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		_platform = a_platform;
		// Buttonbar stuff
	}
	
	// @GFx
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{		
		var nextClip = pathToFocus.shift();
		if (nextClip && nextClip.handleInput(details, pathToFocus))
			return true;
	
		if (GlobalFunc.IsKeyPressed(details, false)) {
			if (details.navEquivalent == NavigationCode.TAB) {
				// Close panel
				return true;
			}
		}
		
		// Don't forward to higher level
		return true;
	}
	
	private function onStylePress(a_event: Object): Void
	{
		selectOption(styleTable.entryList[a_event.index]);
	}
	
	private function onStyleChange(a_event: Object): Void
	{
		
	}
	
	private function selectOption(a_entryObject: Object): Void
	{
		if(!a_entryObject)
			return;
			
		trace("Selected option: " + a_entryObject.editorId);
	}
}