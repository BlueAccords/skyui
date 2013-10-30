class EnhancedCharacterEdit
{
	public static function init(parentObject: Object): Void
	{
		/* ECE Compatibility Start */
		var ECECharGen: Object = _global.skse.plugins.ExCharGen;
		if(ECECharGen) {
			var raceArray: Array = new Array();
			var extraSliders: Array = new Array();
			var sliderValues: Array = new Array();
			
			ECECharGen.itemList = parentObject.itemList;
			ECECharGen.sliders = new Array();
			ECECharGen.GetPlayerRaceName(raceArray);
			ECECharGen.raceName = raceArray[0].text;
			ECECharGen.GetList(ECECharGen.raceName, extraSliders, 10000);
			
			for(var i = 0; i < extraSliders.length; i++) {
				if(extraSliders[i].type >= 0 && extraSliders[i].type <= 4) {
					if(extraSliders[i].text == undefined)
						continue;
					
					var newSliderID = ECECharGen.sliders.length + RaceMenuDefines.ECE_SLIDER_OFFSET;
					var sliderObject: Object = {type: RaceMenuDefines.ENTRY_TYPE_SLIDER, text: extraSliders[i].text, filterFlag: RaceMenuDefines.CATEGORY_ECE, callbackName: "ChangeDoubleMorph", sliderMin: extraSliders[i].sliderMin, sliderMax: extraSliders[i].sliderMax, sliderID: newSliderID, position: 0, interval: extraSliders[i].interval, uniqueID: extraSliders[i].uniqueID, ECESlider: true, enabled: true};
					sliderObject.internalCallback = function()
					{
						_global.skse.plugins.ExCharGen.UpdateMorphs();
					}
					ECECharGen.sliders.push(sliderObject);
					ECECharGen.itemList.entryList.push(sliderObject);
				}
			}
			
			ECECharGen.slotNumber = 0;
			ECECharGen.GetSlotData(ECECharGen.raceName, ECECharGen.slotNumber, sliderValues);
			for(var i = 0; i < ECECharGen.sliders.length; i++) {
				for(var k = 0; k < sliderValues.length; k++) {
					if(ECECharGen.sliders[i].uniqueID == sliderValues[k].uniqueID) {
						ECECharGen.sliders[i].position = sliderValues[k].position;
						continue;
					}
				}
			}
			
			ECECharGen.UpdateMorphs = function()
			{
				var info: Array = new Array();
				for(var i = 0; i < this.sliders.length; i++) {
					info.push(this.sliders[i].uniqueID);
					info.push(this.sliders[i].position);
				}
				
				this.SetPlayerPreset(0, 33);
				
				if(this.slotNumber > 0) {
					this.SetMergedMorphs(this.raceName, info, this.slotNumber);
				}
				
				this.SetMergedMorphsMemory(this.raceName, info, this.slotNumber);
			}
			ECECharGen.LoadSliderData = function()
			{
				_global.skse.SendModEvent("ExCharGen_GetSliderPos");
			}
			ECECharGen.SaveSliderData = function()
			{
				var str: String = "version,2,"; // slider version.
				for (var i: Number = 0; i < this.sliders.length; i++) {
					str += this.sliders[i].uniqueID + "," + this.sliders[i].position + ",";
				}
				str = str.substr(0, str.length - 1);
				_global.skse.SendModEvent("ExCharGen_SetSliderPos", str);
			}
			parentObject["ExCharGenGetListCallback"] = function(str: String)
			{
				var ECECharGen: Object = _global.skse.plugins.ExCharGen;
				if(ECECharGen) {
					var sliderParams: Array = str.split(",");
					sliderParams.splice(0, 2);
					for(var i = 0; i < sliderParams.length; i += 2) {
						var uniqueID: Number = Number(sliderParams[i]);
						var position: Number = Number(sliderParams[i + 1]);
						for(var k = 0; k < ECECharGen.sliders.length; k++) {
							if(ECECharGen.sliders[k].uniqueID == uniqueID) {
								ECECharGen.sliders[k].position = position;
								break;
							}
						}
					}
				}
				
				ECECharGen.itemList.requestUpdate();
			}
			
			ECECharGen.LoadSliderData();
		}
		/* ECE Compatibility End */
	}
}