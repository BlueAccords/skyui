import skyui.util.ColorFunctions;

class FloatingWidget extends MovieClip
{	
	public var Meter: skyui.components.Meter;
	public var nameField: TextField;
	public var healthField: TextField;
	
	public var flags: Number;
		
	public function onLoad()
	{
		updateVisibility();
		updateDimensions();
		updateTextFields();
	}
	
	public function updateVisibility()
	{
		var hudExtension = _root.hudExtension.floatingWidgets;
		Meter._visible = hudExtension["_meterVisible"];
		nameField._visible = hudExtension["_nameVisible"];
		healthField._visible = hudExtension["_healthVisible"];
	}
	
	public function updateDimensions()
	{
		var hudExtension = _root.hudExtension.floatingWidgets;
		Meter.setSize(hudExtension["_meterWidth"], hudExtension["_meterHeight"]);
		nameField.autoSize = hudExtension["_nameAutoSize"];
		nameField._x += hudExtension["_nameXOffset"];
		nameField._y += hudExtension["_nameYOffset"];
		
		healthField.autoSize = hudExtension["_healthAutoSize"];
		healthField._x += hudExtension["_healthXOffset"];
		healthField._y += hudExtension["_healthYOffset"];
		
		Meter._x += hudExtension["_meterXOffset"];
		Meter._y += hudExtension["_meterYOffset"];
		
		Meter.swapDepths(healthField);
	}
	
	public function setValues(a_current: Number, a_maximum: Number)
	{
		healthField.SetText(Math.max(Math.round(a_current)) + " / " + Math.round(a_maximum));
		Meter.percent = a_current / a_maximum;
	}
	
	public function isFriendly(): Boolean
	{
		return (this.flags & 128) == 128;
	}
	
	public function setColors(a_primaryColor: Number, a_secondaryColor: Number, a_flashColor: Number)
	{
		var hudExtension = _root.hudExtension.floatingWidgets;
			
		var primaryColor: Number = hudExtension["_primaryColorDefault"];
		var secondaryColor: Number = hudExtension["_secondaryColorDefault"];
		var flashColor: Number = hudExtension["_flashColorDefault"];
			
		if(isFriendly()) {
			primaryColor = hudExtension["_primaryFriendlyColorDefault"];
			secondaryColor = hudExtension["_secondaryFriendlyColorDefault"];
			flashColor = hudExtension["_flashFriendlyColorDefault"];
		}
			
		var colors: Array = [(a_primaryColor != null) ? a_primaryColor : primaryColor,
							(a_secondaryColor != null) ? a_secondaryColor : secondaryColor,
							(a_flashColor != null) ? a_flashColor : flashColor];
		
		Meter.setColors(colors[0], colors[1], colors[2]);
		updateTextFields();
	}
	
	public function updateTextFields()
	{
		var hudExtension = _root.hudExtension.floatingWidgets;
		
		var nameFormat = new TextFormat();
		nameFormat.size = hudExtension["_nameSize"];
		if(isFriendly())
			nameFormat.color = hudExtension["_nameColorFriendly"];
		else
			nameFormat.color = hudExtension["_nameColorHostile"];
		
		nameFormat.alignment = hudExtension["_nameAlignment"];
		nameField.setTextFormat(nameFormat);
		
		var healthFormat = new TextFormat();
		healthFormat.size = hudExtension["_healthSize"];
		
		if(isFriendly())
			healthFormat.color = hudExtension["_healthColorFriendly"];
		else
			healthFormat.color = hudExtension["_healthColorHostile"];

		healthFormat.alignment = hudExtension["_healthAlignment"];
		healthField.setTextFormat(healthFormat);
	}
	
	public function setFillDirection(a_fill: String)
	{
		Meter.fillDirection = a_fill;
	}
	
	public function startFlash(a_force: Boolean)
	{
		Meter.startFlash(a_force);
	}

	public function loadMeter(a_meterId: Number, a_flags: Number, a_current: Number, a_maximum: Number, a_primaryColor: Number, a_secondaryColor: Number, a_flashColor: Number, a_primaryFriendlyColor: Number, a_secondaryFriendlyColor: Number, a_flashFriendlyColor: Number, a_fillDirection: Number): MovieClip
	{
		var flags: Number = (a_flags != null) ? a_flags : 0;
		var percent: Number = (a_current != null) ? Math.max(a_current, 0) / a_maximum : 0.5;
		var fillDir: String = "both";
		switch(a_fillDirection) {
			case 0:
			fillDir = "left";
			break;
			case 1:
			fillDir = "right";
			break;
			default:
			fillDir = "both";
			break;
		}
		
		var widgetContainer = _root.hudExtension.floatingWidgets;
		
		var primaryColor: Number = (a_primaryColor != null) ? a_primaryColor : widgetContainer["_primaryColorDefault"];
		var secondaryColor: Number = (a_secondaryColor != null) ? a_secondaryColor : widgetContainer["_secondaryColorDefault"];
		var flashColor: Number = (a_flashColor != null) ? a_flashColor : widgetContainer["_flashColorDefault"];
		if((a_flags & 128) == 128) {
			primaryColor = (a_primaryFriendlyColor != null) ? a_primaryFriendlyColor : widgetContainer["_primaryFriendlyColorDefault"];
			secondaryColor = (a_secondaryFriendlyColor != null) ? a_secondaryFriendlyColor : widgetContainer["_secondaryFriendlyColorDefault"];
			flashColor = (a_flashFriendlyColor != null) ? a_flashFriendlyColor : widgetContainer["_flashFriendlyColorDefault"];
		}
		
		if(secondaryColor == -1) {
			var darkColorHSV: Array = ColorFunctions.hexToHsv(primaryColor);
			darkColorHSV[2] -= 40;
			secondaryColor = ColorFunctions.hsvToHex(darkColorHSV);
		}
		if(flashColor == -1) {
			flashColor = primaryColor;
		}
		
		var fillDirection: String = (a_fillDirection != null) ? fillDir : widgetContainer["_fillDirectionDefault"];
		
		var Meter = this.attachMovie("Meter", "Meter", this.getNextHighestDepth(), 
			{
				_currentPercent: percent,
				_fillDirection: fillDirection,
				_secondaryColor: secondaryColor,
				_primaryColor: primaryColor,
				_flashColor: flashColor
			});
		
		healthField.SetText(Math.max(Math.round(a_current), 0) + " / " + Math.round(a_maximum));

		this.flags = flags;
		Meter._x = -Meter.width/2;
		return Meter;
	}
}