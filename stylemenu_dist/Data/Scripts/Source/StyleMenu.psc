Scriptname StyleMenu extends StyleMenuBase

Event OnInitialized()
	parent.OnInitialized()

	; Init stuff here
EndEvent

Function OnStartup()
	RegisterForModEvent("SSM_Initialized", "OnMenuInitialized") ; Event sent when the menu initializes enough to load data
	RegisterForModEvent("SSM_ChangeHeadPart", "OnChangeHeadPart")

	If SKSE.GetVersionRelease() < 37
		Debug.Notification("SKSE version mismatch. You are running SKSE Version " + SKSE.GetVersion() + "." + SKSE.GetVersionMinor() + "." + SKSE.GetVersionBeta() + "." + SKSE.GetVersionRelease() + " you require 1.6.9 or greater.")
	Endif
	If SKSE.GetVersionRelease() != SKSE.GetScriptVersionRelease()
		Debug.Notification("SKSE script version mismatch. Please reinstall your SKSE scripts to match your version.")
	Endif
EndFunction

Event OnGameReload()
	OnStartup()
	SendModEvent("SSM_LoadPlugins")
EndEvent

Event OnChangeHeadPart(string eventName, string strArg, float numArg, Form formArg)
	HeadPart newPart = HeadPart.GetHeadPart(strArg)
	If newPart
		_targetActor.ChangeHeadPart(newPart)
	Endif
EndEvent

