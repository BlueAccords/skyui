Scriptname UIMenuBase extends Quest

int Function OpenMenu(Form akForm = None, Form akReceiver = None)
	return -1
EndFunction

string Function GetMenuName()
	return ""
EndFunction

Event OnGameReload()
	
EndEvent

Function ResetMenu()

EndFunction

float Function GetResultFloat()
	return 0.0
EndFunction

int Function GetResultInt()
	return 0
EndFunction

string Function GetResultString()
	return ""
EndFunction

Form Function GetResultForm()
	return None
EndFunction

; Property functions

; Getters
int Function GetPropertyInt(string propertyName)

EndFunction

bool Function GetPropertyBool(string propertyName)

EndFunction

string Function GetPropertyString(string propertyName)

EndFunction

float Function GetPropertyFloat(string propertyName)

EndFunction

Form Function GetPropertyForm(string propertyName)

EndFunction

; Setters
Function SetPropertyInt(string propertyName, int value)

EndFunction

Function SetPropertyBool(string propertyName, bool value)

EndFunction

Function SetPropertyString(string propertyName, string value)

EndFunction

Function SetPropertyFloat(string propertyName, float value)

EndFunction

Function SetPropertyForm(string propertyName, Form value)

EndFunction

Function SetPropertyAlias(string propertyName, Alias value)

EndFunction

; Property Index functions
Function SetPropertyIndexInt(string propertyName, int index, int value)

EndFunction

Function SetPropertyIndexBool(string propertyName, int index, bool value)

EndFunction

Function SetPropertyIndexString(string propertyName, int index, string value)

EndFunction

Function SetPropertyIndexFloat(string propertyName, int index, float value)

EndFunction

Function SetPropertyIndexForm(string propertyName, int index, Form value)

EndFunction

Function SetPropertyIndexAlias(string propertyName, int index, Alias value)

EndFunction

; Array Functions
Function SetPropertyIntA(string propertyName, int[] value)

EndFunction

Function SetPropertyBoolA(string propertyName, bool[] value)

EndFunction

Function SetPropertyStringA(string propertyName, string[] value)

EndFunction

Function SetPropertyFloatA(string propertyName, float[] value)

EndFunction

Function SetPropertyFormA(string propertyName, Form[] value)

EndFunction

Function SetPropertyAliasA(string propertyName, Alias[] value)

EndFunction