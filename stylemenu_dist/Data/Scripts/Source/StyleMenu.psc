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

Function OnHeadPartRequest(int mode, Actor targetActor, ActorBase targetActorBase, Race targetRace, bool isFemale)
	If !isFemale
		AddHeadPart("HairMaleRedguard1", "HairMaleRedguard1", "", 100, true, targetRace)
		AddHeadPart("HairMaleRedguard2", "HairMaleRedguard2", "", 100, true, targetRace)
		AddHeadPart("HairMaleRedguard3", "HairMaleRedguard3", "", 100, true, targetRace)
		AddHeadPart("HairMaleRedguard4", "HairMaleRedguard4", "", 100, true, targetRace)
		AddHeadPart("HairMaleRedguard5", "HairMaleRedguard5", "", 100, true, targetRace)
		AddHeadPart("HairMaleRedguard6", "HairMaleRedguard6", "", 100, true, targetRace)
		AddHeadPart("HairMaleRedguard7", "HairMaleRedguard7", "", 100, true, targetRace)
		AddHeadPart("HairMaleRedguard8", "HairMaleRedguard8", "", 100, true, targetRace)
		;AddHeadPart("HairMaleRedguard9", "HairMaleRedguard9", "", 100)
		AddHeadPart("HairMaleNord01", "HairMaleNord01", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord02", "HairMaleNord02", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord03", "HairMaleNord03", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord04", "HairMaleNord04", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord05", "HairMaleNord05", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord06", "HairMaleNord06", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord07", "HairMaleNord07", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord08", "HairMaleNord08", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord09", "HairMaleNord09", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord10", "HairMaleNord10", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord11", "HairMaleNord11", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord12", "HairMaleNord12", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord13", "HairMaleNord13", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord14", "HairMaleNord14", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord15", "HairMaleNord15", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord16", "HairMaleNord16", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord17", "HairMaleNord17", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord18", "HairMaleNord18", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord19", "HairMaleNord19", "", 100, true, targetRace)
		AddHeadPart("HairMaleNord20", "HairMaleNord20", "", 100, true, targetRace)
		AddHeadPart("HairMaleElf01", "HairMaleElf01", "", 100, true, targetRace)
		AddHeadPart("HairMaleElf02", "HairMaleElf02", "", 100, true, targetRace)
		AddHeadPart("HairMaleElf03", "HairMaleElf03", "", 100, true, targetRace)
		AddHeadPart("HairMaleElf04", "HairMaleElf04", "", 100, true, targetRace)
		AddHeadPart("HairMaleElf05", "HairMaleElf05", "", 100, true, targetRace)
		AddHeadPart("HairMaleElf06", "HairMaleElf06", "", 100, true, targetRace)
		AddHeadPart("HairMaleElf07", "HairMaleElf07", "", 100, true, targetRace)
		AddHeadPart("HairMaleElf08", "HairMaleElf08", "", 100, true, targetRace)
		AddHeadPart("HairMaleElf09", "HairMaleElf09", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc01", "HairMaleOrc01", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc02", "HairMaleOrc02", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc03", "HairMaleOrc03", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc04", "HairMaleOrc04", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc05", "HairMaleOrc05", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc06", "HairMaleOrc06", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc07", "HairMaleOrc07", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc08", "HairMaleOrc08", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc09", "HairMaleOrc09", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc10", "HairMaleOrc10", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc11", "HairMaleOrc11", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc12", "HairMaleOrc12", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc13", "HairMaleOrc13", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc14", "HairMaleOrc14", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc15", "HairMaleOrc15", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc16", "HairMaleOrc16", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc17", "HairMaleOrc17", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc18", "HairMaleOrc18", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc19", "HairMaleOrc19", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc20", "HairMaleOrc20", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc21", "HairMaleOrc21", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc22", "HairMaleOrc22", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc23", "HairMaleOrc23", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc24", "HairMaleOrc24", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc25", "HairMaleOrc25", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc26", "HairMaleOrc26", "", 100, true, targetRace)
		AddHeadPart("HairMaleOrc27", "HairMaleOrc27", "", 100, true, targetRace)
		AddHeadPart("HairMaleDarkElf01", "HairMaleDarkElf01", "", 100, true, targetRace)
		AddHeadPart("HairMaleDarkElf02", "HairMaleDarkElf02", "", 100, true, targetRace)
		AddHeadPart("HairMaleDarkElf03", "HairMaleDarkElf03", "", 100, true, targetRace)
		AddHeadPart("HairMaleDarkElf04", "HairMaleDarkElf04", "", 100, true, targetRace)
		AddHeadPart("HairMaleDarkElf05", "HairMaleDarkElf05", "", 100, true, targetRace)
		AddHeadPart("HairMaleDarkElf06", "HairMaleDarkElf06", "", 100, true, targetRace)
		AddHeadPart("HairMaleDarkElf07", "HairMaleDarkElf07", "", 100, true, targetRace)
		AddHeadPart("HairMaleDarkElf08", "HairMaleDarkElf08", "", 100, true, targetRace)
		AddHeadPart("HairMaleDarkElf09", "HairMaleDarkElf09", "", 100, true, targetRace)
		;AddHeadPart("HumanBeard01", "HumanBeard01", "", 100, true, targetRace)
		AddHeadPart("HumanBeard02", "HumanBeard02", "", 100, true, targetRace)
		AddHeadPart("HumanBeard03", "HumanBeard03", "", 100, true, targetRace)
		AddHeadPart("HumanBeard04", "HumanBeard04", "", 100, true, targetRace)
		AddHeadPart("HumanBeard05", "HumanBeard05", "", 100, true, targetRace)
		AddHeadPart("HumanBeard06", "HumanBeard06", "", 100, true, targetRace)
		AddHeadPart("HumanBeard07", "HumanBeard07", "", 100, true, targetRace)
		AddHeadPart("HumanBeard08", "HumanBeard08", "", 100, true, targetRace)
		AddHeadPart("HumanBeard09", "HumanBeard09", "", 100, true, targetRace)
		AddHeadPart("HumanBeard10", "HumanBeard10", "", 100, true, targetRace)
		AddHeadPart("HumanBeard11", "HumanBeard11", "", 100, true, targetRace)
		AddHeadPart("HumanBeard12", "HumanBeard12", "", 100, true, targetRace)
		AddHeadPart("HumanBeard13", "HumanBeard13", "", 100, true, targetRace)
		AddHeadPart("HumanBeard14", "HumanBeard14", "", 100, true, targetRace)
		AddHeadPart("HumanBeard15", "HumanBeard15", "", 100, true, targetRace)
		AddHeadPart("HumanBeard16", "HumanBeard16", "", 100, true, targetRace)
		AddHeadPart("HumanBeard17", "HumanBeard17", "", 100, true, targetRace)
		AddHeadPart("HumanBeard18", "HumanBeard18", "", 100, true, targetRace)
		AddHeadPart("HumanBeard19", "HumanBeard19", "", 100, true, targetRace)
		AddHeadPart("HumanBeard20", "HumanBeard20", "", 100, true, targetRace)
		AddHeadPart("HumanBeard21", "HumanBeard21", "", 100, true, targetRace)
		AddHeadPart("HumanBeard22", "HumanBeard22", "", 100, true, targetRace)
		AddHeadPart("HumanBeard23", "HumanBeard23", "", 100, true, targetRace)
		AddHeadPart("HumanBeard24", "HumanBeard24", "", 100, true, targetRace)
		AddHeadPart("HumanBeard25", "HumanBeard25", "", 100, true, targetRace)
		AddHeadPart("HumanBeard26", "HumanBeard26", "", 100, true, targetRace)
		AddHeadPart("HumanBeard27", "HumanBeard27", "", 100, true, targetRace)
		AddHeadPart("HumanBeard28", "HumanBeard28", "", 100, true, targetRace)
		AddHeadPart("HumanBeard29", "HumanBeard29", "", 100, true, targetRace)
		AddHeadPart("HumanBeard30", "HumanBeard30", "", 100, true, targetRace)
		AddHeadPart("HumanBeard31", "HumanBeard31", "", 100, true, targetRace)
		AddHeadPart("HumanBeard32", "HumanBeard32", "", 100, true, targetRace)
		AddHeadPart("HumanBeard33", "HumanBeard33", "", 100, true, targetRace)
		AddHeadPart("HumanBeard34", "HumanBeard34", "", 100, true, targetRace)
		AddHeadPart("HumanBeard35", "HumanBeard35", "", 100, true, targetRace)
		AddHeadPart("HumanBeard36", "HumanBeard36", "", 100, true, targetRace)
		AddHeadPart("HumanBeard37", "HumanBeard37", "", 100, true, targetRace)
		AddHeadPart("HumanBeard38", "HumanBeard38", "", 100, true, targetRace)
		AddHeadPart("HumanBeard39", "HumanBeard39", "", 100, true, targetRace)
		AddHeadPart("HumanBeard40", "HumanBeard40", "", 100, true, targetRace)
		AddHeadPart("HumanBeard41", "HumanBeard41", "", 100, true, targetRace)
		AddHeadPart("HumanBeard42", "HumanBeard42", "", 100, true, targetRace)
		AddHeadPart("HumanBeard43", "HumanBeard43", "", 100, true, targetRace)
		AddHeadPart("HumanBeard44", "HumanBeard44", "", 100, true, targetRace)
		AddHeadPart("HumanBeard45", "HumanBeard45", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale01", "HairArgonianMale01", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale02", "HairArgonianMale02", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale03", "HairArgonianMale03", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale04", "HairArgonianMale04", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale05", "HairArgonianMale05", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale06", "HairArgonianMale06", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale07", "HairArgonianMale07", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale08", "HairArgonianMale08", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale09", "HairArgonianMale09", "", 100, true, targetRace)
		AddHeadPart("HairArgonianMale10", "HairArgonianMale10", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitMale01", "HairKhajiitMale01", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitMale02", "HairKhajiitMale02", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitMale03", "HairKhajiitMale03", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitMale04", "HairKhajiitMale04", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitMale05", "HairKhajiitMale05", "", 100, true, targetRace)
	Else
		;AddHeadPart("Ha, true, targetRaceirFemaleRedguard1", "HairFemaleRedguard1", "", 100)
		;AddHeadPart("HairFemaleRedguard2", "HairFemaleRedguard2", "", 100, true, targetRace)
		;AddHeadPart("HairFemaleRedguard3", "HairFemaleRedguard3", "", 100, true, targetRace)
		AddHeadPart("HairFemaleNord01", "HairFemaleNord01", "stylemenu/thumbnails/hair/female/01.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord02", "HairFemaleNord02", "stylemenu/thumbnails/hair/female/02.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord03", "HairFemaleNord03", "stylemenu/thumbnails/hair/female/03.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord04", "HairFemaleNord04", "stylemenu/thumbnails/hair/female/04.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord05", "HairFemaleNord05", "stylemenu/thumbnails/hair/female/05.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord06", "HairFemaleNord06", "stylemenu/thumbnails/hair/female/06.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord07", "HairFemaleNord07", "stylemenu/thumbnails/hair/female/07.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord08", "HairFemaleNord08", "stylemenu/thumbnails/hair/female/08.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord09", "HairFemaleNord09", "stylemenu/thumbnails/hair/female/09.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord10", "HairFemaleNord10", "stylemenu/thumbnails/hair/female/10.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord11", "HairFemaleNord11", "stylemenu/thumbnails/hair/female/11.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord12", "HairFemaleNord12", "stylemenu/thumbnails/hair/female/12.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord13", "HairFemaleNord13", "stylemenu/thumbnails/hair/female/13.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord14", "HairFemaleNord14", "stylemenu/thumbnails/hair/female/14.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord15", "HairFemaleNord15", "stylemenu/thumbnails/hair/female/15.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord16", "HairFemaleNord16", "stylemenu/thumbnails/hair/female/16.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord17", "HairFemaleNord17", "stylemenu/thumbnails/hair/female/17.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord18", "HairFemaleNord18", "stylemenu/thumbnails/hair/female/18.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord19", "HairFemaleNord19", "stylemenu/thumbnails/hair/female/19.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleNord20", "HairFemaleNord20", "stylemenu/thumbnails/hair/female/20.dds", 100, true, targetRace)
		AddHeadPart("HairFemaleElf01", "HairFemaleElf01", "", 100, true, targetRace)
		AddHeadPart("HairFemaleElf02", "HairFemaleElf02", "", 100, true, targetRace)
		AddHeadPart("HairFemaleElf03", "HairFemaleElf03", "", 100, true, targetRace)
		AddHeadPart("HairFemaleElf04", "HairFemaleElf04", "", 100, true, targetRace)
		AddHeadPart("HairFemaleElf05", "HairFemaleElf05", "", 100, true, targetRace)
		AddHeadPart("HairFemaleElf06", "HairFemaleElf06", "", 100, true, targetRace)
		AddHeadPart("HairFemaleElf07", "HairFemaleElf07", "", 100, true, targetRace)
		AddHeadPart("HairFemaleElf08", "HairFemaleElf08", "", 100, true, targetRace)
		AddHeadPart("HairFemaleElf09", "HairFemaleElf09", "", 100, true, targetRace)
		AddHeadPart("HairFemaleElf10", "HairFemaleElf10", "", 100, true, targetRace)
		AddHeadPart("HairFemaleDarkElf01", "HairFemaleDarkElf01", "", 100, true, targetRace)
		AddHeadPart("HairFemaleDarkElf02", "HairFemaleDarkElf02", "", 100, true, targetRace)
		AddHeadPart("HairFemaleDarkElf03", "HairFemaleDarkElf03", "", 100, true, targetRace)
		AddHeadPart("HairFemaleDarkElf04", "HairFemaleDarkElf04", "", 100, true, targetRace)
		AddHeadPart("HairFemaleDarkElf05", "HairFemaleDarkElf05", "", 100, true, targetRace)
		AddHeadPart("HairFemaleDarkElf06", "HairFemaleDarkElf06", "", 100, true, targetRace)
		AddHeadPart("HairFemaleDarkElf07", "HairFemaleDarkElf07", "", 100, true, targetRace)
		AddHeadPart("HairFemaleDarkElf08", "HairFemaleDarkElf08", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc01", "HairFemaleOrc01", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc02", "HairFemaleOrc02", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc03", "HairFemaleOrc03", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc04", "HairFemaleOrc04", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc05", "HairFemaleOrc05", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc06", "HairFemaleOrc06", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc07", "HairFemaleOrc07", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc08", "HairFemaleOrc08", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc09", "HairFemaleOrc09", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc10", "HairFemaleOrc10", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc11", "HairFemaleOrc11", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc12", "HairFemaleOrc12", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc13", "HairFemaleOrc13", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc14", "HairFemaleOrc14", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc15", "HairFemaleOrc15", "", 100, true, targetRace)
		;AddHeadPart("HairFemaleOrc16", "HairFemaleOrc16", "", 100, true, targetRace)
		AddHeadPart("HairFemaleOrc17", "HairFemaleOrc17", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale01", "HairArgonianFemale01", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale02", "HairArgonianFemale02", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale03", "HairArgonianFemale03", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale04", "HairArgonianFemale04", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale05", "HairArgonianFemale05", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale06", "HairArgonianFemale06", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale07", "HairArgonianFemale07", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale08", "HairArgonianFemale08", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale09", "HairArgonianFemale09", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale10", "HairArgonianFemale10", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale11", "HairArgonianFemale11", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale12", "HairArgonianFemale12", "", 100, true, targetRace)
		AddHeadPart("HairArgonianFemale13", "HairArgonianFemale13", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale01", "HairKhajiitFemale01", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale02", "HairKhajiitFemale02", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale03", "HairKhajiitFemale03", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale04", "HairKhajiitFemale04", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale05", "HairKhajiitFemale05", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale06", "HairKhajiitFemale06", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale07", "HairKhajiitFemale07", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale08", "HairKhajiitFemale08", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale09", "HairKhajiitFemale09", "", 100, true, targetRace)
		AddHeadPart("HairKhajiitFemale10", "HairKhajiitFemale10", "", 100, true, targetRace)
	Endif
EndFunction

Function InjectCustomMenu(int mode = 0, Actor target = None)
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

	; Send the platform immediately
	UI.SetBool(DIALOGUE_MENU, "_global.platform", Game.UsingGamepad())

	; Send the mode
	UI.SetInt(DIALOGUE_MENU, "_global.menuMode", mode)
		
	; Create empty container clip
	UI.InvokeStringA(DIALOGUE_MENU, "_root.createEmptyMovieClip", args)

	; Inject movieclip
	UI.InvokeString(DIALOGUE_MENU, "_root.StyleMenuContainer.loadMovie", "stylemenu.swf")
EndFunction