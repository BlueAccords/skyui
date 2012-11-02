import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;

class ColorSlider extends gfx.controls.Slider
{
	function ColorSlider()
	{
		super();
	}

	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (details.navEquivalent == NavigationCode.GAMEPAD_L2 || details.navEquivalent == NavigationCode.GAMEPAD_R2) {
			var increment: Number = 0;
			if(details.navEquivalent == NavigationCode.GAMEPAD_L2)
				increment = -10;
			else if(details.navEquivalent == NavigationCode.GAMEPAD_R2)
				increment = 10;

			value = value + increment;
			dispatchEventAndSound({type: "change"});
			return true;
		} else if (details.navEquivalent == NavigationCode.GAMEPAD_L1 || details.navEquivalent == NavigationCode.GAMEPAD_R1) {
			var newValue = value;
			if(details.navEquivalent == NavigationCode.GAMEPAD_L1)
				newValue = minimum;
			else if(details.navEquivalent == NavigationCode.GAMEPAD_R1)
				newValue = maximum;
				
			value = newValue;
			dispatchEventAndSound({type: "change"});
			return true;
		}
		return super.handleInput(details, pathToFocus);
	}
}