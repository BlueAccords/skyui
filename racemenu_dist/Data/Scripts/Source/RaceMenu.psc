Scriptname RaceMenu extends RaceMenuBase

int Property TINT_TYPE_HAIR = 128 AutoReadOnly

int Property MAX_PRESETS = 4 AutoReadOnly
int Property MAX_MORPHS = 19 AutoReadOnly

ColorForm _hairColor = None
Form _lightForm = None
ObjectReference _light = None
int _color = 0
bool _customHair = false
int[] _tintTypes
int[] _tintColors
string[] _tintTextures
int[] _presets
float[] _morphs

Event OnInitialized()
	parent.OnInitialized()

	_hairColor = Game.GetFormFromFile(0x801, "RaceMenu.esp") as ColorForm
	_lightForm = Game.GetFormFromFile(0x803, "RaceMenu.esp")
	
	_tintTextures = new string[128]
	_tintTypes = new int[128]
	_tintColors = new int[128]
	_presets = new int[4]
	_morphs = new float[19]

	SaveHair()
	SaveTints()
EndEvent

Function OnStartup()
	RegisterForMenu(RACESEX_MENU)

	RegisterForModEvent("RSM_Initialized", "OnMenuInitialized") ; Event sent when the menu initializes enough to load data
	RegisterForModEvent("RSM_Reinitialized", "OnMenuReinitialized") ; Event sent when sliders have re-initialized
	RegisterForModEvent("RSM_HairColorChange", "OnHairColorChange") ; Event sent when hair color changes
	RegisterForModEvent("RSM_TintColorChange", "OnTintColorChange") ; Event sent when a tint changes color
	RegisterForModEvent("RSM_TintTextureChange", "OnTintTextureChange") ; Event sent when a tint changes texture
	RegisterForModEvent("RSM_ToggleLight", "OnToggleLight") ; Event sent when the Light button is pressed

	; Handles clipboard data transfer DO NOT EDIT
	RegisterForModEvent("RSM_RequestLoadClipboard", "OnLoadClipboard")
	RegisterForModEvent("RSM_RequestSaveClipboard", "OnSaveClipboard")

	RegisterForModEvent("RSM_ClipboardData", "OnClipboardData")
	RegisterForModEvent("RSM_ClipboardFinished", "OnClipboardFinished")
	; --------------------------------------------

	Utility.SetINIFloat("fPlayerBodyEditDistance:Interface", 180.0)
	Utility.SetINIFloat("fPlayerFaceEditDistance:Interface", 60.0)
EndFunction

Event OnGameReload()
	OnStartup()

	; Reload player settings
	LoadHair()
	LoadTints()

	_playerActor.QueueNiNodeUpdate()
EndEvent

Event OnMenuOpen(string menuName)
	If menuName == RACESEX_MENU
		UpdateRaces()
		_light = _playerActor.placeAtMe(_lightForm)
		float zOffset = _light.GetHeadingAngle(_playerActor)
		_light.SetAngle(_light.GetAngleX(), _light.GetAngleY(), _light.GetAngleZ() + zOffset)
		_light.MoveTo(_playerActor, 60 * Math.Sin(_playerActor.GetAngleZ()), 60 * Math.Cos(_playerActor.GetAngleZ()), _playerActor.GetHeight())
	Endif
EndEvent

Event OnMenuClose(string menuName)
	If menuName == RACESEX_MENU
		_light.Delete()
		_light = None
		SaveHair()
		SaveTints()
	Endif
EndEvent

Event OnMenuInitialized(string eventName, string strArg, float numArg, Form formArg)
	UpdateColors()
	LoadTints()
	LoadHair()
	_playerActor.QueueNiNodeUpdate()
	parent.OnMenuInitialized(eventName, strArg, numArg, formArg)
EndEvent

Event OnMenuReinitialized(string eventName, string strArg, float numArg, Form formArg)
	SaveHair()
	SaveTints()
	UpdateColors()
EndEvent

Function LoadHair()
	If _customHair
		_hairColor.SetColor(_color)
		_playerActorBase.SetHairColor(_hairColor)
	EndIf
EndFunction

Function SaveHair()
	ColorForm hairColor = _playerActorBase.GetHairColor()
	If hairColor == _hairColor
		_color = hairColor.GetColor() + 0xFF000000
		_customHair = true
	Elseif hairColor != None
		_color = hairColor.GetColor() + 0xFF000000
		_customHair = false
	Else
		_color = 0xFF000000
		_customHair = false
	EndIf
