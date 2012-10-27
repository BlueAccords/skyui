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
ObjectReference _light = None
int _color = 0
float _height = 1.0
bool _customHair = false
int[] _tintTypes
int[] _tintColors

Event OnInit()
	_hairColor = Game.GetFormFromFile(0x801, "RaceMenu.esp") as ColorForm
	_playerActor = Game.GetPlayer()
	_playerActorBase = _playerActor.GetActorBase()
	_tintTypes = new int[128]
	_tintColors = new int[128]
EndEvent

Event OnGameReload()
	RegisterForMenu(RACESEX_MENU)
	RegisterForModEvent("RSM_LoadSliders", "OnLoadSliders")
	RegisterForModEvent("RSM_OnSliderChange", "OnSliderChange")
	RegisterForModEvent("RSM_OnHairColorChange", "OnHairColorChange")
	RegisterForModEvent("RSM_OnTintColorChange", "OnTintColorChange")
	RegisterForModEvent("RSM_OnToggleLight", "OnToggleLight")

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
		LoadTints()
		If _customHair
			_playerActorBase.SetHairColor(_hairColor)
		EndIf
		_playerActor.QueueNiNodeUpdate()
		UpdateColors()
		_light = _playerActor.placeAtMe(Game.GetFormFromFile(0x803, "RaceMenu.esp"))
		float zOffset = _light.GetHeadingAngle(_playerActor)
		_light.SetAngle(_light.GetAngleX(), _light.GetAngleY(), _light.GetAngleZ() + zOffset)
		_light.MoveTo(_playerActor, 60 * Math.Sin(_playerActor.GetAngleZ()), 60 * Math.Cos(_playerActor.GetAngleZ()), _playerActor.GetHeight())
	Endif
EndEvent

Event OnMenuClose(string menuName)
	If menuName == RACESEX_MENU
		_light.Delete()
		_light = None
		If _playerActorBase.GetHairColor() == _hairColor
			_color = _hairColor.GetColor()
			_customHair = true
		Else
			_customHair = false
		EndIf

		SaveTints()
	Endif
EndEvent

Function LoadTints()
	int i = 0
	int totalTints = Game.GetNumTintMasks()
	While i < totalTints
		int color = _tintColors[i]
		If color != 0
			Game.SetNthTintMaskColor(i, _tintColors[i])
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
		i += 1
	EndWhile
EndFunction

Function ClearTints()
	int i = 0
	While i < _tintTypes.length
		_tintTypes[i] = 0
		_tintColors[i] = 0
		i += 1
	EndWhile
EndFunction

Event OnLoadSliders(string eventName, string strArg, float numArg, Form formArg)
	If eventName == "RSM_LoadSliders"
		AddSlider("$Height", CATEGORY_BODY, "ChangeHeight", 0.25, 1.50, 0.01, Game.GetPlayer().GetActorBase().GetHeight())
	Endif
EndEvent

Event OnSliderChange(string eventName, string strArg, float numArg, Form formArg)
	If eventName == "RSM_OnSliderChange"
		If strArg == "ChangeHeight"
			_height = numArg
			_playerActorBase.SetHeight(numArg)
			_playerActor.QueueNiNodeUpdate()
		Endif
	Endif
EndEvent

Event OnHairColorChange(string eventName, string strArg, float numArg, Form formArg)
	If eventName == "RSM_OnHairColorChange"
		_color = numArg as int
		_hairColor.SetColor(_color)
		_playerActorBase.SetHairColor(_hairColor)
		_playerActor.QueueNiNodeUpdate()
	Endif
EndEvent

Event OnTintColorChange(string eventName, string strArg, float numArg, Form formArg)
	If eventName == "RSM_OnTintColorChange"
		int color = numArg as int
		int arg = strArg as int
		int type = arg / 1000
		int index = arg - (type * 1000)
		Game.SetTintMaskColor(0xFF000000 + color, type, index)
		_playerActor.QueueNiNodeUpdate()
	Endif
EndEvent

Event OnToggleLight(string eventName, string strArg, float numArg, Form formArg)
	If eventName == "RSM_OnToggleLight"
		bool lightOn = numArg as bool
		if lightOn
			_light.EnableNoWait()
		Else
			_light.DisableNoWait()
		Endif
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
	float[] tints = new float[128]
	tints[0] = 128
	tints[1] = _color
	int i = 2
	int k = 0
	While i < tints.length
		tints[i] = _tintTypes[k] as float
		tints[i + 1] = _tintColors[k] as float
		k += 1
		i += 2
	EndWhile
	UI.InvokeNumberA(RACESEX_MENU, MENU_ROOT + "RSM_LoadColors", tints)
EndFunction