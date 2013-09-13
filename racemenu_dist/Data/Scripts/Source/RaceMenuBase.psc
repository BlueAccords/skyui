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

string Property _targetMenu = "" Auto
string Property _targetRoot = "" Auto
Actor Property _targetActor = None Auto

string[] _textures = None
int _textureBuffer = 0

; Body Paint
string[] _textures_body = None
int _textureBuffer_body = 0

; Hand Paint
string[] _textures_hand = None
int _textureBuffer_hand = 0

; Feet Paint
string[] _textures_feet = None
int _textureBuffer_feet

string[] _sliders = None
int _sliderBuffer = 0

int Function GetScriptVersionRelease() global
	return 2
EndFunction

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

	; Body Paint
	_textures_body = new string[128]
	_textureBuffer_body = 0

	; Hand Paint
	_textures_hand = new string[128]
	_textureBuffer_hand = 0

	; Feet Paint
	_textures_feet = new string[128]
	_textureBuffer_feet = 0
EndEvent

; Reinitializes variables if necessary
Function Reinitialize()
	If !_textures
		_textures = new string[128]
		_textureBuffer = 0
	Endif
	If !_sliders
		_sliders = new string[128]
		_sliderBuffer = 0
	Endif
	If !_textures_body
		_textures_body = new string[128]
		_textureBuffer_body = 0
	Endif
	If !_textures_hand
		_textures_hand = new string[128]
		_textureBuffer_hand = 0
	Endif
	If !_textures_feet
		_textures_feet = new string[128]
		_textureBuffer_feet = 0
	Endif
EndFunction

Event OnGameReload()
	OnStartup()
	Reinitialize()
EndEvent

Event OnCellLoaded(ObjectReference akRef)
	; Do nothing
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
	RegisterForModEvent("RSM_LoadPlugins", "OnMenuLoadPlugins")

	; RaceSexMenu Data Transfer
	RegisterForModEvent("RSMDT_SendMenuName", "OnReceiveMenuName")
	RegisterForModEvent("RSMDT_SendRootName", "OnReceiveRootName")
	RegisterForModEvent("RSMDT_SendPaintRequest", "OnReceivePaintRequest")
	RegisterForModEvent("RSMDT_SendRestore", "OnReceiveRestore")

	_targetMenu = RACESEX_MENU
	_targetRoot = MENU_ROOT
	_targetActor = _playerActor
EndEvent

Event OnReceiveMenuName(string eventName, string strArg, float numArg, Form formArg)
	_targetMenu = strArg
EndEvent

Event OnReceiveRootName(string eventName, string strArg, float numArg, Form formArg)
	_targetRoot = strArg
EndEvent

Event OnReceiveRestore(string eventName, string strArg, float numArg, Form formArg)
	_targetMenu = RACESEX_MENU
	_targetRoot = MENU_ROOT
	_targetActor = _playerActor
EndEvent

Event OnReceivePaintRequest(string eventName, string strArg, float numArg, Form formArg)
	int requestFlag = numArg as int
	bool sendFacePaint = Math.LogicalAnd(requestFlag, 0x01) == 0x01
	bool sendBodyPaint = Math.LogicalAnd(requestFlag, 0x02) == 0x02
	bool sendHandPaint = Math.LogicalAnd(requestFlag, 0x04) == 0x04
	bool sendFeetPaint = Math.LogicalAnd(requestFlag, 0x08) == 0x08
	If sendFacePaint
		OnWarpaintRequest()
	Endif
	If sendBodyPaint
		OnBodyPaintRequest()
	Endif
	If sendHandPaint
		OnHandPaintRequest()
	Endif
	If sendFeetPaint
		OnFeetPaintRequest()
	Endif
	If sendFacePaint
		AddWarpaints(_textures)
	Endif
	If sendBodyPaint
		AddBodyPaints(_textures_body)
	Endif
	If sendHandPaint
		AddHandPaints(_textures_hand)
	Endif
	If sendFeetPaint
		AddFeetPaints(_textures_feet)
	Endif
	If sendFacePaint || sendBodyPaint || sendHandPaint || sendFeetPaint
		FlushBuffer(0)
	Endif
EndEvent

Event OnMenuInitialized(string eventName, string strArg, float numArg, Form formArg)
	OnWarpaintRequest()
	OnBodyPaintRequest()
	OnHandPaintRequest()
	OnFeetPaintRequest()
	AddWarpaints(_textures)
	AddBodyPaints(_textures_body)
	AddHandPaints(_textures_hand)
	AddFeetPaints(_textures_feet)
	OnInitializeMenu(_playerActor, _playerActorBase)
	OnSliderRequest(_playerActor, _playerActorBase, _playerActorBase.GetRace(), _playerActorBase.GetSex() as bool)
	AddSliders(_sliders)
	FlushBuffer(2)
EndEvent

Event OnMenuReinitialized(string eventName, string strArg, float numArg, Form formArg)
	OnResetMenu(_playerActor, _playerActorBase)
	OnSliderRequest(_playerActor, _playerActorBase, _playerActorBase.GetRace(), _playerActorBase.GetSex() as bool)
	AddSliders(_sliders)
	FlushBuffer(1)
EndEvent

Event OnMenuSliderChange(string eventName, string strArg, float numArg, Form formArg)
	OnSliderChanged(strArg, numArg)
