import gfx.events.EventDispatcher;
import skyui.util.Defines;

class ActorPanel extends MovieClip
{	
	/* CONSTANTS */
	static private var ACTOR_FADE_IN_DURATION: Number = 0.25;
	static private var ACTOR_FADE_OUT_DURATION: Number = 0.75;
	static private var ACTOR_MOVE_DURATION: Number = 1.00;
	
	/* STAGE ELEMENTS */
	private var content: MovieClip;
	private var background: MovieClip;

	/* PUBLIC VARIABLES */
	public var updateInterval: Number = 150;

	/* PRIVATE VARIABLES */
	private var _actorList: Array;
	private var _intervalId: Number;
	
	// Test List
	//public var _tempList: Array;

	public function ActorPanel()
	{
		super();
		content.fadeInDuration = ACTOR_FADE_IN_DURATION;
		content.fadeOutDuration = ACTOR_FADE_OUT_DURATION;
		content.moveDuration = ACTOR_MOVE_DURATION;
		content.maxEntries = 5;
		content.paddingBottom = 10;
		_actorList = new Array();
		//_tempList = new Array();
	}
	
	/*public function onLoad()
	{
		
		var actor = {actorBase: {fullName: "Jack"}, formType: 1, formId: 1, actorValues: [{base: 0, current: 0, maximum: 0},
												  {base: 10, current: 1, maximum: 0},
												  {base: 10, current: 2, maximum: 0},
												  {base: 10, current: 3, maximum: 0},
												  {base: 10, current: 4, maximum: 0},
												  {base: 10, current: 5, maximum: 0},
												  {base: 10, current: 6, maximum: 0},
												  {base: 10, current: 7, maximum: 0},
												  {base: 10, current: 8, maximum: 0},
												  {base: 10, current: 9, maximum: 0},
												  {base: 10, current: 10, maximum: 0},
												  {base: 10, current: 11, maximum: 0},
												  {base: 10, current: 12, maximum: 0},
												  {base: 10, current: 13, maximum: 0},
												  {base: 10, current: 14, maximum: 0},
												  {base: 10, current: 15, maximum: 0},
												  {base: 10, current: 16, maximum: 0},
												  {base: 10, current: 17, maximum: 0},
												  {base: 10, current: 18, maximum: 0},
												  {base: 10, current: 19, maximum: 0},
												  {base: 10, current: 20, maximum: 0},
												  {base: 10, current: 21, maximum: 0},
												  {base: 1000, current: 22, maximum: 100},
												  {base: 100, current: 23, maximum: 500},
												  {base: 100, current: 510000/2.54, maximum: 510000},
												  {base: 100, current: 25, maximum: 520},
												  {base: 100, current: 26, maximum: 530},
												  {base: 100, current: 27, maximum: 540},
												  {base: 100, current: 28, maximum: 550},
												  {base: 100, current: 29, maximum: 560},
												  {base: 100, current: 30, maximum: 570},
												  {base: 100, current: 31, maximum: 1000}]};
		addActor(actor);
		
		_tempList.push([{id: Defines.ACTORVALUE_HEALTH, current: actor.actorValues[Defines.ACTORVALUE_HEALTH].current, maximum: actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum, base: actor.actorValues[Defines.ACTORVALUE_HEALTH].base},
						{id: Defines.ACTORVALUE_MAGICKA, current: actor.actorValues[Defines.ACTORVALUE_MAGICKA].current, maximum: actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum, base: actor.actorValues[Defines.ACTORVALUE_MAGICKA].base},
						{id: Defines.ACTORVALUE_STAMINA, current: actor.actorValues[Defines.ACTORVALUE_STAMINA].current, maximum: actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum, base: actor.actorValues[Defines.ACTORVALUE_STAMINA].base}]);
		
		actor = copyObject(actor);
		actor.actorBase.fullName = "Joe";
		actor.formId = 10;
		actor.actorValues[Defines.ACTORVALUE_HEALTH].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_STAMINA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum = 100;
		
		addActor(actor);
		
		_tempList.push([{id: Defines.ACTORVALUE_HEALTH, current: actor.actorValues[Defines.ACTORVALUE_HEALTH].current, maximum: actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum, base: actor.actorValues[Defines.ACTORVALUE_HEALTH].base},
						{id: Defines.ACTORVALUE_MAGICKA, current: actor.actorValues[Defines.ACTORVALUE_MAGICKA].current, maximum: actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum, base: actor.actorValues[Defines.ACTORVALUE_MAGICKA].base},
						{id: Defines.ACTORVALUE_STAMINA, current: actor.actorValues[Defines.ACTORVALUE_STAMINA].current, maximum: actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum, base: actor.actorValues[Defines.ACTORVALUE_STAMINA].base}]);
		
		actor = copyObject(actor);
		actor.actorBase.fullName = "Jim";
		actor.formId = 11;
		actor.actorValues[Defines.ACTORVALUE_HEALTH].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_STAMINA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum = 100;
		
		addActor(actor);
		
		_tempList.push([{id: Defines.ACTORVALUE_HEALTH, current: actor.actorValues[Defines.ACTORVALUE_HEALTH].current, maximum: actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum, base: actor.actorValues[Defines.ACTORVALUE_HEALTH].base},
						{id: Defines.ACTORVALUE_MAGICKA, current: actor.actorValues[Defines.ACTORVALUE_MAGICKA].current, maximum: actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum, base: actor.actorValues[Defines.ACTORVALUE_MAGICKA].base},
						{id: Defines.ACTORVALUE_STAMINA, current: actor.actorValues[Defines.ACTORVALUE_STAMINA].current, maximum: actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum, base: actor.actorValues[Defines.ACTORVALUE_STAMINA].base}]);
		
		actor = copyObject(actor);
		actor.actorBase.fullName = "Jerry";
		actor.formId = 12;
		actor.actorValues[Defines.ACTORVALUE_HEALTH].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_STAMINA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum = 100;
		
		addActor(actor);
		
		_tempList.push([{id: Defines.ACTORVALUE_HEALTH, current: actor.actorValues[Defines.ACTORVALUE_HEALTH].current, maximum: actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum, base: actor.actorValues[Defines.ACTORVALUE_HEALTH].base},
						{id: Defines.ACTORVALUE_MAGICKA, current: actor.actorValues[Defines.ACTORVALUE_MAGICKA].current, maximum: actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum, base: actor.actorValues[Defines.ACTORVALUE_MAGICKA].base},
						{id: Defines.ACTORVALUE_STAMINA, current: actor.actorValues[Defines.ACTORVALUE_STAMINA].current, maximum: actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum, base: actor.actorValues[Defines.ACTORVALUE_STAMINA].base}]);
		
		actor = copyObject(actor);
		actor.actorBase.fullName = "Sally";
		actor.formId = 13;
		actor.actorValues[Defines.ACTORVALUE_HEALTH].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_STAMINA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum = 100;
		
		addActor(actor);
		
		_tempList.push([{id: Defines.ACTORVALUE_HEALTH, current: actor.actorValues[Defines.ACTORVALUE_HEALTH].current, maximum: actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum, base: actor.actorValues[Defines.ACTORVALUE_HEALTH].base},
						{id: Defines.ACTORVALUE_MAGICKA, current: actor.actorValues[Defines.ACTORVALUE_MAGICKA].current, maximum: actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum, base: actor.actorValues[Defines.ACTORVALUE_MAGICKA].base},
						{id: Defines.ACTORVALUE_STAMINA, current: actor.actorValues[Defines.ACTORVALUE_STAMINA].current, maximum: actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum, base: actor.actorValues[Defines.ACTORVALUE_STAMINA].base}]);
		
		actor = copyObject(actor);
		actor.actorBase.fullName = "Wally";
		actor.formId = 14;
		actor.actorValues[Defines.ACTORVALUE_HEALTH].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum = 100;
		actor.actorValues[Defines.ACTORVALUE_STAMINA].current = 100 * Math.random();
		actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum = 100;
		
		addActor(actor);
		
		_tempList.push([{id: Defines.ACTORVALUE_HEALTH, current: actor.actorValues[Defines.ACTORVALUE_HEALTH].current, maximum: actor.actorValues[Defines.ACTORVALUE_HEALTH].maximum, base: actor.actorValues[Defines.ACTORVALUE_HEALTH].base},
						{id: Defines.ACTORVALUE_MAGICKA, current: actor.actorValues[Defines.ACTORVALUE_MAGICKA].current, maximum: actor.actorValues[Defines.ACTORVALUE_MAGICKA].maximum, base: actor.actorValues[Defines.ACTORVALUE_MAGICKA].base},
						{id: Defines.ACTORVALUE_STAMINA, current: actor.actorValues[Defines.ACTORVALUE_STAMINA].current, maximum: actor.actorValues[Defines.ACTORVALUE_STAMINA].maximum, base: actor.actorValues[Defines.ACTORVALUE_STAMINA].base}]);
		

		setInterval(this, "timeoutChange", 1000);
		//setInterval(this, "timeoutRemove", 10000);
	}*/
	
