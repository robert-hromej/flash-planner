package utils.methods{
	public function dateToString(date:Date):String{
		var months:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
		var str:String = ""
		str += " " + date.getDate()
		str += " " + months[date.getMonth()]
		str += " " + date.fullYear
		return str
	}
}