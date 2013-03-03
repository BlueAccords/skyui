Scriptname StyleMenuLoad extends ReferenceAlias

Event OnPlayerLoadGame()
	(GetOwningQuest() as StyleMenuBase).OnGameReload()
EndEvent