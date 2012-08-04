Scriptname XFLWheel extends Quest

Message Property FollowerWheel Auto

string _rootMenu = "MessageBoxMenu"
string _proxyMenu = "_root.MessageMenu.proxyMenu.WheelPhase.WheelBase."
Actor _actor = None
bool _enabled = true

string[] _optionText

Function OnInit()
	_optionText = new String[8]
	_optionText[0] = "Melee/Ranged " ; Trailing space to prevent string caching, trimmed in AS
	_optionText[1] = "Open Inventory"
	_optionText[2] = "Distance "
	_optionText[3] = "Backup "
	_optionText[4] = "Aggression "
	_optionText[5] = "Use Potion"
	_optionText[6] = "Talk "
	_optionText[7] = "Wait/Follow"
EndFunction

int Function OpenMenu(Actor follower)
	_actor = follower
	RegisterForMenu(_rootMenu)
	return FollowerWheel.Show()
EndFunction

Event OnMenuOpen(string menuName)
	If menuName == _rootMenu
		UpdateWheelActor()
		UpdateWheelOptions()
	Endif
EndEvent

Event OnMenuClose(string menuName)
	If menuName == _rootMenu
		UnregisterFromMenu(_rootMenu)
	Endif
EndEvent

Function SetWheelOptionText(int id, string str)
	If id >= 0 && id < 8
		_optionText[id] = str
	Endif
EndFunction

; Functions only to be used while the menu is open
Function UpdateWheelActor()
	UI.InvokeForm(_rootMenu, _proxyMenu + "SetWheelActor", _actor)
EndFunction

Function UpdateWheelVisibility()
	UI.SetBool(_rootMenu, _proxyMenu + "enabled", _enabled)
	UI.SetBool(_rootMenu, _proxyMenu + "_visible", _enabled)
EndFunction

Function UpdateWheelOptions()
	UI.InvokeStringA(_rootMenu, _proxyMenu + "SetWheelOptions", _optionText)
EndFunction