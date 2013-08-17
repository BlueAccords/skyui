Scriptname UIStatsMenu extends UIMenuBase

Message Property UIStatsMenuMessage Auto

string property		ROOT_MENU		= "MessageBoxMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.MessageMenu.proxyMenu.ActorStatsPanelFader.actorStatsPanel." autoReadonly

Form _form = None

string Function GetMenuName()
	return "UIStatsMenu"
EndFunction

int Function OpenMenu(Form inForm = None, Form akReceiver = None)
	_form = inForm
	RegisterForModEvent("UIStatsMenu_LoadMenu", "OnLoadMenu")
	RegisterForModEvent("UIStatsMenu_CloseMenu", "OnUnloadMenu")
	return UIStatsMenuMessage.Show()
EndFunction

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	UpdateStatsForm()
EndEvent

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	UnregisterForModEvent("UIStatsMenu_LoadMenu")
	UnregisterForModEvent("UIStatsMenu_CloseMenu")
EndEvent

Function UpdateStatsForm()
	UI.InvokeForm(ROOT_MENU, MENU_ROOT + "setActorStatsPanelForm", _form)
EndFunction

