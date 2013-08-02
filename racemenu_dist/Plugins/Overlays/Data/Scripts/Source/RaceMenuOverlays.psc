Scriptname RaceMenuOverlays extends RaceMenuBase

Event OnBodyPaintRequest()
	AddBodyPaint("Male Tattoo 0", "Actors\\Character\\Overlays\\MaleBodyTattoo_0.dds")
	AddBodyPaint("Male Tattoo 1", "Actors\\Character\\Overlays\\MaleBodyTattoo_1.dds")
	AddBodyPaint("Male Tattoo 2", "Actors\\Character\\Overlays\\MaleBodyTattoo_2.dds")
	AddBodyPaint("Male Tattoo 3", "Actors\\Character\\Overlays\\MaleBodyTattoo_3.dds")
	AddBodyPaint("Male Tattoo 4", "Actors\\Character\\Overlays\\MaleBodyTattoo_4.dds")
	AddBodyPaint("Male Tattoo 5", "Actors\\Character\\Overlays\\MaleBodyTattoo_5.dds")
	AddBodyPaint("Male Tattoo 6", "Actors\\Character\\Overlays\\MaleBodyTattoo_6.dds")
	AddBodyPaint("Male Tattoo 7", "Actors\\Character\\Overlays\\MaleBodyTattoo_7.dds")

	AddBodyPaint("Female Tattoo 0", "Actors\\Character\\Overlays\\FemaleBodyTattoo_0.dds")

	AddBodyPaint("Female Belly Button 0", "Actors\\Character\\Overlays\\FemaleBodyTattoo_0BB.dds")
	AddBodyPaint("Female Belly Button 1", "Actors\\Character\\Overlays\\FemaleBodyTattoo_1BB.dds")
	AddBodyPaint("Female Belly Button 2", "Actors\\Character\\Overlays\\FemaleBodyTattoo_2BB.dds")

	AddBodyPaint("Female Chest 0", "Actors\\Character\\Overlays\\FemaleBodyTattoo_0Chest.dds")
	AddBodyPaint("Female Chest 1", "Actors\\Character\\Overlays\\FemaleBodyTattoo_1Chest.dds")
	AddBodyPaint("Female Chest 2", "Actors\\Character\\Overlays\\FemaleBodyTattoo_2Chest.dds")

	AddBodyPaint("Female Lower Back 0", "Actors\\Character\\Overlays\\FemaleBodyTattoo_0LBack.dds")
	AddBodyPaint("Female Lower Back 1", "Actors\\Character\\Overlays\\FemaleBodyTattoo_1LBack.dds")
	AddBodyPaint("Female Lower Back 2", "Actors\\Character\\Overlays\\FemaleBodyTattoo_2LBack.dds")

	AddBodyPaint("Female Upper Back 0", "Actors\\Character\\Overlays\\FemaleBodyTattoo_0UpperBack.dds")
	AddBodyPaint("Female Upper Back 1", "Actors\\Character\\Overlays\\FemaleBodyTattoo_1UpperBack.dds")
	AddBodyPaint("Female Upper Back 2", "Actors\\Character\\Overlays\\FemaleBodyTattoo_2UpperBack.dds")
EndEvent

Event OnHandPaintRequest()
	AddHandPaint("Nail Paint 0", "Actors\\Character\\Overlays\\FemaleHands_0.dds")
EndEvent

Event OnFeetPaintRequest()
	; None yet
EndEvent