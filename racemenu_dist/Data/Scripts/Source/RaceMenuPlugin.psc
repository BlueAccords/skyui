Scriptname RaceMenuPlugin extends RaceMenuBase

string Property NINODE_NPC = "NPC" AutoReadOnly
string Property NINODE_HEAD = "NPC Head [Head]" AutoReadOnly
string Property NINODE_LEFT_BREAST = "NPC L Breast" AutoReadOnly
string Property NINODE_RIGHT_BREAST = "NPC R Breast" AutoReadOnly
string Property NINODE_Left_BICEP = "NPC L UpperarmTwist2 [LUt2]" AutoReadOnly
string Property NINODE_RIGHT_BICEP = "NPC R UpperarmTwist2 [RUt2]" AutoReadOnly

; Custom Properties
float _height = 1.0
float _head = 1.0
float _leftBreast = 1.0
float _rightBreast = 1.0
float _rightBicep = 1.0
float _leftBicep = 1.0

bool hasInitialized = false ; For one time init, used for loading data inside OnGameLoad instead of Init (Unsafe)

Event OnReloadSettings(Actor player, ActorBase playerBase)
	If !hasInitialized ; Init script values from current player
		SavePlayerNodeScales(player)
		hasInitialized = true
	Else
		LoadPlayerNodeScales(player)
	Endif
EndEvent

Function LoadPlayerNodeScales(Actor player)
	NetImmerse.SetNodeScale(player, NINODE_NPC, _height, false)
	NetImmerse.SetNodeScale(player, NINODE_HEAD, _head, false)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BREAST, _leftBreast, false)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BREAST, _rightBreast, false)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BICEP, _leftBicep, false)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BICEP, _rightBicep, false)
	NetImmerse.SetNodeScale(player, NINODE_NPC, _height, true)
	NetImmerse.SetNodeScale(player, NINODE_HEAD, _head, true)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BREAST, _leftBreast, true)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BREAST, _rightBreast, true)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BICEP, _leftBicep, true)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BICEP, _rightBicep, true)
EndFunction

Event On3DLoaded(ObjectReference akRef)
	OnReloadSettings(_playerActor, _playerActorBase)
EndEvent

Event OnCellLoaded(ObjectReference akRef)
	LoadPlayerNodeScales(_playerActor)
EndEvent

; Add Custom Warpaint here
Event OnWarpaintRequest()
	AddWarpaint("$Beauty Mark 01", "Actors\\Character\\Character Assets\\TintMasks\\BeautyMark_01.dds")
	AddWarpaint("$Beauty Mark 02", "Actors\\Character\\Character Assets\\TintMasks\\BeautyMark_02.dds")
	AddWarpaint("$Beauty Mark 03", "Actors\\Character\\Character Assets\\TintMasks\\BeautyMark_03.dds")
	AddWarpaint("$Dragon Tattoo 01", "Actors\\Character\\Character Assets\\TintMasks\\DragonTattoo_01.dds")
EndEvent

Function SavePlayerNodeScales(Actor player)
	If NetImmerse.HasNode(player, NINODE_NPC, false)
		_height = NetImmerse.GetNodeScale(player, NINODE_NPC, false)
	Else
		_height = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_HEAD, false)
		_head = NetImmerse.GetNodeScale(player, NINODE_HEAD, false)
	Else
		_head = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_LEFT_BREAST, false)
		_leftBreast = NetImmerse.GetNodeScale(player, NINODE_LEFT_BREAST, false)
	Else
		_leftBreast = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_RIGHT_BREAST, false)
		_rightBreast = NetImmerse.GetNodeScale(player, NINODE_RIGHT_BREAST, false)
	Else
		_rightBreast = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_LEFT_BICEP, false)
		_leftBicep = NetImmerse.GetNodeScale(player, NINODE_LEFT_BICEP, false)
	Else
		_leftBicep = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_RIGHT_BICEP, false)
		_rightBicep = NetImmerse.GetNodeScale(player, NINODE_RIGHT_BICEP, false)
	Else
		_rightBicep = 1.0
	Endif
EndFunction

Event OnInitializeMenu(Actor player, ActorBase playerBase)
	SavePlayerNodeScales(player)
EndEvent

Event OnResetMenu(Actor player, ActorBase playerBase)
	_height = 1.0
	_head = 1.0
	_leftBreast = 1.0
	_rightBreast = 1.0
	_rightBicep = 1.0
	_leftBicep = 1.0
	LoadPlayerNodeScales(player)
EndEvent

; Add Custom sliders here
Event OnSliderRequest(Actor player, ActorBase playerBase, Race actorRace, bool isFemale)
	AddSlider("$Height", CATEGORY_BODY, "ChangeHeight", 0.25, 1.50, 0.01, _height)

	If NetImmerse.HasNode(player, NINODE_HEAD, false)
		AddSlider("$Head", CATEGORY_BODY, "ChangeHeadSize", 0.01, 3.00, 0.01, _head)
	Endif

	If isFemale == true		
		If NetImmerse.HasNode(player, NINODE_LEFT_BREAST, false)
			AddSlider("$Left Breast", CATEGORY_BODY, "ChangeLeftBreast", 0.1, 5.00, 0.01, _leftBreast)
		Endif
		If NetImmerse.HasNode(player, NINODE_RIGHT_BREAST, false)
			AddSlider("$Right Breast", CATEGORY_BODY, "ChangeRightBreast", 0.1, 5.00, 0.01, _rightBreast)
		Endif
	Endif

	AddSlider("$Left Biceps", CATEGORY_BODY, "ChangeLeftBiceps", 0.1, 5.00, 0.01, _leftBicep)
	AddSlider("$Right Biceps", CATEGORY_BODY, "ChangeRightBiceps", 0.1, 5.00, 0.01, _rightBicep)
EndEvent

Event OnSliderChanged(string callback, float value)
	If callback == "ChangeHeight"
		_height = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_NPC, _height, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_NPC, _height, true)
	ElseIf callback == "ChangeHeadSize"
		_head = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_HEAD, _head, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_HEAD, _head, true)
	Elseif callback == "ChangeLeftBreast"
		_leftBreast = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BREAST, _leftBreast, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BREAST, _leftBreast, true)
	Elseif callback == "ChangeRightBreast"
		_rightBreast = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BREAST, _rightBreast, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BREAST, _rightBreast, true)
	Elseif callback == "ChangeLeftBiceps"
		_leftBicep = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BICEP, _leftBicep, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BICEP, _leftBicep, true)
	Elseif callback == "ChangeRightBiceps"
		_rightBicep = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BICEP, _rightBicep, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BICEP, _rightBicep, true)
	Endif
EndEvent