EndEvent

Event OnMenuLoadPlugins(string eventName, string strArg, float numArg, Form formArg)
	OnReloadSettings(_playerActor, _playerActorBase)
EndEvent

Event OnReloadSettings(Actor player, ActorBase playerBase)
	; Do nothing
EndEvent

Event OnWarpaintRequest()
	; Do nothing
EndEvent

Event OnBodyPaintRequest()
	; Do nothing
EndEvent

Event OnHandPaintRequest()
	; Do nothing
EndEvent

Event OnFeetPaintRequest()
	; Do nothing
EndEvent

Event OnInitializeMenu(Actor player, ActorBase playerBase)
	; Do nothing
EndEvent

Event OnResetMenu(Actor player, ActorBase playerBase)
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

Function AddBodyPaint(string name, string texturePath)
	_textures_body[_textureBuffer_body] = name + ";;" + texturePath
	_textureBuffer_body += 1
EndFunction

Function AddBodyPaintEx(string name, string texture0, string texture1 = "ignore", string texture2 = "ignore", string texture3 = "ignore", string texture4 = "ignore", string texture5 = "ignore", string texture6 = "ignore", string texture7 = "ignore")
	_textures_body[_textureBuffer_body] = name + ";;" + texture0 + "|" + texture1 + "|" + texture2 + "|" + texture3 + "|" + texture4 + "|" + texture5 + "|" + texture6 + "|" + texture7
	_textureBuffer_body += 1
EndFunction

Function AddHandPaint(string name, string texturePath)
	_textures_hand[_textureBuffer_hand] = name + ";;" + texturePath
	_textureBuffer_hand += 1
EndFunction

Function AddHandPaintEx(string name, string texture0, string texture1 = "ignore", string texture2 = "ignore", string texture3 = "ignore", string texture4 = "ignore", string texture5 = "ignore", string texture6 = "ignore", string texture7 = "ignore")
	_textures_hand[_textureBuffer_hand] = name + ";;" + texture0 + "|" + texture1 + "|" + texture2 + "|" + texture3 + "|" + texture4 + "|" + texture5 + "|" + texture6 + "|" + texture7
	_textureBuffer_hand += 1
EndFunction

Function AddFeetPaint(string name, string texturePath)
	_textures_feet[_textureBuffer_feet] = name + ";;" + texturePath
	_textureBuffer_feet += 1
EndFunction

Function AddFeetPaintEx(string name, string texture0, string texture1 = "ignore", string texture2 = "ignore", string texture3 = "ignore", string texture4 = "ignore", string texture5 = "ignore", string texture6 = "ignore", string texture7 = "ignore")
	_textures_feet[_textureBuffer_feet] = name + ";;" + texture0 + "|" + texture1 + "|" + texture2 + "|" + texture3 + "|" + texture4 + "|" + texture5 + "|" + texture6 + "|" + texture7
	_textureBuffer_feet += 1
EndFunction


Function AddSlider(string name, int section, string callback, float min, float max, float interval, float position)
	_sliders[_sliderBuffer] = name + ";;" + section + ";;" + callback + ";;" + min + ";;" + max + ";;" + interval + ";;" + position
	_sliderBuffer += 1
EndFunction

Function AddWarpaints(string[] textures)
	UI.InvokeStringA(_targetMenu, _targetRoot + "RSM_AddWarpaints", textures)
EndFunction

Function AddBodyPaints(string[] textures)
	UI.InvokeStringA(_targetMenu, _targetRoot + "RSM_AddBodyPaints", textures)
EndFunction

Function AddHandPaints(string[] textures)
	UI.InvokeStringA(_targetMenu, _targetRoot + "RSM_AddHandPaints", textures)
EndFunction

Function AddFeetPaints(string[] textures)
	UI.InvokeStringA(_targetMenu, _targetRoot + "RSM_AddFeetPaints", textures)
EndFunction

Function AddSliders(string[] sliders)
	UI.InvokeStringA(_targetMenu, _targetRoot + "RSM_AddSliders", sliders)
EndFunction

Function SetSliderParameters(string callback, float min, float max, float interval, float position)
	string[] params = new string[5]
	params[0] = callback
	params[1] = min as string
	params[2] = max as string
	params[3] = interval as string
	params[4] = position as string
	UI.InvokeStringA(_targetMenu, _targetRoot + "RSM_SetSliderParameters", params)
EndFunction

; 0 - Texture Buffers
; 1 - Slider Buffers
; 2 - Both Buffers
Function FlushBuffer(int bufferType)
	int i = 0
	While i < 128
		if bufferType == 0 || bufferType == 2
			_textures[i] = ""

			If _textures_body
				_textures_body[i] = ""
			Endif
			If _textures_hand
				_textures_hand[i] = ""
			Endif
			If _textures_feet
				_textures_feet[i] = ""
			Endif
		Endif
		If bufferType == 1 || bufferType == 2
			_sliders[i] = ""
		Endif
		i += 1
	EndWhile

	if bufferType == 0 || bufferType == 2
		_textureBuffer = 0
		_textureBuffer_body = 0
		_textureBuffer_hand = 0
		_textureBuffer_feet = 0
	Endif
	If bufferType == 1 || bufferType == 2
		_sliderBuffer = 0
	Endif
EndFunction
