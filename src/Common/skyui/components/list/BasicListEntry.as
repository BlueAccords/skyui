import skyui.components.list.BasicList;
import skyui.components.list.ListState;


class skyui.components.list.BasicListEntry extends MovieClip
{
  /* STAGE ELEMENTS */

	public var background: MovieClip;
	
	
  /* PROPERTIES */
	
	public var itemIndex: Number;
	public var onPressAux: Function;
	
	
  /* PUBLIC FUNCTIONS */
	
	public function BasicListEntry()
	{
		super();
		this.onRollOver = function()
		{
			var list = this._parent;
			
			if (itemIndex != undefined && enabled)
				list.onItemRollOver(itemIndex);
		}
		
		this.onRollOut = function()
		{
			var list = this._parent;
			
			if (itemIndex != undefined && enabled)
				list.onItemRollOut(itemIndex);
		}
		
		this.onPress = function(a_mouseIndex: Number, a_keyboardOrMouse: Number)
		{
			var list = this._parent;
				
			if (itemIndex != undefined && enabled)
				list.onItemPress(itemIndex, a_keyboardOrMouse);
		}

		this.onPressAux = function(a_mouseIndex: Number, a_keyboardOrMouse: Number, a_buttonIndex: Number)
		{
			var list = this._parent;
				
			if (itemIndex != undefined && enabled)
				list.onItemPressAux(itemIndex, a_keyboardOrMouse, a_buttonIndex);
		}
	}
	
	// This is called after the object is added to the stage since the constructor does not accept any parameters.
	public function initialize(a_index: Number, a_state: ListState): Void
	{
		// Do nothing.
	}
	
	// @abstract
	public function setEntry(a_entryObject: Object, a_state: ListState): Void {}
}