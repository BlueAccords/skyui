class HudMeters extends MovieClip
{
	public var ready: Boolean;
	private var _meterContainer: MovieClip;
	private var _mcl: MovieClipLoader;
	
	private var _config;
	
	private var _primaryColorDefault: Number = 0xFF0000;
	private var _secondaryColorDefault: Number = -1;
	private var _flashColorDefault: Number = -1;
	
	private var _primaryFriendlyColorDefault: Number = -1;
	private var _secondaryFriendlyColorDefault: Number = -1;
	private var _flashFriendlyColorDefault: Number = -1;
	
	private var _fillDirectionDefault: Number = 2;

	public function HudMeters()
	{
		_mcl = new MovieClipLoader();
		_mcl.addListener(this);

		ready = false;
		HudConfig.registerLoadCallback(this, "onConfigLoad");
		/*
		//this["All"] = false;
		this["Favor"] = true;
		this["MovementDisabled"] = true;
		this["Swimming"] = true;
		this["WarhorseMode"] = true;
		this["HorseMode"] = true;
		//this["InventoryMode"] = false;
		//this["BookMode"] = false;
		this["DialogueMode"] = true;
		this["StealthMode"] = true;
		//this["SleepWaitMode"] = false;
		//this["BarterMode"] = false;
		//this["TweenMode"] = false;
		//this["WorldMapMode"] = false;
		//this["JournalMode"] = false;
		this["CartMode"] = true;
		this["VATSPlayback"] = true;
		_root.HUDMovieBaseInstance.HudElements.push(this);
		*/
	}

	public function initialize(a_meterContainer: MovieClip): Void
	{
		_meterContainer = a_meterContainer;
		_mcl.loadClip("meter.swf", _meterContainer);
	}
	
	private function onConfigLoad(event: Object): Void
	{
		setConfig(event.config);
	}
	
	public function setConfig(a_config: Object): Void
	{
		_config = a_config;
		var general = a_config["General"];
		_primaryColorDefault = general.colors.hostile.primary;
		_secondaryColorDefault = general.colors.hostile.secondary;
		_flashColorDefault = general.colors.hostile.flash;
		_primaryFriendlyColorDefault = general.colors.friendly.primary;
		_secondaryFriendlyColorDefault = general.colors.friendly.secondary;
		_flashFriendlyColorDefault = general.colors.friendly.flash;
	}

	public function loadMeter(a_meterId: Number, a_flags: Number, a_percent: Number, a_primaryColor: Number, a_secondaryColor: Number, a_flashColor: Number, a_primaryFriendlyColor: Number, a_secondaryFriendlyColor: Number, a_flashFriendlyColor: Number, a_fillDirection: Number): MovieClip
	{
		var flags: Number = (a_flags != null) ? a_flags : 0;
		var percent: Number = (a_percent != null) ? a_percent : 0.5;
		
		var primaryColor: Number = (a_primaryColor != null) ? a_primaryColor : _primaryColorDefault;
		var secondaryColor: Number = (a_secondaryColor != null) ? a_secondaryColor : _secondaryColorDefault;
		var flashColor: Number = (a_flashColor != null) ? a_flashColor : _flashColorDefault;
		
		var primaryFriendlyColor: Number = (a_primaryFriendlyColor != null) ? a_primaryFriendlyColor : _primaryFriendlyColorDefault;
		var secondaryFriendlyColor: Number = (a_secondaryFriendlyColor != null) ? a_secondaryFriendlyColor : _secondaryFriendlyColorDefault;
		var flashFriendlyColor: Number = (a_flashFriendlyColor != null) ? a_flashFriendlyColor : _flashFriendlyColorDefault;
		
		var fillDirection: Number = (a_fillDirection != null) ? a_fillDirection : _fillDirectionDefault;

		var meterIdStr: String = a_meterId.toString();
		var meterHolder = _meterContainer.createEmptyMovieClip(meterIdStr, _meterContainer.getNextHighestDepth());
		var meter = meterHolder.attachMovie("Meter", "Meter", meterHolder.getNextHighestDepth(), null);
		meter.setPercent(percent, true);
		meter["flags"] = flags;
		meter["isFriendly"] = function(): Boolean
		{
			return (this.flags & 128) == 128;
		}
		
		if(!meter.isFriendly())
			meter.setColors(primaryColor, secondaryColor, flashColor);
		else
			meter.setColors(primaryFriendlyColor, secondaryFriendlyColor, flashFriendlyColor);
			
		meter["setColorsDefault"] = meter["setColors"];
		meter["setColors"] = function(a_primaryColor: Number, a_secondaryColor: Number, a_flashColor: Number)
		{
			var hudExtension = _root.hudExtension.hudMeters;
						
			var primaryColor: Number = hudExtension["_primaryColorDefault"];
			var secondaryColor: Number = hudExtension["_secondaryColorDefault"];
			var flashColor: Number = hudExtension["_flashColorDefault"];
			
			if(this.isFriendly()) {
				primaryColor = hudExtension["_primaryFriendlyColorDefault"];
				secondaryColor = hudExtension["_secondaryFriendlyColorDefault"];
				flashColor = hudExtension["_flashFriendlyColorDefault"];
			}
			
			var colors: Array = [(a_primaryColor != null) ? a_primaryColor : primaryColor,
								(a_secondaryColor != null) ? a_secondaryColor : secondaryColor,
								(a_flashColor != null) ? a_flashColor : flashColor];
						
			this.setColorsDefault(colors[0], colors[1], colors[2]);
		}
			
		meter.setFillDirection(fillDirection, true);
		

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

	/* PRIVATE FUNCTIONS */

	private function onLoadInit(a_targetClip: MovieClip): Void
	{
		ready = true;
		a_targetClip["All"] = true;
		a_targetClip["Favor"] = true;
		a_targetClip["MovementDisabled"] = true;
		a_targetClip["Swimming"] = true;
		a_targetClip["WarhorseMode"] = true;
		a_targetClip["HorseMode"] = true;
		//a_targetClip["InventoryMode"] = false;
		//a_targetClip["BookMode"] = false;
		a_targetClip["DialogueMode"] = true;
		a_targetClip["StealthMode"] = true;
		//a_targetClip["SleepWaitMode"] = false;
		//a_targetClip["BarterMode"] = false;
		//a_targetClip["TweenMode"] = false;
		//a_targetClip["WorldMapMode"] = false;
		//a_targetClip["JournalMode"] = false;
		a_targetClip["CartMode"] = true;
		a_targetClip["VATSPlayback"] = true;
		_root.HUDMovieBaseInstance.HudElements.push(a_targetClip);
	}
}