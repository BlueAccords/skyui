import gfx.events.EventDispatcher;
import skyui.components.ButtonPanel;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;

class TextEntryField extends MovieClip
{
	public var buttonPanel: ButtonPanel;
	public var TextInputInstance: TextField;
	
	private var _acceptButton: MovieClip;
	private var _cancelButton: MovieClip;

	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;

	public function TextEntryField()
	{
		super();
		EventDispatcher.initialize(this);
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
			}
		}
		
		if(bHandledInput) {
			return bHandledInput;
		} else {
			var nextClip = pathToFocus.shift();
			if (nextClip.handleInput(details, pathToFocus)) {
				return true;
			}
		}
		
		return false;
	}

	public function SetupButtons(): Void
	{
		buttonPanel.clearButtons();
		_acceptButton = buttonPanel.addButton({text: "$Accept", controls: InputDefines.Enter});
		_cancelButton = buttonPanel.addButton({text: "$Cancel", controls: InputDefines.Escape});
		_acceptButton.addEventListener("click", this, "onAccept");
		_cancelButton.addEventListener("click", this, "onCancel");
		buttonPanel.updateButtons();
	}

	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		buttonPanel.setPlatform(a_platform, a_bPS3Switch);
	}

	public function GetValidName(): Boolean
	{
		return TextInputInstance.text.length > 0;
	}

	public function onAccept(): Void
	{
		if (GetValidName()) {
			dispatchEvent({type: "nameChange", nameChanged: true});
		}
	}

	public function onCancel(): Void
	{
		dispatchEvent({type: "nameChange", nameChanged: false});
	}

}
