import com.greensock.TweenLite;
import com.greensock.OverwriteManager;
import com.greensock.easing.Linear;

import skyui.util.Defines;

class PanelList extends MovieClip
{
	private var fadeInDuration: Number;
	private var fadeOutDuration: Number;
	private var moveDuration: Number;
	private var maxEntries: Number;
	private var paddingBottom: Number;
	
	private var mask: MovieClip;
	
	/* PRIVATE VARIABLES */
	private var _actorArray: Array
	
	/* PUBLIC FUNCTIONS */
	public function PanelList()
	{
		super();
		
		_actorArray = new Array();
		setMask(mask);
	}
	
	public function get actors(): Array
	{
		return _actorArray;
	}
	
	public function get totalHeight(): Number
	{
		return _actorArray.length * _actorArray[0].background._height;
	}
	
	public function get maxHeight(): Number
	{
		return _actorArray[0].background._height * maxEntries;
	}
	
	public function addActor(a_actor: Object): MovieClip
	{
		if(_actorArray.length == 0) // Previously had no items, fadein
			_parent._parent.gotoAndPlay("FadeIn");
		
		var initObject: Object = {index: _actorArray.length,
									formId: a_actor.formId,
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
		updateBackground(moveDuration);
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
				updateBackground(moveDuration);
			}
		} else {
			_parent._parent.gotoAndPlay("FadeOut");
		}
	}
	
	private function updateBackground(duration: Number)
	{
		TweenLite.to(mask, duration, {_height: Math.min(totalHeight, maxHeight), overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		TweenLite.to(_parent.background, duration, {_height: Math.min(totalHeight + paddingBottom, maxHeight + paddingBottom), overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
	}
}
