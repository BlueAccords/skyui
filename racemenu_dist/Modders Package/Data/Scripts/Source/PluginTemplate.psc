Scriptname PluginTemplate extends RaceMenuBase

; Valid Categories
; CATEGORY_BODY = 4
; CATEGORY_HEAD = 8
; CATEGORY_FACE = 16
; CATEGORY_EYES = 32
; CATEGORY_BROW = 64
; CATEGORY_MOUTH = 128
; CATEGORY_HAIR = 256
; CATEGORY_COLOR = 512
; Adding these together will result in your 
; slider appearing in multiple categories

Event OnReloadSettings(Actor player, ActorBase playerBase)
	; Restore and re-apply your values here
	; if they are dynamically added properties
EndEvent

Event On3DLoaded(ObjectReference akRef)
	OnReloadSettings(_playerActor, _playerActorBase)
EndEvent

Event OnCellLoaded(ObjectReference akRef)
EndEvent

; Use this event to Add your warpaints
; AddWarpaint(string name, string texturePath)
Event OnWarpaintRequest()
	;AddWarpaint("My Warpaint", "Actors\\Character\\Character Assets\\TintMasks\\MyWarpaint.dds")
EndEvent

; AddBodyPaint(string name, string texturePath)
Event OnBodyPaintRequest()
	;AddBodyPaint("My Bodypaint", "Actors\\Character\\Character Assets\\Overlays\\MyWarpaint.dds")
EndEvent

; AddHandPaint(string name, string texturePath)
Event OnHandPaintRequest()
	;AddHandPaint("My Handpaint", "Actors\\Character\\Character Assets\\Overlays\\MyWarpaint.dds")
EndEvent

; AddFeetPaint(string name, string texturePath)
Event OnFeetPaintRequest()
	;AddFeetPaint("My Feetpaint", "Actors\\Character\\Character Assets\\Overlays\\MyWarpaint.dds")
EndEvent

; Use this event to add custom categories
Event OnCategoryRequest()
	;AddCategory("my_category_key", "$BODY SCALES")
EndEvent

; Use this event to reset your values to defaults as well as Add your sliders
; AddSlider(string name, int section, string callback, float min, float max, float interval, float position)
Event OnSliderRequest(Actor player, ActorBase playerBase, Race actorRace, bool isFemale)
	; --------- Reset stored values here -----
	; _myValue = 0

	; --------- AddSliders here --------------
	; Give your Slider a very unique callback Name
	; you will use this to determine whether the value 
	; changed, you may also receive other mod callbacks

	; AddSlider("MyValue", CATEGORY_BODY, "ChangeMYMODValue", 0.0, 100.0, 1, _myValue)
	; AddSliderEx("MyValue", "my_category_key", "ChangeMYMODValue", 0.0, 100.0, 1, _myValue)
EndEvent

Event OnSliderChanged(string callback, float value)
	; if callback == "ChangeMYMODValue"
	; 	_myValue = value
	; endif
EndEvent