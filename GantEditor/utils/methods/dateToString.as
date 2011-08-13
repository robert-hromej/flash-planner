package utils.methods{
	public function dateToString(date):String{
		var months:Array = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
		var str:String = "";
//		str += " Mon ";
		str += " " + months[date.getMonth()];
		str += " " + date.getDate();
		str += " " + date.fullYear;
		return str
	}
	
}