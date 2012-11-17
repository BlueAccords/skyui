import gfx.events.EventDispatcher;
import skyui.components.list.BasicList;
import skyui.components.list.BasicListEntry;
import skyui.components.list.ListState;

import gfx.io.GameDelegate;
import gfx.controls.Slider;

import RaceMenuDefines;

class SliderListEntry extends BasicListEntry
{	
	/* PROPERTIES */
  
	public static var defaultTextColor: Number = 0xffffff;
	public static var activeTextColor: Number = 0xffffff;
	public static var selectedTextColor: Number = 0xffffff;
	public static var disabledTextColor: Number = 0x4c4c4c;
	public static var squareFillColor: Number = 0x0000000;
	private var sliderWait: Number;
	private var proxyObject: Object;
	
	/* STAGE ELMENTS */
	public var activeIndicator: MovieClip;
	public var selectIndicator: MovieClip;
	public var textField: TextField;
	public var valueField: TextField;
	public var SliderInstance: Slider;
	public var trigger: MovieClip;
	public var colorSquare: MovieClip;
		
	/* PUBLIC FUNCTIONS */
	
	public function SliderListEntry()
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
		activeIndicator.onPress = trigger.onPress;
		
		colorSquare.onRollOver = trigger.onRollOver;
		colorSquare.onPress = function()
		{
			var list = this._parent._parent;
			
			if (_parent.itemIndex != undefined && enabled)
				list.onItemPress(_parent.itemIndex);
		}
	}
	
	public function onLoad()
	{
		super.onLoad();
		SliderInstance.addEventListener("onWidgetLoad", this, "onSliderLoad");
	}
	
	public function onSliderLoad(event: Object)
	{
		setSlider(proxyObject);
	}

	public function setEntry(a_entryObject: Object, a_state: ListState): Void
	{
		enabled = a_entryObject.enabled;
		
		var isSelected = a_entryObject == a_state.list.selectedEntry;
		var isActive = (a_state.activeEntry != undefined && a_entryObject == a_state.activeEntry);

		if (a_entryObject.state != undefined)
			gotoAndPlay(a_entryObject.state);

		if (textField != undefined) {
			textField.autoSize = a_entryObject.align ? a_entryObject.align : "left";
			
			if (!a_entryObject.enabled)
				textField.textColor = disabledTextColor;
			else if (isActive)
				textField.textColor = activeTextColor;
			else if (isSelected)
				textField.textColor = selectedTextColor;
			else
				textField.textColor = defaultTextColor;

			textField.SetText(a_entryObject.text ? a_entryObject.text : " ");
		}
		
		if (selectIndicator != undefined)
			selectIndicator._visible = isSelected;
			
		if (activeIndicator != undefined) {
			activeIndicator._visible = isActive;
			activeIndicator._x = textField._x + textField._width + 5;
		}
		
		switch(a_entryObject.type)
		{
			case RaceMenuDefines.ENTRY_TYPE_RACE:
			{
				SliderInstance._visible = false;
				colorSquare._visible = false;
				valueField._visible = false;
			}
			break;
			
			case RaceMenuDefines.ENTRY_TYPE_SLIDER:
			{
				SliderInstance._visible = true;
				// Yeah this is stupid, but its the only way to tell if the slider loaded
				if(!SliderInstance.initialized) {
					proxyObject = a_entryObject;
				} else {
					setSlider(a_entryObject);
				}
				
				valueField._visible = true;
				valueField.SetText(((a_entryObject.position * 100)|0)/100);
				
				if(a_entryObject.callbackName == "ChangeTintingMask" || a_entryObject.callbackName == "ChangeMaskColor" || a_entryObject.callbackName == "ChangeHairColorPreset") {
					var colorOverlay: Color = new Color(colorSquare.fill);
					colorOverlay.setRGB(a_entryObject.fillColor & 0x00FFFFFF);
					colorSquare.fill._alpha = ((a_entryObject.fillColor >>> 24) / 0xFF) * 100;
					colorSquare.enabled = colorSquare._visible = true;
				} else {
					colorSquare.enabled = colorSquare._visible = false;
				}
			}
			break;
			
			case RaceMenuDefines.ENTRY_TYPE_MAKEUP:
			{
				SliderInstance._visible = false;
				valueField._visible = false;
						
				var colorOverlay: Color = new Color(colorSquare.fill);
				colorOverlay.setRGB(a_entryObject.fillColor & 0x00FFFFFF);
				colorSquare.fill._alpha = ((a_entryObject.fillColor >>> 24) / 0xFF) * 100;
				colorSquare.enabled = colorSquare._visible = true;
			}
			break;
		}
	}

	public function updatePosition(a_position: Number): Void
	{
		SliderInstance.position = a_position;
		SliderInstance.changedCallback();
	}
	
	private function setSlider(a_entryObject: Object): Void
	{
		SliderInstance.enabled = a_entryObject.enabled;
		SliderInstance.minimum = a_entryObject.sliderMin;
		SliderInstance.maximum = a_entryObject.sliderMax;
		SliderInstance.snapInterval = a_entryObject.interval;
		SliderInstance.position = a_entryObject.position;
		SliderInstance.callbackName = a_entryObject.callbackName;
		SliderInstance.sliderID = a_entryObject.sliderID;
		SliderInstance.entryObject = a_entryObject;
		
		SliderInstance.changedCallback = function()
		{
			if(this.sliderID < 1000) {
				GameDelegate.call(this.callbackName, [this.position, this.sliderID]);
			} else {
				skse.SendModEvent("RSM_SliderChange", this.callbackName, this.position);
			}
			this.entryObject.position = this.position;
			_parent.valueField.SetText(((this.position * 100)|0)/100);
		};
		SliderInstance.addEventListener("change", SliderInstance, "changedCallback");
	}
}
