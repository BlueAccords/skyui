import flash.geom.Matrix;

import gfx.events.EventDispatcher;
import gfx.controls.Slider;
import gfx.controls.Button;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;

import skyui.util.ColorFunctions;


class HSVSelector extends MovieClip {
	/* STAGE ELEMENTS */
	public var sliders: MovieClip;
  
	public var hSlider: Slider;
	public var sSlider: Slider;
	public var vSlider: Slider;
	public var currentColor: MovieClip;
	private var _color: Number;
	
	private var dispatchEvent: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;
	

  /* PRIVATE VARIABLES */

	private var _hsv: Array;

	function HSVSelector()
	{
		hSlider = sliders.hSlider;
		sSlider = sliders.sSlider;
		vSlider = sliders.vSlider;
		setupGradients();
		EventDispatcher.initialize(this);
	}

	public function onLoad(): Void
	{
		hSlider.minimum = 0;
		hSlider.maximum = 360;
		hSlider.liveDragging = true;

		sSlider.minimum = 0;
		sSlider.maximum = 100;
		sSlider.liveDragging = true;

		vSlider.minimum = 0;
		vSlider.maximum = 100;
		vSlider.liveDragging = true;

		hSlider.addEventListener("change", this, "onHSliderChange");
		sSlider.addEventListener("change", this, "onSSliderChange");
		vSlider.addEventListener("change", this, "onVSliderChange");
		
		setColor(0x000000);
	}

	public function setColor(a_color: Number): Void
	{
		_hsv = ColorFunctions.hexToHsv(a_color);
		var satRGB: Number = ColorFunctions.hsvToHex([_hsv[0], 100, _hsv[2]]);
		var valRGB: Number = ColorFunctions.hsvToHex([_hsv[0], _hsv[1], 100]);

		hSlider.track.trackWhite._alpha = 100 - _hsv[1]; //hue.white
		hSlider.track.trackBlack._alpha = 100 - _hsv[2]; //hue.black
		
		sSlider.track.trackBlack._alpha = 100 - _hsv[2]; //sat.black

		vSlider.track.trackWhite._alpha = 100 - _hsv[1]; //val.white
		
		var colorOverlay: Color = new Color(sSlider.track.trackColor);
		colorOverlay.setRGB(satRGB);
		colorOverlay = new Color(vSlider.track.trackColor);
		colorOverlay.setRGB(valRGB);
		colorOverlay = new Color(currentColor);
		colorOverlay.setRGB(a_color);

		hSlider.value = _hsv[0];
		sSlider.value = _hsv[1];
		vSlider.value = _hsv[2];
		_color = a_color;
	}

	public function onHSliderChange(a_event: Object): Void
	{
		var newHue: Number = a_event.target.value;
		_hsv[0] = newHue;

		var newRGB: Number = ColorFunctions.hsvToHex(_hsv);
		var satRGB: Number = ColorFunctions.hsvToHex([_hsv[0], 100, _hsv[2]]);
		var valRGB: Number = ColorFunctions.hsvToHex([_hsv[0], _hsv[1], 100]);

		var colorOverlay: Color = new Color(sSlider.track.trackColor);
		colorOverlay.setRGB(satRGB);
		colorOverlay = new Color(vSlider.track.trackColor);
		colorOverlay.setRGB(valRGB);
		colorOverlay = new Color(currentColor);
		colorOverlay.setRGB(newRGB);
		_color = newRGB;
		dispatchEvent({type: "changeColor", color: _color});
	}

	public function onSSliderChange(a_event: Object): Void
	{
		var newSat: Number = a_event.target.value;
		_hsv[1] = newSat;

		var newRGB: Number = ColorFunctions.hsvToHex(_hsv);
		var valRGB: Number = ColorFunctions.hsvToHex([_hsv[0], _hsv[1], 100]);

		hSlider.track.trackWhite._alpha = 100 - _hsv[1]; //hue.white
		vSlider.track.trackWhite._alpha = 100 - _hsv[1]; //val.white

		var colorOverlay: Color = new Color(vSlider.track.trackColor);
		colorOverlay.setRGB(valRGB);
		colorOverlay = new Color(currentColor);
		colorOverlay.setRGB(newRGB);
		_color = newRGB;
		dispatchEvent({type: "changeColor", color: _color});
	}

	public function onVSliderChange(a_event: Object): Void
	{
		var newVal: Number = a_event.target.value;
		_hsv[2] = newVal;

		var newRGB: Number = ColorFunctions.hsvToHex(_hsv);
		var satRGB: Number = ColorFunctions.hsvToHex([_hsv[0], 100, _hsv[2]]);

		hSlider.track.trackBlack._alpha = 100 - _hsv[2]; //hue.black
		sSlider.track.trackBlack._alpha = 100 - _hsv[2]; //sat.black

		var colorOverlay: Color = new Color(sSlider.track.trackColor);
		colorOverlay.setRGB(satRGB);
		colorOverlay = new Color(currentColor);
		colorOverlay.setRGB(newRGB);
		_color = newRGB;
		dispatchEvent({type: "changeColor", color: _color});
	}

	public function getColor(): Number
	{
		return _color;
	}

