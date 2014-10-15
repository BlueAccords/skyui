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

; If you are making your own scaling mod, use your own key name
string Property MOD_OVERRIDE_KEY = "RSMPlugin" AutoReadOnly

; NiOverride version data
int Property NIOVERRIDE_VERSION = 3 AutoReadOnly
int Property NIOVERRIDE_SCRIPT_VERSION = 2 AutoReadOnly

bool _versionValid = false

; Add Custom Warpaint here
Event OnWarpaintRequest()
	AddWarpaint("$Beauty Mark 01", "Actors\\Character\\Character Assets\\TintMasks\\BeautyMark_01.dds")
	AddWarpaint("$Beauty Mark 02", "Actors\\Character\\Character Assets\\TintMasks\\BeautyMark_02.dds")
	AddWarpaint("$Beauty Mark 03", "Actors\\Character\\Character Assets\\TintMasks\\BeautyMark_03.dds")
	AddWarpaint("$Dragon Tattoo 01", "Actors\\Character\\Character Assets\\TintMasks\\DragonTattoo_01.dds")
EndEvent

Event OnStartup()
	parent.OnStartup()

	int nioverrideVersion = SKSE.GetPluginVersion("NiOverride")
	int nioverrideScriptVersion = NiOverride.GetScriptVersion()

	; Check NiOverride version, disable most features if this fails
	if nioverrideVersion >= NIOVERRIDE_VERSION && nioverrideScriptVersion >= NIOVERRIDE_SCRIPT_VERSION
		_versionValid = true
	Else
		_versionValid = false
	Endif
EndEvent

Event OnResetMenu(Actor target, ActorBase targetBase)
	bool isFemale = targetBase.GetSex() as bool
	If _versionValid ; Delete all the previous scales
		RemoveNodeTransforms(target, isFemale, NINODE_NPC)
		RemoveNodeTransforms(target, isFemale, NINODE_HEAD)
		RemoveNodeTransforms(target, isFemale, NINODE_LEFT_BREAST)
		RemoveNodeTransforms(target, isFemale, NINODE_RIGHT_BREAST)
		RemoveNodeTransforms(target, isFemale, NINODE_LEFT_BREAST_FORWARD)
		RemoveNodeTransforms(target, isFemale, NINODE_RIGHT_BREAST_FORWARD)
		RemoveNodeTransforms(target, isFemale, NINODE_LEFT_BUTT)
		RemoveNodeTransforms(target, isFemale, NINODE_RIGHT_BUTT)
		RemoveNodeTransforms(target, isFemale, NINODE_LEFT_BICEP)
		RemoveNodeTransforms(target, isFemale, NINODE_RIGHT_BICEP)
		RemoveNodeTransforms(target, isFemale, NINODE_LEFT_BICEP_2)
		RemoveNodeTransforms(target, isFemale, NINODE_RIGHT_BICEP_2)
		RemoveNodeTransforms(target, isFemale, NINODE_QUIVER)
		RemoveNodeTransforms(target, isFemale, NINODE_BOW)
		RemoveNodeTransforms(target, isFemale, NINODE_AXE)
		RemoveNodeTransforms(target, isFemale, NINODE_SWORD)
		RemoveNodeTransforms(target, isFemale, NINODE_MACE)
		RemoveNodeTransforms(target, isFemale, NINODE_SHIELD)
		RemoveNodeTransforms(target, isFemale, NINODE_WEAPON_BACK)
		RemoveNodeTransforms(target, isFemale, NINODE_WEAPON)
	Endif
EndEvent

