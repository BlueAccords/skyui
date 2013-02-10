import gfx.events.EventDispatcher;
import gfx.ui.NavigationCode;
import gfx.ui.InputDetails;
import Shared.GlobalFunc;

import skyui.defines.Input;
import skyui.util.GlobalFunctions;
import skyui.components.list.EntryClipManager;
import skyui.components.list.BasicList;
import skyui.filter.IFilter;


class RaceMenuList extends skyui.components.list.ScrollingList
{
	public var entryHeight: Number = 25;
	
	public function RaceMenuList()
	{
		super();
	}
	
	// @GFx
	public function handleInput(details: InputDetails, pathToFocus: Array): Boolean
	{
		if (disableInput)
			return false;

		// That makes no sense, does it?
		var bHandled = selectedClip != undefined && selectedClip.handleInput != undefined && selectedClip.handleInput(details, pathToFocus.slice(1));
		if (bHandled)
			return true;

		if (GlobalFunc.IsKeyPressed(details)) {
			if (details.navEquivalent == NavigationCode.UP || details.navEquivalent == NavigationCode.PAGE_UP) {
				moveSelectionUp(details.navEquivalent == NavigationCode.PAGE_UP);
				return true;
			} else if (details.navEquivalent == NavigationCode.DOWN || details.navEquivalent == NavigationCode.PAGE_DOWN) {
				moveSelectionDown(details.navEquivalent == NavigationCode.PAGE_DOWN);
				return true;
			} else if (!disableSelection && (details.navEquivalent == NavigationCode.ENTER || details.skseKeycode == GlobalFunctions.getMappedKey("Activate", Input.CONTEXT_GAMEPLAY, _platform != 0))) {
				onItemPress();
				return true;
			} else if (!disableSelection && (details.control == "YButton" || 
											 details.control == "Wait" || 
											 details.skseKeycode == GlobalFunctions.getMappedKey("YButton", Input.CONTEXT_GAMEPLAY, _platform != 0) || 
											 details.skseKeycode == GlobalFunctions.getMappedKey("Wait", Input.CONTEXT_GAMEPLAY, _platform != 0))) {
				dispatchEvent({type: "itemPressSecondary", index: _selectedIndex, entry: selectedEntry, clip: selectedClip});
				return true;
			}
		}
		return false;
	}

	
	public function moveSelectionUp(a_bScrollPage: Boolean): Void
	{
		if (!disableSelection && !a_bScrollPage) {
			if (_selectedIndex == -1) {
				selectDefaultIndex(false);
			} else if (getSelectedListEnumIndex() >= scrollDelta) {
				doSetSelectedIndex(getListEnumRelativeIndex(-scrollDelta), SELECT_KEYBOARD);
				isMouseDrivenNav = false;
			} else {
				doSetSelectedIndex(-1, SELECT_MOUSE);
			}
		} else if (a_bScrollPage) {
			var t = scrollPosition - _listIndex;
			scrollPosition = t > 0 ? t : 0;
			doSetSelectedIndex(-1, SELECT_MOUSE);
		} else {
			scrollPosition = scrollPosition - scrollDelta;
		}
	}

	public function moveSelectionDown(a_bScrollPage: Boolean): Void
	{
		if (!disableSelection && !a_bScrollPage) {
			if (_selectedIndex == -1) {
				selectDefaultIndex(true);
			} else if (getSelectedListEnumIndex() < getListEnumSize() - scrollDelta) {
				doSetSelectedIndex(getListEnumRelativeIndex(scrollDelta), SELECT_KEYBOARD);
				isMouseDrivenNav = false;
			} else {
				doSetSelectedIndex(-1, SELECT_MOUSE);
			}
		} else if (a_bScrollPage) {
			var t = scrollPosition + _listIndex;
			scrollPosition = t < _maxScrollPosition ? t : _maxScrollPosition;
			doSetSelectedIndex(-1, SELECT_MOUSE);
		} else {
			scrollPosition = scrollPosition + scrollDelta;
		}
	}
}