EndFunction

Function LoadTints()
	int i = 0
	int totalTints = Game.GetNumTintMasks()
	While i < totalTints
		int color = _tintColors[i]
		string texture = _tintTextures[i]
		If texture != ""
			Game.SetNthTintMaskTexturePath(texture, i)
		Endif
		If color != 0
			Game.SetNthTintMaskColor(i, color)
		Endif
		i += 1
	EndWhile
EndFunction

Function SaveTints()
	int totalTints = Game.GetNumTintMasks()
	int i = 0
	While i < totalTints
		_tintTypes[i] = Game.GetNthTintMaskType(i)
		_tintColors[i] = Game.GetNthTintMaskColor(i)
		_tintTextures[i] = Game.GetNthTintMaskTexturePath(i)
		i += 1
	EndWhile
EndFunction

Function LoadPresets()
	int totalPresets = MAX_PRESETS
	int i = 0
	While i < totalPresets
		_playerActorBase.SetFacePreset(_presets[i], i)
		i += 1
	EndWhile
EndFunction

Function SavePresets()
	int totalPresets = MAX_PRESETS
	int i = 0
	While i < totalPresets
		_presets[i] = _playerActorBase.GetFacePreset(i)
		i += 1
	EndWhile
EndFunction

Function LoadMorphs()
	int totalMorphs = MAX_MORPHS
	int i = 0
	While i < totalMorphs
		_playerActorBase.SetFaceMorph(_morphs[i], i)
		i += 1
	EndWhile
EndFunction

Function SaveMorphs()
	int totalMorphs = MAX_MORPHS
	int i = 0
	While i < totalMorphs
		_morphs[i] = _playerActorBase.GetFaceMorph(i)
		i += 1
	EndWhile
EndFunction

Function ClearTints()
	int i = 0
	While i < _tintTypes.length
		_tintTypes[i] = 0
		_tintColors[i] = 0
		_tintTextures[i] = ""
		i += 1
	EndWhile
EndFunction

Event OnHairColorChange(string eventName, string strArg, float numArg, Form formArg)
	_color = strArg as int
	_hairColor.SetColor(_color)
	_playerActorBase.SetHairColor(_hairColor)
	Game.UpdateHairColor()
EndEvent

Event OnTintColorChange(string eventName, string strArg, float numArg, Form formArg)
	int color = strArg as int
	int arg = numArg as int
	int type = arg / 1000
	int index = arg - (type * 1000)
	Game.SetTintMaskColor(color, type, index)
	_playerActor.QueueNiNodeUpdate()
	;Game.UpdateTintMaskColors()
EndEvent

Event OnTintTextureChange(string eventName, string strArg, float numArg, Form formArg)
	string texture = strArg
	int arg = numArg as int
	int type = arg / 1000
	int index = arg - (type * 1000)
	Game.SetTintMaskTexturePath(strArg, type, index)
	_playerActor.QueueNiNodeUpdate()
EndEvent

Event OnToggleLight(string eventName, string strArg, float numArg, Form formArg)
	bool lightOn = numArg as bool
	if lightOn
		_light.EnableNoWait()
	Else
		_light.DisableNoWait()
	Endif
EndEvent

; ------------------------------- Clipboard Events -----------------------------------
Event OnLoadClipboard(string eventName, string strArg, float numArg, Form formArg)
	UI.InvokeBool(RACESEX_MENU, MENU_ROOT + "RSM_ToggleLoader", true)
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_LoadClipboard")
EndEvent

Event OnSaveClipboard(string eventName, string strArg, float numArg, Form formArg)
	SavePresets()
	SaveMorphs()
	float[] args = new float[23]
	int i = 0
	While i < MAX_PRESETS
		args[i] = _presets[i]
		i += 1
	EndWhile
	i = 0
	While i < MAX_MORPHS
		args[i + 4] = _morphs[i]
		i += 1
	EndWhile

	UI.InvokeFloatA(RACESEX_MENU, MENU_ROOT + "RSM_SaveClipboard", args)
EndEvent

Event OnClipboardData(string eventName, string strArg, float numArg, Form formArg)
	int index = strArg as int
	If index < 4
		_presets[index] = numArg as int
	Else
		index = index - 4
		_morphs[index] = numArg
	Endif
EndEvent

Event OnClipboardFinished(string eventName, string strArg, float numArg, Form formArg)
	LoadPresets()
	LoadMorphs()
	_playerActor.QueueNiNodeUpdate()
	UI.InvokeBool(RACESEX_MENU, MENU_ROOT + "RSM_ToggleLoader", false)
