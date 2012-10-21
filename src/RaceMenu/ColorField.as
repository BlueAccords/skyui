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
		colorSelector.hSlider.addEventListener("change", this, "onSliderChange");
		colorSelector.sSlider.addEventListener("change", this, "onSliderChange");
		colorSelector.vSlider.addEventListener("change", this, "onSliderChange");
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
				if(_currentSlider > 2)
					_currentSlider = 0;
				bHandledInput = true;
			} else if(details.navEquivalent == NavigationCode.UP) {
				_currentSlider--;
				if(_currentSlider < 0)
					_currentSlider = 2;
				bHandledInput = true;
			} else if (details.navEquivalent == NavigationCode.LEFT || details.navEquivalent == NavigationCode.RIGHT || details.navEquivalent == NavigationCode.HOME || details.navEquivalent == NavigationCode.END) {
				var sliderObject: Slider = null;
				switch(_currentSlider) {
					case 0:	sliderObject = colorSelector.hSlider;	break;
					case 1:	sliderObject = colorSelector.sSlider;	break;
					case 2:	sliderObject = colorSelector.vSlider;	break;
				}
				bHandledInput = sliderObject.handleInput(details, pathToFocus);
			} else if (details.navEquivalent == NavigationCode.GAMEPAD_L2 || details.navEquivalent == NavigationCode.GAMEPAD_R2) {
				var increment: Number = 0;
				if(details.navEquivalent == NavigationCode.GAMEPAD_L2)
					increment = -10;
				else if(details.navEquivalent == NavigationCode.GAMEPAD_R2)
					increment = 10;
				var sliderObject: Slider = null;
				switch(_currentSlider) {
					case 0:	sliderObject = colorSelector.hSlider;	break;
					case 1:	sliderObject = colorSelector.sSlider;	break;
					case 2:	sliderObject = colorSelector.vSlider;	break;
				}
				sliderObject.value = sliderObject.value + increment;
				sliderObject.dispatchEventAndSound({type: "change"});
				bHandledInput = true;
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
	
	public function setColor(a_color: Number): Void
	{
		_currentColor = a_color;
		colorSelector.setColor(_currentColor);
	}

	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		buttonPanel.setPlatform(a_platform, a_bPS3Switch);
	}
	
	public function onSliderChange(): Void
	{
		dispatchEvent({type: "changeColor", color: colorSelector.getCurrentColor()});
	}

	public function onAccept(): Void
	{
		dispatchEvent({type: "setColor", color: colorSelector.getCurrentColor()});
	}

	public function onCancel(): Void
	{
		dispatchEvent({type: "setColor", color: _currentColor});
	}
}
