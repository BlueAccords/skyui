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

	function updateThumb()
	{
		var __reg2 = this.__width - this.offsetLeft - this.offsetRight;
		this.thumb._x = (this._value - this._minimum) / (this._maximum - this._minimum) * __reg2 - this.thumb._width / 2 + this.offsetLeft;
	}
}
