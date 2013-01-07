Scriptname RaceMenuPlugin extends RaceMenuBase

string Property NINODE_HEAD = "NPC Head [Head]" AutoReadOnly
string Property NINODE_LEFT_BREAST = "NPC L Breast" AutoReadOnly
string Property NINODE_RIGHT_BREAST = "NPC R Breast" AutoReadOnly
string Property NINODE_LEFT_BUTT = "NPC L Butt" AutoReadOnly
string Property NINODE_RIGHT_BUTT = "NPC R Butt" AutoReadOnly
string Property NINODE_Left_BICEP = "NPC L UpperarmTwist2 [LUt2]" AutoReadOnly
string Property NINODE_RIGHT_BICEP = "NPC R UpperarmTwist2 [RUt2]" AutoReadOnly

; Custom Properties
float _height = 1.0
float _head = 1.0
float _leftBreast = 1.0
float _rightBreast = 1.0
float _leftButt = 1.0
float _rightButt = 1.0
float _rightBicep = 1.0
float _leftBicep = 1.0

; Reload Custom slider settings here
Event OnReloadSettings(Actor player, ActorBase playerBase)
	playerBase.SetHeight(_height)
	player.QueueNiNodeUpdate()
	LoadNodeScales(player)
EndEvent

Function LoadNodeScales(Actor player)
	NetImmerse.SetNodeScale(player, NINODE_HEAD, _head)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BREAST, _leftBreast)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BREAST, _rightBreast)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BUTT, _leftButt)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BUTT, _rightButt)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BICEP, _leftBicep)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BICEP, _rightBicep)
EndFunction

Event On3DLoaded(ObjectReference akRef)
	OnReloadSettings(_playerActor, _playerActorBase)
EndEvent

Event OnCellLoaded(ObjectReference akRef)
	LoadNodeScales(_playerActor)
EndEvent

; Add Custom Warpaint here
Event OnWarpaintRequest()
	AddWarpaint("$Beauty Mark 01", "Actors\\Character\\Character Assets\\TintMasks\\BeautyMark_01.dds")
	AddWarpaint("$Beauty Mark 02", "Actors\\Character\\Character Assets\\TintMasks\\BeautyMark_02.dds")
	AddWarpaint("$Beauty Mark 03", "Actors\\Character\\Character Assets\\TintMasks\\BeautyMark_03.dds")
	AddWarpaint("$Dragon Tattoo 01", "Actors\\Character\\Character Assets\\TintMasks\\DragonTattoo_01.dds")
EndEvent

; Add Custom sliders here
Event OnSliderRequest(Actor player, ActorBase playerBase, Race actorRace, bool isFemale)
	; Reset the stored data
	_height = playerBase.GetHeight()
	_head = NetImmerse.GetNodeScale(player, NINODE_HEAD)
	_leftBreast = NetImmerse.GetNodeScale(player, NINODE_LEFT_BREAST)
	_rightBreast = NetImmerse.GetNodeScale(player, NINODE_RIGHT_BREAST)
	_leftButt = NetImmerse.GetNodeScale(player, NINODE_LEFT_BUTT)
	_rightButt = NetImmerse.GetNodeScale(player, NINODE_RIGHT_BUTT)
	_leftBicep = NetImmerse.GetNodeScale(player, NINODE_LEFT_BICEP)
	_rightBicep = NetImmerse.GetNodeScale(player, NINODE_RIGHT_BICEP)

	AddSlider("$Height", CATEGORY_BODY, "ChangeHeight", 0.25, 1.50, 0.01, _height)

	If NetImmerse.HasNode(player, NINODE_HEAD)
		AddSlider("$Head", CATEGORY_BODY, "ChangeHeadSize", 0.01, 3.00, 0.01, _head)
	Endif

	If isFemale == true		
		If NetImmerse.HasNode(player, NINODE_LEFT_BREAST)
			AddSlider("$Left Breast", CATEGORY_BODY, "ChangeLeftBreast", 0.1, 5.00, 0.1, _leftBreast)
		Endif
		If NetImmerse.HasNode(player, NINODE_RIGHT_BREAST)
			AddSlider("$Right Breast", CATEGORY_BODY, "ChangeRightBreast", 0.1, 5.00, 0.1, _rightBreast)
		Endif
		If NetImmerse.HasNode(player, NINODE_LEFT_BUTT)
			AddSlider("$Left Buttcheek", CATEGORY_BODY, "ChangeLeftButt", 0.1, 5.00, 0.1, _leftButt)
		Endif
		If NetImmerse.HasNode(player, NINODE_RIGHT_BUTT)
			AddSlider("$Right Buttcheek", CATEGORY_BODY, "ChangeRightButt", 0.1, 5.00, 0.1, _rightButt)
		Endif
	Endif

	AddSlider("$Left Bicep", CATEGORY_BODY, "ChangeLeftBicep", 0.1, 5.00, 0.1, _leftBicep)
	AddSlider("$Right Bicep", CATEGORY_BODY, "ChangeRightBicep", 0.1, 5.00, 0.1, _rightBicep)
EndEvent

Event OnSliderChanged(string callback, float value)
	If callback == "ChangeHeight"
		_height = value
		_playerActorBase.SetHeight(value)
		_playerActor.QueueNiNodeUpdate()
	ElseIf callback == "ChangeHeadSize"
		_head = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_HEAD, _head)
	Elseif callback == "ChangeLeftBreast"
		_leftBreast = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BREAST, _leftBreast)
	Elseif callback == "ChangeRightBreast"
		_rightBreast = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BREAST, _rightBreast)
	Elseif callback == "ChangeLeftButt"
		_leftButt = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BUTT, _leftButt)
	Elseif callback == "ChangeRightButt"
		_rightButt = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BUTT, _rightButt)
	Elseif callback == "ChangeLeftBicep"
		_leftBicep = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BICEP, _leftBicep)
	Elseif callback == "ChangeRightBicep"
		_rightBicep = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BICEP, _rightBicep)
	Endif
EndEvent