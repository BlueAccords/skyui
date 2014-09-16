import gfx.io.GameDelegate;
import Components.Meter;

import skyui.components.ButtonPanel;
import skyui.defines.Inventory;


class BottomBar extends MovieClip
{
	#include "../version.as"
	
  /* PRIVATE VARIABLES */	
  	
	
  /* STAGE ELEMENTS */

	public var playerInfo: MovieClip;
	
	
  /* PROPERTIES */
  
	public var buttonPanel: ButtonPanel;
	
	
  /* INITIALIZATION */

	public function BottomBar()
	{
		super();
	}
	
	
  /* PUBLIC FUNCTIONS */

	public function positionElements(a_leftOffset: Number, a_rightOffset: Number): Void
	{
		buttonPanel._x = a_leftOffset;
		buttonPanel.updateButtons(true);
		//playerInfo._x = a_rightOffset - playerInfo._width;
	}

	public function showPlayerInfo(): Void
	{
		playerInfo._alpha = 100;
	}

	public function hidePlayerInfo(): Void
	{
		playerInfo._alpha = 0;
	}

	public function setPlatform(a_platform: Number, a_bPS3Switch: Boolean): Void
	{
		buttonPanel.setPlatform(a_platform, a_bPS3Switch);
	}

  /* PRIVATE FUNCTIONS */
}
