Scriptname XFLSelectionMenu extends Quest

Message Property FollowerSelection Auto

string _rootMenu = "MessageBoxMenu"
string _proxyMenu = "_root.MessageMenu.proxyMenu.MenuHolder.Menu_mc."

Form _form = None
Form _receiver = None

bool Function OpenMenu(Form aForm, Form aReceiver)
	_form = aForm
	_receiver = aReceiver
	RegisterForMenu(_rootMenu)
	_receiver.RegisterForModEvent("SelectForm", "OnSelectForm")
	return FollowerSelection.Show() as bool
EndFunction

Event OnMenuOpen(string menuName)
	If menuName == _rootMenu
		UI.InvokeForm(_rootMenu, _proxyMenu + "SetSelectionMenuFormData", _form)
	Endif
EndEvent

Event OnMenuClose(string menuName)
	If menuName == _rootMenu
		UnregisterFromMenu(_rootMenu)
		_receiver.UnregisterFromModEvent("SelectForm")
	Endif
EndEvent
