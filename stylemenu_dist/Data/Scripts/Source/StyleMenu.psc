Scriptname StyleMenu extends StyleMenuBase

Event OnInitialized()
	parent.OnInitialized()

	; Init stuff here
EndEvent

Function OnStartup()
	RegisterForModEvent("SSM_Initialized", "OnMenuInitialized") ; Event sent when the menu initializes enough to load data

	If SKSE.GetVersionRelease() < 37
		Debug.Notification("SKSE version mismatch. You are running SKSE Version " + SKSE.GetVersion() + "." + SKSE.GetVersionMinor() + "." + SKSE.GetVersionBeta() + "." + SKSE.GetVersionRelease() + " you require 1.6.9 or greater.")
	Endif
	If SKSE.GetVersionRelease() != SKSE.GetScriptVersionRelease()
		Debug.Notification("SKSE script version mismatch. Please reinstall your SKSE scripts to match your version.")
	Endif
EndFunction

Event OnGameReload()
	OnStartup()
	SendModEvent("SSM_LoadPlugins")
EndEvent

Function OnHeadPartRequest()

EndFunction

Function InjectCustomMenu()
	string rootPath = ""

	string[] args = new string[2]
	args[0] = "StyleMenu"
	args[1] = "-1000"
		
	; Create empty container clip
	UI.InvokeStringA(DIALOGUE_MENU, "_root.createEmptyMovieClip", args)

	; Inject movieclip
	UI.InvokeString(DIALOGUE_MENU, "_root.StyleMenu.loadMovie", "stylemenu.swf")
EndFunction