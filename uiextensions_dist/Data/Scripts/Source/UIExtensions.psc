Scriptname UIExtensions Hidden

UIMenuBase Function GetMenu(string menuName, bool reset = true) global
	UIMenuBase menuBase = None
	If menuName == "UIMagicMenu"
		menuBase = (Game.GetFormFromFile(0xE02, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UIListMenu"
		menuBase = (Game.GetFormFromFile(0xE05, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UIStatsMenu"
		menuBase = (Game.GetFormFromFile(0xE03, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UITextEntryMenu"
		menuBase = (Game.GetFormFromFile(0xE04, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UIWheelMenu"
		menuBase = (Game.GetFormFromFile(0xE01, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UISelectionMenu"
		menuBase = (Game.GetFormFromFile(0xE00, "UIExtensions.esp") as UIMenuBase)
	Endif
	if menuBase
		if reset
			menuBase.ResetMenu()
		Endif
		return menuBase
	Endif
	return None
EndFunction