import skyui.util.Defines;

class PanelList extends MovieClip
{
	private var fadeInDuration: Number;
	private var fadeOutDuration: Number;
	private var moveDuration: Number;
	
	/* PRIVATE VARIABLES */
	private var _actorArray: Array
	
	/* PUBLIC FUNCTIONS */
	public function PanelList()
	{
		super();
		
		_actorArray = new Array();
	}
	
	public function onLoad()
	{
		/*var entry0: MovieClip = attachMovie("PanelEntry", "entry0", getNextHighestDepth());
		var entry1: MovieClip = attachMovie("PanelEntry", "entry1", getNextHighestDepth());
		var entry2: MovieClip = attachMovie("PanelEntry", "entry2", getNextHighestDepth());
		var entry3: MovieClip = attachMovie("PanelEntry", "entry3", getNextHighestDepth());
		var entry4: MovieClip = attachMovie("PanelEntry", "entry4", getNextHighestDepth());
		
		entry1._y = entry0._height;
		entry2._y = entry0._height + entry1._height;
		entry3._y = entry0._height + entry1._height + entry2._height;
		entry4._y = entry0._height + entry1._height + entry2._height + entry3._height;
		_parent.background._height = entry0._height + entry1._height + entry2._height + entry3._height + entry4._height + 10;*/
	}
	
	public function get length(): Number
	{
		return _actorArray.length;
	}
	
	public function get actors(): Array
	{
		return _actorArray;
	}
	
	public function get height(): Number
	{
		return length * _actorArray[0]._height;
	}
	
	public function addActor(a_actor: Object): MovieClip
	{
		var initObject: Object = {index: length,
									name: a_actor.actorBase.fullName,
									health: (a_actor.actorValues[Defines.ACTORVALUE_HEALTH].current / a_actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum) * 100,
									magicka: (a_actor.actorValues[Defines.ACTORVALUE_MAGICKA].current / a_actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum) * 100,
									stamina: (a_actor.actorValues[Defines.ACTORVALUE_STAMINA].current / a_actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum) * 100,
									fadeInDuration: this.fadeInDuration,
									fadeOutDuration: this.fadeOutDuration,
									moveDuration: this.moveDuration
								  };
								  
		var entry: MovieClip = attachMovie("PanelEntry", a_actor.formId, getNextHighestDepth(), initObject);		
		_actorArray.push(entry);
		_parent.updateBackground(moveDuration/4);
		return entry;
	}
	
	// After the actor tweens out
	public function onActorRemoved(a_actorClip: MovieClip): Void
	{
		var removedActorClip: MovieClip = a_actorClip;
		var actorIdx: Number = removedActorClip.index;

		_actorArray.splice(actorIdx, 1);
		removedActorClip.removeMovieClip();

		if (_actorArray.length > 0){
			var Clip: MovieClip;

			for (var i: Number = actorIdx; i < _actorArray.length; i++) {
				Clip = _actorArray[i];
				Clip.updatePosition(i);
				_parent.updateBackground(moveDuration);
			}
		} else {
			_parent._parent.gotoAndPlay("FadeOut");
		}
	}
}
