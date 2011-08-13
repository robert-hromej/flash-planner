package utils.methods{
	public function convertDateToXML(date:Date):String{
		var str:String = ""
		str += date.getFullYear()
		
		if (date.getMonth() < 9){
			str += "0"
		}
		str += (date.getMonth()+1)
		
		if (date.getDate() < 10){
			str += "0"
		}
		str += date.getDate()
		
		str += "T"
		
		if (date.getHours() < 10){
			str += "0"
		}
		str += date.getHours()
		
		if (date.getMinutes() < 10){
			str += "0"
		}
		str += date.getMinutes()
		
		str += "00Z"
		
		
		return str
	}
}