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

Form Function GetResultForm()
	if _mode == 0
		return _selected
	elseif _mode == 1
		return SelectedForms
	endif
	return None
EndFunction

Function SetPropertyInt(string propertyName, int value)
	If propertyName == "menuMode"
		_mode = value
	Endif
EndFunction

int Function OpenMenu(Form aForm = None, Form aReceiver = None)
	_form = aForm
	_receiver = aReceiver
	_selected = None
	SelectedForms.Revert()
	RegisterForModEvent("UISelectionMenu_LoadMenu", "OnLoadMenu")
	RegisterForModEvent("UISelectionMenu_CloseMenu", "OnUnloadMenu")
	RegisterForModEvent("UISelectionMenu_SelectForm", "OnSelect")
	RegisterForModEvent("UISelectionMenu_SelectionReady", "OnSelectForm")
	If _receiver
		_receiver.RegisterForModEvent("UISelectionMenu_SelectionChanged", "OnSelectForm")
	Endif
	_selectionLock = true

	SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
	tempSoundDB = sDescriptor.GetDecibelAttenuation()
	sDescriptor.SetDecibelAttenuation(100.0)

	int ret = UISelectionMessage.Show()
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
EndEvent

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	UnregisterForModEvent("UISelectionMenu_LoadMenu")
	UnregisterForModEvent("UISelectionMenu_CloseMenu")
	UnregisterForModEvent("UISelectionMenu_SelectForm")
	UnregisterForModEvent("UISelectionMenu_SelectionReady")
	If _receiver
		_receiver.UnregisterForModEvent("UISelectionMenu_SelectionChanged")
	Endif
	SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
	sDescriptor.SetDecibelAttenuation(tempSoundDB)
EndEvent
