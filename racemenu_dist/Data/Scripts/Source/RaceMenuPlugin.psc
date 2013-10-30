Scriptname RaceMenuPlugin extends RaceMenuBase

bool Property HEIGHT_ENABLED = true AutoReadOnly ; Set this to false to rebuild if you don't want height
bool Property WEAPONS_ENABLED = true AutoReadOnly ; Set this to false to rebuild if you don't want weapon scales

string Property NINODE_NPC = "NPC" AutoReadOnly
string Property NINODE_HEAD = "NPC Head [Head]" AutoReadOnly
string Property NINODE_LEFT_BREAST = "NPC L Breast" AutoReadOnly
string Property NINODE_RIGHT_BREAST = "NPC R Breast" AutoReadOnly
string Property NINODE_LEFT_BUTT = "NPC L Butt" AutoReadOnly
string Property NINODE_RIGHT_BUTT = "NPC R Butt" AutoReadOnly
string Property NINODE_LEFT_BREAST_FORWARD = "NPC L Breast01" AutoReadOnly
string Property NINODE_RIGHT_BREAST_FORWARD = "NPC R Breast01" AutoReadOnly
string Property NINODE_LEFT_BICEP = "NPC L UpperarmTwist1 [LUt1]" AutoReadOnly
string Property NINODE_RIGHT_BICEP = "NPC R UpperarmTwist1 [RUt1]" AutoReadOnly
string Property NINODE_LEFT_BICEP_2 = "NPC L UpperarmTwist2 [LUt2]" AutoReadOnly
string Property NINODE_RIGHT_BICEP_2 = "NPC R UpperarmTwist2 [RUt2]" AutoReadOnly

string Property NINODE_QUIVER = "QUIVER" AutoReadOnly
string Property NINODE_BOW = "WeaponBow" AutoReadOnly
string Property NINODE_AXE = "WeaponAxe" AutoReadOnly
string Property NINODE_SWORD = "WeaponSword" AutoReadOnly
string Property NINODE_MACE = "WeaponMace" AutoReadOnly
string Property NINODE_SHIELD = "SHIELD" AutoReadOnly
string Property NINODE_WEAPON_BACK = "WeaponBack" AutoReadOnly
string Property NINODE_WEAPON = "WEAPON" AutoReadOnly

; Custom Properties
float _height = 1.0
float _head = 1.0
float _leftBreast = 1.0
float _rightBreast = 1.0
float _leftBreastF = 1.0
float _rightBreastF = 1.0
float _leftButt = 1.0
float _rightButt = 1.0
float _rightBicep = 1.0
float _leftBicep = 1.0
float _rightBicep2 = 1.0
float _leftBicep2 = 1.0

; Weapon related scales
float _quiver = 1.0
float _bow = 1.0
float _axe = 1.0
float _sword = 1.0
float _mace = 1.0
float _shield = 1.0
float _weaponBack = 1.0
float _weapon = 1.0

bool hasInitialized = false ; For one time init, used for loading data inside OnGameLoad instead of Init (Unsafe)

Event OnStartup()
	parent.OnStartup()
	RegisterForModEvent("RSM_RequestNodeSave", "OnSaveScales")
EndEvent

Event OnSaveScales(string eventName, string strArg, float numArg, Form formArg)
	SavePlayerNodeScales(_playerActor)
EndEvent

Event OnReloadSettings(Actor player, ActorBase playerBase)
	If !hasInitialized ; Init script values from current player
		SavePlayerNodeScales(player)
		hasInitialized = true
	Else
		LoadPlayerNodeScales(player)
	Endif
EndEvent

