import com.greensock.*;
import com.greensock.easing.*;

dynamic class FollowerWheel extends MovieClip
{
	/* Private Variables */
	var _nameText: String = "";
	var _optionText: String = "";
	var _options: Array;
	var _side: Number = 0;
	var _option: Number = 0;
	
	function FollowerWheel()
	{
		super();
		
		this._parent._xscale = 0;
		this._parent._yscale = 0;
		
		// 17 is for angle offset, each slice is 35 degrees
		_options = [[{slice: this.Left00, rotationValue: -20 - 17, option: "Melee/Ranged"},
					 {slice: this.Left01, rotationValue: -55 - 17, option: "Open Inventory"},
					 {slice: this.Left02, rotationValue: -90 - 17, option: "Distance"},
					 {slice: this.Left03, rotationValue: -125 - 17, option: "Backup"}],
					[{slice: this.Right00, rotationValue: 20 + 17, option: "Aggression"},
					 {slice: this.Right01, rotationValue: 55 + 17, option: "Use Potion"},
					 {slice: this.Right02, rotationValue: 90 + 17, option: "Talk"},
					 {slice: this.Right03, rotationValue: 125 + 17, option: "Wait/Follow"}]
					];
		
		for(var s = 0; s < _options.length; s++)
		{
			for(var o = 0; o < _options[s].length; o++)
			{
				_options[s][o].slice.gotoAndStop("Inactive");
				
				_options[s][o].slice.side = s;
				_options[s][o].slice.option = o;
				
				_options[s][o].slice.onRollOver = function() {
					this._parent.SetOption(this.side, this.option);
				}
				_options[s][o].slice.onRelease = function() {
					this._parent.EnterOption(this.side, this.option);
				}
			}
		}
		
		gfx.events.EventDispatcher.initialize(this);
	}
	
	function onLoad()
	{
		skse.Log("Loaded Wheel");
		SetNameText("Bob the Builder");
		SetOptionText("Exit");
		SetOption(0, 0, true);
		
		gfx.managers.FocusHandler.instance.setFocus(this, 0);
	}
	
	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = false;
		if (Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				gfx.io.GameDelegate.call("buttonPress", [0]);
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.LEFT) {
				SetOption(0, _option, false);
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.RIGHT) {
				SetOption(1, _option, false);
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.UP) {
				var deltaOption = _option;
				if(deltaOption > 0) {
					deltaOption--;
					SetOption(_side, deltaOption, false);
				}
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.DOWN) {
				var deltaOption = _option;
				if(deltaOption < 3) {
					deltaOption++;
					SetOption(_side, deltaOption, false);
				}
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.ENTER) {
				EnterOption(_side, _option);
				bHandledInput = true;
			}
		}
		
		return bHandledInput;
	}
	
	function EnterOption(side: Number, option: Number)
	{
		skse.Log("Wheel State: s " + side + " o " + option);
	}
	
	function SetNameText(aText: String)
	{
		_nameText = aText;
		this.Name.text = _nameText;
	}
	
	function SetOptionText(aText: String)
	{
		_optionText = aText;
		this.Option.text = _optionText;
	}
	
	function SetOption(side: Number, option: Number, silent: Boolean)
	{
		if(side != _side || option != _option) {
			_options[_side][_option].slice.gotoAndStop("Inactive");
			TweenMax.to(this.Knot, 0.5, {shortRotation:{_rotation:_options[side][option].rotationValue}, ease:Expo.easeOut});
			_options[side][option].slice.gotoAndStop("Active");
			_side = side;
			_option = option;
			SetOptionText(_options[side][option].option);
			
			if(!silent) {
				gfx.io.GameDelegate.call("PlaySound", ["UIMenuFocus"]);
			}
		}
	}
}
