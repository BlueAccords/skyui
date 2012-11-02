import gfx.events.EventDispatcher;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;
import gfx.controls.Slider;
import Shared.GlobalFunc;

import skyui.components.ButtonPanel;

class ColorField extends MovieClip
{
	public var buttonPanel: ButtonPanel;
	public var colorSelector: HSVSelector;
	
	private var _acceptButton: MovieClip;
	private var _cancelButton: MovieClip;
	private var _currentColor: Number = 0;
	private var _currentAlpha: Number = 0;
	public var _currentSlider: Number = 0;

	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;
	
	public function ColorField()
	{
		super();
		EventDispatcher.initialize(this);
	}
	
	public function onLoad()
	{
		colorSelector.addEventListener("changeColor", this, "onSliderChange");
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{			
		var bHandledInput: Boolean = false;
		if (GlobalFunc.IsKeyPressed(details)) {
			if(details.navEquivalent == NavigationCode.ENTER) {
				onAccept();
				bHandledInput = true;
			} else if(details.navEquivalent == NavigationCode.TAB) {
				onCancel();
				bHandledInput = true;
			} else if (details.navEquivalent == NavigationCode.DOWN) {
				_currentSlider++;
				if(_currentSlider > 3)
					_currentSlider = 0;
				bHandledInput = true;
			} else if(details.navEquivalent == NavigationCode.UP) {
				_currentSlider--;
				if(_currentSlider < 0)
					_currentSlider = 3;
				bHandledInput = true;
			} else if (details.navEquivalent == NavigationCode.LEFT || 
					   details.navEquivalent == NavigationCode.RIGHT || 
					   details.navEquivalent == NavigationCode.HOME || 
					   details.navEquivalent == NavigationCode.END || 
					   details.navEquivalent == NavigationCode.GAMEPAD_L2 || 
					   details.navEquivalent == NavigationCode.GAMEPAD_R2 || 
					   details.navEquivalent == NavigationCode.GAMEPAD_L1 || 
					   details.navEquivalent == NavigationCode.GAMEPAD_R1) {
				var sliderObject: Slider = null;
				switch(_currentSlider) {
					case 0:	sliderObject = colorSelector.hSlider;	break;
					case 1:	sliderObject = colorSelector.sSlider;	break;
					case 2:	sliderObject = colorSelector.vSlider;	break;
					case 3:	sliderObject = colorSelector.aSlider;	break;
				}
				bHandledInput = sliderObject.handleInput(details, pathToFocus);
			}
		}

		return bHandledInput;
	}

	public function SetupButtons(): Void
	{
		buttonPanel.clearButtons();
		_acceptButton = buttonPanel.addButton({text: "$Accept", controls: InputDefines.Accept});
		_cancelButton = buttonPanel.addButton({text: "$Cancel", controls: InputDefines.Cancel});
		_acceptButton.addEventListener("click", this, "onAccept");
		_cancelButton.addEventListener("click", this, "onCancel");
		buttonPanel.updateButtons(true);
	}
	
	public function ResetSlider(): Void
	{
		_currentSlider = 0;
	}
	
	public function getColor(): Number
	{
		return _currentColor;
	}
	
	public function getAlpha(): Number
	{
		return _currentAlpha;
	}
	
	public function setColor(a_color: Number, a_alpha: Number): Void
	{
		_currentColor = a_color;
		_currentAlpha = a_alpha;
		colorSelector.setColor(_currentColor, _currentAlpha);
	}

	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		buttonPanel.setPlatform(a_platform, a_bPS3Switch);
	}
	
	public function onSliderChange(event: Object): Void
	{
		dispatchEvent({type: "changeColor", color: event.color, alpha: event.alpha});
	}

	public function onAccept(): Void
	{
		dispatchEvent({type: "setColor", color: colorSelector.getColor(), alpha: colorSelector.getAlpha()});
	}

	public function onCancel(): Void
	{
		dispatchEvent({type: "setColor", color: _currentColor, alpha: _currentAlpha});
	}
}
