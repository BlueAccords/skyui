import com.greensock.*;
import com.greensock.easing.*;
import flash.geom.Transform;
import flash.geom.ColorTransform;
import skyui.defines.Actor;

class FollowerWheel extends MovieClip
{
	/* Private Variables */
	private var _options: Array;
	private var _side: Number = -1;
	private var _option: Number = -1;
	private var _iconSource: String = "";
	
	private var _actor: Object;
	
	private var _movieLoader: MovieClipLoader;
	
	var TOTAL_OPTIONS: Number = 8;
	var SLICE_COLUMN_SIZE: Number = 4;
	
	/* Private Scene Clips */
	private var HealthMeter: MovieClip;
	private var MagickaMeter: MovieClip;
	private var StaminaMeter: MovieClip;
	
	private var Left00: MovieClip;
	private var Left01: MovieClip;
	private var Left02: MovieClip;
	private var Left03: MovieClip;
	
	private var Right00: MovieClip;
	private var Right01: MovieClip;
	private var Right02: MovieClip;
	private var Right03: MovieClip;
	
	private var Icon0: MovieClip;
	private var Icon1: MovieClip;
	private var Icon2: MovieClip;
	private var Icon3: MovieClip;
	private var Icon4: MovieClip;
	private var Icon5: MovieClip;
	private var Icon6: MovieClip;
	private var Icon7: MovieClip;
	
	private var Knot: MovieClip;
	
	private var Name: TextField;
	private var Option: TextField;
	
	private var TextLeft00: TextField;
	private var TextLeft01: TextField;
	private var TextLeft02: TextField;
	private var TextLeft03: TextField;
	
	private var TextRight00: TextField;
	private var TextRight01: TextField;
	private var TextRight02: TextField;
	private var TextRight03: TextField;
	
	function FollowerWheel()
	{
		super();
				
		// 17 is for angle offset, each slice is 35 degrees
		_options = [ {slice: Left00, label: TextLeft00, rot: -20 - 17, iconData: {icon: Icon0, name: "", size: 32, color: 0xFFFFFF}, option: "$Wait"},
					 {slice: Left01, label: TextLeft01, rot: -55 - 17, iconData: {icon: Icon1, name: "", size: 32, color: 0xFFFFFF}, option: "$Trade"},
					 {slice: Left02, label: TextLeft02, rot: -90 - 17, iconData: {icon: Icon2, name: "", size: 32, color: 0xFFFFFF}, option: "$Aggressive"},
					 {slice: Left03, label: TextLeft03, rot: -125 - 17, iconData: {icon: Icon3, name: "", size: 32, color: 0xFFFFFF}, option: "$More"},
					 {slice: Right00, label: TextRight00, rot: 20 + 17, iconData: {icon: Icon4, name: "", size: 32, color: 0xFFFFFF}, option: "$Relax"},
					 {slice: Right01, label: TextRight01, rot: 55 + 17, iconData: {icon: Icon5, name: "", size: 32, color: 0xFFFFFF}, option: "$Stats"},
					 {slice: Right02, label: TextRight02, rot: 90 + 17, iconData: {icon: Icon6, name: "", size: 32, color: 0xFFFFFF}, option: "$Talk"},
					 {slice: Right03, label: TextRight03, rot: 125 + 17, iconData: {icon: Icon7, name: "", size: 32, color: 0xFFFFFF}, option: "$Exit"}
					];
		
		for(var o = 0; o < _options.length; o++)
		{
			_options[o].slice.gotoAndStop("Inactive");
			_options[o].slice.option = o;
			_options[o].slice.onRollOver = function() {
				this._parent.setWheelOption(this.option);
			}
			_options[o].slice.onRelease = function() {
				this._parent.onWheelOption(this.option);
			}
		}
		
		_movieLoader = new MovieClipLoader();
		_movieLoader.addListener(this);
		
		gfx.events.EventDispatcher.initialize(this);
	}
	
	function onLoad()
	{
		gfx.managers.FocusHandler.instance.setFocus(this, 0);
		setWheelIconSource("skyui/skyui_icons_psychosteve.swf");	
	}
	
