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

string[] _textureName
string[] _texturePath
int _textureBuffer

string[] _sliderName
int[] _sliderSection
string[] _sliderCallback
float[] _sliderMin
float[] _sliderMax
float[] _sliderInterval
float[] _sliderPosition
int _sliderBuffer

Event OnInit()
	_playerActor = Game.GetPlayer()
	_playerActorBase = _playerActor.GetActorBase()

	OnInitialized()

	OnStartup()
EndEvent

Event OnInitialized()
	_textureName = new string[128]
	_texturePath = new string[128]
	_textureBuffer = 0

	_sliderName = new string[128]
	_sliderSection = new int[128]
	_sliderCallback = new string[128]
	_sliderMin = new float[128]
	_sliderMax = new float[128]
	_sliderInterval = new float[128]
	_sliderPosition = new float[128]
	_sliderBuffer = 0
EndEvent

Event OnGameReload()
	OnStartup()
	OnReloadSettings(_playerActor, _playerActorBase)
EndEvent

Event OnStartup()
	RegisterForModEvent("RSM_Initialized", "OnMenuInitialized")
	RegisterForModEvent("RSM_Reinitialized", "OnMenuReinitialized")
	RegisterForModEvent("RSM_SliderChange", "OnMenuSliderChange") ; Event sent when a slider's value is changed
EndEvent

Event OnMenuInitialized(string eventName, string strArg, float numArg, Form formArg)
	OnWarpaintRequest()
	AddWarpaints(_textureName, _texturePath)
	OnSliderRequest(_playerActor, _playerActorBase, _playerActorBase.GetRace(), _playerActorBase.GetSex() as bool)
	AddSliders(_sliderName, _sliderSection, _sliderCallback, _sliderMin, _sliderMax, _sliderInterval, _sliderPosition)
	FlushBuffer(2)
EndEvent

Event OnMenuReinitialized(string eventName, string strArg, float numArg, Form formArg)
	OnSliderRequest(_playerActor, _playerActorBase, _playerActorBase.GetRace(), _playerActorBase.GetSex() as bool)
	AddSliders(_sliderName, _sliderSection, _sliderCallback, _sliderMin, _sliderMax, _sliderInterval, _sliderPosition)
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
	_textureName[_textureBuffer] = name
	_texturePath[_textureBuffer] = texturePath
	_textureBuffer += 1
EndFunction

Function AddSlider(string name, int section, string callback, float min, float max, float interval, float position)
	_sliderName[_sliderBuffer] = name
	_sliderSection[_sliderBuffer] = section
	_sliderCallback[_sliderBuffer] = callback
	_sliderMin[_sliderBuffer] = min
	_sliderMax[_sliderBuffer] = max
	_sliderInterval[_sliderBuffer] = interval
	_sliderPosition[_sliderBuffer] = position
	_sliderBuffer += 1
EndFunction

Function AddWarpaints(string[] names, string[] textures)
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_BeginMakeup")
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddMakeupNames", names)
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddMakeupTextures", textures)
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_EndMakeup")
EndFunction

Function AddSliders(string[] name, int[] section, string[] callback, float[] min, float[] max, float[] interval, float[] position)
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_BeginSliders")
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddSliderName", name)
	UI.InvokeIntA(RACESEX_MENU, MENU_ROOT + "RSM_AddSliderSection", section)
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddSliderCallback", callback)
	UI.InvokeFloatA(RACESEX_MENU, MENU_ROOT + "RSM_AddSliderMin", min)
	UI.InvokeFloatA(RACESEX_MENU, MENU_ROOT + "RSM_AddSliderMax", max)
	UI.InvokeFloatA(RACESEX_MENU, MENU_ROOT + "RSM_AddSliderInterval", interval)
	UI.InvokeFloatA(RACESEX_MENU, MENU_ROOT + "RSM_AddSliderPosition", position)
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_EndSliders")
EndFunction

; 0 - Texture Buffers
; 1 - Slider Buffers
; 2 - Both Buffers
Function FlushBuffer(int bufferType)
	int i = 0
	While i < 128
		if bufferType == 0 || bufferType == 2
			_textureName[i] = ""
			_texturePath[i] = ""
		Endif
		If bufferType == 1 || bufferType == 2
			_sliderName[i] = ""
			_sliderSection[i] = 0
			_sliderCallback[i] = ""
			_sliderMin[i] = 0.0
			_sliderMax[i] = 0.0
			_sliderInterval[i] = 0.0
			_sliderPosition[i] = 0.0
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
