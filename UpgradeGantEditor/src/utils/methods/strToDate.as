package utils.methods{
	
	public function strToDate(str:String):Date{
		return new Date(str.substr(0,4),Number(str.substr(4,2))-1,str.substr(6,2),str.substr(9,2),str.substr(11,2),str.substr(13,2))
		
	}
	
}