	function handleInput(details: gfx.ui.InputDetails, pathToFocus: Array): Boolean
	{
		var bHandledInput: Boolean = false;
		if (Shared.GlobalFunc.IsKeyPressed(details)) 
		{
			if (details.navEquivalent == gfx.ui.NavigationCode.TAB) 
			{
				closeMenu(255);
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.LEFT) {
				var deltaOption = _option;
				if(deltaOption >= SLICE_COLUMN_SIZE)
					deltaOption -= SLICE_COLUMN_SIZE;
				deltaOption = GetNearestOption(deltaOption, true);
				setWheelOption(deltaOption, false);
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.RIGHT) {
				var deltaOption = _option;
				if(deltaOption < SLICE_COLUMN_SIZE)
					deltaOption += SLICE_COLUMN_SIZE;
				deltaOption = GetNearestOption(deltaOption, true);
				setWheelOption(deltaOption, false);
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.UP) {
				var deltaOption = _option;
				if(deltaOption > 0) {
					deltaOption--;
					deltaOption = GetNearestOption(deltaOption, false);
					setWheelOption(deltaOption, false);
				}
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.DOWN) {
				var deltaOption = _option;
				if(deltaOption < _options.length - 1) {
					deltaOption++;
					deltaOption = GetNearestOption(deltaOption, true);
					setWheelOption(deltaOption, false);
				}
				bHandledInput = true;
			} else if(details.navEquivalent == gfx.ui.NavigationCode.ENTER) {
				onWheelOption(_option);
				bHandledInput = true;
			}
		}
		
		return bHandledInput;
	}
	
	// @override MovieClipLoader
	public function onLoadInit(a_clip: MovieClip): Void
	{
		if(a_clip == HealthMeter) {
			a_clip.widget.initNumbers(200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0x561818, 0xDF2020, 100, 0, 0xFF3232);
			a_clip.widget.initStrings("$EverywhereFont", "$EverywhereFont", "", "", "", "", "right");
			a_clip.widget.initCommit();
			a_clip.widget.setMeterPercent((_actor.actorValues[Actor.AV_HEALTH].current / _actor.actorValues[Actor.AV_HEALTH].maximum) * 100.0, true);
			a_clip.widget._visible = true;
		} else if(a_clip == MagickaMeter) {
			a_clip.widget.initNumbers(200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0x0C016D, 0x284BD7, 100, 0, 0x3366FF);
			a_clip.widget.initStrings("$EverywhereFont", "$EverywhereFont", "", "", "", "", "right");
			a_clip.widget.initCommit();
			a_clip.widget.setMeterPercent((_actor.actorValues[Actor.AV_MAGICKA].current / _actor.actorValues[Actor.AV_MAGICKA].maximum) * 100.0, true);
			a_clip.widget._visible = true;
		} else if(a_clip == StaminaMeter) {
			a_clip.widget.initNumbers(200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0x003300, 0x339966, 100, 0, 0x009900);
			a_clip.widget.initStrings("$EverywhereFont", "$EverywhereFont", "", "", "", "", "right");
			a_clip.widget.initCommit();
			a_clip.widget.setMeterPercent((_actor.actorValues[Actor.AV_STAMINA].current / _actor.actorValues[Actor.AV_STAMINA].maximum) * 100.0, true);
			a_clip.widget._visible = true;
		} else {
			updateIcon(int(a_clip._name.substring(4, _name.length)));
		}
	}
	
	// @override MovieClipLoader
	public function onLoadError(a_clip:MovieClip, a_errorCode: String): Void
	{
		if(a_clip == HealthMeter) {
			skse.Log("Failed to load health meter.");
		} else if(a_clip == MagickaMeter) {
			skse.Log("Failed to load magicka meter.");
		} else if(a_clip == StaminaMeter) {
			skse.Log("Failed to load stamina meter.");
		}else {
			unloadIcon(int(a_clip._name.substring(4, _name.length)));
		}
	}
	
	private function onWheelOption(option: Number)
	{
		if(!_options[option].slice.enabled)
			return;
			
		//skse.SendModEvent("AcceptWheelOption", "", option);
		closeMenu(option);
	}
	
	private function GetNearestOption(option: Number, top: Boolean): Number
	{
		var foundDown: Number = -1;
		var foundUp: Number = -1;
		var foundOption: Number = -1;
		
		// Search Down
		for(var i = option; i < TOTAL_OPTIONS; i++) {
			if(_options[i].slice.enabled) {
				foundDown = i;
				break;
			}
		}
		// Search Up
		for(var i = option; i >= 0; --i) {
			if(_options[i].slice.enabled) {
				foundUp = i;
				break;
			}
		}
				
		if(foundDown != -1 && foundUp != -1) { // Found item on both sides go for nearest
			var deltaUp = Math.abs(option - foundUp);
			var deltaDown = Math.abs(option - foundDown);
			if(deltaDown < deltaUp) {
				foundOption = foundDown;
			} else if(deltaUp < deltaDown) {
				foundOption = foundUp;
			} else {
				foundOption = top ? foundDown : foundUp;
			}
		} else if(foundDown != -1) {
			foundOption = foundDown;
		} else if(foundUp != -1) {
			foundOption = foundUp;
		}
		
		return foundOption;
	}
	
	private function setWheelOption(option: Number, silent: Boolean)
	{
		if(option == _option || option == -1)
			return;
			
		if(option < 0 || option >= TOTAL_OPTIONS) // Invalid option
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
		
		skse.SendModEvent("XFLWheel_SetOption", "", option);
	}
	