EndEvent
; ------------------------------------------------------------------------------------

; VoiceType Function GetVoiceType(bool female, int index)
; 	If female == false
; 		return _maleVoiceTypes[index]
; 	Elseif female == true
; 		return _femaleVoiceTypes[index]
; 	Endif
; 	return None
; EndFunction

; int Function GetVoiceTypeIndex(bool female, VoiceType aVoice)
; 	If female == false
; 		int i = 0
; 		While i < 25
; 			If _maleVoiceTypes[i] == aVoice
; 				return i
; 			Endif
; 			i += 1
; 		EndWhile
; 	Elseif female == true
; 		int i = 0
; 		While i < 18
; 			If _femaleVoiceTypes[i] == aVoice
; 				return i
; 			Endif
; 			i += 1
; 		EndWhile
; 	EndIf
; 	return -1
; EndFunction

; Function LoadVoiceTypes()
; 	; Avoid adding properties to script
; 	_maleVoiceTypes[0] = Game.GetFormFromFile(0xea267, "Skyrim.esm") as VoiceType ; MaleEvenTonedAccented
; 	_maleVoiceTypes[1] = Game.GetFormFromFile(0xea266, "Skyrim.esm") as VoiceType ; MaleCommonerAccented
; 	_maleVoiceTypes[2] = Game.GetFormFromFile(0xaa8d3, "Skyrim.esm") as VoiceType ; MaleGuard
; 	_maleVoiceTypes[3] = Game.GetFormFromFile(0x9844f, "Skyrim.esm") as VoiceType ; MaleForsworn
; 	_maleVoiceTypes[4] = Game.GetFormFromFile(0x9843b, "Skyrim.esm") as VoiceType ; MaleBandit
; 	_maleVoiceTypes[5] = Game.GetFormFromFile(0x9843a, "Skyrim.esm") as VoiceType ; MaleWarlock
; 	_maleVoiceTypes[6] = Game.GetFormFromFile(0xe5003, "Skyrim.esm") as VoiceType ; MaleNordCommander
; 	_maleVoiceTypes[7] = Game.GetFormFromFile(0x13af2, "Skyrim.esm") as VoiceType ; MaleDarkElf
; 	_maleVoiceTypes[8] = Game.GetFormFromFile(0x13af0, "Skyrim.esm") as VoiceType ; MaleElfHaughty
; 	_maleVoiceTypes[9] = Game.GetFormFromFile(0x13aee, "Skyrim.esm") as VoiceType ; MaleArgonian
; 	_maleVoiceTypes[10] = Game.GetFormFromFile(0x13aec, "Skyrim.esm") as VoiceType ; MaleKhajiit
; 	_maleVoiceTypes[11] = Game.GetFormFromFile(0x13aea, "Skyrim.esm") as VoiceType ; MaleOrc
; 	_maleVoiceTypes[12] = Game.GetFormFromFile(0x13ae8, "Skyrim.esm") as VoiceType ; MaleChild
; 	_maleVoiceTypes[13] = Game.GetFormFromFile(0x13ae6, "Skyrim.esm") as VoiceType ; MaleNord
; 	_maleVoiceTypes[14] = Game.GetFormFromFile(0x13adb, "Skyrim.esm") as VoiceType ; MaleCoward
; 	_maleVoiceTypes[15] = Game.GetFormFromFile(0x13ada, "Skyrim.esm") as VoiceType ; MaleBrute
; 	_maleVoiceTypes[16] = Game.GetFormFromFile(0x13ad9, "Skyrim.esm") as VoiceType ; MaleCondescending
; 	_maleVoiceTypes[17] = Game.GetFormFromFile(0x13ad8, "Skyrim.esm") as VoiceType ; MaleCommander
; 	_maleVoiceTypes[18] = Game.GetFormFromFile(0x13ad7, "Skyrim.esm") as VoiceType ; MaleOldGrumpy
; 	_maleVoiceTypes[19] = Game.GetFormFromFile(0x13ad6, "Skyrim.esm") as VoiceType ; MaleOldKindly
; 	_maleVoiceTypes[20] = Game.GetFormFromFile(0x13ad5, "Skyrim.esm") as VoiceType ; MaleSlyCynical
; 	_maleVoiceTypes[21] = Game.GetFormFromFile(0x13ad4, "Skyrim.esm") as VoiceType ; MaleDrunk
; 	_maleVoiceTypes[22] = Game.GetFormFromFile(0x13ad3, "Skyrim.esm") as VoiceType ; MaleCommoner
; 	_maleVoiceTypes[23] = Game.GetFormFromFile(0x13ad2, "Skyrim.esm") as VoiceType ; MaleEvenToned
; 	_maleVoiceTypes[24] = Game.GetFormFromFile(0x13ad1, "Skyrim.esm") as VoiceType ; MaleYoungEager

