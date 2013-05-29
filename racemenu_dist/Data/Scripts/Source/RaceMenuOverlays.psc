Scriptname RaceMenuOverlays extends RaceMenuBase

int Property TINT_TYPE_BODYPAINT = 256 AutoReadOnly
int Property TINT_TYPE_HANDPAINT = 257 AutoReadOnly
int Property TINT_TYPE_FEETPAINT = 258 AutoReadOnly

Event OnStartup()
	parent.OnStartup()
	RegisterForModEvent("RSM_OverlayTextureChange", "OnOverlayTextureChange")
	RegisterForModEvent("RSM_OverlayColorChange", "OnOverlayColorChange")
EndEvent

Event OnMenuInitialized(string eventName, string strArg, float numArg, Form formArg)
	parent.OnMenuInitialized(eventName, strArg, numArg, formArg)
	UpdateOverlays()
EndEvent

Event OnMenuReinitialized(string eventName, string strArg, float numArg, Form formArg)
	parent.OnMenuReinitialized(eventName, strArg, numArg, formArg)
	UpdateOverlays()
EndEvent

Function UpdateOverlays()
	If SKSE.GetPluginVersion("NiOverride") >= 1 ; Checks to make sure the NiOverride plugin exists
		int i = 0
		string[] tints = new string[128]
		int totalTints = NiOverride.GetNumBodyOverlays()
		While i < totalTints
			int rgb = NiOverride.GetNodePropertyInt(_playerActor, false, "Body [Ovl" + i + "]", 7, -1)
			float alpha = NiOverride.GetNodePropertyFloat(_playerActor, false, "Body [Ovl" + i + "]", 8, -1)
			string texture = NiOverride.GetNodePropertyString(_playerActor, false, "Body [Ovl" + i + "]", 9, 0)
			int color = Math.LogicalOr(Math.LogicalAnd(rgb, 0xFFFFFF), Math.LeftShift((alpha * 255) as Int, 24))
			tints[i] = TINT_TYPE_BODYPAINT + ";;" + color + ";;" + texture
			i += 1
		EndWhile
		UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddBodyTints", tints)

		i = 0
		tints = new string[128]
		totalTints = NiOverride.GetNumHandOverlays()
		While i < totalTints
			int rgb = NiOverride.GetNodePropertyInt(_playerActor, false, "Hands [Ovl" + i + "]", 7, -1)
			float alpha = NiOverride.GetNodePropertyFloat(_playerActor, false, "Hands [Ovl" + i + "]", 8, -1)
			string texture = NiOverride.GetNodePropertyString(_playerActor, false, "Hands [Ovl" + i + "]", 9, 0)
			int color = Math.LogicalOr(Math.LogicalAnd(rgb, 0xFFFFFF), Math.LeftShift((alpha * 255) as Int, 24))
			tints[i] = TINT_TYPE_HANDPAINT + ";;" + color + ";;" + texture
			i += 1
		EndWhile
		UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddHandTints", tints)

		i = 0
		tints = new string[128]
		totalTints = NiOverride.GetNumFeetOverlays()
		While i < totalTints
			int rgb = NiOverride.GetNodePropertyInt(_playerActor, false, "Feet [Ovl" + i + "]", 7, -1)
			float alpha = NiOverride.GetNodePropertyFloat(_playerActor, false, "Feet [Ovl" + i + "]", 8, -1)
			string texture = NiOverride.GetNodePropertyString(_playerActor, false, "Feet [Ovl" + i + "]", 9, 0)
			int color = Math.LogicalOr(Math.LogicalAnd(rgb, 0xFFFFFF), Math.LeftShift((alpha * 255) as Int, 24))
			tints[i] = TINT_TYPE_FEETPAINT + ";;" + color + ";;" + texture
			i += 1
		EndWhile
		UI.InvokeStringA(RACESEX_MENU, MENU_ROOT + "RSM_AddFeetTints", tints)
	Endif
EndFunction

Event OnOverlayColorChange(string eventName, string strArg, float numArg, Form formArg)
	int color = strArg as int
	int arg = numArg as int
	int type = arg / 1000
	int index = arg - (type * 1000)

	string nodeName = ""
	If type == TINT_TYPE_BODYPAINT
		nodeName += "Body [Ovl"
	Elseif type == TINT_TYPE_HANDPAINT
		nodeName += "Hands [Ovl"
	Elseif type == TINT_TYPE_FEETPAINT
		nodeName += "Feet [Ovl"
	Endif
	nodeName += index + "]"

	bool isFemale = _playerActorBase.GetSex() as bool
	If SKSE.GetPluginVersion("NiOverride") >= 1 ; Checks to make sure the NiOverride plugin exists
		int alpha = Math.RightShift(color, 24)
		NiOverride.AddNodeOverrideInt(_playerActor, isFemale, nodeName, 7, -1, color, true) ; Set the tint color
		NiOverride.AddNodeOverrideFloat(_playerActor, isFemale, nodeName, 8, -1, alpha / 255.0, true) ; Set the alpha
	Endif
EndEvent

Event OnOverlayTextureChange(string eventName, string strArg, float numArg, Form formArg)
	string texture = strArg
	int arg = numArg as int
	int type = arg / 1000
	int index = arg - (type * 1000)

	string nodeName = ""
	If type == TINT_TYPE_BODYPAINT
		nodeName += "Body [Ovl"
	Elseif type == TINT_TYPE_HANDPAINT
		nodeName += "Hands [Ovl"
	Elseif type == TINT_TYPE_FEETPAINT
		nodeName += "Feet [Ovl"
	Endif
	nodeName += index + "]"

	bool isFemale = _playerActorBase.GetSex() as bool
	If SKSE.GetPluginVersion("NiOverride") >= 1
		NiOverride.AddNodeOverrideString(_playerActor, isFemale, nodeName, 9, 0, texture, true) ; Set the tint color
	Endif
EndEvent

Event OnBodyPaintRequest()
	AddBodyPaint("Default", "Actors\\Character\\Overlays\\default.dds")
	AddBodyPaint("Female Tattoo 0", "Actors\\Character\\Overlays\\FemaleBodyTattoo_0.dds")
	AddBodyPaint("Male Tattoo 0", "Actors\\Character\\Overlays\\MaleBodyTattoo_0.dds")
	AddBodyPaint("Male Tattoo 1", "Actors\\Character\\Overlays\\MaleBodyTattoo_1.dds")
	AddBodyPaint("Male Tattoo 2", "Actors\\Character\\Overlays\\MaleBodyTattoo_2.dds")
	AddBodyPaint("Male Tattoo 3", "Actors\\Character\\Overlays\\MaleBodyTattoo_3.dds")
	AddBodyPaint("Male Tattoo 4", "Actors\\Character\\Overlays\\MaleBodyTattoo_4.dds")
	AddBodyPaint("Male Tattoo 5", "Actors\\Character\\Overlays\\MaleBodyTattoo_5.dds")
	AddBodyPaint("Male Tattoo 6", "Actors\\Character\\Overlays\\MaleBodyTattoo_6.dds")
	AddBodyPaint("Male Tattoo 7", "Actors\\Character\\Overlays\\MaleBodyTattoo_7.dds")
EndEvent

Event OnHandPaintRequest()
	AddHandPaint("Default", "Actors\\Character\\Overlays\\default.dds")
	AddHandPaint("Nail Paint 0", "Actors\\Character\\Overlays\\FemaleHands_0.dds")
EndEvent

Event OnFeetPaintRequest()
	AddFeetPaint("Default", "Actors\\Character\\Overlays\\default.dds")
EndEvent