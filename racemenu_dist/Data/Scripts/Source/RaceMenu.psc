Scriptname RaceMenu extends RaceMenuBase

int Property CATEGORY_RACE = 2 AutoReadOnly
int Property CATEGORY_BODY = 4 AutoReadOnly
int Property CATEGORY_HEAD = 8 AutoReadOnly
int Property CATEGORY_FACE = 16 AutoReadOnly
int Property CATEGORY_EYES = 32 AutoReadOnly
int Property CATEGORY_BROW = 64 AutoReadOnly
int Property CATEGORY_MOUTH = 128 AutoReadOnly
int Property CATEGORY_HAIR = 256 AutoReadOnly
int Property CATEGORY_COLOR = 512 AutoReadOnly

int Property TINT_TYPE_HAIR = 128 AutoReadOnly

int Property MAX_PRESETS = 4 AutoReadOnly
int Property MAX_MORPHS = 19 AutoReadOnly

string Property NINODE_HEAD = "NPC Head [Head]" AutoReadOnly
string Property NINODE_LEFT_BREAST = "NPC L Breast" AutoReadOnly
string Property NINODE_RIGHT_BREAST = "NPC R Breast" AutoReadOnly
string Property NINODE_LEFT_BUTT = "NPC L Butt" AutoReadOnly
string Property NINODE_RIGHT_BUTT = "NPC R Butt" AutoReadOnly

Actor _playerActor = None
ActorBase _playerActorBase = None
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

; Custom Properties
float _height = 1.0
float _head = 1.0
float _leftBreast = 1.0
float _rightBreast = 1.0
float _leftButt = 1.0
float _rightButt = 1.0

Event OnInit()
	_hairColor = Game.GetFormFromFile(0x801, "RaceMenu.esp") as ColorForm
	_lightForm = Game.GetFormFromFile(0x803, "RaceMenu.esp")
	_playerActor = Game.GetPlayer()
	_playerActorBase = _playerActor.GetActorBase()
	_tintTextures = new string[128]
	_tintTypes = new int[128]
	_tintColors = new int[128]
	_presets = new int[4]
	_morphs = new float[19]

	SaveHair()
	SaveTints()
	
	OnStartup()
EndEvent

Function OnStartup()
	RegisterForMenu(RACESEX_MENU)

	
	RegisterForModEvent("RSM_Initialized", "OnMenuInitialized") ; Event sent when the menu initializes enough to load data
	RegisterForModEvent("RSM_Reinitialized", "OnMenuReinitialized") ; Event sent when sliders have re-initialized
	RegisterForModEvent("RSM_SliderChange", "OnSliderChange") ; Event sent when a slider's value is changed
	RegisterForModEvent("RSM_HairColorChange", "OnHairColorChange") ; Event sent when hair color changes
	RegisterForModEvent("RSM_TintColorChange", "OnTintColorChange") ; Event sent when a tint changes color
	RegisterForModEvent("RSM_TintTextureChange", "OnTintTextureChange") ; Event sent when a tint changes texture
	RegisterForModEvent("RSM_ToggleLight", "OnToggleLight") ; Event sent when the Light button is pressed
	RegisterForModEvent("RSM_RequestCustomContent", "OnRequestCustomContent") ; Load custom sliders and custom warpaints with this event

	; Handles clipboard data transfer DO NOT EDIT
	RegisterForModEvent("RSM_RequestLoadClipboard", "OnLoadClipboard")
	RegisterForModEvent("RSM_RequestSaveClipboard", "OnSaveClipboard")

	RegisterForModEvent("RSM_ClipboardData", "OnClipboardData")
	RegisterForModEvent("RSM_ClipboardFinished", "OnClipboardFinished")
	; --------------------------------------------

	Utility.SetINIFloat("fPlayerBodyEditDistance:Interface", 180.0)
	Utility.SetINIFloat("fPlayerFaceEditDistance:Interface", 50.0)
EndFunction

