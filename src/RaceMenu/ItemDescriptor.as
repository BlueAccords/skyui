class ItemDescriptor extends MovieClip
{
	public var background: MovieClip;
	public var textField: TextField;
	
	public function ItemDescriptor()
	{
		super();
		textField.autoSize = "left";
	}
	
	public function setText(a_text: String): Void
	{
		textField.text = a_text;
		background._width = textField._x + textField.textWidth + 20;
	}
}