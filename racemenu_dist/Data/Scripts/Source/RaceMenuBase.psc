Scriptname RaceMenuBase extends Quest

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

Actor Property _playerActor Auto
ActorBase Property _playerActorBase Auto

string[] _textures
int _textureBuffer

string[] _sliders
int _sliderBuffer

Event OnInit()
	_playerActor = Game.GetPlayer()
	_playerActorBase = _playerActor.GetActorBase()

	OnInitialized()

	OnStartup()
EndEvent

Event OnInitialized()
	_textures = new string[128]
	_textureBuffer = 0

	_sliders = new string[128]
	_sliderBuffer = 0
EndEvent

Event OnGameReload()
	OnStartup()
	OnReloadSettings(_playerActor, _playerActorBase)
EndEvent

Event OnChangeRace(Actor akActor)
	; Do nothing
EndEvent

Event On3DLoaded(ObjectReference akRef)
	; Do nothing
EndEvent

Event OnStartup()
	RegisterForModEvent("RSM_Initialized", "OnMenuInitialized")
	RegisterForModEvent("RSM_Reinitialized", "OnMenuReinitialized")
	RegisterForModEvent("RSM_SliderChange", "OnMenuSliderChange") ; Event sent when a slider's value is changed
EndEvent

Event OnMenuInitialized(string eventName, string strArg, float numArg, Form formArg)
	OnWarpaintRequest()
	AddWarpaints(_textures)
	OnSliderRequest(_playerActor, _playerActorBase, _playerActorBase.GetRace(), _playerActorBase.GetSex() as bool)
	AddSliders(_sliders)
	FlushBuffer(2)
EndEvent

Event OnMenuReinitialized(string eventName, string strArg, float numArg, Form formArg)
	OnSliderRequest(_playerActor, _playerActorBase, _playerActorBase.GetRace(), _playerActorBase.GetSex() as bool)
	AddSliders(_sliders)
	FlushBuffer(1)
EndEvent

Event OnMenuSliderChange(string eventName, string strArg, float numArg, Form formArg)
	OnSliderChanged(strArg, numArg)
EndEvent

Event OnReloadSettings(Actor player, ActorBase playerBase)
	; Do nothing
EndEvent

Event OnWarpaintRequest()
	; Do nothing
EndEvent

Event OnSliderRequest(Actor player, ActorBase playerBase, Race actorRace, bool isFemale)
	; Do nothing
EndEvent

Event OnSliderChanged(string callback, float value)
	; Do nothing
EndEvent

Function AddWarpaint(string name, string texturePath)
	_textures[_textureBuffer] = name + ";;" + texturePath
	_textureBuffer += 1
EndFunction

Function AddSlider(string name, int section, string callback, float min, float max, float interval, float position)
	_sliders[_sliderBuffer] = name + ";;" + section + ";;" + callback + ";;" + min + ";;" + max + ";;" + interval + ";;" + position
	_sliderBuffer += 1
EndFunction

Function AddWarpaints(string[] textures)
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddWarpaints", textures)
EndFunction

Function AddSliders(string[] sliders)
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddSliders", sliders)
EndFunction

Function SetSliderParameters(string callback, float min, float max, float interval, float position)
	string[] params = new string[5]
	params[0] = callback
	params[1] = min as string
	params[2] = max as string
	params[3] = interval as string
	params[4] = position as string
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_SetSliderParameters", params)
EndFunction

; 0 - Texture Buffers
; 1 - Slider Buffers
; 2 - Both Buffers
Function FlushBuffer(int bufferType)
	int i = 0
	While i < 128
		if bufferType == 0 || bufferType == 2
			_textures[i] = ""
		Endif
		If bufferType == 1 || bufferType == 2
			_sliders[i] = ""
		Endif
		i += 1
	EndWhile

	if bufferType == 0 || bufferType == 2
		_textureBuffer = 0
	Endif
	If bufferType == 1 || bufferType == 2
		_sliderBuffer = 0
	Endif
EndFunction