Event OnGameReload()
	OnStartup()

	; Reload player settings
	If _playerActorBase.GetHairColor() == _hairColor
		_hairColor.SetColor(_color)
		_customHair = true
	Else
		_customHair = false
	EndIf
	_playerActorBase.SetHeight(_height)
	_playerActor.SetNiNodeScale(NINODE_HEAD, _head)
	_playerActor.SetNiNodeScale(NINODE_LEFT_BREAST, _leftBreast)
	_playerActor.SetNiNodeScale(NINODE_RIGHT_BREAST, _rightBreast)
	_playerActor.SetNiNodeScale(NINODE_LEFT_BUTT, _leftButt)
	_playerActor.SetNiNodeScale(NINODE_RIGHT_BUTT, _rightButt)
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
	SendDefaultMakeup()
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
	If _playerActorBase.GetHairColor() == _hairColor
		_color = _hairColor.GetColor() + 0xFF000000
		_customHair = true
	Else
		_color = _playerActorBase.GetHairColor().GetColor()
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

Event OnRequestCustomContent(string eventName, string strArg, float numArg, Form formArg)
	AddSlider("$Height", CATEGORY_BODY, "ChangeHeight", 0.25, 1.50, 0.01, _playerActorBase.GetHeight())

	float head = _playerActor.GetNiNodeScale(NINODE_HEAD)
	If head != 0
		AddSlider("$Head", CATEGORY_BODY, "ChangeHeadSize", 0.01, 3.00, 0.01, head)
	Endif

	If _playerActorBase.GetSex() == 1
		float leftBreast = _playerActor.GetNiNodeScale(NINODE_LEFT_BREAST)
		float rightBreast = _playerActor.GetNiNodeScale(NINODE_RIGHT_BREAST)
		float leftButt = _playerActor.GetNiNodeScale(NINODE_LEFT_BUTT)
		float rightButt = _playerActor.GetNiNodeScale(NINODE_RIGHT_BUTT)
		
		If leftBreast != 0 && rightBreast != 0 && leftButt != 0 && rightButt != 0
			AddSlider("$Left Breast", CATEGORY_BODY, "ChangeLeftBreast", 0.1, 5.00, 0.1, leftBreast)
			AddSlider("$Right Breast", CATEGORY_BODY, "ChangeRightBreast", 0.1, 5.00, 0.1, rightBreast)
			AddSlider("$Left Buttcheek", CATEGORY_BODY, "ChangeLeftButt", 0.1, 5.00, 0.1, leftButt)
			AddSlider("$Right Buttcheek", CATEGORY_BODY, "ChangeRightButt", 0.1, 5.00, 0.1, rightButt)
		Endif
	Endif
EndEvent

Event OnSliderChange(string eventName, string strArg, float numArg, Form formArg)
	If strArg == "ChangeHeight"
		_height = numArg
		_playerActorBase.SetHeight(numArg)
		_playerActor.QueueNiNodeUpdate()
	ElseIf strArg == "ChangeHeadSize"
		_head = numArg
		_playerActor.SetNiNodeScale(NINODE_HEAD, _head)
		_playerActor.QueueNiNodeUpdate()
	Elseif strArg == "ChangeLeftBreast"
		_leftBreast = numArg
		_playerActor.SetNiNodeScale(NINODE_LEFT_BREAST, _leftBreast)
		_playerActor.QueueNiNodeUpdate()
	Elseif strArg == "ChangeRightBreast"
		_rightBreast = numArg
		_playerActor.SetNiNodeScale(NINODE_RIGHT_BREAST, _rightBreast)
		_playerActor.QueueNiNodeUpdate()
	Elseif strArg == "ChangeLeftButt"
		_leftButt = numArg
		_playerActor.SetNiNodeScale(NINODE_LEFT_BUTT, _leftButt)
		_playerActor.QueueNiNodeUpdate()
	Elseif strArg == "ChangeRightButt"
		_rightButt = numArg
		_playerActor.SetNiNodeScale(NINODE_RIGHT_BUTT, _rightButt)
		_playerActor.QueueNiNodeUpdate()
	Endif
EndEvent

Event OnHairColorChange(string eventName, string strArg, float numArg, Form formArg)
	_color = strArg as int
	_hairColor.SetColor(_color)
	_playerActorBase.SetHairColor(_hairColor)
	_playerActor.QueueNiNodeUpdate()
EndEvent

Event OnTintColorChange(string eventName, string strArg, float numArg, Form formArg)
	int color = strArg as int
	int arg = numArg as int
	int type = arg / 1000
	int index = arg - (type * 1000)
	Game.SetTintMaskColor(color, type, index)
	_playerActor.QueueNiNodeUpdate()
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

