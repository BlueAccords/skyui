import gfx.events.EventDispatcher;
import skyui.components.list.BasicEnumeration;
import skyui.components.list.ScrollingList;
import gfx.ui.InputDetails;

class ItemView extends MovieClip
{
	public var itemList: ItemList;
	public var background: MovieClip;
	
	public var paddingBottom = 2;
	public var paddingTop = 0;
	
	public var dispatchEvent: Function;
	public var dispatchQueue: Function;
	public var hasEventListener: Function;
	public var addEventListener: Function;
	public var removeEventListener: Function;
	public var removeAllEventListeners: Function;
	public var cleanUpEvents: Function;
		
	public function ItemView()
	{
		super();
		EventDispatcher.initialize(this);
	}
	
	public function onLoad()
	{
		itemList.listEnumeration = new BasicEnumeration(itemList.entryList);
		itemList.addEventListener("invalidateHeight", this, "onInvalidateHeight");
		dispatchEvent({type: "onLoad", view: this});
	}
	
	public function get entryList(): Array
	{
		return itemList.entryList;
	}
	
	public function set entryList(a_newArray: Array): Void
	{
		itemList.entryList = a_newArray;
		itemList.listEnumeration = new BasicEnumeration(a_newArray);
	}
	
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{		
		return itemList.handleInput(details, pathToFocus);
	}
	
	public function get listHeight(): Number
	{
		return itemList.listHeight;
	}
	
	public function setMinViewport(a_minEntries: Number, a_update: Boolean): Void
	{
		itemList.minViewport = a_minEntries;
		if(a_update) {
			itemList.requestInvalidate();
		}
	}
	
	public function setMaxViewport(a_maxEntries: Number, a_update: Boolean): Void
	{
		itemList.maxViewport = a_maxEntries;
		if(a_update) {
			itemList.requestInvalidate();
		}
	}
	
	public function set listHeight(a_height: Number): Void
	{
		itemList.listHeight = a_height;
		
		background._y = -paddingTop;
		background._height = a_height + paddingTop + paddingBottom;
	}
	
	public function onInvalidateHeight(event: Object): Void
	{
		listHeight = event.height;
	}
}
