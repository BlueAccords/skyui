import gfx.events.EventDispatcher;
import gfx.io.GameDelegate;
import skyui.components.list.BasicEnumeration;
import skyui.components.list.ScrollingList;

class HistoryWindow extends gfx.core.UIComponent
{
	public var historyList: HistoryList;
	public var background: MovieClip;
		
	private var _dragOffset: Object;
				
	// GFx Functions
	public var dispatchEvent: Function;
	public var addEventListener: Function;
	
	function HistoryWindow()
	{
		super();
		Mouse.addListener(this);
		EventDispatcher.initialize(this);
	}
	
	function onLoad()
	{
		super.onLoad();		
		EventDispatcher.initialize(background);
		background.addEventListener("press", this, "beginDrag");
		background.onPress = function(controllerIdx, keyboardOrMouse, button)
		{
			if (this.disabled) 
				return undefined;
		
			dispatchEvent({type: "press", controllerIdx: controllerIdx, button: button});
		}
		
		historyList.listEnumeration = new BasicEnumeration(historyList.entryList);
		
		historyList.addEventListener("itemPress", this, "onItemPress");
		historyList.addEventListener("selectionChange", this, "onSelectionChange");
		
		historyList.requestInvalidate();
	}
	
	public function InitExtensions()
	{
		GameDelegate.addCallBack("AddAction", this, "onAddAction");
	}
	
	private function onSelectionChange(event: Object): Void
	{
		var selectedEntry: Object = historyList.entryList[event.index];
		historyList.listState.selectedEntry = selectedEntry;
		historyList.requestUpdate();
		
		_parent._parent.setStatusText(selectedEntry.part);
	}
	
	public function onAddAction(action: Object): Void
	{
		historyList.entryList.push(action);
		historyList.InvalidateData();
		historyList.lastEntry();
	}
	
	public function unloadAssets()
	{
		historyList.entryList.splice(0, historyList.entryList.length);
		historyList.requestInvalidate();
	}
	
	// Move background
	private function beginDrag(event)
	{
		onMouseMove = doDrag;
		onMouseUp = endDrag;
		
		_dragOffset = {x: _xmouse, y: _ymouse};
		
		dispatchEvent({type: event.type, controllerIdx: event.controllerIdx, button: event.button});
	}

	private function doDrag()
	{
		var diffX = _xmouse - _dragOffset.x;
		var diffY = _ymouse - _dragOffset.y;
		
		_x += diffX;
		_y += diffY;
	}

	private function endDrag()
	{
		delete onMouseUp;
		delete onMouseMove;
	}
}