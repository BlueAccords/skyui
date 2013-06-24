Scriptname UIExtensions Hidden

UIMenuBase Function GetMenu(string menuName) global
	If menuName == "UIMagicMenu"
		return (Game.GetFormFromFile(0xE02, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UIListMenu"
		return (Game.GetFormFromFile(0xE05, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UIStatsMenu"
		return (Game.GetFormFromFile(0xE03, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UITextEntryMenu"
		return (Game.GetFormFromFile(0xE04, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UIWheelMenu"
		return (Game.GetFormFromFile(0xE01, "UIExtensions.esp") as UIMenuBase)
	Elseif menuName == "UISelectionMenu"
		return (Game.GetFormFromFile(0xE00, "UIExtensions.esp") as UIMenuBase)
	Endif
	return None
EndFunction