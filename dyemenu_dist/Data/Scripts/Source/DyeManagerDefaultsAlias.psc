Scriptname DyeManagerDefaultsAlias extends ReferenceAlias

Event OnPlayerLoadGame()
	(GetOwningQuest() as DyeManagerDefaults).OnGameReload()
EndEvent