; Add Custom sliders here
Event OnSliderRequest(Actor target, ActorBase targetBase, Race actorRace, bool isFemale)
	If HEIGHT_ENABLED
		AddSlider("$Height", CATEGORY_BODY, "ChangeHeight", 0.25, 2.00, 0.01, GetNodeScale(target, isFemale, NINODE_NPC))
	Endif

	If NetImmerse.HasNode(target, NINODE_HEAD, false)
		AddSlider("$Head", CATEGORY_BODY, "ChangeHeadSize", 0.01, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_HEAD))
	Endif

	If isFemale == true		
		If NetImmerse.HasNode(target, NINODE_LEFT_BREAST, false)
			AddSlider("$Left Breast", CATEGORY_BODY, "ChangeLeftBreast", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_LEFT_BREAST))
		Endif
		If NetImmerse.HasNode(target, NINODE_RIGHT_BREAST, false)
			AddSlider("$Right Breast", CATEGORY_BODY, "ChangeRightBreast", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_RIGHT_BREAST))
		Endif
		If NetImmerse.HasNode(target, NINODE_LEFT_BREAST_FORWARD, false)
			AddSlider("$Left Breast Curve", CATEGORY_BODY, "ChangeLeftBreastCurve", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_LEFT_BREAST_FORWARD))
		Endif
		If NetImmerse.HasNode(target, NINODE_RIGHT_BREAST_FORWARD, false)
			AddSlider("$Right Breast Curve", CATEGORY_BODY, "ChangeRightBreastCurve", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_RIGHT_BREAST_FORWARD))
		Endif
		If NetImmerse.HasNode(target, NINODE_LEFT_BUTT, false)
			AddSlider("$Left Glute", CATEGORY_BODY, "ChangeLeftButt", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_LEFT_BUTT))
		Endif
		If NetImmerse.HasNode(target, NINODE_RIGHT_BUTT, false)
			AddSlider("$Right Glute", CATEGORY_BODY, "ChangeRightButt", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_RIGHT_BUTT))
		Endif
	Endif

	AddSlider("$Left Biceps", CATEGORY_BODY, "ChangeLeftBiceps", 0.1, 2.00, 0.01, GetNodeScale(target, isFemale, NINODE_LEFT_BICEP))
	AddSlider("$Right Biceps", CATEGORY_BODY, "ChangeRightBiceps", 0.1, 2.00, 0.01, GetNodeScale(target, isFemale, NINODE_RIGHT_BICEP))

	AddSlider("$Left Biceps 2", CATEGORY_BODY, "ChangeLeftBiceps2", 0.1, 2.00, 0.01, GetNodeScale(target, isFemale, NINODE_LEFT_BICEP_2))
	AddSlider("$Right Biceps 2", CATEGORY_BODY, "ChangeRightBiceps2", 0.1, 2.00, 0.01, GetNodeScale(target, isFemale, NINODE_RIGHT_BICEP_2))

	If WEAPONS_ENABLED
		If NetImmerse.HasNode(target, NINODE_QUIVER, false)
			AddSlider("$Quiver Scale", CATEGORY_BODY, "ChangeQuiverScale", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_QUIVER))
		Endif
		If NetImmerse.HasNode(target, NINODE_BOW, false)
			AddSlider("$Bow Scale", CATEGORY_BODY, "ChangeBowScale", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_BOW))
		Endif
		If NetImmerse.HasNode(target, NINODE_AXE, false)
			AddSlider("$Axe Scale", CATEGORY_BODY, "ChangeAxeScale", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_AXE))
		Endif
		If NetImmerse.HasNode(target, NINODE_SWORD, false)
			AddSlider("$Sword Scale", CATEGORY_BODY, "ChangeSwordScale", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_SWORD))
		Endif
		If NetImmerse.HasNode(target, NINODE_MACE, false)
			AddSlider("$Mace Scale", CATEGORY_BODY, "ChangeMaceScale", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_MACE))
		Endif
		If NetImmerse.HasNode(target, NINODE_SHIELD, false)
			AddSlider("$Shield Scale", CATEGORY_BODY, "ChangeShieldScale", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_SHIELD))
		Endif
		If NetImmerse.HasNode(target, NINODE_WEAPON_BACK, false)
			AddSlider("$Weapon Back Scale", CATEGORY_BODY, "ChangeWeaponBackScale", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_WEAPON_BACK))
		Endif
		If NetImmerse.HasNode(target, NINODE_WEAPON, false)
			AddSlider("$Weapon Scale", CATEGORY_BODY, "ChangeWeaponScale", 0.1, 3.00, 0.01, GetNodeScale(target, isFemale, NINODE_WEAPON))
		Endif
	Endif
EndEvent

