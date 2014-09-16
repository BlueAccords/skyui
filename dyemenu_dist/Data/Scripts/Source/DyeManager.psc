Scriptname DyeManager extends Quest

Perk Property DyeAlchemyPerk Auto

; Minimum SKSE version statistics
int Property SKSE_MAJOR_VERSION = 1 AutoReadOnly
int Property SKSE_MINOR_VERSION = 7 AutoReadOnly
int Property SKSE_BETA_VERSION = 1 AutoReadOnly
int Property SKSE_RELEASE_VERSION = 46 AutoReadOnly

; NiOverride version data
int Property NIOVERRIDE_VERSION = 3 AutoReadOnly
int Property NIOVERRIDE_SCRIPT_VERSION = 1 AutoReadOnly

Event OnInit()
	OnGameReload()
EndEvent

Event OnGameReload()
	; SKSE Version Check
	string startupError = ""
	If SKSE.GetVersionRelease() < SKSE_RELEASE_VERSION
		startupError += ("SKSE version error. You are running SKSE Version " + SKSE.GetVersion() + "." + SKSE.GetVersionMinor() + "." + SKSE.GetVersionBeta() + "." + SKSE.GetVersionRelease() + " expected "+SKSE_MAJOR_VERSION+"."+SKSE_MINOR_VERSION+"."+SKSE_BETA_VERSION+"."+SKSE_RELEASE_VERSION+" or greater. ")
	Endif
	If SKSE.GetVersionRelease() != SKSE.GetScriptVersionRelease()
		startupError += ("SKSE script version mismatch detected (" + SKSE.GetScriptVersionRelease() + ") expected (" + SKSE.GetVersionRelease() + "). Please reinstall your SKSE scripts to match your version. ")
	Endif

	int nioverrideVersion = SKSE.GetPluginVersion("NiOverride")
	int nioverrideScriptVersion = NiOverride.GetScriptVersion()

	; Plugins not installed
	If nioverrideVersion == 0
		startupError += ("NiOverride plugin not detected, DyeMenu will not be available. ")
	Endif
	; Plugin installed but wrong version
	If nioverrideVersion > 0 && nioverrideVersion < NIOVERRIDE_VERSION
		startupError += ("Invalid NiOverride plugin version detected (" + nioverrideVersion + ") expected (" + NIOVERRIDE_VERSION + ") or greater. ")
	Endif
	If nioverrideScriptVersion < NIOVERRIDE_SCRIPT_VERSION
		startupError += ("Invalid NiOverride script version detected (" + nioverrideScriptVersion + ") expected (" + NIOVERRIDE_SCRIPT_VERSION + ") or greater. ")
	Endif
	bool MENUCheck = (Game.GetFormFromFile(0xE07, "UIExtensions.esp") != None)
	if !MENUCheck
		startupError += ("Could not find UIExtensions.esp or DyeManager.")
	Endif

	If startupError != ""
		Debug.MessageBox("DyeManager Error(s): " + startupError)
		Game.GetPlayer().RemovePerk(DyeAlchemyPerk)
	Else
		Game.GetPlayer().AddPerk(DyeAlchemyPerk)
	Endif
EndEvent