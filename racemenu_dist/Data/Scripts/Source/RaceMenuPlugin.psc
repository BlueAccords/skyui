Scriptname RaceMenuPlugin extends RaceMenuBase

string Property NINODE_HEAD = "NPC Head [Head]" AutoReadOnly
string Property NINODE_LEFT_BREAST = "NPC L Breast" AutoReadOnly
string Property NINODE_RIGHT_BREAST = "NPC R Breast" AutoReadOnly
string Property NINODE_LEFT_BUTT = "NPC L Butt" AutoReadOnly
string Property NINODE_RIGHT_BUTT = "NPC R Butt" AutoReadOnly

; Custom Properties
float _height = 1.0
float _head = 1.0
float _leftBreast = 1.0
float _rightBreast = 1.0
float _leftButt = 1.0
float _rightButt = 1.0
; VoiceType _voiceType = None

; Reload Custom slider settings here
Event OnReloadSettings(Actor player, ActorBase playerBase)
	playerBase.SetHeight(_height)
	player.SetNiNodeScale(NINODE_HEAD, _head)
	player.SetNiNodeScale(NINODE_LEFT_BREAST, _leftBreast)
	player.SetNiNodeScale(NINODE_RIGHT_BREAST, _rightBreast)
	player.SetNiNodeScale(NINODE_LEFT_BUTT, _leftButt)
	player.SetNiNodeScale(NINODE_RIGHT_BUTT, _rightButt)
	player.QueueNiNodeUpdate()
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
	AddSlider("$Height", CATEGORY_BODY, "ChangeHeight", 0.25, 1.50, 0.01, playerBase.GetHeight())

	; If isFemale == false
	; 	int vType = GetVoiceTypeIndex(isFemale, _playerActor.GetRace().GetDefaultVoiceType(isFemale))
	; 	If vType != -1
	; 		AddSlider("$Voice Type", CATEGORY_BODY, "ChangeVoice", 0, 24, 1, vType)
	; 	Endif
	; Elseif isFemale == true
	; 	int vType = GetVoiceTypeIndex(isFemale, _playerActor.GetRace().GetDefaultVoiceType(isFemale))
	; 	If vType != -1
	; 		AddSlider("$Voice Type", CATEGORY_BODY, "ChangeVoice", 0, 17, 1, vType)
	; 	Endif
	; Endif

	float head = player.GetNiNodeScale(NINODE_HEAD)
	If head != 0
		AddSlider("$Head", CATEGORY_BODY, "ChangeHeadSize", 0.01, 3.00, 0.01, head)
	Endif

	If isFemale == true
		float leftBreast = player.GetNiNodeScale(NINODE_LEFT_BREAST)
		float rightBreast = player.GetNiNodeScale(NINODE_RIGHT_BREAST)
		float leftButt = player.GetNiNodeScale(NINODE_LEFT_BUTT)
		float rightButt = player.GetNiNodeScale(NINODE_RIGHT_BUTT)
		
		If leftBreast != 0 && rightBreast != 0 && leftButt != 0 && rightButt != 0
			AddSlider("$Left Breast", CATEGORY_BODY, "ChangeLeftBreast", 0.1, 5.00, 0.1, leftBreast)
			AddSlider("$Right Breast", CATEGORY_BODY, "ChangeRightBreast", 0.1, 5.00, 0.1, rightBreast)
			AddSlider("$Left Buttcheek", CATEGORY_BODY, "ChangeLeftButt", 0.1, 5.00, 0.1, leftButt)
			AddSlider("$Right Buttcheek", CATEGORY_BODY, "ChangeRightButt", 0.1, 5.00, 0.1, rightButt)
		Endif
	Endif
EndEvent

Event OnSliderChanged(string callback, float value)
	If callback == "ChangeHeight"
		_height = value
		_playerActorBase.SetHeight(value)
		_playerActor.QueueNiNodeUpdate()
	ElseIf callback == "ChangeHeadSize"
		_head = value
		_playerActor.SetNiNodeScale(NINODE_HEAD, _head)
		_playerActor.QueueNiNodeUpdate()
	Elseif callback == "ChangeLeftBreast"
		_leftBreast = value
		_playerActor.SetNiNodeScale(NINODE_LEFT_BREAST, _leftBreast)
		_playerActor.QueueNiNodeUpdate()
	Elseif callback == "ChangeRightBreast"
		_rightBreast = value
		_playerActor.SetNiNodeScale(NINODE_RIGHT_BREAST, _rightBreast)
		_playerActor.QueueNiNodeUpdate()
	Elseif callback == "ChangeLeftButt"
		_leftButt = value
		_playerActor.SetNiNodeScale(NINODE_LEFT_BUTT, _leftButt)
		_playerActor.QueueNiNodeUpdate()
	Elseif callback == "ChangeRightButt"
		_rightButt = value
		_playerActor.SetNiNodeScale(NINODE_RIGHT_BUTT, _rightButt)
		_playerActor.QueueNiNodeUpdate()
	; Elseif strArg == "ChangeVoice"
	; 	bool isFemale = _playerActorBase.GetSex() as Bool
	; 	VoiceType newVoice = GetVoiceType(isFemale, numArg as int)
	; 	_playerActor.GetRace().SetDefaultVoiceType(isFemale, newVoice)
	; 	Topic swingTopic = Game.GetFormFromFile(0xB876A, "Skyrim.esm") as Topic ; DCETAttack
	; 	_playerActor.Say(swingTopic, None, true)
	Endif
EndEvent