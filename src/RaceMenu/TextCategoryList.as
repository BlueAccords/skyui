import gfx.events.EventDispatcher;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;
import Shared.GlobalFunc;

import skyui.components.list.EntryClipManager;
import skyui.components.list.BasicEnumeration;
import skyui.components.list.AlphaEntryFormatter;
import skyui.components.list.BasicList;


class TextCategoryList extends BasicList
{
  /* CONSTANTS */	
	
  /* STAGE ELEMENTS */
	public var background: MovieClip;
	
	
  /* PRIVATE VARIABLES */
	

  /* PROPERTIES */
	
	// Distance from border to start icon.
	public var _clipSpacing: Number = 10;
			
	
  /* INITIALIZATION */
	
	public function TextCategoryList()
	{
		super();
	}
	
	
  /* PUBLIC FUNCTIONS */
  
  	// Clears the list. For the category list, that's ok since the entryList isn't manipulated directly.
	// @override BasicList
	public function clearList(): Void
	{
		_entryList.splice(0);
	}
	
	// @override BasicList
	public function InvalidateData(): Void
	{
		if (_bSuspended) {
			_bRequestInvalidate = true;
			return;
		}
		
		listEnumeration.invalidate();
		
		if (_selectedIndex >= listEnumeration.size())
			_selectedIndex = listEnumeration.size() - 1;

		UpdateList();
		
		if (onInvalidate)
			onInvalidate();
	}
	
	// @override BasicList
	public function UpdateList(): Void
	{
		if (_bSuspended) {
			_bRequestUpdate = true;
			return;
		}
		
		setClipCount(_entryList.length);

		for (var i = 0; i < _entryList.length; i++) {
			var entryClip = getClipByIndex(i);

			entryClip.setEntry(listEnumeration.at(i), listState);

			listEnumeration.at(i).clipIndex = i;
			entryClip.itemIndex = i;
		}

		var xPos = 0;
		for (var i = 0; i < _entryList.length; i++) {
			var entryClip = getClipByIndex(i);
			entryClip._x = xPos;

			xPos += entryClip.background._width + _clipSpacing;
			
			entryClip._visible = true;
		}
	}
	
	public function gotoStart(): Void
	{
		if (disableSelection)
			return;
			
		var curIndex = _entryList.length - 1;
		var startIndex = _selectedIndex;
			
		do {
			if (curIndex < _entryList.length - 1) {
				curIndex++;
			} else {
				curIndex = 0;
			}
		} while (curIndex != startIndex && listEnumeration.at(curIndex).filterFlag == 0 && !listEnumeration.at(curIndex).bDontHide);
			
		onItemPress(curIndex, 0);
	}
	
	public function gotoEnd(): Void
	{
		if (disableSelection)
			return;

		var curIndex = 0;
		var startIndex = _selectedIndex;
		
		do {
			if (curIndex > 0) {
				curIndex--;
			} else {
				curIndex = _entryList.length - 1;					
			}
		} while (curIndex != startIndex && listEnumeration.at(curIndex).filterFlag == 0 && !listEnumeration.at(curIndex).bDontHide);
			
		onItemPress(curIndex, 0);
	}
	
	// Moves the selection left to the next element. Wraps around.
	public function moveSelectionLeft(a_wrap: Boolean): Void
	{
		if (disableSelection)
			return;

		var curIndex = _selectedIndex;
		var startIndex = _selectedIndex;
			
		do {
			if (curIndex > 0) {
				curIndex--;
			} else if (a_wrap) {
				curIndex = _entryList.length - 1;					
			}
		} while (curIndex != startIndex && listEnumeration.at(curIndex).filterFlag == 0 && !listEnumeration.at(curIndex).bDontHide);
			
		onItemPress(curIndex, 0);
	}

	// Moves the selection right to the next element. Wraps around.
	public function moveSelectionRight(a_wrap: Boolean): Void
	{
		if (disableSelection)
			return;
			
		var curIndex = _selectedIndex;
		var startIndex = _selectedIndex;
			
		do {
			if (curIndex < _entryList.length - 1) {
				curIndex++;
			} else if (a_wrap) {
				curIndex = 0;
			}
		} while (curIndex != startIndex && listEnumeration.at(curIndex).filterFlag == 0 && !listEnumeration.at(curIndex).bDontHide);
			
		onItemPress(curIndex, 0);
	}
	
	public function getClipData()
	{
		var entryClip = getClipByIndex(_selectedIndex);
		return [entryClip._x, entryClip.background._width];
	}
	
	// @GFx
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (disableInput)
			return false;
			
		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.LEFT) {
				moveSelectionLeft(true);
				return true;
			} else if (details.navEquivalent == NavigationCode.RIGHT) {
				moveSelectionRight(true);
				return true;
			}
		}
		return false;
	}
		
	// @override BasicList
	public function onItemPress(a_index: Number, a_keyboardOrMouse: Number): Void
	{
		if (disableInput || disableSelection || a_index == -1)
			return;
			
		doSetSelectedIndex(a_index, a_keyboardOrMouse);
		dispatchEvent({type: "itemPress", index: _selectedIndex, entry: selectedEntry, keyboardOrMouse: a_keyboardOrMouse});
	}
	
	// @override BasicList
	private function onItemPressAux(a_index: Number, a_keyboardOrMouse: Number, a_buttonIndex: Number): Void
	{
		if (disableInput || disableSelection || a_index == -1 || a_buttonIndex != 1)
			return;
		
		doSetSelectedIndex(a_index, a_keyboardOrMouse);
		dispatchEvent({type: "itemPressAux", index: _selectedIndex, entry: selectedEntry, keyboardOrMouse: a_keyboardOrMouse});
	}
	
	// @override BasicList
	public function onItemRollOver(a_index: Number): Void
	{
		if (disableInput || disableSelection)
			return;
			
		isMouseDrivenNav = true;
		
		if (a_index == _selectedIndex)
			return;
			
		var entryClip = getClipByIndex(a_index);
		entryClip._alpha = 75;
	}

	// @override BasicList
	public function onItemRollOut(a_index: Number): Void
	{
		if (disableInput || disableSelection)
			return;
			
		isMouseDrivenNav = true;
		
		if (a_index == _selectedIndex)
			return;
			
		var entryClip = getClipByIndex(a_index);
		entryClip._alpha = 50;
	}
}