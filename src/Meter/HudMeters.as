class HudMeters extends MovieClip
{
	public var ready: Boolean;

	private var _meterContainer: MovieClip;

	private var _mcl: MovieClipLoader;

	public function HudMeters()
	{
		_mcl = new MovieClipLoader();
		_mcl.addListener(this);

		ready = false;
	}

	public function initialize(a_meterContainer: MovieClip): Void
	{
		_meterContainer = a_meterContainer;
		_mcl.loadClip("meter.swf", _meterContainer);
	}

	public function loadMeter(a_meterId: Number, a_flags: Number, a_percent: Number, a_primaryColor: Number, a_secondaryColor: Number, a_flashColor: Number, a_fillDirection: Number): MovieClip
	{
		var flags: Number = (a_flags != null) ? a_flags : 0;
		var percent: Number = (a_percent != null) ? a_percent : 0.5;
		var primaryColor: Number = (a_primaryColor != null) ? a_primaryColor : _primaryColorDefault;
		var secondaryColor: Number = (a_secondaryColor != null) ? a_secondaryColor : _secondaryColorDefault;
		var flashColor: Number = (a_flashColor != null) ? a_flashColor : _flashColorDefault;
		var fillDirection: Number = (a_fillDirection != null) ? a_fillDirection : _fillDirectionDefault;

		var meterIdStr: String = a_meterId.toString();
		var meterHolder = _meterContainer.createEmptyMovieClip(meterIdStr, _meterContainer.getNextHighestDepth());
		var meter = meterHolder.attachMovie("Meter", "Meter", meterHolder.getNextHighestDepth(), null);
		meter.setPercent(percent, true);
		meter.setColors(primaryColor, secondaryColor, flashColor);
		meter.setFillDirection(fillDirection, true);
		meter["flags"] = flags;

		meter._x -= meter._width/2;
		meter._y -= meter._height/2;

		meterHolder._x = -Stage.width;
		meterHolder._y = -Stage.height;
		return meterHolder;
	}

	public function unloadMeter(a_meterId: Number): Boolean
	{
		var meter: MovieClip = _meterContainer[a_meterId.toString()];

		if (meter == undefined)
			return false;

		meter.removeMovieClip();
		delete(meter);
		return true;
	}

	public function sortMeterDepths(a_meterData: Array): Void
	{
		// array[{id: 0, zPos: 0}]
		var meterData = a_meterData.sortOn(["zIndex"], Array.DESCENDING);
		for (var i: Number = 0; i < meterData.length; i++)
		{
			var meter: MovieClip = _meterContainer[meterData[i].id.toString()];
			meter.swapDepths(i);
		}
	}


	// TODO: Make in to an array of objects, index can be enum for RED, GREEN, BLUE for example
	private var _primaryColorDefault: Number = 0xFF0000;
	private var _secondaryColorDefault: Number = -1;
	private var _flashColorDefault: Number = -1;
	private var _fillDirectionDefault: Number = 2;

	public function setDefaults(a_primaryColor: Number, a_secondaryColor: Number, a_flashColor: Number, a_fillDirection: Number): Void
	{
		_primaryColorDefault = (a_primaryColor != null) ? a_primaryColor : 0xFF0000;
		_secondaryColorDefault = (a_secondaryColor != null) ? a_secondaryColor : -1; // -1 is auto
		_flashColorDefault = (a_flashColor != null) ? a_flashColor : -1; // -1 is auto
		_fillDirectionDefault = (a_fillDirection != null) ? a_fillDirection : 2;
	}


	/* PRIVATE FUNCTIONS */

	private function onLoadInit(a_targetClip: MovieClip): Void
	{
		ready = true;
	}
}