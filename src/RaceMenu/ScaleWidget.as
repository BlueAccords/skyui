import flash.geom.*;

class ScaleWidget extends MovieClip
{
	public var xy_plane: MovieClip;
	public var yz_plane: MovieClip;
	public var xz_plane: MovieClip;
	public var xyz_plane: MovieClip;
	
	public var x_axis: MovieClip;
	public var y_axis: MovieClip;
	public var z_axis: MovieClip;
	
	public var x_text: TextField;
	public var y_text: TextField;
	public var z_text: TextField;
	
	public var innerSize: Number = 75;
	public var outerSize: Number = 125;
	
	public var colors: Array;
	
	private var _dragOffset: Object;

	function ScaleWidget()
	{
		colors = [0x0000FF, 0x00FF00, 0x00FF00, 0xFF0000, 0xFF0000, 0x0000FF, 0xFFFF00];
		
		drawWidget(this, innerSize, outerSize, colors);
		drawTextFields(this, innerSize, outerSize, colors);
		
		xy_plane = this.createEmptyMovieClip("xy_plane", this.getNextHighestDepth());
		fillXYPlane(xy_plane, innerSize, outerSize, colors[6]);
		xy_plane._alpha = 0;
		xy_plane.onRollOver = function() { _parent.highlightComponent("xy", true); };
		xy_plane.onRollOut =  function() { _parent.highlightComponent("xy", false); };
		xy_plane.onReleaseOutside = xy_plane.onRollOut;
		xy_plane.onPress =function() { trace("xy"); _parent.beginDrag({object: "xy"}); };
		
		yz_plane = this.createEmptyMovieClip("yz_plane", this.getNextHighestDepth());
		fillYZPlane(yz_plane, innerSize, outerSize, colors[6]);
		yz_plane._alpha = 0;
		yz_plane.onRollOver = function() { _parent.highlightComponent("yz", true); };
		yz_plane.onRollOut =  function() { _parent.highlightComponent("yz", false); };
		yz_plane.onReleaseOutside = yz_plane.onRollOut;
		yz_plane.onPress =function() { trace("yz"); _parent.beginDrag({object: "yz"}); };
		
		xz_plane = this.createEmptyMovieClip("xz_plane", this.getNextHighestDepth());
		fillXZPlane(xz_plane, innerSize, outerSize, colors[6]);
		xz_plane._alpha = 0;
		xz_plane.onRollOver = function() { _parent.highlightComponent("xz", true); };
		xz_plane.onRollOut =  function() { _parent.highlightComponent("xz", false); };
		xz_plane.onReleaseOutside = xz_plane.onRollOut;
		xz_plane.onPress =function() { trace("xz"); _parent.beginDrag({object: "xz"}); };
		
		xyz_plane = this.createEmptyMovieClip("xyz_plane", this.getNextHighestDepth());
		fillXYZPlane(xyz_plane, innerSize, outerSize, colors[6]);
		xyz_plane._alpha = 0;
		xyz_plane.onRollOver = function() { _parent.highlightComponent("xyz", true); };
		xyz_plane.onRollOut =  function() { _parent.highlightComponent("xyz", false); };
		xyz_plane.onReleaseOutside = xyz_plane.onRollOut;
		xyz_plane.onPress =function() { trace("xyz"); _parent.beginDrag({object: "xyz"}); };
		
		x_axis = this.createEmptyMovieClip("x_axis", this.getNextHighestDepth());
		drawXAxis(x_axis, innerSize, outerSize, colors[6]);
		x_axis._alpha = 0;
		x_axis.onRollOver = function() { _parent.highlightComponent("x", true); };
		x_axis.onRollOut =  function() { _parent.highlightComponent("x", false); };
		x_axis.onReleaseOutside = x_axis.onRollOut;
		x_axis.onPress =function() { trace("x"); _parent.beginDrag({object: "x"}); };
		
		y_axis = this.createEmptyMovieClip("y_axis", this.getNextHighestDepth());
		drawYAxis(y_axis, innerSize, outerSize, colors[6]);
		y_axis._alpha = 0;
		y_axis.onRollOver = function() { _parent.highlightComponent("y", true); };
		y_axis.onRollOut =  function() { _parent.highlightComponent("y", false); };
		y_axis.onReleaseOutside = y_axis.onRollOut;
		y_axis.onPress =function() { trace("y"); _parent.beginDrag({object: "y"}); };
		
		z_axis = this.createEmptyMovieClip("z_axis", this.getNextHighestDepth());
		drawZAxis(z_axis, innerSize, outerSize, colors[6]);
		z_axis._alpha = 0;
		z_axis.onRollOver = function() { _parent.highlightComponent("z", true); };
		z_axis.onRollOut =  function() { _parent.highlightComponent("z", false); };
		z_axis.onReleaseOutside = z_axis.onRollOut;
		z_axis.onPress =function() { trace("z"); _parent.beginDrag({object: "z"}); };
	}
	