; 	_femaleVoiceTypes[0] = Game.GetFormFromFile(0x1b560, "Skyrim.esm") as VoiceType ; FemaleSoldier
; 	_femaleVoiceTypes[1] = Game.GetFormFromFile(0x13bc3, "Skyrim.esm") as VoiceType ; FemaleShrill
; 	_femaleVoiceTypes[2] = Game.GetFormFromFile(0x13af3, "Skyrim.esm") as VoiceType ; FemaleDarkElf
; 	_femaleVoiceTypes[3] = Game.GetFormFromFile(0x13af1, "Skyrim.esm") as VoiceType ; FemaleElfHaughty
; 	_femaleVoiceTypes[4] = Game.GetFormFromFile(0x13aef, "Skyrim.esm") as VoiceType ; FemaleArgonian
; 	_femaleVoiceTypes[5] = Game.GetFormFromFile(0x13aed, "Skyrim.esm") as VoiceType ; FemaleKhajiit
; 	_femaleVoiceTypes[6] = Game.GetFormFromFile(0x13aeb, "Skyrim.esm") as VoiceType ; FemaleOrc
; 	_femaleVoiceTypes[7] = Game.GetFormFromFile(0x13ae9, "Skyrim.esm") as VoiceType ; FemaleChild
; 	_femaleVoiceTypes[8] = Game.GetFormFromFile(0x13ae7, "Skyrim.esm") as VoiceType ; FemaleNord
; 	_femaleVoiceTypes[9] = Game.GetFormFromFile(0x13ae5, "Skyrim.esm") as VoiceType ; FemaleCoward
; 	_femaleVoiceTypes[10] = Game.GetFormFromFile(0x13ae4, "Skyrim.esm") as VoiceType ; FemaleCondescending
; 	_femaleVoiceTypes[11] = Game.GetFormFromFile(0x13ae3, "Skyrim.esm") as VoiceType ; FemaleCommander
; 	_femaleVoiceTypes[12] = Game.GetFormFromFile(0x13ae2, "Skyrim.esm") as VoiceType ; FemaleOldGrumpy
; 	_femaleVoiceTypes[13] = Game.GetFormFromFile(0x13ae1, "Skyrim.esm") as VoiceType ; FemaleOldKindly
; 	_femaleVoiceTypes[14] = Game.GetFormFromFile(0x13ae0, "Skyrim.esm") as VoiceType ; FemaleSultry
; 	_femaleVoiceTypes[15] = Game.GetFormFromFile(0x13ade, "Skyrim.esm") as VoiceType ; FemaleCommoner
; 	_femaleVoiceTypes[16] = Game.GetFormFromFile(0x13add, "Skyrim.esm") as VoiceType ; FemaleEvenToned
; 	_femaleVoiceTypes[17] = Game.GetFormFromFile(0x13adc, "Skyrim.esm") as VoiceType ; FemaleYoungEager
; EndFunction

