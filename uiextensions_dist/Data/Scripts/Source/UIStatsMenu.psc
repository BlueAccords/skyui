Scriptname UIStatsMenu extends UIMenuBase

Message Property UIStatsMenuMessage Auto

string property		ROOT_MENU		= "MessageBoxMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.MessageMenu.proxyMenu.ActorStatsPanelFader.actorStatsPanel." autoReadonly

Form _form = None

string Function GetMenuName()
	return "UIStatsMenu"
EndFunction

int Function OpenMenu(Form inForm, Form akReceiver = None)
	_form = inForm
	RegisterForModEvent("UIStatsMenu_LoadMenu", "OnLoadMenu")
	return UIStatsMenuMessage.Show()
EndFunction

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	UpdateStatsForm()
EndEvent

Function UpdateStatsForm()
	UI.InvokeForm(ROOT_MENU, MENU_ROOT + "setActorStatsPanelForm", _form)
EndFunction