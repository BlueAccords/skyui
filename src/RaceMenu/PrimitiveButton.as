import gfx.events.EventDispatcher;

class PrimitiveButton extends MovieClip
{
	public var inside: MovieClip;
	public var outside: MovieClip;
	public var intensity: Number = 0;
	
	function PrimitiveButton()
	{
		super();
		EventDispatcher.initialize(this);
	}
	
	function onLoad()
	{
		this.onRollOver = this.handleMouseRollOver;
		this.onRollOut = this.handleMouseRollOut;
		this.onPress = this.handleMousePress;
		this.onRelease = this.handleMouseRelease;
		this.onReleaseOutside = this.handleReleaseOutside;
		this.onDragOver = this.handleDragOver;
		this.onDragOut = this.handleDragOut;
	}
	
	function getColor(v: Number,vmin: Number,vmax: Number): Number
	{
	   var c: Object = {r: 1.0, g: 1.0, b:1.0}; // white
	   var dv: Number;
	
	   if (v < vmin)
		  v = vmin;
	   if (v > vmax)
		  v = vmax;
	   dv = vmax - vmin;
	
	   if (v < (vmin + 0.25 * dv)) {
		  c.r = 0;
		  c.g = 4 * (v - vmin) / dv;
	   } else if (v < (vmin + 0.5 * dv)) {
		  c.r = 0;
		  c.b = 1 + 4 * (vmin + 0.25 * dv - v) / dv;
	   } else if (v < (vmin + 0.75 * dv)) {
		  c.r = 4 * (v - vmin - 0.5 * dv) / dv;
		  c.b = 0;
	   } else {
		  c.g = 1 + 4 * (vmin + 0.75 * dv - v) / dv;
		  c.b = 0;
	   }
	
	   return ((c.r * 255) << 16 | (c.g * 255) << 8 | (c.b * 255));
	}
	
	function setIntensity(a_percent: Number)
	{
		intensity = a_percent;
		var newColor = new Color(this.inside);
		newColor.setRGB(getColor(a_percent,0.0,1.0));
	}

	function handleMouseRollOver(controllerIdx)
	{
		//setSelection(1.0);
	}

	function handleMouseRollOut(controllerIdx)
	{
		//setSelection(0.0);
	}

	function handleMousePress(controllerIdx, keyboardOrMouse, button)
	{
		//setSelection(0.5);
	}

	function handlePress(controllerIdx)
	{
		
	}

	function handleMouseRelease(controllerIdx, keyboardOrMouse, button)
	{
		//setSelection(0.0);
	}

	function handleRelease(controllerIdx)
	{
		
	}

	function handleClick(controllerIdx, button)
	{
		
	}

	function handleDragOver(controllerIdx, button)
	{
		
	}

	function handleDragOut(controllerIdx, button)
	{
		
	}

	function handleReleaseOutside(controllerIdx, button)
	{
		
	}
}
