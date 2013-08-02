Scriptname RaceMenuMimic extends ActiveMagicEffect  

Event OnEffectStart(Actor akTarget, Actor akCaster)
	RaceMenu rcMenu = Game.GetFormFromFile(0x800, "RaceMenu.esp") as RaceMenu
	ActorBase casterBase = akCaster.GetActorBase()
	ActorBase targetBase = akTarget.GetActorBase()
	If rcMenu && casterBase && targetBase
		int totalPresets = rcMenu.MAX_PRESETS
		int i = 0
		While i < totalPresets
			casterBase.SetFacePreset(targetBase.GetFacePreset(i), i)
			i += 1
		EndWhile

		int totalMorphs = rcMenu.MAX_MORPHS
		i = 0
		While i < totalMorphs
			casterBase.SetFaceMorph(targetBase.GetFaceMorph(i), i)
			i += 1
		EndWhile

		HeadPart eyes = None
		HeadPart hair = None
		HeadPart facialHair = None
		HeadPart scar = None
		HeadPart brows = None

		int totalHeadParts = targetBase.GetNumHeadParts()
		i = 0
		While i < totalHeadParts
			HeadPart current = targetBase.GetNthHeadPart(i)
			If current.GetType() == 2 ; Eyes
				eyes = current
			Elseif current.GetType() == 3 ; Hair
				hair = current
			Elseif current.GetType() == 4 ; FacialHair
				facialHair = current
			Elseif current.GetType() == 5 ; Scar
				scar = current
			Elseif current.GetType() == 6 ; Brows
				brows = current
			Endif
			i += 1
		EndWhile

		casterBase.SetHairColor(targetBase.GetHairColor())
		rcMenu.SaveHair()

		If eyes
			akCaster.ChangeHeadPart(eyes)
		Endif
		If hair
			akCaster.ChangeHeadPart(hair)
		Endif
		If facialHair
			akCaster.ChangeHeadPart(facialHair)
		Endif
		If scar
			akCaster.ChangeHeadPart(scar)
		Endif
		If brows
			akCaster.ChangeHeadPart(brows)
		Endif

		akCaster.QueueNiNodeUpdate()
	Endif
EndEvent