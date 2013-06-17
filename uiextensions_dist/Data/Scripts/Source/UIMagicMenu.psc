Scriptname UIMagicMenu extends UIMenuBase  

Message Property UIMagicMenuMessage Auto

string property		ROOT_MENU		= "MessageBoxMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.MessageMenu.proxyMenu." autoReadonly
string property		CONFIG_ROOT		= "_global.skyui.util.ConfigManager" autoReadonly

Actor _actor = None

float tempSoundDB = 0.0

string Function GetMenuName()
	return "UIMagicMenu"
EndFunction

int Function OpenMenu(Form akForm = None, Form akReceiver = None)
	_actor = akForm as Actor
	RegisterForMenu(ROOT_MENU)
	return UIMagicMenuMessage.Show()
EndFunction

Event OnMenuOpen(string menuName)
	If menuName == ROOT_MENU
		UI.Invoke(ROOT_MENU, MENU_ROOT + "InitExtensions")
		float[] params = new Float[2]
		params[0] = Game.UsingGamepad() as float
		params[1] = 0
		UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "SetPlatform", params)
		UI.InvokeForm(ROOT_MENU, MENU_ROOT + "Menu_mc.SetMagicMenuExtActor", _actor)

		string[] overrideKeys = new string[1]
		string[] overrideValues = new string[1]
		UI.InvokeStringA(ROOT_MENU, CONFIG_ROOT + ".setExternalOverrideKeys", overrideKeys)
		UI.InvokeStringA(ROOT_MENU, CONFIG_ROOT + ".setExternalOverrideValues", overrideValues)

		; Kill the MessageBox UI OK Sound
		SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
		tempSoundDB = sDescriptor.GetDecibelAttenuation()
		sDescriptor.SetDecibelAttenuation(100.0)
	Endif
EndEvent

Event OnMenuClose(string menuName)
	If menuName == ROOT_MENU
		UnregisterForMenu(ROOT_MENU)

		; Restore the MessageBox UI OK Sound
		SoundDescriptor sDescriptor = (Game.GetForm(0x137E7) as Sound).GetDescriptor()
		sDescriptor.SetDecibelAttenuation(tempSoundDB)
	Endif
EndEvent