	public function onUpdateInterval()
	{
		var totalActors = _actorList.length;
		for(var i = 0; i < totalActors; i++) {
			// Request new values
			var actorValues = new Array();
			//var actorValues = _tempList[i];
			skse.RequestActorValues(_actorList[i].formId, 
									[Defines.ACTORVALUE_HEALTH, 
									 Defines.ACTORVALUE_MAGICKA,
									 Defines.ACTORVALUE_STAMINA],
									actorValues);
			
			// Get the old values
			var oldValues = [_actorList[i].actorValues[Defines.ACTORVALUE_HEALTH],
							_actorList[i].actorValues[Defines.ACTORVALUE_MAGICKA],
							_actorList[i].actorValues[Defines.ACTORVALUE_STAMINA]];
			
			var changed: Boolean = false;
			for(var s = 0; s < oldValues.length; s++)
			{
				// Replace changed values
				if(oldValues[s].current != actorValues[s].current || oldValues[s].maximum != actorValues[s].maximum || oldValues[s].base != actorValues[s].base) {
					var index: Number = actorValues[s].id;
					_actorList[i].actorValues[index].current = actorValues[s].current;
					_actorList[i].actorValues[index].maximum = actorValues[s].maximum;
					_actorList[i].actorValues[index].base = actorValues[s].base;
					changed = true;
				}
			}
			
			// One of our actor values changed
			if(changed)
			{
				var totalShown: Number = content.actors.length;
				
				var updated: Boolean = false;
				for(var n = 0; n < totalShown; n++)
				{
					// Actor is already shown
					if(_actorList[i].formId == content.actors[n].formId) {
						//trace("Updating: " + _actorList[i].actorBase.fullName + " " + (_actorList[i].actorValues[Defines.ACTORVALUE_HEALTH].current|0) + " " + (_actorList[i].actorValues[Defines.ACTORVALUE_MAGICKA].current|0) + " " + (_actorList[i].actorValues[Defines.ACTORVALUE_STAMINA].current|0));
						content.actors[n].update(_actorList[i]);
						updated = true;
						break;
					}
				}
				
				// Not in our list, add them
				if(!updated) {
					//trace("Added: " + _actorList[i].actorBase.fullName);
					content.addActor(_actorList[i]);
				}
			}
		}
	}
	
