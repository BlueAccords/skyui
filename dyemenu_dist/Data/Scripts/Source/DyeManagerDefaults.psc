Scriptname DyeManagerDefaults extends Quest

Event OnInit()
	OnGameReload()
EndEvent

Event OnGameReload()
	; White
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x34cdf, "Skyrim.esm"), 0xFFFFFFFF) ; Salt Pile
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x34cdd, "Skyrim.esm"), 0xFFFFFFFF) ; Bonemeal
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x4da22, "Skyrim.esm"), 0xFFFFFFFF) ; White Cap
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x3f7f8, "Skyrim.esm"), 0xFFFFFFFF) ; Tundra Cotton

	; Black
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x3ad76, "Skyrim.esm"), 0xFF000000) ; Vampire Dust
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x2e500, "Skyrim.esm"), 0xFF000000) ; Black Soul Gem
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x2e504, "Skyrim.esm"), 0xFF000000) ; Black Soul Gem
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x3ad60, "Skyrim.esm"), 0xFF000000) ; Void Salts
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0xf11c0, "Skyrim.esm"), 0xFF000000) ; Dwarven Oil

	; Orange
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0xbb956, "Skyrim.esm"), 0xFFFF7900) ; Orange Dartwing
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x727e0, "Skyrim.esm"), 0xFFFF7900) ; Monarch Butterfly
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x03545, "Skyrim.esm"), 0xFFFF7900) ; Salmon Roe
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x3ad5e, "Skyrim.esm"), 0xFFFF7900) ; Fire Salts
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x64b40, "Skyrim.esm"), 0xFFFF7900) ; Carrot

	; Purple
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x516c8, "Skyrim.esm"), 0xFF7900FF) ; Deathbell
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x6ac4a, "Skyrim.esm"), 0xFF7900FF) ; Jazbay Grapes
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x45c28, "Skyrim.esm"), 0xFF7900FF) ; Lavender
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x134aa, "Skyrim.esm"), 0xFF7900FF) ; Thistle Branch
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x2f44c, "Skyrim.esm"), 0xFF7900FF) ; Nightshade

	; Yellow
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0xb08c5, "Skyrim.esm"), 0xFFFFFF00) ; Honeycomb
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x4da73, "Skyrim.esm"), 0xFFFFFF00) ; Torchbug Thorax
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x02a78, "Dawnguard.esm"), 0xFFFFFF00) ; Yellow Mountain Flower
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x23d77, "Skyrim.esm"), 0xFFFFFF00) ; Chicken Egg
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x4b0ba, "Skyrim.esm"), 0xFFFFFF00) ; Wheat
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x10394d, "Skyrim.esm"), 0xFFFFFF00) ; Honey

	; Green
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x727df, "Skyrim.esm"), 0xFF00FF00) ; Luna Moth Wing
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x7e8c8, "Skyrim.esm"), 0xFF00FF00) ; Rock Warbler Egg
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x64b3f, "Skyrim.esm"), 0xFF00FF00) ; Cabbage
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x34d32, "Skyrim.esm"), 0xFF00FF00) ; Frost Mirriam
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x57f91, "Skyrim.esm"), 0xFF00FF00) ; Hanging Moss

	; Blue
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x727de, "Skyrim.esm"), 0xFF0000FF) ; Blue Dartwing
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0xe4f0c, "Skyrim.esm"), 0xFF0000FF) ; Blue Butterfly Wing
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x77e1c, "Skyrim.esm"), 0xFF0000FF) ; Blue Mountain Flower

	; Red
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x3ad61, "Skyrim.esm"), 0xFFFF0000) ; Briar Heart
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x3ad5b, "Skyrim.esm"), 0xFFFF0000) ; Daedra Heart
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0xb18cd, "Skyrim.esm"), 0xFFFF0000) ; Human Heart
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x1016b3, "Skyrim.esm"), 0xFFFF0000) ; Human Flesh
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x77e1d, "Skyrim.esm"), 0xFFFF0000) ; Red Mountain Flower
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x64b42, "Skyrim.esm"), 0xFFFF0000) ; Tomato

	; Pink
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x67181, "Skyrim.esm"), 0xFFFF00FF) ; Soul Gem Fragment
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x67182, "Skyrim.esm"), 0xFFFF00FF) ; Soul Gem Fragment
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x67183, "Skyrim.esm"), 0xFFFF00FF) ; Soul Gem Fragment
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x67184, "Skyrim.esm"), 0xFFFF00FF) ; Soul Gem Fragment
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x67185, "Skyrim.esm"), 0xFFFF00FF) ; Soul Gem Fragment

	; Cyan
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x3ad56, "Skyrim.esm"), 0xFF00FFFF) ; Chaurus Eggs
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x0b097, "Skyrim.esm"), 0xFF00FFFF) ; Gleamblossom
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x7ee01, "Skyrim.esm"), 0xFF00FFFF) ; Glowing Mushroom
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x3ad73, "Skyrim.esm"), 0xFF00FFFF) ; Glow Dust
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x6bc0e, "Skyrim.esm"), 0xFF00FFFF) ; Wisp Wrappings

	; Rainbow
	NiOverride.RegisterFormDyeColor(Game.GetFormFromFile(0x2e4ff, "Skyrim.esm"), 0x00FFFFFF)
EndEvent
