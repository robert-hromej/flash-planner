package utils.methods{
	
	public function strToMinute(str):uint{
		return (uint(str.substr(0,2))*60 + uint(str.substr(2,2)))
	}

}