Scriptname StyleMenuBase extends Quest

string Property DIALOGUE_MENU = "Dialogue Menu" AutoReadOnly
string Property DIALOGUE_MENU_ROOT = "_root.DialogueMenu_mc" AutoReadOnly
string Property MENU_ROOT = "_root.StyleMenu" AutoReadOnly

Actor Property _playerActor Auto
ActorBase Property _playerActorBase Auto

string[] _headParts
int _headPartBuffer

Event OnInit()
	_playerActor = Game.GetPlayer()
	_playerActorBase = _playerActor.GetActorBase()

	OnInitialized()

	OnStartup()
EndEvent

Event OnInitialized()
	_headParts = new string[128]
	_headPartBuffer = 0
EndEvent

Event OnGameReload()
	OnStartup()
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
	RegisterForModEvent("SSM_Initialized", "OnMenuInitialized")
	RegisterForModEvent("SSM_Reinitialized", "OnMenuReinitialized")
	RegisterForModEvent("SSM_LoadPlugins", "OnMenuLoadPlugins")
EndEvent

Event OnMenuInitialized(string eventName, string strArg, float numArg, Form formArg)
	OnHeadPartRequest()
	AddHeadParts(_headParts)
	OnInitializeMenu(_playerActor, _playerActorBase)
	FlushBuffer(0)
EndEvent

Event OnMenuReinitialized(string eventName, string strArg, float numArg, Form formArg)
	OnResetMenu(_playerActor, _playerActorBase)
	FlushBuffer(0)
EndEvent

Event OnMenuLoadPlugins(string eventName, string strArg, float numArg, Form formArg)
	OnReloadSettings(_playerActor, _playerActorBase)
EndEvent

Event OnReloadSettings(Actor player, ActorBase playerBase)
	; Do nothing
EndEvent

Event OnHeadPartRequest()
	; Do nothing
EndEvent

Event OnInitializeMenu(Actor player, ActorBase playerBase)
	; Do nothing
EndEvent

Event OnResetMenu(Actor player, ActorBase playerBase)
	; Do nothing
EndEvent

Function AddHeadPart(string name, string editorId, int cost)
	_headParts[_headPartBuffer] = name + ";;" + editorId + ";;" + cost
	_headPartBuffer += 1
EndFunction

Function AddHeadParts(string[] headParts)
	UI.InvokeStringA(DIALOGUE_MENU, MENU_ROOT + "SSM_AddHeadParts", headParts)
EndFunction

; 0 - HeadPart Buffers
Function FlushBuffer(int bufferType)
	int i = 0
	While i < 128
		if bufferType == 0
			_headParts[i] = ""
		Endif
		i += 1
	EndWhile

	if bufferType == 0
		_headPartBuffer = 0
	Endif
EndFunction
