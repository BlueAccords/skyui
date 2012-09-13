import skyui.components.list.BasicList;
import skyui.components.list.IEntryFormatter;
import skyui.components.list.ButtonEntryFormatter;

class ActorValueEntryFormatter extends ButtonEntryFormatter
{
	/* PROPERTIES */
	
	/* STAGE ELMENTS */
	
	/* PUBLIC FUNCTIONS */
	
	function ActorValueEntryFormatter(a_list: BasicList)
	{
		super(a_list);
	}
	
	public function setEntry(a_entryClip: MovieClip, a_entryObject: Object): Void
	{
		super.setEntry(a_entryClip, a_entryObject);
		
		if (a_entryClip == undefined || a_entryObject.value == undefined) {
			a_entryClip.valueField.text = "0";
			return;
		}
		
		a_entryClip.valueField.textAutoSize = "shrink";
		
		var statStr: String;
		if(a_entryObject.type == undefined)
			statStr = "" + Math.round(1000 * a_entryObject.value.current) / 1000 + "";
		else if(a_entryObject.type == "pc")
			statStr = "" + Math.round(100 * (a_entryObject.value.current / a_entryObject.value.maximum)) + "%";
		else if(a_entryObject.type == "p")
			statStr = "" + Math.round(a_entryObject.value.current) + "%";

		if(a_entryObject.value.base < a_entryObject.value.maximum) { // Net Gain
			statStr += " <font color=\'#189515\'>(+" + Math.round(a_entryObject.value.maximum - a_entryObject.value.base) + ")</font>";
		} else if(a_entryObject.value.base > a_entryObject.value.maximum){ // Net Loss
			statStr += " <font color=\'#FF0000\'>(" + Math.round(a_entryObject.value.maximum - a_entryObject.value.base) + ")</font>";
		}
		a_entryClip.valueField.html = true;
		a_entryClip.valueField.SetText(statStr, true);
	}
}
