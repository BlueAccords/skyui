Scriptname DyeManagerAlias extends ReferenceAlias

Event OnPlayerLoadGame()
	(GetOwningQuest() as DyeManager).OnGameReload()
EndEvent