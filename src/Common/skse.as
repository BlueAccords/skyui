﻿intrinsic class skse
{
	static function Log(a_string:String):Void;
	static function AllowTextInput(a_flag:Boolean):Void;
	static function SetINISetting(a_key:String, a_value:Number):Void;
	static function GetINISetting(a_key:String):Number;
	static function OpenMenu(a_menu:String):Void;
	static function CloseMenu(a_menu:String):Void;
	static function ExtendData(enable:Boolean):Void;
	static function ForceContainerCategorization(enable:Boolean):Void;	
	static function SendModEvent(a_eventName:String, a_strArg:String, a_numArg:Number, a_formArg:Number):Void;
	static function RequestPlayerActiveEffects(a_list: Array):Void;
}