Function OnHeadPartRequest(Actor targetActor, ActorBase targetActorBase, Race targetRace, bool isFemale)
	If !isFemale
		AddHeadPart("HairMaleRedguard1", "HairMaleRedguard1", "", 100)
		AddHeadPart("HairMaleRedguard2", "HairMaleRedguard2", "", 100)
		AddHeadPart("HairMaleRedguard3", "HairMaleRedguard3", "", 100)
		AddHeadPart("HairMaleRedguard4", "HairMaleRedguard4", "", 100)
		AddHeadPart("HairMaleRedguard5", "HairMaleRedguard5", "", 100)
		AddHeadPart("HairMaleRedguard6", "HairMaleRedguard6", "", 100)
		AddHeadPart("HairMaleRedguard7", "HairMaleRedguard7", "", 100)
		AddHeadPart("HairMaleRedguard8", "HairMaleRedguard8", "", 100)
		;AddHeadPart("HairMaleRedguard9", "HairMaleRedguard9", "", 100)
		AddHeadPart("HairMaleNord01", "HairMaleNord01", "", 100)
		AddHeadPart("HairMaleNord02", "HairMaleNord02", "", 100)
		AddHeadPart("HairMaleNord03", "HairMaleNord03", "", 100)
		AddHeadPart("HairMaleNord04", "HairMaleNord04", "", 100)
		AddHeadPart("HairMaleNord05", "HairMaleNord05", "", 100)
		AddHeadPart("HairMaleNord06", "HairMaleNord06", "", 100)
		AddHeadPart("HairMaleNord07", "HairMaleNord07", "", 100)
		AddHeadPart("HairMaleNord08", "HairMaleNord08", "", 100)
		AddHeadPart("HairMaleNord09", "HairMaleNord09", "", 100)
		AddHeadPart("HairMaleNord10", "HairMaleNord10", "", 100)
		AddHeadPart("HairMaleNord11", "HairMaleNord11", "", 100)
		AddHeadPart("HairMaleNord12", "HairMaleNord12", "", 100)
		AddHeadPart("HairMaleNord13", "HairMaleNord13", "", 100)
		AddHeadPart("HairMaleNord14", "HairMaleNord14", "", 100)
		AddHeadPart("HairMaleNord15", "HairMaleNord15", "", 100)
		AddHeadPart("HairMaleNord16", "HairMaleNord16", "", 100)
		AddHeadPart("HairMaleNord17", "HairMaleNord17", "", 100)
		AddHeadPart("HairMaleNord18", "HairMaleNord18", "", 100)
		AddHeadPart("HairMaleNord19", "HairMaleNord19", "", 100)
		AddHeadPart("HairMaleNord20", "HairMaleNord20", "", 100)
		AddHeadPart("HairMaleElf01", "HairMaleElf01", "", 100)
		AddHeadPart("HairMaleElf02", "HairMaleElf02", "", 100)
		AddHeadPart("HairMaleElf03", "HairMaleElf03", "", 100)
		AddHeadPart("HairMaleElf04", "HairMaleElf04", "", 100)
		AddHeadPart("HairMaleElf05", "HairMaleElf05", "", 100)
		AddHeadPart("HairMaleElf06", "HairMaleElf06", "", 100)
		AddHeadPart("HairMaleElf07", "HairMaleElf07", "", 100)
		AddHeadPart("HairMaleElf08", "HairMaleElf08", "", 100)
		AddHeadPart("HairMaleElf09", "HairMaleElf09", "", 100)
		AddHeadPart("HairMaleOrc01", "HairMaleOrc01", "", 100)
		AddHeadPart("HairMaleOrc02", "HairMaleOrc02", "", 100)
		AddHeadPart("HairMaleOrc03", "HairMaleOrc03", "", 100)
		AddHeadPart("HairMaleOrc04", "HairMaleOrc04", "", 100)
		AddHeadPart("HairMaleOrc05", "HairMaleOrc05", "", 100)
		AddHeadPart("HairMaleOrc06", "HairMaleOrc06", "", 100)
		AddHeadPart("HairMaleOrc07", "HairMaleOrc07", "", 100)
		AddHeadPart("HairMaleOrc08", "HairMaleOrc08", "", 100)
		AddHeadPart("HairMaleOrc09", "HairMaleOrc09", "", 100)
		AddHeadPart("HairMaleOrc10", "HairMaleOrc10", "", 100)
		AddHeadPart("HairMaleOrc11", "HairMaleOrc11", "", 100)
		AddHeadPart("HairMaleOrc12", "HairMaleOrc12", "", 100)
		AddHeadPart("HairMaleOrc13", "HairMaleOrc13", "", 100)
		AddHeadPart("HairMaleOrc14", "HairMaleOrc14", "", 100)
		AddHeadPart("HairMaleOrc15", "HairMaleOrc15", "", 100)
		AddHeadPart("HairMaleOrc16", "HairMaleOrc16", "", 100)
		AddHeadPart("HairMaleOrc17", "HairMaleOrc17", "", 100)
		AddHeadPart("HairMaleOrc18", "HairMaleOrc18", "", 100)
		AddHeadPart("HairMaleOrc19", "HairMaleOrc19", "", 100)
		AddHeadPart("HairMaleOrc20", "HairMaleOrc20", "", 100)
		AddHeadPart("HairMaleOrc21", "HairMaleOrc21", "", 100)
		AddHeadPart("HairMaleOrc22", "HairMaleOrc22", "", 100)
		AddHeadPart("HairMaleOrc23", "HairMaleOrc23", "", 100)
		AddHeadPart("HairMaleOrc24", "HairMaleOrc24", "", 100)
		AddHeadPart("HairMaleOrc25", "HairMaleOrc25", "", 100)
		AddHeadPart("HairMaleOrc26", "HairMaleOrc26", "", 100)
		AddHeadPart("HairMaleOrc27", "HairMaleOrc27", "", 100)
		AddHeadPart("HairMaleDarkElf01", "HairMaleDarkElf01", "", 100)
		AddHeadPart("HairMaleDarkElf02", "HairMaleDarkElf02", "", 100)
		AddHeadPart("HairMaleDarkElf03", "HairMaleDarkElf03", "", 100)
		AddHeadPart("HairMaleDarkElf04", "HairMaleDarkElf04", "", 100)
		AddHeadPart("HairMaleDarkElf05", "HairMaleDarkElf05", "", 100)
		AddHeadPart("HairMaleDarkElf06", "HairMaleDarkElf06", "", 100)
		AddHeadPart("HairMaleDarkElf07", "HairMaleDarkElf07", "", 100)
		AddHeadPart("HairMaleDarkElf08", "HairMaleDarkElf08", "", 100)
		AddHeadPart("HairMaleDarkElf09", "HairMaleDarkElf09", "", 100)
		;AddHeadPart("HumanBeard01", "HumanBeard01", "", 100)
		AddHeadPart("HumanBeard02", "HumanBeard02", "", 100)
		AddHeadPart("HumanBeard03", "HumanBeard03", "", 100)
		AddHeadPart("HumanBeard04", "HumanBeard04", "", 100)
		AddHeadPart("HumanBeard05", "HumanBeard05", "", 100)
		AddHeadPart("HumanBeard06", "HumanBeard06", "", 100)
		AddHeadPart("HumanBeard07", "HumanBeard07", "", 100)
		AddHeadPart("HumanBeard08", "HumanBeard08", "", 100)
		AddHeadPart("HumanBeard09", "HumanBeard09", "", 100)
		AddHeadPart("HumanBeard10", "HumanBeard10", "", 100)
		AddHeadPart("HumanBeard11", "HumanBeard11", "", 100)
		AddHeadPart("HumanBeard12", "HumanBeard12", "", 100)
		AddHeadPart("HumanBeard13", "HumanBeard13", "", 100)
		AddHeadPart("HumanBeard14", "HumanBeard14", "", 100)
		AddHeadPart("HumanBeard15", "HumanBeard15", "", 100)
		AddHeadPart("HumanBeard16", "HumanBeard16", "", 100)
		AddHeadPart("HumanBeard17", "HumanBeard17", "", 100)
		AddHeadPart("HumanBeard18", "HumanBeard18", "", 100)
		AddHeadPart("HumanBeard19", "HumanBeard19", "", 100)
		AddHeadPart("HumanBeard20", "HumanBeard20", "", 100)
		AddHeadPart("HumanBeard21", "HumanBeard21", "", 100)
		AddHeadPart("HumanBeard22", "HumanBeard22", "", 100)
		AddHeadPart("HumanBeard23", "HumanBeard23", "", 100)
		AddHeadPart("HumanBeard24", "HumanBeard24", "", 100)
		AddHeadPart("HumanBeard25", "HumanBeard25", "", 100)
		AddHeadPart("HumanBeard26", "HumanBeard26", "", 100)
		AddHeadPart("HumanBeard27", "HumanBeard27", "", 100)
		AddHeadPart("HumanBeard28", "HumanBeard28", "", 100)
		AddHeadPart("HumanBeard29", "HumanBeard29", "", 100)
		AddHeadPart("HumanBeard30", "HumanBeard30", "", 100)
		AddHeadPart("HumanBeard31", "HumanBeard31", "", 100)
		AddHeadPart("HumanBeard32", "HumanBeard32", "", 100)
		AddHeadPart("HumanBeard33", "HumanBeard33", "", 100)
		AddHeadPart("HumanBeard34", "HumanBeard34", "", 100)
		AddHeadPart("HumanBeard35", "HumanBeard35", "", 100)
		AddHeadPart("HumanBeard36", "HumanBeard36", "", 100)
		AddHeadPart("HumanBeard37", "HumanBeard37", "", 100)
		AddHeadPart("HumanBeard38", "HumanBeard38", "", 100)
		AddHeadPart("HumanBeard39", "HumanBeard39", "", 100)
		AddHeadPart("HumanBeard40", "HumanBeard40", "", 100)
		AddHeadPart("HumanBeard41", "HumanBeard41", "", 100)
		AddHeadPart("HumanBeard42", "HumanBeard42", "", 100)
		AddHeadPart("HumanBeard43", "HumanBeard43", "", 100)
		AddHeadPart("HumanBeard44", "HumanBeard44", "", 100)
		AddHeadPart("HumanBeard45", "HumanBeard45", "", 100)
		AddHeadPart("HairArgonianMale01", "HairArgonianMale01", "", 100)
		AddHeadPart("HairArgonianMale02", "HairArgonianMale02", "", 100)
		AddHeadPart("HairArgonianMale03", "HairArgonianMale03", "", 100)
		AddHeadPart("HairArgonianMale04", "HairArgonianMale04", "", 100)
		AddHeadPart("HairArgonianMale05", "HairArgonianMale05", "", 100)
		AddHeadPart("HairArgonianMale06", "HairArgonianMale06", "", 100)
		AddHeadPart("HairArgonianMale07", "HairArgonianMale07", "", 100)
		AddHeadPart("HairArgonianMale08", "HairArgonianMale08", "", 100)
		AddHeadPart("HairArgonianMale09", "HairArgonianMale09", "", 100)
		AddHeadPart("HairArgonianMale10", "HairArgonianMale10", "", 100)
		AddHeadPart("HairKhajiitMale01", "HairKhajiitMale01", "", 100)
		AddHeadPart("HairKhajiitMale02", "HairKhajiitMale02", "", 100)
		AddHeadPart("HairKhajiitMale03", "HairKhajiitMale03", "", 100)
		AddHeadPart("HairKhajiitMale04", "HairKhajiitMale04", "", 100)
		AddHeadPart("HairKhajiitMale05", "HairKhajiitMale05", "", 100)
	Else
		;AddHeadPart("HairFemaleRedguard1", "HairFemaleRedguard1", "", 100)
		;AddHeadPart("HairFemaleRedguard2", "HairFemaleRedguard2", "", 100)
		;AddHeadPart("HairFemaleRedguard3", "HairFemaleRedguard3", "", 100)
		AddHeadPart("HairFemaleNord01", "HairFemaleNord01", "", 100)
		AddHeadPart("HairFemaleNord02", "HairFemaleNord02", "", 100)
		AddHeadPart("HairFemaleNord03", "HairFemaleNord03", "", 100)
		AddHeadPart("HairFemaleNord04", "HairFemaleNord04", "", 100)
		AddHeadPart("HairFemaleNord05", "HairFemaleNord05", "", 100)
		AddHeadPart("HairFemaleNord06", "HairFemaleNord06", "", 100)
		AddHeadPart("HairFemaleNord07", "HairFemaleNord07", "", 100)
		AddHeadPart("HairFemaleNord08", "HairFemaleNord08", "", 100)
		AddHeadPart("HairFemaleNord09", "HairFemaleNord09", "", 100)
		AddHeadPart("HairFemaleNord10", "HairFemaleNord10", "", 100)
		AddHeadPart("HairFemaleNord11", "HairFemaleNord11", "", 100)
		AddHeadPart("HairFemaleNord12", "HairFemaleNord12", "", 100)
		AddHeadPart("HairFemaleNord13", "HairFemaleNord13", "", 100)
		AddHeadPart("HairFemaleNord14", "HairFemaleNord14", "", 100)
		AddHeadPart("HairFemaleNord15", "HairFemaleNord15", "", 100)
		AddHeadPart("HairFemaleNord16", "HairFemaleNord16", "", 100)
		AddHeadPart("HairFemaleNord17", "HairFemaleNord17", "", 100)
		AddHeadPart("HairFemaleNord18", "HairFemaleNord18", "", 100)
		AddHeadPart("HairFemaleNord19", "HairFemaleNord19", "", 100)
		AddHeadPart("HairFemaleNord20", "HairFemaleNord20", "", 100)
		AddHeadPart("HairFemaleElf01", "HairFemaleElf01", "", 100)
		AddHeadPart("HairFemaleElf02", "HairFemaleElf02", "", 100)
		AddHeadPart("HairFemaleElf03", "HairFemaleElf03", "", 100)
		AddHeadPart("HairFemaleElf04", "HairFemaleElf04", "", 100)
		AddHeadPart("HairFemaleElf05", "HairFemaleElf05", "", 100)
		AddHeadPart("HairFemaleElf06", "HairFemaleElf06", "", 100)
		AddHeadPart("HairFemaleElf07", "HairFemaleElf07", "", 100)
		AddHeadPart("HairFemaleElf08", "HairFemaleElf08", "", 100)
		AddHeadPart("HairFemaleElf09", "HairFemaleElf09", "", 100)
		AddHeadPart("HairFemaleElf10", "HairFemaleElf10", "", 100)
		AddHeadPart("HairFemaleDarkElf01", "HairFemaleDarkElf01", "", 100)
		AddHeadPart("HairFemaleDarkElf02", "HairFemaleDarkElf02", "", 100)
		AddHeadPart("HairFemaleDarkElf03", "HairFemaleDarkElf03", "", 100)
		AddHeadPart("HairFemaleDarkElf04", "HairFemaleDarkElf04", "", 100)
		AddHeadPart("HairFemaleDarkElf05", "HairFemaleDarkElf05", "", 100)
		AddHeadPart("HairFemaleDarkElf06", "HairFemaleDarkElf06", "", 100)
		AddHeadPart("HairFemaleDarkElf07", "HairFemaleDarkElf07", "", 100)
		AddHeadPart("HairFemaleDarkElf08", "HairFemaleDarkElf08", "", 100)
		AddHeadPart("HairFemaleOrc01", "HairFemaleOrc01", "", 100)
		AddHeadPart("HairFemaleOrc02", "HairFemaleOrc02", "", 100)
		AddHeadPart("HairFemaleOrc03", "HairFemaleOrc03", "", 100)
		AddHeadPart("HairFemaleOrc04", "HairFemaleOrc04", "", 100)
		AddHeadPart("HairFemaleOrc05", "HairFemaleOrc05", "", 100)
		AddHeadPart("HairFemaleOrc06", "HairFemaleOrc06", "", 100)
		AddHeadPart("HairFemaleOrc07", "HairFemaleOrc07", "", 100)
		AddHeadPart("HairFemaleOrc08", "HairFemaleOrc08", "", 100)
		AddHeadPart("HairFemaleOrc09", "HairFemaleOrc09", "", 100)
		AddHeadPart("HairFemaleOrc10", "HairFemaleOrc10", "", 100)
		AddHeadPart("HairFemaleOrc11", "HairFemaleOrc11", "", 100)
		AddHeadPart("HairFemaleOrc12", "HairFemaleOrc12", "", 100)
		AddHeadPart("HairFemaleOrc13", "HairFemaleOrc13", "", 100)
		AddHeadPart("HairFemaleOrc14", "HairFemaleOrc14", "", 100)
		AddHeadPart("HairFemaleOrc15", "HairFemaleOrc15", "", 100)
		;AddHeadPart("HairFemaleOrc16", "HairFemaleOrc16", "", 100)
		AddHeadPart("HairFemaleOrc17", "HairFemaleOrc17", "", 100)
		AddHeadPart("HairArgonianFemale01", "HairArgonianFemale01", "", 100)
		AddHeadPart("HairArgonianFemale02", "HairArgonianFemale02", "", 100)
		AddHeadPart("HairArgonianFemale03", "HairArgonianFemale03", "", 100)
		AddHeadPart("HairArgonianFemale04", "HairArgonianFemale04", "", 100)
		AddHeadPart("HairArgonianFemale05", "HairArgonianFemale05", "", 100)
		AddHeadPart("HairArgonianFemale06", "HairArgonianFemale06", "", 100)
		AddHeadPart("HairArgonianFemale07", "HairArgonianFemale07", "", 100)
		AddHeadPart("HairArgonianFemale08", "HairArgonianFemale08", "", 100)
		AddHeadPart("HairArgonianFemale09", "HairArgonianFemale09", "", 100)
		AddHeadPart("HairArgonianFemale10", "HairArgonianFemale10", "", 100)
		AddHeadPart("HairArgonianFemale11", "HairArgonianFemale11", "", 100)
		AddHeadPart("HairArgonianFemale12", "HairArgonianFemale12", "", 100)
		AddHeadPart("HairArgonianFemale13", "HairArgonianFemale13", "", 100)
		AddHeadPart("HairKhajiitFemale01", "HairKhajiitFemale01", "", 100)
		AddHeadPart("HairKhajiitFemale02", "HairKhajiitFemale02", "", 100)
		AddHeadPart("HairKhajiitFemale03", "HairKhajiitFemale03", "", 100)
		AddHeadPart("HairKhajiitFemale04", "HairKhajiitFemale04", "", 100)
		AddHeadPart("HairKhajiitFemale05", "HairKhajiitFemale05", "", 100)
		AddHeadPart("HairKhajiitFemale06", "HairKhajiitFemale06", "", 100)
		AddHeadPart("HairKhajiitFemale07", "HairKhajiitFemale07", "", 100)
		AddHeadPart("HairKhajiitFemale08", "HairKhajiitFemale08", "", 100)
		AddHeadPart("HairKhajiitFemale09", "HairKhajiitFemale09", "", 100)
		AddHeadPart("HairKhajiitFemale10", "HairKhajiitFemale10", "", 100)
	Endif
EndFunction

Function InjectCustomMenu(Actor target = None)
	If target
		_targetActor = target
		_targetActorBase = target.GetActorBase()
	Else
		_targetActor = Game.GetPlayer()
		_targetActorBase = _targetActor.GetActorBase()
	Endif

	string[] args = new string[2]
	args[0] = "StyleMenuContainer"
	args[1] = "-1000"
		
	; Create empty container clip
	UI.InvokeStringA(DIALOGUE_MENU, "_root.createEmptyMovieClip", args)

	; Inject movieclip
	UI.InvokeString(DIALOGUE_MENU, "_root.StyleMenuContainer.loadMovie", "stylemenu.swf")

	; Send the platform immediately
	UI.SetBool(DIALOGUE_MENU, "_global.platform", Game.UsingGamepad())
EndFunction