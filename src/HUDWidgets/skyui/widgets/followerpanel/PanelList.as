import gfx.events.EventDispatcher;

import com.greensock.TweenLite;
import com.greensock.OverwriteManager;
import com.greensock.easing.Linear;

import skyui.widgets.followerpanel.PanelDefines;

class skyui.widgets.followerpanel.PanelList extends MovieClip
{
	private var fadeInDuration: Number;
	private var fadeOutDuration: Number;
	private var moveDuration: Number;
	private var maxEntries: Number;
	private var paddingBottom: Number;
	
	private var mask: MovieClip;
	private var _actorPanel: MovieClip;
	
	/* PRIVATE VARIABLES */
	private var _actorArray: Array
	
	/* GFX */
	public var dispatchEvent: Function;
	public var addEventListener: Function;
	
	/* PUBLIC FUNCTIONS */
	public function PanelList()
	{
		super();
		EventDispatcher.initialize(this);
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
	
	public function removeActor(a_actor: Object)
	{
		var totalActors: Number = _actorArray.length;
		for(var i = 0; i < totalActors; i++)
		{
			if(_actorArray[i].formId == a_actor.formId) {
				_actorArray[i].remove();
				break;
			}
		}
	}
	
	public function addActor(a_actor: Object): MovieClip
	{
		if(_actorArray.length == 0) // Previously had no items, fadein
			dispatchEvent({type:"startFadeIn"});
		
		var initObject: Object = {index: _actorArray.length,
									formId: a_actor.formId,
									name: a_actor.actorBase.fullName,
									health: (a_actor.actorValues[PanelDefines.ACTORVALUE_HEALTH].current / a_actor.actorValues[PanelDefines.ACTORVALUE_HEALTH].maximum),
									magicka: (a_actor.actorValues[PanelDefines.ACTORVALUE_MAGICKA].current / a_actor.actorValues[PanelDefines.ACTORVALUE_MAGICKA].maximum),
									stamina: (a_actor.actorValues[PanelDefines.ACTORVALUE_STAMINA].current / a_actor.actorValues[PanelDefines.ACTORVALUE_STAMINA].maximum),
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
			dispatchEvent({type:"startFadeOut"});
		}
		
		updateBackground(moveDuration);
	}
	
	private function updateBackground(duration: Number)
	{
		TweenLite.to(mask, duration, {_height: Math.min(totalHeight, maxHeight), overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
		dispatchEvent({type:"updateBackground", duration: duration, height: Math.min(totalHeight + paddingBottom, maxHeight + paddingBottom)});
		//TweenLite.to(_actorPanel.background, duration, {_height: Math.min(totalHeight + paddingBottom, maxHeight + paddingBottom), overwrite: OverwriteManager.NONE, easing: Linear.easeNone});
	}
}
