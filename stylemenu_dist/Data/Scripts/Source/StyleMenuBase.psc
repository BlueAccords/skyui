Scriptname StyleMenuBase extends Quest

string Property DIALOGUE_MENU = "Dialogue Menu" AutoReadOnly
string Property DIALOGUE_MENU_ROOT = "_root.DialogueMenu_mc" AutoReadOnly
string Property MENU_ROOT = "_root.StyleMenuContainer.styleMenu." AutoReadOnly

Actor Property _targetActor Auto
ActorBase Property _targetActorBase Auto

string[] _headParts01 = None
string[] _headParts02 = None
int _headPartBuffer

Event OnInit()
	_targetActor = Game.GetPlayer()
	_targetActorBase = _targetActor.GetActorBase()

	OnInitialized()

	OnStartup()
EndEvent

Event OnInitialized()
	_headParts01 = new string[128]
	_headParts02 = new string[128]
	_headPartBuffer = 0
EndEvent

Event OnGameReload()
	OnStartup()
EndEvent

Event OnStartup()
	RegisterForModEvent("SSM_Initialized", "OnMenuInitialized")
	RegisterForModEvent("SSM_LoadPlugins", "OnMenuLoadPlugins")
EndEvent

Event OnMenuInitialized(string eventName, string strArg, float numArg, Form formArg)
	OnHeadPartRequest(_targetActor, _targetActorBase, _targetActor.GetRace(), _targetActorBase.GetSex() as bool)
	AddHeadParts(_headParts01)
	AddHeadParts(_headParts02)
	OnInitializeMenu(_targetActor, _targetActorBase)
	FlushBuffer(0)
EndEvent

Event OnMenuReinitialized(string eventName, string strArg, float numArg, Form formArg)
	OnResetMenu(_targetActor, _targetActorBase)
	FlushBuffer(0)
EndEvent

Event OnMenuLoadPlugins(string eventName, string strArg, float numArg, Form formArg)
	OnReloadSettings(_targetActor, _targetActorBase)
EndEvent

Event OnReloadSettings(Actor targetActor, ActorBase targetActorBase)
	; Do nothing
EndEvent

Event OnHeadPartRequest(Actor targetActor, ActorBase targetActorBase, Race targetRace, bool isFemale)
	; Do nothing
EndEvent

Event OnInitializeMenu(Actor targetActor, ActorBase targetActorBase)
	; Do nothing
EndEvent

Event OnResetMenu(Actor targetActor, ActorBase targetActorBase)
	; Do nothing
EndEvent

Function AddHeadPart(string name, string editorId, string thumbnailPath, int cost)
	If _headPartBuffer < 128
		_headParts01[_headPartBuffer] = name + ";;" + editorId + ";;" + thumbnailPath + ";;" + cost
	Elseif _headPartBuffer >= 128
		_headParts02[_headPartBuffer - 128] = name + ";;" + editorId + ";;" + thumbnailPath + ";;" + cost
	Endif

	HeadPart newPart = HeadPart.GetHeadPart(editorId)
	If !newPart
		Debug.Trace("StyleMenu - Invalid HeadPart: " + editorId)
	Endif

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
			_headParts01[i] = ""
			_headParts02[i] = ""
		Endif
		i += 1
	EndWhile

	if bufferType == 0
		_headPartBuffer = 0
	Endif
EndFunction
