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
}