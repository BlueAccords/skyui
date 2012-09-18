import com.greensock.TweenLite;
import com.greensock.easing.Linear;

class PanelEntry extends MovieClip
{
	/* STAGE ELEMENTS */
	private var background: MovieClip;
	private var NameField: TextField;
	private var HealthMeter: MovieClip;
	private var MagickaMeter: MovieClip;
	private var StaminaMeter: MovieClip;
	
	/* PRIVATE VARIABLES */
	private var _meterLoader: MovieClipLoader;
	
	private var _healthMeter: MovieClip;
	private var _magickaMeter: MovieClip;
	private var _staminaMeter: MovieClip;
	
	private var index: Number;
	private var name: String = "";
	private var health: Number = 0;
	private var magicka: Number = 0;
	private var stamina: Number = 0;
	
	public var fadeInDuration: Number;
	public var fadeOutDuration: Number;
	public var moveDuration: Number;
	
	public function PanelEntry()
	{
		super();
		_meterLoader = new MovieClipLoader();
		_meterLoader.addListener(this);
		
		NameField.text = name;
		NameField.textAutoSize = "shrink";
		
		_healthMeter = HealthMeter.createEmptyMovieClip("meter", getNextHighestDepth());
		_magickaMeter = MagickaMeter.createEmptyMovieClip("meter", getNextHighestDepth());
		_staminaMeter = StaminaMeter.createEmptyMovieClip("meter", getNextHighestDepth());
		
		_meterLoader.loadClip("widgets/status.swf", _healthMeter);
		_meterLoader.loadClip("widgets/status.swf", _magickaMeter);
		_meterLoader.loadClip("widgets/status.swf", _staminaMeter);
		
		_y = index * background._height;		
		TweenLite.from(this, fadeInDuration, {_alpha: 0, overwrite: "AUTO", easing: Linear.easeNone});
	}
	
	private function onLoadInit(a_clip: MovieClip): Void
	{
		if(a_clip == _healthMeter) {
			a_clip.widget.initNumbers(background._width, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0x561818, 0xDF2020, 100, 0, 0xFF3232);
			a_clip.widget.initStrings("$EverywhereFont", "$EverywhereFont", "", "", "", "", "right");
			a_clip.widget.initCommit();
			a_clip.widget.setMeterPercent(health, true);
			a_clip.widget._visible = true;
			a_clip._visible = true;
		} else if(a_clip == _magickaMeter) {
			a_clip.widget.initNumbers(background._width, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0x0C016D, 0x284BD7, 100, 0, 0x3366FF);
			a_clip.widget.initStrings("$EverywhereFont", "$EverywhereFont", "", "", "", "", "right");
			a_clip.widget.initCommit();
			a_clip.widget.setMeterPercent(magicka, true);
			a_clip.widget._visible = true;
			a_clip._visible = true;
		} else if(a_clip == _staminaMeter) {
			a_clip.widget.initNumbers(background._width, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 50, 0x003300, 0x339966, 100, 0, 0x009900);
			a_clip.widget.initStrings("$EverywhereFont", "$EverywhereFont", "", "", "", "", "right");
			a_clip.widget.initCommit();
			a_clip.widget.setMeterPercent(stamina, true);
			a_clip.widget._visible = true;
			a_clip._visible = true;
		}
	}
	private function onLoadError(a_clip: MovieClip): Void
	{
		if(a_clip == _healthMeter) {
			skse.Log("Failed to load health meter");
		} else if(a_clip == _magickaMeter) {
			skse.Log("Failed to load magicka meter");
		} else if(a_clip == _staminaMeter) {
			skse.Log("Failed to load stamina meter");
		}
	}
	
	public function updatePosition(a_newIndex): Void
	{
		index = a_newIndex;

		TweenLite.to(this, moveDuration, {_y:  index * background._height, overwrite: "AUTO", easing: Linear.easeNone});
	}

	public function remove(): Void
	{
		TweenLite.to(this, fadeOutDuration, {_alpha: 0, onCompleteScope: _parent, onComplete: _parent.onActorRemoved, onCompleteParams: [this], overwrite: "AUTO", easing: Linear.easeNone});
	}
}
