Scriptname RaceMenu extends Quest  

string Property RACESEX_MENU = "RaceSex Menu" Autoreadonly
string Property MENU_ROOT = "_root.RaceSexMenuBaseInstance.RaceSexPanelsInstance." Autoreadonly

int Property CATEGORY_RACE = 2 AutoReadOnly
int Property CATEGORY_BODY = 4 AutoReadOnly
int Property CATEGORY_HEAD = 8 AutoReadOnly
int Property CATEGORY_FACE = 16 AutoReadOnly
int Property CATEGORY_EYES = 32 AutoReadOnly
int Property CATEGORY_BROW = 64 AutoReadOnly
int Property CATEGORY_MOUTH = 128 AutoReadOnly
int Property CATEGORY_HAIR = 256 AutoReadOnly
int Property CATEGORY_COLOR = 512 AutoReadOnly

Actor _playerActor = None
ActorBase _playerActorBase = None
ColorForm _hairColor = None
Form _lightForm = None
ObjectReference _light = None
int _color = 0
float _height = 1.0
bool _customHair = false
int[] _tintTypes
int[] _tintColors
string[] _tintTextures

Event OnInit()
	_hairColor = Game.GetFormFromFile(0x801, "RaceMenu.esp") as ColorForm
	_lightForm = Game.GetFormFromFile(0x803, "RaceMenu.esp")
	_playerActor = Game.GetPlayer()
	_playerActorBase = _playerActor.GetActorBase()
	_tintTextures = new string[128]
	_tintTypes = new int[128]
	_tintColors = new int[128]
	
	OnStartup()
EndEvent

Function OnStartup()
	RegisterForMenu(RACESEX_MENU)
	RegisterForModEvent("RSM_LoadSliders", "OnLoadSliders")
	RegisterForModEvent("RSM_SliderChange", "OnSliderChange")
	RegisterForModEvent("RSM_HairColorChange", "OnHairColorChange")
	RegisterForModEvent("RSM_TintColorChange", "OnTintColorChange")
	RegisterForModEvent("RSM_ToggleLight", "OnToggleLight")

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
	_playerActor.QueueNiNodeUpdate()
EndEvent

Event OnMenuOpen(string menuName)
	If menuName == RACESEX_MENU
		UpdateColors()
		LoadTints()
		LoadHair()
		_playerActor.QueueNiNodeUpdate()
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

Function LoadHair()
	If _customHair
		_playerActorBase.SetHairColor(_hairColor)
	EndIf
EndFunction

Function SaveHair()
	If _playerActorBase.GetHairColor() == _hairColor
		_color = _hairColor.GetColor()
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

Function ClearTints()
	int i = 0
	While i < _tintTypes.length
		_tintTypes[i] = 0
		_tintColors[i] = 0
		_tintTextures[i] = ""
		i += 1
	EndWhile
EndFunction

Event OnLoadSliders(string eventName, string strArg, float numArg, Form formArg)
	AddSlider("$Height", CATEGORY_BODY, "ChangeHeight", 0.25, 1.50, 0.01, _playerActorBase.GetHeight())
	SaveHair()
	SaveTints()
	UpdateColors()
EndEvent

Event OnSliderChange(string eventName, string strArg, float numArg, Form formArg)
	If strArg == "ChangeHeight"
		_height = numArg
		_playerActorBase.SetHeight(numArg)
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

Event OnToggleLight(string eventName, string strArg, float numArg, Form formArg)
	bool lightOn = numArg as bool
	if lightOn
		_light.EnableNoWait()
	Else
		_light.DisableNoWait()
	Endif
EndEvent

Function AddSlider(string name, int section, string callback, float min, float max, float interval, float position)
	string[] params = new string[7]
	params[0] = name
	params[1] = section as string
	params[2] = callback
	params[3] = min as string
	params[4] = max as string
	params[5] = position as string
	params[6] = interval as string
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddSlider", params)
EndFunction

Function UpdateColors()
	UI.InvokeInt(RACESEX_MENU, MENU_ROOT + "RSM_AddTintTypes", 128)
	UI.InvokeInt(RACESEX_MENU, MENU_ROOT + "RSM_AddTintColors", _color)
	UI.InvokeString(RACESEX_MENU, MENU_ROOT + "RSM_AddTintTextures", "")

	UI.InvokeIntA(RACESEX_MENU, MENU_ROOT + "RSM_AddTintTypes", _tintTypes)
	UI.InvokeIntA(RACESEX_MENU, MENU_ROOT + "RSM_AddTintColors", _tintColors)
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddTintTextures", _tintTextures)

	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_UpdateSettings")
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