Function OnWarpaintRequest()
	AddWarpaint("$Male Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_01.dds")
	AddWarpaint("$Male Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_02.dds")
	AddWarpaint("$Male Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_03.dds")
	AddWarpaint("$Male Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_04.dds")
	AddWarpaint("$Male Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_05.dds")
	AddWarpaint("$Male Warpaint 06", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_06.dds")
	AddWarpaint("$Male Warpaint 07", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_07.dds")
	AddWarpaint("$Male Warpaint 08", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_08.dds")
	AddWarpaint("$Male Warpaint 09", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_09.dds")
	AddWarpaint("$Male Warpaint 10", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_10.dds")
	AddWarpaint("$Male Nord Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_01.dds")
	AddWarpaint("$Male Nord Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_02.dds")
	AddWarpaint("$Male Nord Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_03.dds")
	AddWarpaint("$Male Nord Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_04.dds")
	AddWarpaint("$Male Nord Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_05.dds")
	AddWarpaint("$Female Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_01.dds")
	AddWarpaint("$Female Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_02.dds")
	AddWarpaint("$Female Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_03.dds")
	AddWarpaint("$Female Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_04.dds")
	AddWarpaint("$Female Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_05.dds")
	AddWarpaint("$Female Warpaint 06", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_06.dds")
	AddWarpaint("$Female Warpaint 07", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_07.dds")
	AddWarpaint("$Female Warpaint 08", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_08.dds")
	AddWarpaint("$Female Warpaint 09", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_09.dds")
	AddWarpaint("$Female Warpaint 10", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_10.dds")
	AddWarpaint("$Female Nord Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_01.dds")
	AddWarpaint("$Female Nord Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_02.dds")
	AddWarpaint("$Female Nord Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_03.dds")
	AddWarpaint("$Female Nord Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_04.dds")
	AddWarpaint("$Female Nord Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_05.dds")
	AddWarpaint("$Argonian Stripes 01", "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes01.dds")
	AddWarpaint("$Argonian Stripes 02", "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes02.dds")
	AddWarpaint("$Argonian Stripes 03", "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes03.dds")
	AddWarpaint("$Argonian Stripes 04", "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes04.dds")
	AddWarpaint("$Argonian Stripes 05", "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes05.dds")
	AddWarpaint("$Argonian Stripes 06", "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes06.dds")
	AddWarpaint("$Female High Elf Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadHighElfWarPaint_01.dds")
	AddWarpaint("$Female High Elf Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadHighElfWarPaint_02.dds")
	AddWarpaint("$Female High Elf Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadHighElfWarPaint_03.dds")
	AddWarpaint("$Female High Elf Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadHighElfWarPaint_04.dds")
	AddWarpaint("$Male Dark Elf Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_01.dds")
	AddWarpaint("$Male Dark Elf Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_02.dds")
	AddWarpaint("$Male Dark Elf Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_03.dds")
	AddWarpaint("$Male Dark Elf Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_04.dds")
	AddWarpaint("$Male Dark Elf Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_05.dds")
	AddWarpaint("$Male Dark Elf Warpaint 06", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_06.dds")
	AddWarpaint("$Female Dark Elf Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_01.dds")
	AddWarpaint("$Female Dark Elf Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_02.dds")
	AddWarpaint("$Female Dark Elf Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_03.dds")
	AddWarpaint("$Female Dark Elf Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_04.dds")
	AddWarpaint("$Female Dark Elf Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_05.dds")
	AddWarpaint("$Female Dark Elf Warpaint 06", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_06.dds")
	AddWarpaint("$Male Imperial Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_01.dds")
	AddWarpaint("$Male Imperial Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_02.dds")
	AddWarpaint("$Male Imperial Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_03.dds")
	AddWarpaint("$Male Imperial Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_04.dds")
	AddWarpaint("$Male Imperial Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_05.dds")
	AddWarpaint("$Female Imperial Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_01.dds")
	AddWarpaint("$Female Imperial Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_02.dds")
	AddWarpaint("$Female Imperial Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_03.dds")
	AddWarpaint("$Female Imperial Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_04.dds")
	AddWarpaint("$Female Imperial Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_05.dds")
	AddWarpaint("$Khajiit Stripes 01", "Actors\\Character\\Character Assets\\TintMasks\\KhajiitStripes01.dds")
	AddWarpaint("$Khajiit Stripes 02", "Actors\\Character\\Character Assets\\TintMasks\\KhajiitStripes02.dds")
	AddWarpaint("$Khajiit Stripes 03", "Actors\\Character\\Character Assets\\TintMasks\\KhajiitStripes03.dds")
	AddWarpaint("$Khajiit Stripes 04", "Actors\\Character\\Character Assets\\TintMasks\\KhajiitStripes04.dds")
	AddWarpaint("$Khajiit Paint 01", "Actors\\Character\\Character Assets\\TintMasks\\KhajiitPaint01.dds")
	AddWarpaint("$Khajiit Paint 02", "Actors\\Character\\Character Assets\\TintMasks\\KhajiitPaint02.dds")
	AddWarpaint("$Khajiit Paint 03", "Actors\\Character\\Character Assets\\TintMasks\\KhajiitPaint03.dds")
	AddWarpaint("$Khajiit Paint 04", "Actors\\Character\\Character Assets\\TintMasks\\KhajiitPaint04.dds")
	AddWarpaint("$Male Orc Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_01.dds")
	AddWarpaint("$Male Orc Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_02.dds")
	AddWarpaint("$Male Orc Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_03.dds")
	AddWarpaint("$Male Orc Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_04.dds")
	AddWarpaint("$Male Orc Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_05.dds")
	AddWarpaint("$Female Orc Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_01.dds")
	AddWarpaint("$Female Orc Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_02.dds")
	AddWarpaint("$Female Orc Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_03.dds")
	AddWarpaint("$Female Orc Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_04.dds")
	AddWarpaint("$Female Orc Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_05.dds")
	AddWarpaint("$Male Redguard Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_01.dds")
	AddWarpaint("$Male Redguard Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_02.dds")
	AddWarpaint("$Male Redguard Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_03.dds")
	AddWarpaint("$Male Redguard Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_04.dds")
	AddWarpaint("$Male Redguard Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_05.dds")
	AddWarpaint("$Female Redguard Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_01.dds")
	AddWarpaint("$Female Redguard Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_02.dds")
	AddWarpaint("$Female Redguard Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_03.dds")
	AddWarpaint("$Female Redguard Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_04.dds")
	AddWarpaint("$Female Redguard Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_05.dds")
	AddWarpaint("$Male Wood Elf Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_01.dds")
	AddWarpaint("$Male Wood Elf Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_02.dds")
	AddWarpaint("$Male Wood Elf Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_03.dds")
	AddWarpaint("$Male Wood Elf Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_04.dds")
	AddWarpaint("$Male Wood Elf Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_05.dds")
	AddWarpaint("$Female Wood Elf Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_01.dds")
	AddWarpaint("$Female Wood Elf Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_02.dds")
	AddWarpaint("$Female Wood Elf Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_03.dds")
	AddWarpaint("$Female Wood Elf Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_04.dds")
	AddWarpaint("$Female Wood Elf Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_05.dds")
	AddWarpaint("$Male Breton Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_01.dds")
	AddWarpaint("$Male Breton Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_02.dds")
	AddWarpaint("$Male Breton Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_03.dds")
	AddWarpaint("$Male Breton Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_04.dds")
	AddWarpaint("$Male Breton Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_05.dds")
	AddWarpaint("$Female Breton Warpaint 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_01.dds")
	AddWarpaint("$Female Breton Warpaint 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_02.dds")
	AddWarpaint("$Female Breton Warpaint 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_03.dds")
	AddWarpaint("$Female Breton Warpaint 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_04.dds")
	AddWarpaint("$Female Breton Warpaint 05", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_05.dds")
	AddWarpaint("$Male Forsworn Tattoo 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadForswornTattoo_01.dds")
	AddWarpaint("$Male Forsworn Tattoo 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadForswornTattoo_02.dds")
	AddWarpaint("$Male Forsworn Tattoo 03", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadForswornTattoo_03.dds")
	AddWarpaint("$Male Forsworn Tattoo 04", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadForswornTattoo_04.dds")
	AddWarpaint("$Female Forsworn Tattoo 01", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadForswornTattoo_01.dds")
	AddWarpaint("$Female Forsworn Tattoo 02", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadForswornTattoo_02.dds")
	AddWarpaint("$Female Forsworn Tattoo 03", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadForswornTattoo_03.dds")
	AddWarpaint("$Female Forsworn Tattoo 04", "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadForswornTattoo_04.dds")
	AddWarpaint("$Male Black Blood Tattoo 01", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBlackBloodTattoo_01.dds")
	AddWarpaint("$Male Black Blood Tattoo 02", "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBlackBloodTattoo_02.dds")
EndFunction

Function UpdateColors()
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_BeginSettings")

	UI.InvokeInt(RACESEX_MENU, MENU_ROOT + "RSM_AddTintTypes", TINT_TYPE_HAIR)
	UI.InvokeInt(RACESEX_MENU, MENU_ROOT + "RSM_AddTintColors", _color)
	UI.InvokeString(RACESEX_MENU, MENU_ROOT + "RSM_AddTintTextures", "")

	UI.InvokeIntA(RACESEX_MENU, MENU_ROOT + "RSM_AddTintTypes", _tintTypes)
	UI.InvokeIntA(RACESEX_MENU, MENU_ROOT + "RSM_AddTintColors", _tintColors)
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddTintTextures", _tintTextures)

	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_EndSettings")
EndFunction

Function UpdateRaces()
	int totalRaces = Race.GetNumPlayableRaces()
	int i = 0
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_BeginExtend")
	While i < totalRaces
		Race playableRace = Race.GetNthPlayableRace(i)
		UI.InvokeForm(RACESEX_MENU, MENU_ROOT + "RSM_ExtendRace", playableRace)
		i += 1
	EndWhile
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_EndExtend")
EndFunction