Scriptname CharGen Hidden

int Function GetScriptVersion() global
	return 1
EndFunction

; Saves a character's appearances to a preset file as well as a tint mask DDS
Function SaveCharacter(string characterName) native global

; Loads a character's appearance preset file onto an Actor
bool Function LoadCharacter(Actor akDestination, Race akRace, string characterName) native global

; Deletes the slot,dds,nif
Function DeleteCharacter(string characterName) native global

; Unmaps the presets to their corresponding NPC
Function ClearPreset(ActorBase npc) native global
Function ClearPresets() native global

; External Mode
; Saves the characters slot, nif, and dds
Function SaveExternalCharacter(string characterName) native global

; Same as LoadCharacter, except it does not internally map the preset, meant to be paired with S.E.C
bool Function LoadExternalCharacter(Actor akDestination, Race akRace, string characterName) native global

; Determines whether loading external heads is enabled in the ini setting
bool Function IsExternalEnabled() native global

; Exports the player's head mesh and tint mask DDS relative to Data\SKSE\Plugins\CharGen\
Function ExportHead(string fileName) native global