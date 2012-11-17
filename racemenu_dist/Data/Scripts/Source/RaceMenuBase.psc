Scriptname RaceMenuBase extends Quest

string Property RACESEX_MENU = "RaceSex Menu" Autoreadonly
string Property MENU_ROOT = "_root.RaceSexMenuBaseInstance.RaceSexPanelsInstance." Autoreadonly

string[] _nameBuffer
string[] _textureBuffer
int _bufferPos

Event OnInit()
	_nameBuffer = new string[128]
	_textureBuffer = new string[128]
	_bufferPos = 0
	OnStartup()
EndEvent

Event OnGameReload()
	OnStartup()
EndEvent

Event OnStartup()
	RegisterForModEvent("RSM_Initialized", "OnMenuInitialized")
EndEvent

Event OnMenuInitialized(string eventName, string strArg, float numArg, Form formArg)
	OnWarpaintRequest()
	AddMakeupList(_nameBuffer, _textureBuffer)
	FlushBuffer()
EndEvent

Event OnWarpaintRequest()
	; Do nothing
EndEvent

Function AddWarpaint(string name, string texturePath)
	_nameBuffer[_bufferPos] = name
	_textureBuffer[_bufferPos] = texturePath
	_bufferPos += 1
EndFunction

; Useable
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

; Not recommended for use
Function AddMakeupList(string[] names, string[] textures)
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_BeginMakeup")
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddMakeupNames", names)
	UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddMakeupTextures", textures)
	UI.Invoke(RACESEX_MENU, MENU_ROOT + "RSM_EndMakeup")
EndFunction

Function FlushBuffer()
	int i = 0
	While i < 128
		_nameBuffer[i] = ""
		_textureBuffer[i] = ""
		i += 1
	EndWhile
	_bufferPos = 0
EndFunction