  /* PRIVATE FUNCTIONS */
	private function setupGradients(): Void
	{
		var hTrack: Button = hSlider.track;
		var sTrack: Button = sSlider.track;
		var vTrack: Button = vSlider.track;

		var width: Number;
		var height: Number;

		var colors: Array;
		var alphas: Array;
		var ratios: Array;
		var matrix: Matrix;

		var trackColor: MovieClip;
		var trackWhite: MovieClip;
		var trackBlack: MovieClip;

		//------------------------------------------------------------------------------------------
		// Hue Slider
		width = hTrack._width;
		height = hTrack._height;

		colors = [0xFF0000, 0xFFFF00, 0x00FF00, 0x00FFFF, 0x0000FF, 0xFF00FF, 0xFF0000];
		alphas = [100, 100, 100, 100, 100, 100, 100];
		ratios = [0, 42.5, 85, 127.5, 170, 212.5, 255];
		matrix = new Matrix();
		matrix.createGradientBox(width, height);

		trackColor = hTrack.createEmptyMovieClip("trackColor", hTrack.getNextHighestDepth());
		trackColor.beginGradientFill("linear", colors, alphas, ratios, matrix);
		trackColor.moveTo(0, 0);
		trackColor.lineTo(0, height);
		trackColor.lineTo(width, height);
		trackColor.lineTo(width, 0);
		trackColor.lineTo(0, 0);
		trackColor.endFill();

		trackWhite = hTrack.createEmptyMovieClip("trackWhite", hTrack.getNextHighestDepth());
		trackWhite.beginFill(0xFFFFFF);
		trackWhite.moveTo(0, 0);
		trackWhite.lineTo(0, height);
		trackWhite.lineTo(width, height);
		trackWhite.lineTo(width, 0);
		trackWhite.lineTo(0, 0);
		trackWhite.endFill();

		trackBlack = hTrack.createEmptyMovieClip("trackBlack", hTrack.getNextHighestDepth());
		trackBlack.beginFill(0x000000);
		trackBlack.moveTo(0, 0);
		trackBlack.lineTo(0, height);
		trackBlack.lineTo(width, height);
		trackBlack.lineTo(width, 0);
		trackBlack.lineTo(0, 0);
		trackBlack.endFill();

		//------------------------------------------------------------------------------------------
		// Saturation Slider
		width = sTrack._width;
		height = sTrack._height;

		trackColor = sTrack.createEmptyMovieClip("trackColor", sTrack.getNextHighestDepth());
		trackColor.beginFill(0x000000);
		trackColor.moveTo(0,0);
		trackColor.lineTo(width, 0);
		trackColor.lineTo(width, height);
		trackColor.lineTo(0, height);
		trackColor.lineTo(0, 0);
		trackColor.endFill();

		colors = [0xFFFFFF, 0x000000];
		alphas = [100, 0];
		ratios = [0, 255];
		matrix = new Matrix();
		matrix.createGradientBox(width, height);

		trackWhite = sTrack.createEmptyMovieClip("trackWhite", sTrack.getNextHighestDepth());
		trackWhite.beginGradientFill("linear", colors, alphas, ratios, matrix);
		trackWhite.moveTo(0,0);
		trackWhite.lineTo(width, 0);
		trackWhite.lineTo(width, height);
		trackWhite.lineTo(0, height);
		trackWhite.lineTo(0, 0);
		trackWhite.endFill();
		
		trackBlack = sTrack.createEmptyMovieClip("trackBlack", sTrack.getNextHighestDepth());
		trackBlack.beginFill(0x000000);
		trackBlack.moveTo(0,0);
		trackBlack.lineTo(width, 0);
		trackBlack.lineTo(width, height);
		trackBlack.lineTo(0, height);
		trackBlack.lineTo(0, 0);
		trackBlack.endFill();

		//------------------------------------------------------------------------------------------
		// Value Slider
		width = vTrack._width;
		height = vTrack._height;

		trackColor = vTrack.createEmptyMovieClip("trackColor", vTrack.getNextHighestDepth());
		trackColor.beginFill(0x000000);
		trackColor.moveTo(0,0);
		trackColor.lineTo(width, 0);
		trackColor.lineTo(width, height);
		trackColor.lineTo(0, height);
		trackColor.lineTo(0, 0);
		trackColor.endFill();
		
		trackWhite = vTrack.createEmptyMovieClip("trackWhite", vTrack.getNextHighestDepth());
		trackWhite.beginFill(0xFFFFFF);
		trackWhite.moveTo(0,0);
		trackWhite.lineTo(width, 0);
		trackWhite.lineTo(width, height);
		trackWhite.lineTo(0, height);
		trackWhite.lineTo(0, 0);
		trackWhite.endFill();

		colors = [0x000000, 0x000000];
		alphas = [100, 0];
		ratios = [0, 255];
		matrix = new Matrix();
		matrix.createGradientBox(width, height);

		trackBlack = vTrack.createEmptyMovieClip("trackBlack", vTrack.getNextHighestDepth());
		trackBlack.beginGradientFill("linear", colors, alphas, ratios, matrix);
		trackBlack.moveTo(0,0);
		trackBlack.lineTo(width, 0);
		trackBlack.lineTo(width, height);
		trackBlack.lineTo(0, height);
		trackBlack.lineTo(0, 0);
		trackBlack.endFill();
	}
}