import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;

class RaceMenuSlider extends gfx.controls.Slider
{
	function RaceMenuSlider()
	{
		super();
	}

	function onLoad()
	{
		super.onLoad();
		dispatchEvent({type: "onWidgetLoad", object: this});
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		var keyState = details.value == "keyDown" || details.value == "keyHold";
		if (details.navEquivalent === gfx.ui.NavigationCode.RIGHT) 
		{
			if (keyState) 
			{
				this.value = this.value + this._snapInterval;
				this.dispatchEventAndSound({type: "change"});
			}
		}
		else if (details.navEquivalent === gfx.ui.NavigationCode.LEFT) 
		{
			if (keyState) 
			{
				this.value = this.value - this._snapInterval;
				this.dispatchEventAndSound({type: "change"});
			}
		}
		else if (details.navEquivalent === NavigationCode.GAMEPAD_R2) 
		{
			if (keyState) 
			{
				this.value = this.value + this.maximum / 8;
				this.dispatchEventAndSound({type: "change"});
			}
		}
		else if (details.navEquivalent === NavigationCode.GAMEPAD_L2) 
		{
			if (keyState) 
			{
				this.value = this.value - this.maximum / 8;
				this.dispatchEventAndSound({type: "change"});
			}
		}
		else if (details.navEquivalent === gfx.ui.NavigationCode.HOME)
		{
			if (!keyState) 
			{
				this.value = this.minimum;
				this.dispatchEventAndSound({type: "change"});
			}
		}
		else if (details.navEquivalent === gfx.ui.NavigationCode.END)
		{
			if (!keyState) 
			{
				this.value = this.maximum;
				this.dispatchEventAndSound({type: "change"});
			}
		}
		else 
		{
			return false;
		}
		return true;
	}

	function updateThumb()
	{
		var __reg2 = this.__width - this.offsetLeft - this.offsetRight;
		this.thumb._x = (this._value - this._minimum) / (this._maximum - this._minimum) * __reg2 - this.thumb._width / 2 + this.offsetLeft;
	}
}
