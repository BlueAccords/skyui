import gfx.events.EventDispatcher;
import skyui.components.list.BasicList;
import skyui.components.list.BasicListEntry;
import skyui.components.list.ListState;

import gfx.io.GameDelegate;

class HistoryListEntry extends BasicListEntry
{	
	/* PROPERTIES */
  	
	/* STAGE ELMENTS */
	public var selectIndicator: MovieClip;
	public var textField: TextField;
	public var trigger: MovieClip;
	
	static var UNDO_TYPE_NONE: Number = 0;
	static var UNDO_TYPE_STROKE: Number = 1;
	static var UNDO_TYPE_RESETMASK: Number = 2;
	
	static var STROKE_TYPE_NONE: Number = 0;
	static var STROKE_TYPE_MASK_ADD: Number = 1;
	static var STROKE_TYPE_MASK_SUB: Number = 2;
	static var STROKE_TYPE_INFLATE: Number = 3;
	static var STROKE_TYPE_DEFLATE: Number = 4;
	static var STROKE_TYPE_MOVE: Number = 5;
	static var STROKE_TYPE_SMOOTH: Number = 6;
		
	/* PUBLIC FUNCTIONS */
	
	public function HistoryListEntry()
	{
		super();
		delete this.onRollOver;
		delete this.onRollOut;
		delete this.onPress;
		delete this.onPressAux;
		
		trigger.onRollOver = function()
		{
			var list = this._parent._parent;
			
			if (_parent.itemIndex != undefined && enabled)
				list.onItemRollOver(_parent.itemIndex);
		}
		
		trigger.onRollOut = function()
		{
			var list = this._parent._parent;
			
			if (_parent.itemIndex != undefined && enabled)
				list.onItemRollOut(_parent.itemIndex);
		}
		
		/* Build all the onPress functions for the underlying pieces*/

		trigger.onPress = function()
		{
			// Four levels up...
			var list = this._parent._parent;
			
			if (_parent.itemIndex != undefined && enabled)
				list.onItemPress(_parent.itemIndex);
		}
	}

	public function setEntry(a_entryObject: Object, a_state: ListState): Void
	{
		var isSelected = a_entryObject == a_state.list.selectedEntry;
		
		var text: String = "";
		var info: String = "";
		if(a_entryObject.vertices > 0)
			info = " (" + a_entryObject.vertices + ")";
		if(a_entryObject.mirror == true)
			info += " (M)";
		
		switch(a_entryObject.type) {
			case UNDO_TYPE_STROKE:
			{
				switch(a_entryObject.stroke) {
					case STROKE_TYPE_MASK_ADD:
					text = "$Mask Add";
					break;
					case STROKE_TYPE_MASK_SUB:
					text = "$Mask Subtract";
					break;
					case STROKE_TYPE_INFLATE:
					text = "$Inflate";
					break;
					case STROKE_TYPE_DEFLATE:
					text = "$Deflate";
					break;
					case STROKE_TYPE_MOVE:
					text = "$Move";
					break;
					case STROKE_TYPE_SMOOTH:
					text = "$Smooth";
					break;
					default:
					text = "Unknown Stroke";
					break;
				}
			}
			break;
			case UNDO_TYPE_RESETMASK:
			text = "$Clear Mask";
			break;
			default:
			text = "Unknown Action";
			break;
		}
		
		if (textField != undefined) {			
			textField.autoSize = a_entryObject.align ? a_entryObject.align : "left";
			textField.SetText(text ? (skyui.util.Translator.translateNested(text) + info) : " ");
		}
		
		if(selectIndicator != undefined)
			selectIndicator._visible = isSelected;
	}
}
