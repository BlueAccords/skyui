import skyui.util.ColorFunctions;

class FloatingWidget extends MovieClip
{	
	//dupe all 3 of the following variables to health/stam/magicka

	//health
	public var HealthMeter: skyui.components.Meter;
	public var healthNameField: TextField;
	public var healthField: TextField;
	
	//magicka
	public var MagickaMeter: skyui.components.Meter;
	public var magickaNameField: TextField;
	public var magickaField: TextField;

	//stamina
	public var StaminaMeter: skyui.components.Meter;
	public var staminaNameField: TextField;
	public var staminaField: TextField;	

	public var flags: Number;
		
	public function onLoad()
	{
		updateVisibility();
		updateDimensions();
		updateTextFields();
	}
	
	// _visible:
	// http://help.adobe.com/en_US/AS2LCR/Flash_10.0/help.html?content=00001369.html
	// _root: references the main timeline.
	// http://help.adobe.com/en_US/AS2LCR/Flash_10.0/help.html?content=00000627.html
	// hudExtension references the floatingWidgets.as file and the strings in the brackets
	// represent properties of the floatingWidgets.as
	public function updateVisibility()
	{
		var hudExtension = _root.hudExtension.floatingWidgets;
		//health
		HealthMeter._visible = hudExtension["_meterHealthVisible"];
		healthNameField._visible = hudExtension["_nameHealthVisible"];
		healthField._visible = hudExtension["_healthVisible"];

		//magicka
		MagickaMeter._visible = hudExtension["_meterMagickaVisible"];
		magickaNameField._visible = hudExtension["_nameMagickaVisible"];
		magickaField._visible = hudExtension["_magickaVisible"];

		//stamina
		StaminaMeter._visible = hudExtension["_meterStaminaVisible"];
		staminaNameField._visible = hudExtension["_nameStaminaVisible"];
		staminaField._visible = hudExtension["_staminaVisible"];
	}
	
	public function updateDimensions()
	{
		var hudExtension = _root.hudExtension.floatingWidgets;

		//name fields
		//health
		HealthMeter.setSize(hudExtension["_meterHealthWidth"], hudExtension["_meterHealthHeight"]);
		healthNameField.autoSize = hudExtension["_nameHealthAutoSize"];
		healthNameField._x += hudExtension["_nameHealthXOffset"];
		healthNameField._y += hudExtension["_nameHealthYOffset"];
		
		//magicka
		MagickaMeter.setSize(hudExtension["_meterMagickaWidth"], hudExtension["_meterMagickaHeight"]);
		magickaNameField.autoSize = hudExtension["_nameMagickaAutoSize"];
		magickaNameField._x += hudExtension["_nameMagickaXOffset"];
		magickaNameField._y += hudExtension["_nameMagickaYOffset"];

		//stamina
		StaminaMeter.setSize(hudExtension["_meterStaminaWidth"], hudExtension["_meterStaminaHeight"]);
		staminaNameField.autoSize = hudExtension["_nameStaminaAutoSize"];
		staminaNameField._x += hudExtension["_nameStaminaXOffset"];
		staminaNameField._y += hudExtension["_nameStaminaYOffset"];

		// autosize, XY offsets, meter offsets

		//health
		healthField.autoSize = hudExtension["_healthAutoSize"];
		healthField._x += hudExtension["_healthXOffset"];
		healthField._y += hudExtension["_healthYOffset"];
		
		HealthMeter._x += hudExtension["_meterHealthXOffset"];
		HealthMeter._y += hudExtension["_meterHealthYOffset"];
		
		HealthMeter.swapDepths(healthField);

		//magicka
		magickaField.autoSize = hudExtension["_magickaAutoSize"];
		magickaField._x += hudExtension["_magickaXOffset"];
		magickaField._y += hudExtension["_magickaYOffset"];
		
		MagickaMeter._x += hudExtension["_meterMagickaXOffset"];
		MagickaMeter._y += hudExtension["_meterMagickaYOffset"];
		
		MagickaMeter.swapDepths(magickaField);

		//stamina
		staminaField.autoSize = hudExtension["_staminaAutoSize"];
		staminaField._x += hudExtension["_staminaXOffset"];
		staminaField._y += hudExtension["_staminaYOffset"];
		
		StaminaMeter._x += hudExtension["_meterStaminaXOffset"];
		StaminaMeter._y += hudExtension["_meterStaminaYOffset"];
		
		StaminaMeter.swapDepths(staminaField);
	}
	
