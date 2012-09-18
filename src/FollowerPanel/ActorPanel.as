import skyui.util.Defines;

class ActorPanel extends MovieClip
{
	/* CONSTANTS */
	
	/* STAGE ELEMENTS */
	private var content: MovieClip;
	private var background: MovieClip;

	/* PUBLIC VARIABLES */

	/* PRIVATE VARIABLES */
	

	public function ActorPanel()
	{
		super();		
	}
	
	public function onLoad()
	{
		_parent.gotoAndPlay("FadeIn");
		
		var actor1: Object = {actorBase: {fullName: "Jack"}, formType: 1, formId: 1, actorValues: [{base: 0, current: 0, maximum: 0},
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
		var actor2 = copyObject(actor1);
		actor2.actorBase.fullName = "Jill";
		actor2.formId = 2;
		actor2.actorValues[Defines.ACTORVALUE_HEALTH].current = 5;
		actor2.actorValues[Defines.ACTORVALUE_HEALTH].maximum = 10;
		actor2.actorValues[Defines.ACTORVALUE_MAGICKA].current = 2;
		actor2.actorValues[Defines.ACTORVALUE_MAGICKA].maximum = 10;
		actor2.actorValues[Defines.ACTORVALUE_STAMINA].current = 7;
		actor2.actorValues[Defines.ACTORVALUE_STAMINA].maximum = 10;
		
		var actor3 = copyObject(actor1);
		actor3.actorBase.fullName = "James";
		actor3.formId = 3;
		actor3.actorValues[Defines.ACTORVALUE_HEALTH].current = 1;
		actor3.actorValues[Defines.ACTORVALUE_HEALTH].maximum = 10;
		actor3.actorValues[Defines.ACTORVALUE_MAGICKA].current = 2;
		actor3.actorValues[Defines.ACTORVALUE_MAGICKA].maximum = 10;
		actor3.actorValues[Defines.ACTORVALUE_STAMINA].current = 3;
		actor3.actorValues[Defines.ACTORVALUE_STAMINA].maximum = 10;
		
		var actor4 = copyObject(actor1);
		actor4.actorBase.fullName = "Bill";
		actor4.formId = 4;
		actor4.actorValues[Defines.ACTORVALUE_HEALTH].current = 4;
		actor4.actorValues[Defines.ACTORVALUE_HEALTH].maximum = 10;
		actor4.actorValues[Defines.ACTORVALUE_MAGICKA].current = 5;
		actor4.actorValues[Defines.ACTORVALUE_MAGICKA].maximum = 10;
		actor4.actorValues[Defines.ACTORVALUE_STAMINA].current = 6;
		actor4.actorValues[Defines.ACTORVALUE_STAMINA].maximum = 10;
		
		content.addActor(actor1);
		content.addActor(actor2);
		content.addActor(actor3);
		content.addActor(actor4);
		
		_global.setTimeout(this,"timeout",3000);
	}
	
	private function timeout()
	{
		content.actors[1].remove();
		content.actors[0].remove();
	}

	/* PRIVATE FUNCTIONS */
	function copyObject(obj)
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
	}
}