Event OnSliderChanged(string callback, float value)
	bool isFemale = _targetActorBase.GetSex() as bool
	If _versionValid
		If callback == "ChangeHeight"
			SetNodeScale(_targetActor, isFemale, NINODE_NPC, value)
		ElseIf callback == "ChangeHeadSize"
			SetNodeScale(_targetActor, isFemale, NINODE_HEAD, value)
		Elseif callback == "ChangeLeftBreast"
			SetNodeScale(_targetActor, isFemale, NINODE_LEFT_BREAST, value)
		Elseif callback == "ChangeRightBreast"
			SetNodeScale(_targetActor, isFemale, NINODE_RIGHT_BREAST, value)
		Elseif callback == "ChangeLeftBreastCurve"
			SetNodeScale(_targetActor, isFemale, NINODE_LEFT_BREAST_FORWARD, value)
		Elseif callback == "ChangeRightBreastCurve"
			SetNodeScale(_targetActor, isFemale, NINODE_RIGHT_BREAST_FORWARD, value)
		Elseif callback == "ChangeLeftButt"
			SetNodeScale(_targetActor, isFemale, NINODE_LEFT_BUTT, value)
		Elseif callback == "ChangeRightButt"
			SetNodeScale(_targetActor, isFemale, NINODE_RIGHT_BUTT, value)
		Elseif callback == "ChangeLeftBiceps"
			SetNodeScale(_targetActor, isFemale, NINODE_LEFT_BICEP, value)
		Elseif callback == "ChangeRightBiceps"
			SetNodeScale(_targetActor, isFemale, NINODE_RIGHT_BICEP, value)
		Elseif callback == "ChangeLeftBiceps2"
			SetNodeScale(_targetActor, isFemale, NINODE_LEFT_BICEP_2, value)
		Elseif callback == "ChangeRightBiceps2"
			SetNodeScale(_targetActor, isFemale, NINODE_RIGHT_BICEP_2, value)
		Elseif callback == "ChangeQuiverScale"
			SetNodeScale(_targetActor, isFemale, NINODE_QUIVER, value)
		Elseif callback == "ChangeBowScale"
			SetNodeScale(_targetActor, isFemale, NINODE_BOW, value)
		Elseif callback == "ChangeAxeScale"
			SetNodeScale(_targetActor, isFemale, NINODE_AXE, value)
		Elseif callback == "ChangeSwordScale"
			SetNodeScale(_targetActor, isFemale, NINODE_SWORD, value)
		Elseif callback == "ChangeMaceScale"
			SetNodeScale(_targetActor, isFemale, NINODE_MACE, value)
		Elseif callback == "ChangeShieldScale"
			SetNodeScale(_targetActor, isFemale, NINODE_SHIELD, value)
		Elseif callback == "ChangeWeaponBackScale"
			SetNodeScale(_targetActor, isFemale, NINODE_WEAPON_BACK, value)
		Elseif callback == "ChangeWeaponScale"
			SetNodeScale(_targetActor, isFemale, NINODE_WEAPON, value)
		Endif
	Endif
EndEvent

Function RemoveNodeTransforms(Actor akActor, bool isFemale, string nodeName)
	NiOverride.RemoveNodeTransformScale(akActor, false, isFemale, nodeName, MOD_OVERRIDE_KEY)
	NiOverride.RemoveNodeTransformScale(akActor, true, isFemale, nodeName, MOD_OVERRIDE_KEY)
	NiOverride.UpdateNodeTransform(akActor, false, isFemale, nodeName)
	NiOverride.UpdateNodeTransform(akActor, true, isFemale, nodeName)
EndFunction

Function SetNodeScale(Actor akActor, bool isFemale, string nodeName, float value)
	If value != 1.0
		NiOverride.AddNodeTransformScale(akActor, false, isFemale, nodeName, MOD_OVERRIDE_KEY, value)
		NiOverride.AddNodeTransformScale(akActor, true, isFemale, nodeName, MOD_OVERRIDE_KEY, value)
	Else
		NiOverride.RemoveNodeTransformScale(akActor, false, isFemale, nodeName, MOD_OVERRIDE_KEY)
		NiOverride.RemoveNodeTransformScale(akActor, true, isFemale, nodeName, MOD_OVERRIDE_KEY)
	Endif
	NiOverride.UpdateNodeTransform(akActor, false, isFemale, nodeName)
	NiOverride.UpdateNodeTransform(akActor, true, isFemale, nodeName)
EndFunction

float Function GetNodeScale(Actor akActor, bool isFemale, string nodeName)
	return NiOverride.GetNodeTransformScale(akActor, false, isFemale, nodeName, MOD_OVERRIDE_KEY)
EndFunction