Function LoadPlayerNodeScales(Actor player)
	Normalize()

	If HEIGHT_ENABLED ; Load height only if enabled
		NetImmerse.SetNodeScale(player, NINODE_NPC, _height, false)
		NetImmerse.SetNodeScale(player, NINODE_NPC, _height, true)
	Endif

	NetImmerse.SetNodeScale(player, NINODE_HEAD, _head, false)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BREAST, _leftBreast, false)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BREAST, _rightBreast, false)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BUTT, _leftButt, false)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BUTT, _rightButt, false)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BREAST_FORWARD, _leftBreastF, false)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BREAST_FORWARD, _rightBreastF, false)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BICEP, _leftBicep, false)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BICEP, _rightBicep, false)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BICEP_2, _leftBicep2, false)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BICEP_2, _rightBicep2, false)

	NetImmerse.SetNodeScale(player, NINODE_HEAD, _head, true)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BREAST, _leftBreast, true)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BREAST, _rightBreast, true)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BUTT, _leftButt, true)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BUTT, _rightButt, true)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BREAST_FORWARD, _leftBreastF, true)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BREAST_FORWARD, _rightBreastF, true)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BICEP, _leftBicep, true)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BICEP, _rightBicep, true)
	NetImmerse.SetNodeScale(player, NINODE_LEFT_BICEP_2, _leftBicep, true)
	NetImmerse.SetNodeScale(player, NINODE_RIGHT_BICEP_2, _rightBicep, true)

	If WEAPONS_ENABLED ; Load scales only if enabled
		; Weapon scales 3rd
		NetImmerse.SetNodeScale(player, NINODE_QUIVER, _quiver, false)
		NetImmerse.SetNodeScale(player, NINODE_BOW, _bow, false)
		NetImmerse.SetNodeScale(player, NINODE_AXE, _axe, false)
		NetImmerse.SetNodeScale(player, NINODE_SWORD, _sword, false)
		NetImmerse.SetNodeScale(player, NINODE_MACE, _mace, false)
		NetImmerse.SetNodeScale(player, NINODE_SHIELD, _shield, false)
		NetImmerse.SetNodeScale(player, NINODE_WEAPON_BACK, _weaponBack, false)
		NetImmerse.SetNodeScale(player, NINODE_WEAPON, _weapon, false)

		; Weapon scales 1st
		NetImmerse.SetNodeScale(player, NINODE_QUIVER, _quiver, true)
		NetImmerse.SetNodeScale(player, NINODE_BOW, _bow, true)
		NetImmerse.SetNodeScale(player, NINODE_AXE, _axe, true)
		NetImmerse.SetNodeScale(player, NINODE_SWORD, _sword, true)
		NetImmerse.SetNodeScale(player, NINODE_MACE, _mace, true)
		NetImmerse.SetNodeScale(player, NINODE_SHIELD, _shield, true)
		NetImmerse.SetNodeScale(player, NINODE_WEAPON_BACK, _weaponBack, true)
		NetImmerse.SetNodeScale(player, NINODE_WEAPON, _weapon, true)
	Endif
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

Function Normalize()
	if _height == 0
		_height = 1
	Endif
	if _head == 0
		_head = 1
	Endif
	if _leftBreast == 0
		_leftBreast = 1
	Endif
	if _rightBreast == 0
		_rightBreast = 1
	Endif
	if _leftBreastF == 0
		_leftBreastF = 1
	Endif
	if _rightBreastF == 0
		_rightBreastF = 1
	Endif
	if _leftButt == 0
		_leftButt = 1
	Endif
	if _rightButt == 0
		_rightButt = 1
	Endif
	if _leftBicep == 0
		_leftBicep = 1
	Endif
	if _rightBicep == 0
		_rightBicep = 1
	Endif
	if _leftBicep2 == 0
		_leftBicep2 = 1
	Endif
	if _rightBicep2 == 0
		_rightBicep2 = 1
	Endif
	if _quiver == 0
		_quiver = 1
	Endif
	if _bow == 0
		_bow = 1
	Endif
	if _axe == 0
		_axe = 1
	Endif
	if _sword == 0
		_sword = 1
	Endif
	if _mace == 0
		_mace = 1
	Endif
	if _shield == 0
		_shield = 1
	Endif
	if _weaponBack == 0
		_weaponBack = 1
	Endif
	if _weapon == 0
		_weapon = 1
	Endif
EndFunction

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
	If NetImmerse.HasNode(player, NINODE_LEFT_BREAST_FORWARD, false)
		_leftBreastF = NetImmerse.GetNodeScale(player, NINODE_LEFT_BREAST_FORWARD, false)
	Else
		_leftBreastF = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_RIGHT_BREAST_FORWARD, false)
		_rightBreastF = NetImmerse.GetNodeScale(player, NINODE_RIGHT_BREAST_FORWARD, false)
	Else
		_rightBreastF = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_LEFT_BUTT, false)
		_leftButt = NetImmerse.GetNodeScale(player, NINODE_LEFT_BUTT, false)
	Else
		_leftButt = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_RIGHT_BUTT, false)
		_rightButt = NetImmerse.GetNodeScale(player, NINODE_RIGHT_BUTT, false)
	Else
		_rightButt = 1.0
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
	If NetImmerse.HasNode(player, NINODE_LEFT_BICEP_2, false)
		_leftBicep2 = NetImmerse.GetNodeScale(player, NINODE_LEFT_BICEP_2, false)
	Else
		_leftBicep2 = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_RIGHT_BICEP_2, false)
		_rightBicep2 = NetImmerse.GetNodeScale(player, NINODE_RIGHT_BICEP_2, false)
	Else
		_rightBicep2 = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_QUIVER, false)
		_quiver = NetImmerse.GetNodeScale(player, NINODE_QUIVER, false)
	Else
		_quiver = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_BOW, false)
		_bow = NetImmerse.GetNodeScale(player, NINODE_BOW, false)
	Else
		_bow = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_AXE, false)
		_axe = NetImmerse.GetNodeScale(player, NINODE_AXE, false)
	Else
		_axe = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_SWORD, false)
		_sword = NetImmerse.GetNodeScale(player, NINODE_SWORD, false)
	Else
		_sword = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_MACE, false)
		_mace = NetImmerse.GetNodeScale(player, NINODE_MACE, false)
	Else
		_mace = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_SHIELD, false)
		_shield = NetImmerse.GetNodeScale(player, NINODE_SHIELD, false)
	Else
		_shield = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_WEAPON_BACK, false)
		_weaponBack = NetImmerse.GetNodeScale(player, NINODE_WEAPON_BACK, false)
	Else
		_weaponBack = 1.0
	Endif
	If NetImmerse.HasNode(player, NINODE_WEAPON, false)
		_weapon = NetImmerse.GetNodeScale(player, NINODE_WEAPON, false)
	Else
		_weapon = 1.0
	Endif
	Normalize()