	/*private function timeoutChange()
	{
		var index: Number = (_actorList.length * Math.random())|0;
		_tempList[index][0].current = (100 * Math.random())|0;
		_tempList[index][1].current = (100 * Math.random())|0;
		_tempList[index][2].current = (100 * Math.random())|0;
	}*/
		
	/* PAPYRUS FUNCTIONS */
	public function addActors(a_form: Object)
	{
		if(a_form.formType == Defines.FORMTYPE_LIST)
		{
			var totalForms: Number = a_form.forms.length;
			for(var i = 0; i < totalForms; i++) {
				addActor(a_form.forms[i]);
			}
		} else {
			addActor(a_form.forms[i]);
		}
	}
	
	public function addActor(a_form: Object)
	{
		// We're about to add our first actor, start polling
		if(_actorList.length == 0) {
			clearInterval(_intervalId);
			_intervalId = setInterval(this, "onUpdateInterval", updateInterval);
		}
		
		skse.ExtendForm(a_form.formId, a_form, false, false);
		skse.ExtendForm(a_form.actorBase.formId, a_form.actorBase, false, false);
		
		_actorList.push(a_form);
	}
	
	public function removeActors(a_form: Object)
	{
		if(a_form.formType == Defines.FORMTYPE_LIST)
		{
			var totalForms: Number = a_form.forms.length;
			for(var i = 0; i < totalForms; i++) {
				removeActor(a_form.forms[i]);
			}
		} else {
			removeActor(a_form);
		}
	}
	
	public function removeActor(a_form: Object)
	{
		var totalActors: Number = _actorList.length;
		for(var i = 0; i < totalActors; i++) {
			if(_actorList[i].formId == a_form.formId) {
				content.removeActor(a_form);
				_actorList.splice(i, 1);
			}
		}
		
		// No actors left, kill the update
		if(_actorList.length == 0) {
			clearInterval(_intervalId);
		}
	}

	/* PRIVATE FUNCTIONS */
	/*function copyObject(obj)
	{
	   var i;
	   var o;
	
	   o = new Object()
	
	   for(i in obj)
	   {
		  if(obj[i] instanceof Object)
		  {
			  o[i] = copyObject(obj[i]);
		  }
		  else
		  {
			  o[i] = i;
		  }
	   }
	
	   return(o);
	}*/
}

