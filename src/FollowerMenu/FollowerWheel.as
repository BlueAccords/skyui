import com.greensock.*;
import com.greensock.easing.*;
import flash.geom.Transform;
import flash.geom.ColorTransform;

class FollowerWheel extends MovieClip
{
	/* Private Variables */
	var _options: Array;
	var _side: Number = -1;
	var _option: Number = -1;
	var SLICE_COLUMN_SIZE: Number = 4;
	
	var Left00: MovieClip;
	var Left01: MovieClip;
	var Left02: MovieClip;
	var Left03: MovieClip;
	
	var Right00: MovieClip;
	var Right01: MovieClip;
	var Right02: MovieClip;
	var Right03: MovieClip;
	
	var Knot: MovieClip;
	
	var Name: TextField;
	var Option: TextField;
	
	function FollowerWheel()
	{
		super();
		
		// 17 is for angle offset, each slice is 35 degrees
		_options = [ {slice: Left00, rot: -20 - 17, option: "Melee/Ranged"},
					 {slice: Left01, rot: -55 - 17, option: "Open Inventory"},
					 {slice: Left02, rot: -90 - 17, option: "Distance"},
					 {slice: Left03, rot: -125 - 17, option: "Backup"},
					 {slice: Right00, rot: 20 + 17, option: "Aggression"},
					 {slice: Right01, rot: 55 + 17, option: "Use Potion"},
					 {slice: Right02, rot: 90 + 17, option: "Talk"},
					 {slice: Right03, rot: 125 + 17, option: "Wait/Follow"}
					];
		
		for(var o = 0; o < _options.length; o++)
		{
			_options[o].slice.gotoAndStop("Inactive");
			_options[o].slice.option = o;
			_options[o].slice.onRollOver = function() {
				this._parent.SelectWheelOption(this.option);
			}
			_options[o].slice.onRelease = function() {
				this._parent.AcceptWheelOption(this.option);
			}
		}
		
		gfx.events.EventDispatcher.initialize(this);
	}
	
	function onLoad()
	{
		gfx.managers.FocusHandler.instance.setFocus(this, 0);
	}
	
	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = false;
		if (Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				gfx.io.GameDelegate.call("buttonPress", [255]);
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.LEFT) {
				var deltaOption = _option;
				if(deltaOption >= SLICE_COLUMN_SIZE)
					deltaOption -= SLICE_COLUMN_SIZE;
				SelectWheelOption(deltaOption, false);
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.RIGHT) {
				var deltaOption = _option;
				if(deltaOption < SLICE_COLUMN_SIZE)
					deltaOption += SLICE_COLUMN_SIZE;
				SelectWheelOption(deltaOption, false);
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.UP) {
				var deltaOption = _option;
				if(deltaOption > 0) {
					deltaOption--;
					SelectWheelOption(deltaOption, false);
				}
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.DOWN) {
				var deltaOption = _option;
				if(deltaOption < _options.length - 1) {
					deltaOption++;
					SelectWheelOption(deltaOption, false);
				}
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.ENTER) {
				AcceptWheelOption(_option);
				bHandledInput = true;
			}
		}
		
		return bHandledInput;
	}
	
	function AcceptWheelOption(option: Number)
	{
		if(!_options[option].slice.enabled)
			return;
			
		//skse.SendModEvent("AcceptWheelOption", "", option);
		gfx.io.GameDelegate.call("buttonPress", [option]);
	}
	
	function SetWheelName(aText: String)
	{
		this.Name.text = aText;
	}
	
	function SetWheelOptionText(aText: String, option: Number)
	{
		_options[option].option = aText;
	}
	
	function SetWheelActor(object: Object)
	{
		SetWheelName(object.actorBase.fullName);
	}
	
	function SetWheelOptions()
	{
		var options: Array = arguments;
		for(var i = 0; i < options.length; i++)
		{
			if(options[i].charAt(options[i].length-1) == ' ')
				options[i] = options[i].substring(0, options[i].length-1);
				
			_options[i].option = options[i];
		}
	}
	
	function SetEnableWheelOption(option: Number, enable: Boolean)
	{
		_options[option].slice.enabled = enable;
		_options[option].slice._visible = enable;
	}
	
	function SelectWheelOption(option: Number, silent: Boolean)
	{
		if(option == -1) // Invalid state
			return;
			
		if(option == _option) // Option unchanged
			return;
		
		if(_option != -1) // De-select previous state
			_options[_option].slice.gotoAndStop("Inactive");
			
		TweenMax.to(this.Knot, 0.5, {shortRotation:{_rotation:_options[option].rot}, ease:Expo.easeOut});
		
		// Select new state
		_options[option].slice.gotoAndStop("Active");
		_option = option;
		
		this.Option.text = _options[option].option;
		
		if(!silent) {
			gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
		}
	}
}
