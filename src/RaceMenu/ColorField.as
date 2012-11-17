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
	public var colorText: TextField;
	public var currentSelectionLeft: MovieClip;
	public var currentSelectionRight: MovieClip;
	
	private var _acceptButton: Object;
	private var _cancelButton: Object;
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
		colorText.textAutoSize = "shrink";
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
				UpdateSelection();
				bHandledInput = true;
			} else if(details.navEquivalent == NavigationCode.UP) {
				_currentSlider--;
				if(_currentSlider < 0)
					_currentSlider = 3;
				UpdateSelection();
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
		var acceptButton: MovieClip = buttonPanel.addButton({text: "$Accept", controls: _acceptButton});
		var cancelButton: MovieClip = buttonPanel.addButton({text: "$Cancel", controls: _cancelButton});
		acceptButton.addEventListener("click", this, "onAccept");
		cancelButton.addEventListener("click", this, "onCancel");
		buttonPanel.updateButtons(true);
	}
	
	public function UpdateSelection(): Void
	{
		currentSelectionLeft.gotoAndStop(_currentSlider + 1);
		currentSelectionRight.gotoAndStop(_currentSlider + 1);
	}
	
	public function ResetSlider(): Void
	{
		_currentSlider = 0;
		UpdateSelection();
	}
	
	public function getColor(): Number
	{
		return _currentColor;
	}
		
	public function setText(a_text: String): Void
	{
		colorText.text = a_text;
	}
	
	public function setColor(a_color: Number): Void
	{
		_currentColor = a_color;
		colorSelector.setColor(_currentColor & 0x00FFFFFF, (_currentColor >>> 24));
	}

	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		if(a_platform == 0) {
			_acceptButton = InputDefines.Accept;
			_cancelButton = InputDefines.Tab;
		} else {
			_acceptButton = InputDefines.Accept;
			_cancelButton = InputDefines.Cancel;
		}
		buttonPanel.setPlatform(a_platform, a_bPS3Switch);
	}
	
	public function onSliderChange(event: Object): Void
	{
		dispatchEvent({type: "changeColor", color: (event.color | event.alpha << 24)});
	}

	public function onAccept(): Void
	{
		dispatchEvent({type: "setColor", color: (colorSelector.getColor() | colorSelector.getAlpha() << 24)});
	}

	public function onCancel(): Void
	{
		dispatchEvent({type: "setColor", color: _currentColor});
	}
}