EndFunction

Event OnInitializeMenu(Actor player, ActorBase playerBase)
	SavePlayerNodeScales(player)
EndEvent

Event OnResetMenu(Actor player, ActorBase playerBase)
	_height = 1.0
	_head = 1.0
	_leftBreast = 1.0
	_rightBreast = 1.0
	_leftBreastF = 1.0
	_rightBreastF = 1.0
	_leftButt = 1.0
	_rightButt = 1.0
	_rightBicep = 1.0
	_leftBicep = 1.0
	_rightBicep2 = 1.0
	_leftBicep2 = 1.0
	_quiver = 1.0
	_bow = 1.0
	_axe = 1.0
	_sword = 1.0
	_mace = 1.0
	_shield = 1.0
	_weaponBack = 1.0
	_weapon = 1.0
	LoadPlayerNodeScales(player)
EndEvent

; Add Custom sliders here
Event OnSliderRequest(Actor player, ActorBase playerBase, Race actorRace, bool isFemale)
	If HEIGHT_ENABLED
		AddSlider("$Height", CATEGORY_BODY, "ChangeHeight", 0.25, 2.00, 0.01, _height)
	Endif

	If NetImmerse.HasNode(player, NINODE_HEAD, false)
		AddSlider("$Head", CATEGORY_BODY, "ChangeHeadSize", 0.01, 3.00, 0.01, _head)
	Endif

	If isFemale == true		
		If NetImmerse.HasNode(player, NINODE_LEFT_BREAST, false)
			AddSlider("$Left Breast", CATEGORY_BODY, "ChangeLeftBreast", 0.1, 3.00, 0.01, _leftBreast)
		Endif
		If NetImmerse.HasNode(player, NINODE_RIGHT_BREAST, false)
			AddSlider("$Right Breast", CATEGORY_BODY, "ChangeRightBreast", 0.1, 3.00, 0.01, _rightBreast)
		Endif
		If NetImmerse.HasNode(player, NINODE_LEFT_BREAST_FORWARD, false)
			AddSlider("$Left Breast Curve", CATEGORY_BODY, "ChangeLeftBreastCurve", 0.1, 3.00, 0.01, _leftBreastF)
		Endif
		If NetImmerse.HasNode(player, NINODE_RIGHT_BREAST_FORWARD, false)
			AddSlider("$Right Breast Curve", CATEGORY_BODY, "ChangeRightBreastCurve", 0.1, 3.00, 0.01, _rightBreastF)
		Endif
		If NetImmerse.HasNode(player, NINODE_LEFT_BUTT, false)
			AddSlider("$Left Glute", CATEGORY_BODY, "ChangeLeftButt", 0.1, 3.00, 0.01, _leftButt)
		Endif
		If NetImmerse.HasNode(player, NINODE_RIGHT_BUTT, false)
			AddSlider("$Right Glute", CATEGORY_BODY, "ChangeRightButt", 0.1, 3.00, 0.01, _rightButt)
		Endif
	Endif

	AddSlider("$Left Biceps", CATEGORY_BODY, "ChangeLeftBiceps", 0.1, 2.00, 0.01, _leftBicep)
	AddSlider("$Right Biceps", CATEGORY_BODY, "ChangeRightBiceps", 0.1, 2.00, 0.01, _rightBicep)

	AddSlider("$Left Biceps 2", CATEGORY_BODY, "ChangeLeftBiceps2", 0.1, 2.00, 0.01, _leftBicep2)
	AddSlider("$Right Biceps 2", CATEGORY_BODY, "ChangeRightBiceps2", 0.1, 2.00, 0.01, _rightBicep2)

	If WEAPONS_ENABLED
		If NetImmerse.HasNode(player, NINODE_QUIVER, false)
			AddSlider("$Quiver Scale", CATEGORY_BODY, "ChangeQuiverScale", 0.1, 3.00, 0.01, _quiver)
		Endif
		If NetImmerse.HasNode(player, NINODE_BOW, false)
			AddSlider("$Bow Scale", CATEGORY_BODY, "ChangeBowScale", 0.1, 3.00, 0.01, _bow)
		Endif
		If NetImmerse.HasNode(player, NINODE_AXE, false)
			AddSlider("$Axe Scale", CATEGORY_BODY, "ChangeAxeScale", 0.1, 3.00, 0.01, _axe)
		Endif
		If NetImmerse.HasNode(player, NINODE_SWORD, false)
			AddSlider("$Sword Scale", CATEGORY_BODY, "ChangeSwordScale", 0.1, 3.00, 0.01, _sword)
		Endif
		If NetImmerse.HasNode(player, NINODE_MACE, false)
			AddSlider("$Mace Scale", CATEGORY_BODY, "ChangeMaceScale", 0.1, 3.00, 0.01, _mace)
		Endif
		If NetImmerse.HasNode(player, NINODE_SHIELD, false)
			AddSlider("$Shield Scale", CATEGORY_BODY, "ChangeShieldScale", 0.1, 3.00, 0.01, _shield)
		Endif
		If NetImmerse.HasNode(player, NINODE_WEAPON_BACK, false)
			AddSlider("$Weapon Back Scale", CATEGORY_BODY, "ChangeWeaponBackScale", 0.1, 3.00, 0.01, _weaponBack)
		Endif
		If NetImmerse.HasNode(player, NINODE_WEAPON, false)
			AddSlider("$Weapon Scale", CATEGORY_BODY, "ChangeWeaponScale", 0.1, 3.00, 0.01, _weapon)
		Endif
	Endif
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
	Elseif callback == "ChangeLeftBreastCurve"
		_leftBreastF = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BREAST_FORWARD, _leftBreastF, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BREAST_FORWARD, _leftBreastF, true)
	Elseif callback == "ChangeRightBreastCurve"
		_rightBreastF = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BREAST_FORWARD, _rightBreastF, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BREAST_FORWARD, _rightBreastF, true)
	Elseif callback == "ChangeLeftButt"
		_leftButt = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BUTT, _leftButt, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BUTT, _leftButt, true)
	Elseif callback == "ChangeRightButt"
		_rightButt = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BUTT, _rightButt, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BUTT, _rightButt, true)
	Elseif callback == "ChangeLeftBiceps"
		_leftBicep = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BICEP, _leftBicep, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BICEP, _leftBicep, true)
	Elseif callback == "ChangeRightBiceps"
		_rightBicep = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BICEP, _rightBicep, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BICEP, _rightBicep, true)
	Elseif callback == "ChangeLeftBiceps2"
		_leftBicep2 = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BICEP_2, _leftBicep2, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_LEFT_BICEP_2, _leftBicep2, true)
	Elseif callback == "ChangeRightBiceps2"
		_rightBicep2 = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BICEP_2, _rightBicep2, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_RIGHT_BICEP_2, _rightBicep2, true)
	Elseif callback == "ChangeQuiverScale"
		_quiver = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_QUIVER, _quiver, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_QUIVER, _quiver, true)
	Elseif callback == "ChangeBowScale"
		_bow = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_BOW, _bow, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_BOW, _bow, true)
	Elseif callback == "ChangeAxeScale"
		_axe = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_AXE, _axe, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_AXE, _axe, true)
	Elseif callback == "ChangeSwordScale"
		_sword = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_SWORD, _sword, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_SWORD, _sword, true)
	Elseif callback == "ChangeMaceScale"
		_mace = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_MACE, _mace, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_MACE, _mace, true)
	Elseif callback == "ChangeShieldScale"
		_shield = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_SHIELD, _shield, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_SHIELD, _shield, true)
	Elseif callback == "ChangeWeaponBackScale"
		_weaponBack = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_WEAPON_BACK, _weaponBack, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_WEAPON_BACK, _weaponBack, true)
		SetSliderParameters("ChangeWeaponScale", 0.1, 3.0, 0.01, _weaponBack / 3)
	Elseif callback == "ChangeWeaponScale"
		_weapon = value
		NetImmerse.SetNodeScale(_playerActor, NINODE_WEAPON, _weapon, false)
		NetImmerse.SetNodeScale(_playerActor, NINODE_WEAPON, _weapon, true)
	Endif
EndEvent