import skyui.components.list.BasicList;

class MagicExtDataExtender extends MagicDataExtender
{
	/* CONSTRUCTORS */
  
	public function MagicExtDataExtender()
	{
		super();
	}


	/* PUBLIC FUNCTIONS */
	function processEntry(a_entryObject: Object, a_itemInfo: Object): Void
	{
		super.processEntry(a_entryObject, a_itemInfo);
	}
	
	// @override IListProcessor
	public function processList(a_list: BasicList): Void
	{
		var entryList = a_list.entryList;
		
		for (var i = 0; i < entryList.length; i++) {
			if (entryList[i].skyui_itemcardDataExtended)
				continue;
			entryList[i].skyui_itemcardDataExtended = true;
			
			processEntry(entryList[i], entryList[i].itemInfo);
		}
	}
}