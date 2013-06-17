Scriptname UITextEntryMenu extends UIMenuBase

string property		ROOT_MENU		= "MessageBoxMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.MessageMenu.proxyMenu.textEntry." autoReadonly

string _internalString = ""
string _internalResult = ""

bool _entryLock = false

Message Property UITextEntryMenuMessage Auto

string Function GetMenuName()
	return "UITextEntryMenu"
EndFunction

string Function GetResultString()
	return _internalResult
EndFunction

Function SetPropertyString(string propertyName, string value)
	If propertyName == "UITextEntryMenuText"
		_internalString = value
	Endif
EndFunction

int Function OpenMenu(Form inForm = None, Form akReceiver = None)
	_internalResult = ""
	RegisterForModEvent("UITextEntryMenu_LoadMenu", "OnLoadMenu")
	RegisterForModEvent("UITextEntryMenu_TextChanged", "OnTextChanged")
	_entryLock = true
	int ret = UITextEntryMenuMessage.Show()
	int counter = 0
	while _entryLock
		Utility.Wait(0.1)
		counter += 1
		if counter > 30
			_entryLock = false
		Endif
	EndWhile
	return ret
EndFunction

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	float[] params = new Float[2]
	params[0] = Game.UsingGamepad() as float
	params[1] = 0
	UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "SetPlatform", params)
	UI.Invoke(ROOT_MENU, MENU_ROOT + "SetupButtons")
	UpdateTextEntryString()
EndEvent

Event OnTextChanged(string eventName, string strArg, float numArg, Form formArg)
	_internalResult = strArg
	_entryLock = false
EndEvent

Function UpdateTextEntryString()
	UI.InvokeString(ROOT_MENU, MENU_ROOT + "setTextEntryMenuText", _internalString)
EndFunction

Event OnMenuClose(string menuName)
	If menuName == ROOT_MENU
		UnregisterForMenu(ROOT_MENU)
		UnregisterForModEvent("UITextEntryMenu_LoadMenu")
		UnregisterForModEvent("UITextEntryMenu_TextChanged")
	Endif
EndEvent
