package utils.methods{
	
	public function clearTabs(str):String{
		while (str.substring(0,1) == " "){
			str = str.substring(1)
		}
		return str
	}
	
}