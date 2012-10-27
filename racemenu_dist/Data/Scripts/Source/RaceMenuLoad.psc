Scriptname RaceMenuLoad extends ReferenceAlias

Event OnPlayerLoadGame()
	(GetOwningQuest() as RaceMenu).OnGameReload()
EndEvent