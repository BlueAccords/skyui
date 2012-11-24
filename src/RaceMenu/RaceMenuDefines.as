﻿class RaceMenuDefines
{
	static var ENTRY_TYPE_CAT: Number = 0;
	static var ENTRY_TYPE_RACE: Number = 1;
	static var ENTRY_TYPE_SLIDER: Number = 2;
	static var ENTRY_TYPE_MAKEUP: Number = 3;
	
	static var CAT_TEXT: Number = 0;
	static var CAT_FLAG: Number = 1;
	static var CAT_STRIDE: Number = 2;
	
	static var RACE_NAME: Number = 0;
	static var RACE_DESCRIPTION: Number = 1;
	static var RACE_EQUIPSTATE: Number = 2;
	static var RACE_STRIDE: Number = 3;
		
	static var SLIDER_NAME: Number = 0;
	static var SLIDER_FILTERFLAG: Number = 1;
	static var SLIDER_CALLBACKNAME: Number = 2;
	static var SLIDER_MIN: Number = 3;
	static var SLIDER_MAX: Number = 4;
	static var SLIDER_POSITION: Number = 5;
	static var SLIDER_INTERVAL: Number = 6;
	static var SLIDER_ID: Number = 7;
	static var SLIDER_STRIDE: Number = 8;

	static var CATEGORY_RACE: Number = 2;
	static var CATEGORY_BODY: Number = 4;
	static var CATEGORY_HEAD: Number = 8;
	static var CATEGORY_FACE: Number = 16;
	static var CATEGORY_EYES: Number = 32;
	static var CATEGORY_BROW: Number = 64;
	static var CATEGORY_MOUTH: Number = 128;
	static var CATEGORY_HAIR: Number = 256;
	static var CATEGORY_COLOR: Number = 512;
	static var CATEGORY_MAKEUP: Number = 1024;
	
	static var STATIC_SLIDER_SEX: Number = -1;
	static var STATIC_SLIDER_PRESET: Number = 0;
	static var STATIC_SLIDER_SKIN: Number = 1;
	static var STATIC_SLIDER_WEIGHT: Number = 2;
	static var STATIC_SLIDER_COMPLEXION: Number = 3;
	static var STATIC_SLIDER_DIRT: Number = 4;
	static var STATIC_SLIDER_WARPAINT: Number = 7;
	
	static var TINT_TYPE_HAIR: Number = 128;
	static var TINT_TYPE_FRECKLES: Number = 0;
	static var TINT_TYPE_LIPS: Number = 1;
	static var TINT_TYPE_CHEEKS: Number = 2;
	static var TINT_TYPE_EYELINER: Number = 3;
	static var TINT_TYPE_UPPEREYE: Number = 4;
	static var TINT_TYPE_LOWEREYE: Number = 5;
	static var TINT_TYPE_SKINTONE: Number = 6;
	static var TINT_TYPE_WARPAINT: Number = 7;
	static var TINT_TYPE_LAUGHLINES: Number = 8;
	static var TINT_TYPE_LOWERCHEEKS: Number = 9;
	static var TINT_TYPE_NOSE: Number = 10;
	static var TINT_TYPE_CHIN: Number = 11;
	static var TINT_TYPE_NECK: Number = 12;
	static var TINT_TYPE_FOREHEAD: Number = 13;
	static var TINT_TYPE_DIRT: Number = 14;
	
	static var CUSTOM_SLIDER_OFFSET: Number = 1000;

	static var SLIDER_MAP: Array = [// Male
										[{sliderID: 11, tintType: TINT_TYPE_HAIR}, // Hair Color
										{sliderID: 45, tintType: TINT_TYPE_LIPS}, // Lips Color
										{sliderID: 32, tintType: TINT_TYPE_CHEEKS}, // Cheeks Color
										{sliderID: 17, tintType: TINT_TYPE_EYELINER}, // Eyeliner Color
										{sliderID: 18, tintType: TINT_TYPE_UPPEREYE}, // Upper Eyesocket Color
										{sliderID: 19, tintType: TINT_TYPE_LOWEREYE}, // Lower Eyesocket Color
										{sliderID: 1, tintType: TINT_TYPE_SKINTONE}, // SkinTone Color
										{sliderID: 8, tintType: TINT_TYPE_WARPAINT}, // Warpaint Color
										{sliderID: 33, tintType: TINT_TYPE_LAUGHLINES}, // FrownLines Color
										{sliderID: 34, tintType: TINT_TYPE_LOWERCHEEKS}, // LowerCheeks Color
										{sliderID: 35, tintType: TINT_TYPE_NOSE}, // Nose Color
										{sliderID: 36, tintType: TINT_TYPE_CHIN}, // Chin Color
										{sliderID: 37, tintType: TINT_TYPE_NECK}, // Neck Color
										{sliderID: 38, tintType: TINT_TYPE_FOREHEAD}, // Forehead Color
										{sliderID: 5, tintType: TINT_TYPE_DIRT} // Dirt Color
										], // Female
										[{sliderID: 10, tintType: TINT_TYPE_HAIR}, // Hair Color
										{sliderID: 44, tintType: TINT_TYPE_LIPS}, // Lips Color
										{sliderID: 31, tintType: TINT_TYPE_CHEEKS}, // Cheeks Color
										{sliderID: 16, tintType: TINT_TYPE_EYELINER}, // Eyeliner Color
										{sliderID: 17, tintType: TINT_TYPE_UPPEREYE}, // Upper Eyesocket Color
										{sliderID: 18, tintType: TINT_TYPE_LOWEREYE}, // Lower Eyesocket Color
										{sliderID: 1, tintType: TINT_TYPE_SKINTONE}, // SkinTone Color
										{sliderID: 8, tintType: TINT_TYPE_WARPAINT}, // Warpaint Color
										{sliderID: 32, tintType: TINT_TYPE_LAUGHLINES}, // FrownLines Color
										{sliderID: 33, tintType: TINT_TYPE_LOWERCHEEKS}, // LowerCheeks Color
										{sliderID: 34, tintType: TINT_TYPE_NOSE}, // Nose Color
										{sliderID: 35, tintType: TINT_TYPE_CHIN}, // Chin Color
										{sliderID: 36, tintType: TINT_TYPE_NECK}, // Neck Color
										{sliderID: 37, tintType: TINT_TYPE_FOREHEAD}, // Forehead Color
										{sliderID: 5, tintType: TINT_TYPE_DIRT} // Dirt Color
										]];
	
	static var ACTORVALUE_ALCHEMY: Number = 16;
	static var ACTORVALUE_ALTERATION: Number = 18;
	static var ACTORVALUE_MARKSMAN: Number = 8;
	static var ACTORVALUE_BLOCK: Number = 9;
	static var ACTORVALUE_CONJURATION: Number = 19;
	static var ACTORVALUE_DESTRUCTION: Number = 20;
	static var ACTORVALUE_ENCHANTING: Number = 23;
	static var ACTORVALUE_HEAVYARMOR: Number = 11;
	static var ACTORVALUE_ILLUSION: Number = 21;
	static var ACTORVALUE_LIGHTARMOR: Number = 12;
	static var ACTORVALUE_LOCKPICKING: Number = 14;
	static var ACTORVALUE_ONEHANDED: Number = 6;
	static var ACTORVALUE_PICKPOCKET: Number = 13;
	static var ACTORVALUE_RESTORATION: Number = 22;
	static var ACTORVALUE_SMITHING: Number = 10;
	static var ACTORVALUE_SNEAK: Number = 15;
	static var ACTORVALUE_SPEECHCRAFT: Number = 17;
	static var ACTORVALUE_TWOHANDED: Number = 7;
	static var ACTORVALUE_NONE: Number = 255;
	
	static var ACTORVALUE_MAP: Array = [{value: ACTORVALUE_ALCHEMY, text: "$Alchemy"},
										{value: ACTORVALUE_ALTERATION, text: "$Alteration"},
										{value: ACTORVALUE_MARKSMAN, text: "$Archery"},
										{value: ACTORVALUE_BLOCK, text: "$Block"},
										{value: ACTORVALUE_CONJURATION, text: "$Conjuration"},
										{value: ACTORVALUE_DESTRUCTION, text: "$Destruction"},
										{value: ACTORVALUE_ENCHANTING, text: "$Enchanting"},
										{value: ACTORVALUE_HEAVYARMOR, text: "$Heavy Armor"},
										{value: ACTORVALUE_ILLUSION, text: "$Illusion"},
										{value: ACTORVALUE_LIGHTARMOR, text: "$Light Armor"},
										{value: ACTORVALUE_LOCKPICKING, text: "$Lockpicking"},
										{value: ACTORVALUE_ONEHANDED, text: "$One Handed"},
										{value: ACTORVALUE_PICKPOCKET, text: "$Pickpocket"},
										{value: ACTORVALUE_RESTORATION, text: "$Restoration"},
										{value: ACTORVALUE_SMITHING, text: "$Smithing"},
										{value: ACTORVALUE_SNEAK, text: "$Sneak"},
										{value: ACTORVALUE_SPEECHCRAFT, text: "$Speechcraft"},
										{value: ACTORVALUE_TWOHANDED, text: "$Two Handed"},
										{value: ACTORVALUE_NONE, text: "$None"}
										];
}