Function SendDefaultMakeup()
	string[] names = new string[120]
	string[] textures = new string[120]
	names[0] = "$Male Warpaint 01"
	textures[0] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_01.dds"
	names[1] = "$Male Warpaint 02"
	textures[1] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_02.dds"
	names[2] = "$Male Warpaint 03"
	textures[2] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_03.dds"
	names[3] = "$Male Warpaint 04"
	textures[3] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_04.dds"
	names[4] = "$Male Warpaint 05"
	textures[4] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_05.dds"
	names[5] = "$Male Warpaint 06"
	textures[5] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_06.dds"
	names[6] = "$Male Warpaint 07"
	textures[6] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_07.dds"
	names[7] = "$Male Warpaint 08"
	textures[7] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_08.dds"
	names[8] = "$Male Warpaint 09"
	textures[8] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_09.dds"
	names[9] = "$Male Warpaint 10"
	textures[9] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWarPaint_10.dds"
	names[10] = "$Male Nord Warpaint 01"
	textures[10] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_01.dds"
	names[11] = "$Male Nord Warpaint 02"
	textures[11] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_02.dds"
	names[12] = "$Male Nord Warpaint 03"
	textures[12] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_03.dds"
	names[13] = "$Male Nord Warpaint 04"
	textures[13] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_04.dds"
	names[14] = "$Male Nord Warpaint 05"
	textures[14] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadNordWarPaint_05.dds"
	names[15] = "$Female Warpaint 01"
	textures[15] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_01.dds"
	names[16] = "$Female Warpaint 02"
	textures[16] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_02.dds"
	names[17] = "$Female Warpaint 03"
	textures[17] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_03.dds"
	names[18] = "$Female Warpaint 04"
	textures[18] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_04.dds"
	names[19] = "$Female Warpaint 05"
	textures[19] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_05.dds"
	names[20] = "$Female Warpaint 06"
	textures[20] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_06.dds"
	names[21] = "$Female Warpaint 07"
	textures[21] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_07.dds"
	names[22] = "$Female Warpaint 08"
	textures[22] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_08.dds"
	names[23] = "$Female Warpaint 09"
	textures[23] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_09.dds"
	names[24] = "$Female Warpaint 10"
	textures[24] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWarPaint_10.dds"
	names[25] = "$Female Nord Warpaint 01"
	textures[25] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_01.dds"
	names[26] = "$Female Nord Warpaint 02"
	textures[26] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_02.dds"
	names[27] = "$Female Nord Warpaint 03"
	textures[27] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_03.dds"
	names[28] = "$Female Nord Warpaint 04"
	textures[28] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_04.dds"
	names[29] = "$Female Nord Warpaint 05"
	textures[29] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadNordWarPaint_05.dds"
	names[30] = "$Argonian Stripes 01"
	textures[30] = "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes01.dds"
	names[31] = "$Argonian Stripes 02"
	textures[31] = "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes02.dds"
	names[32] = "$Argonian Stripes 03"
	textures[32] = "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes03.dds"
	names[33] = "$Argonian Stripes 04"
	textures[33] = "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes04.dds"
	names[34] = "$Argonian Stripes 05"
	textures[34] = "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes05.dds"
	names[35] = "$Argonian Stripes 06"
	textures[35] = "Actors\\Character\\Character Assets\\TintMasks\\ArgonianStripes06.dds"
	names[36] = "$Female High Elf Warpaint 01"
	textures[36] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadHighElfWarPaint_01.dds"
	names[37] = "$Female High Elf Warpaint 02"
	textures[37] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadHighElfWarPaint_02.dds"
	names[38] = "$Female High Elf Warpaint 03"
	textures[38] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadHighElfWarPaint_03.dds"
	names[39] = "$Female High Elf Warpaint 04"
	textures[39] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadHighElfWarPaint_04.dds"
	names[40] = "$Male Dark Elf Warpaint 01"
	textures[40] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_01.dds"
	names[41] = "$Male Dark Elf Warpaint 02"
	textures[41] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_02.dds"
	names[42] = "$Male Dark Elf Warpaint 03"
	textures[42] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_03.dds"
	names[43] = "$Male Dark Elf Warpaint 04"
	textures[43] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_04.dds"
	names[44] = "$Male Dark Elf Warpaint 05"
	textures[44] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_05.dds"
	names[45] = "$Male Dark Elf Warpaint 06"
	textures[45] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadDarkElfWarPaint_06.dds"
	names[46] = "$Female Dark Elf Warpaint 01"
	textures[46] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_01.dds"
	names[47] = "$Female Dark Elf Warpaint 02"
	textures[47] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_02.dds"
	names[48] = "$Female Dark Elf Warpaint 03"
	textures[48] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_03.dds"
	names[49] = "$Female Dark Elf Warpaint 04"
	textures[49] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_04.dds"
	names[50] = "$Female Dark Elf Warpaint 05"
	textures[50] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_05.dds"
	names[51] = "$Female Dark Elf Warpaint 06"
	textures[51] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadDarkElfWarPaint_06.dds"
	names[52] = "$Male Imperial Warpaint 01"
	textures[52] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_01.dds"
	names[53] = "$Male Imperial Warpaint 02"
	textures[53] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_02.dds"
	names[54] = "$Male Imperial Warpaint 03"
	textures[54] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_03.dds"
	names[55] = "$Male Imperial Warpaint 04"
	textures[55] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_04.dds"
	names[56] = "$Male Imperial Warpaint 05"
	textures[56] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadImperialWarPaint_05.dds"
	names[57] = "$Female Imperial Warpaint 01"
	textures[57] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_01.dds"
	names[58] = "$Female Imperial Warpaint 02"
	textures[58] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_02.dds"
	names[59] = "$Female Imperial Warpaint 03"
	textures[59] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_03.dds"
	names[60] = "$Female Imperial Warpaint 04"
	textures[60] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_04.dds"
	names[61] = "$Female Imperial Warpaint 05"
	textures[61] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadImperialWarPaint_05.dds"
	names[62] = "$Khajiit Stripes 01"
	textures[62] = "Actors\\Character\\Character Assets\\TintMasks\\KhajiitStripes01.dds"
	names[63] = "$Khajiit Stripes 02"
	textures[63] = "Actors\\Character\\Character Assets\\TintMasks\\KhajiitStripes02.dds"
	names[64] = "$Khajiit Stripes 03"
	textures[64] = "Actors\\Character\\Character Assets\\TintMasks\\KhajiitStripes03.dds"
	names[65] = "$Khajiit Stripes 04"
	textures[65] = "Actors\\Character\\Character Assets\\TintMasks\\KhajiitStripes04.dds"
	names[66] = "$Khajiit Paint 01"
	textures[66] = "Actors\\Character\\Character Assets\\TintMasks\\KhajiitPaint01.dds"
	names[67] = "$Khajiit Paint 02"
	textures[67] = "Actors\\Character\\Character Assets\\TintMasks\\KhajiitPaint02.dds"
	names[68] = "$Khajiit Paint 03"
	textures[68] = "Actors\\Character\\Character Assets\\TintMasks\\KhajiitPaint03.dds"
	names[69] = "$Khajiit Paint 04"
	textures[69] = "Actors\\Character\\Character Assets\\TintMasks\\KhajiitPaint04.dds"
	names[70] = "$Male Orc Warpaint 01"
	textures[70] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_01.dds"
	names[71] = "$Male Orc Warpaint 02"
	textures[71] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_02.dds"
	names[72] = "$Male Orc Warpaint 03"
	textures[72] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_03.dds"
	names[73] = "$Male Orc Warpaint 04"
	textures[73] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_04.dds"
	names[74] = "$Male Orc Warpaint 05"
	textures[74] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadOrcWarPaint_05.dds"
	names[75] = "$Female Orc Warpaint 01"
	textures[75] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_01.dds"
	names[76] = "$Female Orc Warpaint 02"
	textures[76] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_02.dds"
	names[77] = "$Female Orc Warpaint 03"
	textures[77] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_03.dds"
	names[78] = "$Female Orc Warpaint 04"
	textures[78] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_04.dds"
	names[79] = "$Female Orc Warpaint 05"
	textures[79] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadOrcWarPaint_05.dds"
	names[80] = "$Male Redguard Warpaint 01"
	textures[80] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_01.dds"
	names[81] = "$Male Redguard Warpaint 02"
	textures[81] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_02.dds"
	names[82] = "$Male Redguard Warpaint 03"
	textures[82] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_03.dds"
	names[83] = "$Male Redguard Warpaint 04"
	textures[83] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_04.dds"
	names[84] = "$Male Redguard Warpaint 05"
	textures[84] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadRedguardWarPaint_05.dds"
	names[85] = "$Female Redguard Warpaint 01"
	textures[85] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_01.dds"
	names[86] = "$Female Redguard Warpaint 02"
	textures[86] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_02.dds"
	names[87] = "$Female Redguard Warpaint 03"
	textures[87] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_03.dds"
	names[88] = "$Female Redguard Warpaint 04"
	textures[88] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_04.dds"
	names[89] = "$Female Redguard Warpaint 05"
	textures[89] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadRedguardWarPaint_05.dds"
	names[90] = "$Male Wood Elf Warpaint 01"
	textures[90] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_01.dds"
	names[91] = "$Male Wood Elf Warpaint 02"
	textures[91] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_02.dds"
	names[92] = "$Male Wood Elf Warpaint 03"
	textures[92] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_03.dds"
	names[93] = "$Male Wood Elf Warpaint 04"
	textures[93] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_04.dds"
	names[94] = "$Male Wood Elf Warpaint 05"
	textures[94] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadWoodElfWarPaint_05.dds"
	names[95] = "$Female Wood Elf Warpaint 01"
	textures[95] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_01.dds"
	names[96] = "$Female Wood Elf Warpaint 02"
	textures[96] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_02.dds"
	names[97] = "$Female Wood Elf Warpaint 03"
	textures[97] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_03.dds"
	names[98] = "$Female Wood Elf Warpaint 04"
	textures[98] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_04.dds"
	names[99] = "$Female Wood Elf Warpaint 05"
	textures[99] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadWoodElfWarPaint_05.dds"
	names[100] = "$Male Breton Warpaint 01"
	textures[100] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_01.dds"
	names[101] = "$Male Breton Warpaint 02"
	textures[101] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_02.dds"
	names[102] = "$Male Breton Warpaint 03"
	textures[102] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_03.dds"
	names[103] = "$Male Breton Warpaint 04"
	textures[103] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_04.dds"
	names[104] = "$Male Breton Warpaint 05"
	textures[104] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBretonWarPaint_05.dds"
	names[105] = "$Female Breton Warpaint 01"
	textures[105] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_01.dds"
	names[106] = "$Female Breton Warpaint 02"
	textures[106] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_02.dds"
	names[107] = "$Female Breton Warpaint 03"
	textures[107] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_03.dds"
	names[108] = "$Female Breton Warpaint 04"
	textures[108] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_04.dds"
	names[109] = "$Female Breton Warpaint 05"
	textures[109] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadBretonWarPaint_05.dds"
	names[110] = "$Male Forsworn Tattoo 01"
	textures[110] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadForswornTattoo_01.dds"
	names[111] = "$Male Forsworn Tattoo 02"
	textures[111] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadForswornTattoo_02.dds"
	names[112] = "$Male Forsworn Tattoo 03"
	textures[112] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadForswornTattoo_03.dds"
	names[113] = "$Male Forsworn Tattoo 04"
	textures[113] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadForswornTattoo_04.dds"
	names[114] = "$Female Forsworn Tattoo 01"
	textures[114] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadForswornTattoo_01.dds"
	names[115] = "$Female Forsworn Tattoo 02"
	textures[115] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadForswornTattoo_02.dds"
	names[116] = "$Female Forsworn Tattoo 03"
	textures[116] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadForswornTattoo_03.dds"
	names[117] = "$Female Forsworn Tattoo 04"
	textures[117] = "Actors\\Character\\Character Assets\\TintMasks\\FemaleHeadForswornTattoo_04.dds"
	names[118] = "$Male Black Blood Tattoo 01"
	textures[118] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBlackBloodTattoo_01.dds"
	names[119] = "$Male Black Blood Tattoo 02"
	textures[119] = "Actors\\Character\\Character Assets\\TintMasks\\MaleHeadBlackBloodTattoo_02.dds"
	AddMakeupList(names, textures)
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