	private function beginDrag(event)
	{
		onMouseMove = doDrag;
		onMouseUp = endDrag;
		
		_dragOffset = {x: _xmouse, y: _ymouse};
	}

	private function doDrag()
	{
		var diffX = _xmouse - _dragOffset.x;
		var diffY = _ymouse - _dragOffset.y;
		var d = Math.sqrt(Math.pow(diffX, 2) + Math.pow(diffY, 2));
		trace(d + " - X: " + diffX + " Y: " + diffY);
	}

	private function endDrag()
	{
		delete onMouseUp;
		delete onMouseMove;
	}
	
	function fillXYPlane(canvas, innerSize, outerSize, color)
	{
		var inside = Math.sqrt(3) / 3 * innerSize;
		var outside = Math.sqrt(3) / 3 * outerSize;
		with (canvas) {
			lineStyle(2.0, color, 100);
			moveTo(0,0);
			lineTo(-inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
			beginFill(color, 50);
			lineTo(-outside * Math.cos(Math.PI / 6), outside * Math.sin(Math.PI / 6));
			lineTo(outside * Math.cos(Math.PI / 6), outside * Math.sin(Math.PI / 6));
			lineTo(inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
			lineTo(-inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
			endFill();
			moveTo(0,0);
			lineTo(inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
		}
	}
	
	function fillXZPlane(canvas, innerSize, outerSize, color)
	{
		var inside = Math.sqrt(3) / 3 * innerSize;
		var outside = Math.sqrt(3) / 3 * outerSize;
		with (canvas) {
			lineStyle(2.0, color, 100);
			moveTo(0,0);
			lineTo(0, -inside);
			beginFill(color, 50);
			lineTo(0, -outside);
			lineTo(outside * Math.cos(Math.PI / 6), outside * Math.sin(Math.PI / 6));
			lineTo(inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
			endFill();
			moveTo(0,0);
			lineTo(inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
		}
	}
	
	function fillYZPlane(canvas, innerSize, outerSize, color)
	{
		var inside = Math.sqrt(3) / 3 * innerSize;
		var outside = Math.sqrt(3) / 3 * outerSize;
		with (canvas) {
			lineStyle(2.0, color, 100);
			moveTo(0,0);
			lineTo(0, -inside);
			beginFill(color, 50);
			lineTo(0, -outside);
			lineTo(-outside * Math.cos(Math.PI / 6), outside * Math.sin(Math.PI / 6));
			lineTo(-inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
			endFill();
			moveTo(0,0);
			lineTo(-inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
		}
	}
	
	function fillXYZPlane(canvas, innerSize, outerSize, color)
	{
		var inside = Math.sqrt(3) / 3 * innerSize;
		var outside = Math.sqrt(3) / 3 * outerSize;
		with (canvas) {
			lineStyle(2.0, color, 100);
			moveTo(0,-inside);
			beginFill(color, 50);
			lineTo(-inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
			lineTo(inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
			lineTo(0, -inside);
			endFill();
			moveTo(0,0);
			lineTo(0,-inside);
			moveTo(0,0);
			lineTo(-inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));
			moveTo(0,0);
			lineTo(inside * Math.cos(Math.PI / 6), inside * Math.sin(Math.PI / 6));			
		}
	}
	
	function drawTriangle(canvas, size, colors)
	{
		var px;
		var py;
		var d = Math.sqrt(3) / 3 * size;
		
		with (canvas)
		{
			px = 0; py = -d;
			moveTo(px, py);
			
			px += size/2 * Math.cos(Math.PI / 3);
			py += size/2 * Math.sin(Math.PI / 3);
			lineStyle(1, colors[0], 100);
			lineTo(px, py);
			
			px += size/2 * Math.cos(Math.PI / 3);
			py += size/2 * Math.sin(Math.PI / 3);
			lineStyle(1, colors[1], 100); lineTo(px, py);
			
			px -= size/2;
			lineStyle(1, colors[2], 100); lineTo(px, py);
			
			px -= size/2;
			lineStyle(1, colors[3], 100); lineTo(px, py);
			
			px += size/2 * Math.cos(Math.PI / 3);
			py -= size/2 * Math.sin(Math.PI / 3);
			lineStyle(1, colors[4], 100); lineTo(px, py);
			
			px += size/2 * Math.cos(Math.PI / 3);
			py -= size/2 * Math.sin(Math.PI / 3);
			lineStyle(1, colors[5], 100); lineTo(px, py);
		}
	}
	
	function drawWidget(canvas, innerSize, outerSize, colors)
	{
		drawTriangle(canvas, innerSize, colors);
		drawTriangle(canvas, outerSize, colors);
		
		var px;
		var py;
		var d = Math.sqrt(3) / 3 * outerSize + 20;
		
		with (canvas)
		{
			// Z
			moveTo(0, 0);
			lineStyle(1, colors[0], 100);
			lineTo(0, -d );
			
			// Y
			moveTo(0, 0);
			lineStyle(1, colors[2], 100);
			lineTo(d * Math.cos(Math.PI / 6), d * Math.sin(Math.PI / 6));
			
			// X
			moveTo(0, 0);
			lineStyle(1, colors[4], 100);
			lineTo(-d * Math.cos(Math.PI / 6), d * Math.sin(Math.PI / 6));
		}
	}
	
	function drawTextFields(canvas, innerSize, outerSize, colors)
	{
		var d = Math.sqrt(3) / 3 * outerSize + 20;
		
		var x_text = canvas.createTextField("x_text", canvas.getNextHighestDepth(), d * Math.cos(Math.PI / 6), d * Math.sin(Math.PI / 6), 32, 32);
		with(x_text) {
			var format:TextFormat = new TextFormat();
			format.font = "$EverywhereMediumFont";
			format.size = 25;
			format.bold = true;
			format.align = "center";
			text = "X";
			textColor = colors[2];
			selectable = false;
			setTextFormat(format);
		}
		
		var y_text = canvas.createTextField("y_text", canvas.getNextHighestDepth(), -d * Math.cos(Math.PI / 6) - 32, d * Math.sin(Math.PI / 6), 32, 32);
		with(y_text) {
			var format:TextFormat = new TextFormat();
			format.font = "$EverywhereMediumFont";
			format.size = 25;
			format.bold = true;
			format.align = "center";
			text = "Y";
			textColor = colors[4];
			selectable = false;
			setTextFormat(format);
		}
		
		var z_text = canvas.createTextField("z_text", canvas.getNextHighestDepth(), -16, -d - 36, 32, 32);
		with(z_text) {
			var format:TextFormat = new TextFormat();
			format.font = "$EverywhereMediumFont";
			format.size = 25;
			format.bold = true;
			format.align = "center";
			text = "Z";
			textColor = colors[0];
			selectable = false;
			setTextFormat(format);
		}
	}
	
	function highlightComponent(a_selected: String, a_show: Boolean)
	{
		switch(a_selected)
		{
			case "x":
			this["x_axis"]._alpha = a_show ? 100 : 0;
			this["x_text"].textColor = a_show ? colors[6] : colors[2];
			break;
			
			case "y":
			this["y_axis"]._alpha = a_show ? 100 : 0;
			this["y_text"].textColor = a_show ? colors[6] : colors[4];
			break;
			
			case "z":
			this["z_axis"]._alpha = a_show ? 100 : 0;
			this["z_text"].textColor = a_show ? colors[6] : colors[0];
			break;
			
			case "xy":
			this["xy_plane"]._alpha = a_show ? 100 : 0;
			this["x_text"].textColor = a_show ? colors[6] : colors[2];
			this["y_text"].textColor = a_show ? colors[6] : colors[4];
			break;
			
			case "xz":
			this["xz_plane"]._alpha = a_show ? 100 : 0;
			this["x_text"].textColor = a_show ? colors[6] : colors[2];
			this["z_text"].textColor = a_show ? colors[6] : colors[0];
			break;
			
			case "yz":
			this["yz_plane"]._alpha = a_show ? 100 : 0;
			this["y_text"].textColor = a_show ? colors[6] : colors[4];
			this["z_text"].textColor = a_show ? colors[6] : colors[0];
			break;
			
			case "xyz":
			this["xyz_plane"]._alpha = a_show ? 100 : 0;
			this["x_text"].textColor = a_show ? colors[6] : colors[2];
			this["y_text"].textColor = a_show ? colors[6] : colors[4];
			this["z_text"].textColor = a_show ? colors[6] : colors[0];
			break;
		}
	}
	
	function drawYAxis(canvas, innerSize, outerSize, color)
	{
		var d = Math.sqrt(3) / 3 * outerSize + 20;
		var s = 2;
		with (canvas)
		{
			// Draw invisible selection box
			lineStyle(1, 0, 0);
			beginFill(0, 0);
			moveTo(0, 0);
			lineTo(-s, -s);
			lineTo(-s + -d * Math.cos(Math.PI / 6), -s + d * Math.sin(Math.PI / 6));
			lineTo(-d * Math.cos(Math.PI / 6), d * Math.sin(Math.PI / 6));
			lineTo(s + -d * Math.cos(Math.PI / 6), s + d * Math.sin(Math.PI / 6));
			lineTo(s, s);
			endFill();
			
			moveTo(0, 0);
			lineStyle(3, color, 100);
			lineTo(-d * Math.cos(Math.PI / 6), d * Math.sin(Math.PI / 6));
		}
	}
	
	function drawXAxis(canvas, innerSize, outerSize, color)
	{
		var d = Math.sqrt(3) / 3 * outerSize + 20;
		var s = 2;
		with (canvas)
		{
			// Draw invisible selection box
			lineStyle(1, 0, 0);
			beginFill(0, 0);
			moveTo(0, 0);
			lineTo(s, -s);
			lineTo(s + d * Math.cos(Math.PI / 6), -s + d * Math.sin(Math.PI / 6));
			lineTo(d * Math.cos(Math.PI / 6), d * Math.sin(Math.PI / 6));
			lineTo(-s + d * Math.cos(Math.PI / 6), s + d * Math.sin(Math.PI / 6));
			lineTo(-s, s);
			endFill();
			
			moveTo(0, 0);
			lineStyle(3, color, 100);
			lineTo(d * Math.cos(Math.PI / 6), d * Math.sin(Math.PI / 6));
		}
	}
	
	function drawZAxis(canvas, innerSize, outerSize, color)
	{
		var d = Math.sqrt(3) / 3 * outerSize + 20;
		var s = 3;
		with (canvas)
		{
			// Draw invisible selection box
			lineStyle(1, 0, 0);
			beginFill(0, 0);
			moveTo(0, 0);
			lineTo(0, -d);
			lineTo(-s, -d);
			lineTo(-s, 0);
			lineTo(s, 0);
			lineTo(s, -d);
			lineTo(0, -d);
			endFill();
			
			lineStyle(3, color, 100);
			moveTo(0, 0);
			lineTo(0, -d);
		}
	}
};