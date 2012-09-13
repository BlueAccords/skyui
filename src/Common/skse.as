intrinsic class skse
{
	static function Log(a_string:String):Void;
	static function AllowTextInput(a_flag:Boolean):Void;
	static function SetINISetting(a_key:String, a_value:Number):Void;
	static function GetINISetting(a_key:String):Number;
	static function OpenMenu(a_menu:String):Void;
	static function CloseMenu(a_menu:String):Void;
	static function ExtendData(enable:Boolean):Void;
	static function ForceContainerCategorization(enable:Boolean):Void;	
<<<<<<< HEAD
	static function SendModEvent(a_eventName:String, a_strArg:String, a_numArg:Number, a_formArg:Number):Void;
	static function RequestActivePlayerEffects(a_list:Array):Void;
	static function	ExtendForm(a_formid:Number, a_object:Object, a_extraData:Boolean, a_recursive:Boolean):Void;
	static function RequestActorValue(a_formid:Number, a_actorValue:Number, a_object:Object):Void;
=======
	static function SendModEvent(a_eventName:String, a_strArg:String, a_numArg:Number):Void;
	static function RequestActivePlayerEffects(a_list:Array):Void;
	static function ExtendForm(a_formid:Number, a_object:Object, a_extraData:Boolean, a_recursive:Boolean):Void;
>>>>>>> df726b955a5c985f96cceb6a8a5417e3b2c40f44
}