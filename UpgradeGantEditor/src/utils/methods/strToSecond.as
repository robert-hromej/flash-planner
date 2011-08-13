package utils.methods{
	
	public function strToSecond(str:String):uint{
		return (uint(str.substr(0,2))*3600 + uint(str.substr(2,2))*60)
	}
	
}