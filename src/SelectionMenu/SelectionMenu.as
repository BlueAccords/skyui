class SelectionMenu extends MovieClip
{
	var ItemList: MovieClip;
	var LeftPanel: MovieClip;
	var List_mc: MovieClip;

	function SelectionMenu()
	{
		super();
		ItemList = List_mc;
	}

	function onLoad()
	{
		ItemList.InvalidateData();
		ItemList.addEventListener("listMovedUp", this, "onListMoveUp");
		ItemList.addEventListener("listMovedDown", this, "onListMoveDown");
		ItemList.addEventListener("itemPress", this, "onItemSelect");
		gfx.managers.FocusHandler.instance.setFocus(ItemList, 0);
		_parent.gotoAndPlay("startFadeIn");
	}
	
	function SetSelectionMenuFormData(aObject: Object)
	{
		if(aObject.forms != undefined)
		{
			for(var i = 0; i < aObject.forms.length; i++)
				aObject.forms[i].text = aObject.forms[i].actorBase.fullName;
			
			ItemList.entryList = aObject.forms;
			ItemList.InvalidateData();
		}
	}

	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		if (!pathToFocus[0].handleInput(details, pathToFocus.slice(1))) 
		{
			if (Shared.GlobalFunc.IsKeyPressed(details) && details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				startFadeOut();
			}
		}
		return true;
	}

	function get selectedIndex()
	{
		return ItemList.selectedEntry.index;
	}

	function get itemList()
	{
		return ItemList;
	}

	function setSelectedItem(aiIndex)
	{
		for (var i = 0; i < ItemList.entryList.length; i++) 
		{
			if (ItemList.entryList[i].index == aiIndex) 
			{
				ItemList.selectedIndex = i;
				ItemList.RestoreScrollPosition(i);
				ItemList.UpdateList();
				return;
			}
		}
	}

	function onListMoveUp(event)
	{
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (event.scrollChanged == true) 
			this.gotoAndPlay("moveUp");
	}

	function onListMoveDown(event)
	{
		gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		if (event.scrollChanged == true) 
			this.gotoAndPlay("moveDown");
	}

	function onItemSelect(event)
	{
		if (event.keyboardOrMouse != 0) {
			if(ItemList.entryList[event.index].formId != undefined) {
				skse.SendModEvent("SelectForm", "", 0, ItemList.entryList[event.index].formId);
				gfx.io.GameDelegate.call("buttonPress", [1]);
			}
		}
	}

	function startFadeOut()
	{
		_parent.gotoAndPlay("startFadeOut");
	}

	function onFadeOutCompletion()
	{
		gfx.io.GameDelegate.call("buttonPress", [0]);
	}

	function SetPlatform(aiPlatform: Number, abPS3Switch: Boolean)
	{
		ItemList.SetPlatform(aiPlatform, abPS3Switch);
		LeftPanel._x = aiPlatform == 0 ? -90 : -78.2;
		LeftPanel.gotoAndStop(aiPlatform == 0 ? "Mouse" : "Gamepad");
	}
}


