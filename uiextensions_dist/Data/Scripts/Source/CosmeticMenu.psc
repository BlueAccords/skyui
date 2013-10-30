Scriptname CosmeticMenu extends RaceMenu

Function RegisterEvents()
	RegisterForModEvent("TTM_TintColorChange", "OnTintColorChange") ; Event sent when a tint changes color
	RegisterForModEvent("TTM_TintTextureChange", "OnTintTextureChange") ; Event sent when a tint changes texture

	; Overlay Management
	RegisterForModEvent("TTM_OverlayTextureChange", "OnOverlayTextureChange") ; Event sent when an overlay's texture changes
	RegisterForModEvent("TTM_OverlayColorChange", "OnOverlayColorChange") ; Event sent when an overlay's color changes
	RegisterForModEvent("TTM_OverlayGlowColorChange", "OnOverlayGlowColorChange") ; Event sent when an overlay's color changes
	RegisterForModEvent("TTM_ShadersInvalidated", "OnShadersInvalidated") ; Event sent when a tint changes

	; RaceSexMenu Data Transfer
	RegisterForModEvent("RSMDT_SendMenuName", "OnReceiveMenuName")
	RegisterForModEvent("RSMDT_SendRootName", "OnReceiveRootName")
	RegisterForModEvent("RSMDT_SendPaintRequest", "OnReceivePaintRequest")
	RegisterForModEvent("RSMDT_SendRestore", "OnReceiveRestore")
	; --------------------------------------------
EndFunction

Function OnStartup()
	RegisterEvents()

	; Re-initialization in case of init failure?
	Reinitialize()
	
	If SKSE.GetVersionRelease() < 37
		Debug.Notification("SKSE version mismatch. You are running SKSE Version " + SKSE.GetVersion() + "." + SKSE.GetVersionMinor() + "." + SKSE.GetVersionBeta() + "." + SKSE.GetVersionRelease() + " you require 1.6.9 or greater.")
	Endif
	If SKSE.GetVersionRelease() != SKSE.GetScriptVersionRelease()
		Debug.Notification("SKSE script version mismatch. Please reinstall your SKSE scripts to match your version.")
	Endif
	If RaceMenuBase.GetScriptVersionRelease() < 1
		Debug.Notification("Invalid RaceMenuBase script version detected.")
	Endif

	_targetRoot = RACESEX_MENU
	_targetMenu = MENU_ROOT
	_targetActor = _playerActor
EndFunction

Event OnReceivePaintRequest(string eventName, string strArg, float numArg, Form formArg)
	LoadDefaults()
	SaveTints()
	UpdateColors()
	UpdateOverlays()
	parent.OnReceivePaintRequest(eventName, strArg, numArg, formArg)
EndEvent

Event OnGameReload()
	OnStartup()
	LoadDefaults()
EndEvent

Function UpdateTints()
	
EndFunction

Event On3DLoaded(ObjectReference akRef)

EndEvent

Event OnMenuOpen(string menuName)

EndEvent

Event OnMenuClose(string menuName)

EndEvent