	private function closeMenu(option: Number)
	{
		//skse.SendModEvent("MenuClosing", "", 0);
		gfx.io.GameDelegate.call("buttonPress", [option]);
		//skse.SendModEvent("MenuClosing", "", 1);
	}
	
	// @Papyrus
	public function setWheelSelection(option: Number, silent: Number): Void
	{
		option = GetNearestOption(option, true);
		setWheelOption(option, silent >= 1 ? true : false);
	}
	
	// @Papyrus
	public function setWheelIconSource(a_iconSource: String): Void
	{
		if (_iconSource == a_iconSource)
			return;
			
		_iconSource = a_iconSource;		
		if (_iconSource == "")
		{
			for(var i = 0; i < TOTAL_OPTIONS; i++)
				unloadIcon(i);
		}
		else
		{
			for(var i = 0; i < TOTAL_OPTIONS; i++)
				loadIcon(i);
		}
	}
	
	// @Papyrus
	public function setWheelActor(object: Object)
	{
		_actor = object;
		skse.ExtendForm(_actor.formId, _actor, true, false);
		skse.ExtendForm(_actor.actorBase.formId, _actor.actorBase, true, false);
		this.Name.text = _actor.actorBase.fullName;
		
		_movieLoader.loadClip("./widgets/status.swf", HealthMeter);
		_movieLoader.loadClip("./widgets/status.swf", MagickaMeter);
		_movieLoader.loadClip("./widgets/status.swf", StaminaMeter);
	}
	
	// @Papyrus
	public function setWheelText(a_text: String)
	{
		this.Name.text = a_text;
	}
	
	// @Papyrus
	public function setWheelOptions()
	{
		var options: Array = arguments;
		for(var i = 0; i < options.length; i++)
		{
			if(options[i].charAt(options[i].length-1) == ' ')
				options[i] = options[i].substring(0, options[i].length-1);
				
			_options[i].option = options[i];
		}
	}
	
	// @Papyrus
	public function setWheelOptionLabels()
	{
		var options: Array = arguments;
		for(var i = 0; i < options.length; i++)
		{
			if(options[i].charAt(options[i].length-1) == ' ')
				options[i] = options[i].substring(0, options[i].length-1);
				
			_options[i].label.text = options[i];
		}
	}
	
	// @Papyrus
	public function setWheelOptionIcons()
	{
		var options: Array = arguments;
		for(var i = 0; i < options.length; i++)
		{
			if(options[i].charAt(options[i].length-1) == ' ')
				options[i] = options[i].substring(0, options[i].length-1);
				
			_options[i].iconData.name = options[i];
			updateIcon(i);
		}
	}
	
	// @Papyrus
	public function setWheelOptionIconColors()
	{
		var options: Array = arguments;
		for(var i = 0; i < options.length; i++)
		{
			if(options[i].charAt(options[i].length-1) == ' ')
				options[i] = options[i].substring(0, options[i].length-1);
				
			_options[i].iconData.color = options[i];
			updateIcon(i);
		}
	}
	
	// @Papyrus
	function setWheelOptionsEnabled()
	{
		var options: Array = arguments;
		for(var i = 0; i < options.length; i++)
		{
			_options[i].slice.enabled = options[i] >= 1 ? true : false;
			_options[i].slice._visible = options[i] >= 1 ? true : false;
		}
	}
	
	// @Papyrus
	public function setWheelOptionText(option: Number, a_text: String)
	{
		if(option < 0 || option >= TOTAL_OPTIONS)
			return;
			
		_options[option].option = a_text;
	}
	
	// @Papyrus
	public function setWheelOptionIcon(option: Number, a_icon: String)
	{
		if(option < 0 || option >= TOTAL_OPTIONS)
			return;
			
		_options[option].iconData.name = a_icon;
		updateIcon(option);
	}
	
	// @Papyrus
	public function setWheelOptionIconColor(option: Number, a_color: Number)
	{
		if(option < 0 || option >= TOTAL_OPTIONS)
			return;
			
		_options[option].iconData.color = a_color;
		updateIcon(option);
	}
	
	
	private function loadIcon(option: Number): Void
	{
		_movieLoader.loadClip(_iconSource, _options[option].iconData.icon);
	}
	
	private function unloadIcon(option: Number): Void
	{
		_movieLoader.unloadClip(_options[option].iconData.icon);
	}
	
	private function updateIcon(option: Number): Void
	{
		var iconData = _options[option].iconData;
		var tf: Transform = new Transform(iconData.icon);
		var colorTf: ColorTransform = new ColorTransform();
		colorTf.rgb = iconData.color;
		tf.colorTransform = colorTf;
		
		iconData.icon._width = iconData.icon._height = iconData.size;
		if(iconData.name != "")
			iconData.icon.gotoAndStop(iconData.name);
		else
			iconData.icon.gotoAndStop(0);
	}
}
