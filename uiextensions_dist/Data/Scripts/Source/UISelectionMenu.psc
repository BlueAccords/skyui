Scriptname UISelectionMenu extends UIMenuBase

Message Property UISelectionMessage Auto
FormList Property SelectedForms  Auto  

string property		ROOT_MENU		= "MessageBoxMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.MessageMenu.proxyMenu.MenuHolder.Menu_mc." autoReadonly

Form _form = None
Form _receiver = None
Form _selected = None

bool _selectionLock = false
int _mode = 0

float tempSoundDB = 0.0

Form Function GetFormResult()
	if _mode == 0
		return _selected
	elseif _mode == 1
		return SelectedForms
	endif
	return None
EndFunction

Function SetPropertyInt(string propertyName, int value)
	If propertyName == "UISelectionMenuMode"
		_mode = value
	Endif
EndFunction

int Function OpenMenu(Form aForm, Form aReceiver = None)
	_form = aForm
	_receiver = aReceiver
	_selected = None
	SelectedForms.Revert()
	RegisterForMenu(ROOT_MENU)
	RegisterForModEvent("UISelectionMenu_LoadMenu", "OnLoadMenu")
	RegisterForModEvent("UISelectionMenu_SelectForm", "OnSelect")
	RegisterForModEvent("UISelectionMenu_SelectionReady", "OnSelectForm")
	_receiver.RegisterForModEvent("UISelectionMenu_SelectionChanged", "OnSelectForm")
	_selectionLock = true
	int ret = UISelectionMessage.Show()
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
	return "UISelectionMenu"
EndFunction

; Push forms to FormList
Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
	if _mode == 0
		_selected = formArg
	elseif _mode == 1
		SelectedForms.AddForm(formArg)
	endif
EndEvent

; Unlock selection menu
Event OnSelectForm(string eventName, string strArg, float numArg, Form formArg)
	_selectionLock = false
EndEvent

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	UI.InvokeForm(ROOT_MENU, MENU_ROOT + "SetSelectionMenuFormData", _form)
	UI.InvokeFloat(ROOT_MENU, MENU_ROOT + "SetSelectionMenuMode", _mode as float)

	SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
	tempSoundDB = sDescriptor.GetDecibelAttenuation()
	sDescriptor.SetDecibelAttenuation(100.0)
EndEvent

Event OnMenuClose(string menuName)
	If menuName == ROOT_MENU
		UnregisterForMenu(ROOT_MENU)
		_receiver.UnregisterForModEvent("UISelectionMenu_SelectionChanged")
		SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
		sDescriptor.SetDecibelAttenuation(tempSoundDB)
	Endif
EndEvent
