import gfx.events.EventDispatcher;
import skyui.components.ButtonPanel;
import gfx.ui.InputDetails;
import gfx.ui.NavigationCode;
import Shared.GlobalFunc;

class TextEntryField extends MovieClip
{
	public var buttonPanel: ButtonPanel;
	public var TextInputInstance: TextField;

	public var addEventListener: Function;
	public var dispatchEvent: Function;

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
		buttonPanel.addButton({text: "$Accept", controls: InputDefines.Enter});
		buttonPanel.addButton({text: "$Cancel", controls: InputDefines.Escape});

		buttonPanel.buttons[0].addEventListener("click", this, "onAccept");
		buttonPanel.buttons[1].addEventListener("click", this, "onCancel");
		buttonPanel.updateButtons(true);
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
