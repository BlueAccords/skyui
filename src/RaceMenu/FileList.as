class FileList extends skyui.components.list.ScrollingList
{
	public var entryHeight: Number = 25;
	
	public function FileList()
	{
		super();
	}
	
	public function set entryList(a_list: Array): Void
	{
		_entryList = a_list;
	}
}
