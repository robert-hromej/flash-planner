package utils.methods{
	
	public function dateToString(date):String{
		var months:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
		var str = ""
		str += " " + date.getDate()
		str += " " + months[date.getMonth()]
		str += " " + date.fullYear
		return str
	}
	
}