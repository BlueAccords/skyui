Scriptname UICosmeticMenu extends UIMenuBase

Message Property UICosmeticMenuMessage Auto

string property		ROOT_MENU		= "MessageBoxMenu" autoReadonly
string Property 	MENU_ROOT		= "_root.MessageMenu.proxyMenu.cosmeticMenu.RaceMenuInstance." autoReadonly
string Property 	THIS_ROOT		= "_root.MessageMenu.proxyMenu.cosmeticMenu." autoReadonly

string Property 	COSMETIC_CATEGORY_WARPAINT = 1 autoReadonly
string Property 	COSMETIC_CATEGORY_BODYPAINT = 2 autoReadonly
string Property 	COSMETIC_CATEGORY_HANDPAINT = 4 autoReadonly
string Property 	COSMETIC_CATEGORY_FEETPAINT = 8 autoReadonly

Form _form = None
int _categories = 0
bool _selectionLock = false

int Function OpenMenu(Form aForm = None, Form aReceiver = None)
	_form = aForm
	RegisterForModEvent("UICosmeticMenu_LoadMenu", "OnLoadMenu")
	RegisterForModEvent("UICosmeticMenu_CloseMenu", "OnUnloadMenu")
	_selectionLock = true
	int ret = UICosmeticMenuMessage.Show()
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
	return "UICosmeticMenu"
EndFunction

Function SetPropertyInt(string propertyName, int value)
	If propertyName == "categories"
		_categories = value
	Endif
EndFunction

Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	Actor targetActor = _form as Actor
	ActorBase targetBase = targetActor.GetActorBase()
	Race targetRace = targetActor.GetRace()

	((self as Quest) as CosmeticMenu)._targetMenu = ROOT_MENU
	((self as Quest) as CosmeticMenu)._targetRoot = MENU_ROOT
	((self as Quest) as CosmeticMenu)._targetActor = targetActor

	UI.Invoke(ROOT_MENU, MENU_ROOT + "InitExtensions")
	float[] params = new Float[2]
	params[0] = Game.UsingGamepad() as float
	params[1] = 0
	UI.InvokeFloatA(ROOT_MENU, MENU_ROOT + "SetPlatform", params)

	SendModEvent("RSMDT_SendMenuName", ROOT_MENU)
	SendModEvent("RSMDT_SendRootName", MENU_ROOT)

	UI.InvokeString(ROOT_MENU, MENU_ROOT + "SetNameText", targetBase.GetName())
	UI.InvokeString(ROOT_MENU, MENU_ROOT + "SetRaceText", targetRace.GetName())

	UI.InvokeInt(ROOT_MENU, THIS_ROOT + "TTM_ShowCategories", _categories)

	SendModEvent("RSMDT_SendPaintRequest", "", _categories as float)
EndEvent

Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	UnregisterForModEvent("UICosmeticMenu_LoadMenu")
	UnregisterForModEvent("UICosmeticMenu_CloseMenu")

	SendModEvent("RSMDT_SendRestore")
EndEvent