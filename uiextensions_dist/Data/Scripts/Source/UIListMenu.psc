Scriptname UIListMenu extends UIMenuBase

Message Property UIListMenuMessage Auto

string property		ROOT_MENU		= "MessageBoxMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.MessageMenu.proxyMenu.listMenu." autoReadonly

bool _selectionLock = false

float _resultFloat = -1.0
int _resultInt = -1

string[] _entryName = None
int[] _entryId = None
int[] _entryParent = None
int[] _entryCallback = None
bool[] _entryChildren = None
int _entryBuffer = 0

string[] _premadeEntries = None
int _premadeBuffer = 0

int Function GetResultInt()
	return _resultInt
EndFunction

float Function GetResultFloat()
	return _resultFloat
EndFunction

Function SetPropertyStringA(string propertyName, string[] value)
	if propertyName == "appendEntries"
		int i = 0
		If _premadeBuffer > 127
			return ; Can't add anymore premade entries
		Endif
		While i < value.length
			_premadeEntries[_premadeBuffer] = value[i]
			_premadeBuffer += 1
			If _premadeBuffer > 127 ; End the buffer
				i = value.length
			Endif
			i += 1
		EndWhile
	Endif
EndFunction

int Function AddEntryItem(string entryName, int entryParent = -1, int entryCallback = -1, bool entryHasChildren = false)
	_entryName[_entryBuffer] = entryName
	_entryId[_entryBuffer] = _entryBuffer
	_entryParent[_entryBuffer] = entryParent
	_entryCallback[_entryBuffer] = entryCallback
	_entryChildren[_entryBuffer] = entryHasChildren
	int currentEntry = _entryBuffer
	_entryBuffer += 1
	return currentEntry
EndFunction

Function SetPropertyIndexInt(string propertyName, int index, int value)
	If propertyName == "entryId"
		_entryId[index] = value
	Elseif propertyName == "entryParent"
		_entryParent[index] = value
	Elseif propertyName == "entryCallback"
		_entryCallback[index] = value
	Endif
EndFunction

Function SetPropertyIndexBool(string propertyName, int index, bool value)
	If propertyName == "hasChildren"
		_entryChildren[index] = value
	Endif
EndFunction

Function SetPropertyIndexString(string propertyName, int index, string value)
	If propertyName == "entryName"
		_entryName[index] = value
	Endif
EndFunction

int Function GetPropertyInt(string propertyName)
	if propertyName == "currentIndex"
		return _entryBuffer
	Endif
	return -1
EndFunction

Function OnInit()
	_entryName = new string[128]
	_entryId = new int[128]
	_entryParent = new int[128]
	_entryCallback = new int[128]
	_entryChildren = new bool[128]
	_premadeEntries = new string[128]
	ResetMenu()
EndFunction

Function ResetMenu()
	int i = 0
	While i < _entryBuffer
		_entryName[i] = ""
		_entryId[i] = -1
		_entryParent[i] = -1
		_entryCallback[i] = -1
		_entryChildren[i] = false
		i += 1
	EndWhile
	i = 0
	While i < _premadeBuffer
		_premadeEntries[i] = ""
		i += 1
	EndWhile
	_premadeBuffer = 0
	_entryBuffer = 0
EndFunction

int Function OpenMenu(Form aForm = None, Form aReceiver = None)
	_resultFloat = -1.0
	_resultInt = -1
	RegisterForModEvent("UIListMenu_LoadMenu", "OnLoadMenu")
	RegisterForModEvent("UIListMenu_CloseMenu", "OnUnloadMenu")
	RegisterForModEvent("UIListMenu_SelectItem", "OnSelect")
	_selectionLock = true
	int ret = UIListMenuMessage.Show()
	If ret == 0
		_selectionLock = false
		return ret
	Endif
	int counter = 0
	while _selectionLock
		Utility.Wait(0.1)
		counter += 1
		if counter > 30
			_selectionLock = false
		Endif
	EndWhile
	return ret
EndFunction

string Function GetMenuName()
	return "UIListMenu"
EndFunction

Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
	_resultInt = strArg as int
	_resultFloat = numArg
	_selectionLock = false
EndEvent

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	string[] entries = new string[128]
	int i = 0
	While i < _entryBuffer
		entries[i] = _entryName[i] + ";;" + _entryParent[i] + ";;" + _entryId[i] + ";;" + _entryCallback[i] + ";;" + (_entryChildren[i] as int)
		i += 1
	EndWhile

	UI.InvokeStringA(ROOT_MENU, MENU_ROOT + "LM_AddTreeEntries", entries)

	If _premadeBuffer > 0
		UI.InvokeStringA(ROOT_MENU, MENU_ROOT + "LM_AddTreeEntries", _premadeEntries)
	Endif
EndEvent

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	UnregisterForModEvent("UIListMenu_LoadMenu")
	UnregisterForModEvent("UIListMenu_CloseMenu")
	UnregisterForModEvent("UIListMenu_SelectItem")
EndEvent
