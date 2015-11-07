class FloatingWidgets extends MovieClip
{
	public var ready: Boolean;
	private var _widgetContainer: MovieClip;
	private var _mcl: MovieClipLoader;
	
	private var _config;
	// Color Defaults for Enemy colors. 

	// FloatingWidgets.as is the class that holds ALL widgets, dont ever change that class 


	// Health Colors
	private var _primaryHealthColorDefault: Number = 0xFF0000;
	private var _secondaryHealthColorDefault: Number = -1;
	private var _flashHealthColorDefault: Number = -1;

	// Magicka Colors
	private var _primaryMagickaColorDefault: Number = 0x00FF00;
	private var _secondaryMagickaColorDefault: Number = -1;
	private var _flashMagickaColorDefault: Number = -1;

	// Stamina Colors
	private var _primaryStaminaColorDefault: Number = 0x0000FF;
	private var _secondaryStaminaColorDefault: Number = -1;
	private var _flashStaminaColorDefault: Number = -1;	
	
	// Friendly Color Defaults

	// Health
	private var _primaryHealthFriendlyColorDefault: Number = -1;
	private var _secondaryHealthFriendlyColorDefault: Number = -1;
	private var _flashHealthFriendlyColorDefault: Number = -1;
	
	// Magicka
	private var _primaryMagickaFriendlyColorDefault: Number = -1;
	private var _secondaryMagickaFriendlyColorDefault: Number = -1;
	private var _flashMagickaFriendlyColorDefault: Number = -1;

	// Stamina
	private var _primaryStaminaFriendlyColorDefault: Number = -1;
	private var _secondaryStaminaFriendlyColorDefault: Number = -1;
	private var _flashStaminaFriendlyColorDefault: Number = -1;

	// Fill Direction

	// Health
	private var _fillHealthDirectionDefault: String = "both";
	// Magicka
	private var _fillMagickaDirectionDefault: String = "both";
	// Stamina
	private var _fillStaminaDirectionDefault: String = "both";

	// Meter widght, height, xy offsets, visible, and flags

	// Health
	private var _meterHealthWidth: Number = 432.9;
	private var _meterHealthHeight: Number = 36.0;
	private var _meterHealthXOffset: Number = 0;
	private var _meterHealthYOffset: Number = 0;
	private var _meterHealthVisible: Boolean = true;
	private var _flags: Number = 0;

	// Magicka
	private var _meterMagickaWidth: Number = 432.9;
	private var _meterMagickaHeight: Number = 36.0;
	private var _meterMagickaXOffset: Number = 0;
	private var _meterMagickaYOffset: Number = 0;
	private var _meterMagickaVisible: Boolean = true;

	// Stamina
	private var _meterStaminaWidth: Number = 432.9;
	private var _meterStaminaHeight: Number = 36.0;
	private var _meterStaminaXOffset: Number = 0;
	private var _meterStaminaYOffset: Number = 0;
	private var _meterStaminaVisible: Boolean = true;
	
	// Name stats(probably only need one set)	
	private var _nameSize: Number = 72;
	private var _nameColorHostile: Number = 0xFFFFFF;
	private var _nameColorFriendly: Number = 0xFFFFFF;	
	private var _nameAlignment: String = "center";
	private var _nameAutoSize: String = "center";
	private var _nameXOffset: Number = 0;
	private var _nameYOffset: Number = -60;
	private var _nameVisible: Boolean = true;
	
	// May need to change these stats
	// "health" stats

	// health
	private var _healthSize: Number = 40;
	private var _healthColorHostile: Number = 0xFFFFFF;
	private var _healthColorFriendly: Number = 0xFFFFFF;
	private var _healthAlignment: String = "center";
	private var _healthAutoSize: String = "center";
	private var _healthXOffset: Number = 0;
	private var _healthYOffset: Number = -8;
	private var _healthVisible: Boolean = true;

	// Magicka
	private var _magickaSize: Number = 40;
	private var _magickaColorHostile: Number = 0xFFFFFF;
	private var _magickaColorFriendly: Number = 0xFFFFFF;
	private var _magickaAlignment: String = "center";
	private var _magickaAutoSize: String = "center";
	private var _magickaXOffset: Number = 0;
	private var _magickaYOffset: Number = -8;
	private var _magickaVisible: Boolean = true;

	// Stamina
	private var _staminaSize: Number = 40;
	private var _staminaColorHostile: Number = 0xFFFFFF;
	private var _staminaColorFriendly: Number = 0xFFFFFF;
	private var _staminaAlignment: String = "center";
	private var _staminaAutoSize: String = "center";
	private var _staminaXOffset: Number = 0;
	private var _staminaYOffset: Number = -8;
	private var _staminaVisible: Boolean = true;


	public function FloatingWidgets()
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

	public function initialize(a_widgetContainer: MovieClip): Void
	{
		_widgetContainer = a_widgetContainer;
		_mcl.loadClip("floatingwidget.swf", _widgetContainer);
	}
	
	private function onConfigLoad(event: Object): Void
	{
		setConfig(event.config);
		skse.plugins.HudExtension.SetHUDFlags(_flags);
	}
		
	public function setConfig(a_config: Object): Void
	{
		_config = a_config;
		var healthbar = a_config["Healthbar"];
		_primaryColorDefault = healthbar.color.hostile.primary;
		_secondaryColorDefault = healthbar.color.hostile.secondary;
		_flashColorDefault = healthbar.color.hostile.flash;
		_primaryFriendlyColorDefault = healthbar.color.friendly.primary;
		_secondaryFriendlyColorDefault = healthbar.color.friendly.secondary;
		_flashFriendlyColorDefault = healthbar.color.friendly.flash;
		_fillDirectionDefault = healthbar.fillDirection;
		
		_meterWidth = healthbar.dimensions.width;
		_meterHeight = healthbar.dimensions.height;
		_meterVisible = healthbar.visible;
		_meterXOffset = healthbar.x;
		_meterYOffset = healthbar.y;
		
		var texts = a_config["Texts"];
		_nameColorHostile = texts.name.color.hostile;
		_nameColorFriendly = texts.name.color.friendly;
		_nameSize = texts.name.size;
		_nameAlignment = texts.name.alignment;
		_nameAutoSize = texts.name.autoSize;
		_nameXOffset = texts.name.x;
		_nameYOffset = texts.name.y;
		_nameVisible = texts.name.visible;
		// health
		_healthColorHostile = texts.health.color.hostile;
		_healthColorFriendly = texts.health.color.friendly;
		_healthSize = texts.health.size;
		_healthAlignment = texts.health.alignment;
		_healthAutoSize = texts.health.autoSize;
		_healthXOffset = texts.health.x;
		_healthYOffset = texts.health.y;
		_healthVisible = texts.health.visible;
		// magicka
		_magickaColorHostile = texts.health.color.hostile;
		_magickaColorFriendly = texts.health.color.friendly;
		_magickaSize = texts.health.size;
		_magickaAlignment = texts.health.alignment;
		_magickaAutoSize = texts.health.autoSize;
		_magickaXOffset = texts.health.x;
		_magickaYOffset = texts.health.y;
		_magickaVisible = texts.health.visible;
		// stamina
		_staminaColorHostile = texts.health.color.hostile;
		_staminaColorFriendly = texts.health.color.friendly;
		_staminaSize = texts.health.size;
		_staminaAlignment = texts.health.alignment;
		_staminaAutoSize = texts.health.autoSize;
		_staminaXOffset = texts.health.x;
		_staminaYOffset = texts.health.y;
		_staminaVisible = texts.health.visible;

		var behavior = a_config["Behavior"];
		_flags = behavior.flags;
	}

	public function loadWidget(a_meterId: Number, a_flags: Number, a_current: Number, a_maximum: Number, a_primaryColor: Number, a_secondaryColor: Number, a_flashColor: Number, a_primaryFriendlyColor: Number, a_secondaryFriendlyColor: Number, a_flashFriendlyColor: Number, a_fillDirection: Number): MovieClip
	{
		/*var flags: Number = (a_flags != null) ? a_flags : 0;
		var percent: Number = (a_percent != null) ? a_percent : 0.5;
		var fillDir: String = "both";
		switch(a_fillDirection) {
			case 0:
			fillDir = "left";
			break;
			case 1:
			fillDir = "right";
			break;
			default:
			fillDir = "both";
			break;
		}
		
		var primaryColor: Number = (a_primaryColor != null) ? a_primaryColor : _primaryColorDefault;
		var secondaryColor: Number = (a_secondaryColor != null) ? a_secondaryColor : _secondaryColorDefault;
		var flashColor: Number = (a_flashColor != null) ? a_flashColor : _flashColorDefault;
		
		var primaryFriendlyColor: Number = (a_primaryFriendlyColor != null) ? a_primaryFriendlyColor : _primaryFriendlyColorDefault;
		var secondaryFriendlyColor: Number = (a_secondaryFriendlyColor != null) ? a_secondaryFriendlyColor : _secondaryFriendlyColorDefault;
		var flashFriendlyColor: Number = (a_flashFriendlyColor != null) ? a_flashFriendlyColor : _flashFriendlyColorDefault;
		
		var fillDirection: String = (a_fillDirection != null) ? fillDir : _fillDirectionDefault;

		var meterIdStr: String = a_meterId.toString();
		var meterHolder = _widgetContainer.createEmptyMovieClip(meterIdStr, _widgetContainer.getNextHighestDepth());
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
			var hudExtension = _root.hudExtension.floatingWidgets;
						
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
		return meterHolder;*/
		


		// _widgetContainer is defined at the top as a MovieObject
		// 		private var _widgetContainer: MovieClip;

		// _widgetContainer calls the attachMovie Function
		//		public attachMovie(id: String, name: String, depth: Number, [initObject: Object]) : MovieClip
		// Definition of function: "Takes a symbol from the library and attaches it to the movie clip."
		// http://help.adobe.com/en_US/AS2LCR/Flash_10.0/help.html?content=00001274.html

		// attachMovie is called on "FloatingWidget" which should be the id name of the symbol.
		// 		"FloatingWidget" is equal to an identifier in the floatingwidget.fla file		
		var widgetIdStr: String = a_meterId.toString();
		var widgetHolder = _widgetContainer.attachMovie("FloatingWidget", widgetIdStr, _widgetContainer.getNextHighestDepth());
		widgetHolder.loadMeter(a_meterId, a_flags, a_current, a_maximum, a_primaryColor, a_secondaryColor, a_flashColor, a_primaryFriendlyColor, a_secondaryFriendlyColor, a_flashFriendlyColor, a_fillDirection);
		widgetHolder._x = -Stage.width;
		widgetHolder._y = -Stage.height;
		return widgetHolder;
	}

	public function unloadWidget(a_widgetId: Number): Boolean
	{
		var meter: MovieClip = _widgetContainer[a_widgetId.toString()];

		if (meter == undefined)
			return false;

		meter.removeMovieClip();
		delete(meter);
		return true;
	}

	public function sortWidgetDepths(a_widgetData: Array): Void
	{
		// array[{id: 0, zPos: 0}]
		var widgetData = a_widgetData.sortOn(["zIndex"], Array.DESCENDING);
		for (var i: Number = 0; i < widgetData.length; i++)
		{
			var meter: MovieClip = _widgetContainer[widgetData[i].id.toString()];
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