	// this function is called from HudExtension.cpp > UpdateValues
	// where it originally passed a size 2 array.
	public function setValues(a_health_current: Number, a_health_maximum: Number, a_magicka_current: Number, a_magicka_maximum: Number, 
								a_stamina_current: Number, a_stamina_maximum: Number)
	{
		// meter percentage

		//health
		healthField.SetText(Math.max(Math.round(a_health_current)) + " / " + Math.round(a_health_maximum));
		HealthMeter.percent = a_health_current / a_health_maximum;

		//magicka
		magickaField.SetText(Math.max(Math.round(a_magicka_current)) + " / " + Math.round(a_magicka_maximum));
		MagickaMeter.percent = a_magicka_current / a_magicka_maximum;

		//stamina
		staminaField.SetText(Math.max(Math.round(a_stamina_current)) + " / " + Math.round(a_stamina_maximum));
		StaminaMeter.percent = a_stamina_current / a_stamina_maximum;
	}
	
	public function isFriendly(): Boolean
	{
		return (this.flags & 128) == 128;
	}
	
	public function setColors(a_healthPrimaryColor: Number, a_healthSecondaryColor: Number, a_healthFlashColor: Number,
							  a_magickaPrimaryColor: Number, a_magickaSecondaryColor: Number, a_magickaFlashColor: Number,
							  a_staminaPrimaryColor: Number, a_staminaSecondaryColor: Number, a_staminaFlashColor: Number)
	{
		var hudExtension = _root.hudExtension.floatingWidgets;
			
		// primary, secondary, flash Colors
		
		//health	
		var primaryHealthColor: Number = hudExtension["_primaryHealthColorDefault"];
		var secondaryHealthColor: Number = hudExtension["_secondaryHealthColorDefault"];
		var flashHealthColor: Number = hudExtension["_flashHealthColorDefault"];

		//magicka
		var primaryMagickaColor: Number = hudExtension["_primaryMagickaColorDefault"];
		var secondaryMagickaColor: Number = hudExtension["_secondaryMagickaColorDefault"];
		var flashMagickaColor: Number = hudExtension["_flashMagickaColorDefault"];

		//stamina
		var primaryStaminaColor: Number = hudExtension["_primaryStaminaColorDefault"];
		var secondaryStaminaColor: Number = hudExtension["_secondaryStaminaColorDefault"];
		var flashStaminaColor: Number = hudExtension["_flashStaminaColorDefault"];

			
		if(isFriendly()) {
			// primary, secondary, flash colors if friendly

			//health
			primaryHealthColor = hudExtension["_primaryFriendlyColorDefault"];
			secondaryHealthColor = hudExtension["_secondaryFriendlyColorDefault"];
			flashHealthColor = hudExtension["_flashFriendlyColorDefault"];

			//magicka
			primaryMagickaColor = hudExtension["_primaryMagickaFriendlyColorDefault"];
			secondaryMagickaColor = hudExtension["_secondaryMagickaFriendlyColorDefault"];
			flashMagickaColor = hudExtension["_flashMagickaFriendlyColorDefault"];

			//stamina
			primaryStaminaColor = hudExtension["_primaryStaminaFriendlyColorDefault"];
			secondaryStaminaColor = hudExtension["_secondaryStaminaFriendlyColorDefault"];
			flashStaminaColor = hudExtension["_flashStaminaFriendlyColorDefault"];
		}
		
		// Set up backup colors?

		//health
		var colorsHealth: Array = [(a_healthPrimaryColor != null) ? a_healthPrimaryColor : primaryHealthColor,
							(a_healthSecondaryColor != null) ? a_healthSecondaryColor : secondaryHealthColor,
							(a_healthFlashColor != null) ? a_healthFlashColor : flashHealthColor];
		
		HealthMeter.setColors(colorsHealth[0], colorsHealth[1], colorsHealth[2]);

		//magicka
		var colorsMagicka: Array = [(a_magickaPrimaryColor != null) ? a_magickaPrimaryColor : primaryMagickaColor,
							(a_magickaSecondaryColor != null) ? a_magickaSecondaryColor : secondaryMagickaColor,
							(a_magickaFlashColor != null) ? a_magickaFlashColor : flashMagickaColor];
		
		MagickaMeter.setColors(colorsMagicka[0], colorsMagicka[1], colorsMagicka[2]);

		//stamina
		var colorsStamina: Array = [(a_staminaPrimaryColor != null) ? a_staminaPrimaryColor : primaryStaminaColor,
							(a_staminaSecondaryColor != null) ? a_staminaSecondaryColor : secondaryStaminaColor,
							(a_staminaFlashColor != null) ? a_staminaFlashColor : flashStaminaColor];
		
		StaminaMeter.setColors(colorsStamina[0], colorsStamina[1], colorsStamina[2]);
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