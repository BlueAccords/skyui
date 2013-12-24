import flash.geom.*;

class SelectionBrush extends MovieClip
{
	public var radius: Number = 50.0;
	public var hardness: Number = 50.0;
	public var color: Number = 0xFFFFFF;
	
	private var shape: MovieClip;
	
	function SelectionBrush()
	{
		drawBrush();
	}
	
	function moveBrush(x: Number, y: Number)
	{
		this._x = x;
		this._y = y;
	}
	
	function intensity(fx: Number)
	{
		return 1.0 - fx / radius;
	}
	
	function drawBrush()
	{
		if(!shape)
			shape = this.createEmptyMovieClip("shape", this.getNextHighestDepth());
		else
			shape.clear();
		
		shape.matrix = new Matrix();
		shape.matrix.createGradientBox(radius*2, radius*2, 0, 0, 0);
		var hardnessRatio = (hardness / 100.0) * 0xFF - 1;
		shape.beginGradientFill("radial", [color, color, color], [100, hardness, 0], [0, hardnessRatio, 0xFF], shape.matrix, "pad", "linearRGB");
		shape.moveTo(0, 0);
		shape.lineTo(0, radius*2);
		shape.lineTo(radius*2, radius*2);
		shape.lineTo(radius*2, 0);
		shape.lineTo(0, 0);
		shape.endFill();
		shape._x = -radius;
		shape._y = -radius;

	}
};