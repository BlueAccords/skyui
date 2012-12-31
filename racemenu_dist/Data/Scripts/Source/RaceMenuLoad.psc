Scriptname RaceMenuLoad extends ReferenceAlias

Event OnPlayerLoadGame()
	(GetOwningQuest() as RaceMenuBase).OnGameReload()
EndEvent
