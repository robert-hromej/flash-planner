package utils.methods{
	
	public function preDay(date:Date):Date {
//		date.setHours(0,0)
//		date = new Date(date.getTime()-60*1000)
		date = addDays(date, -1)
		date.setHours(22)
		date.setMinutes(00)
		return date
	}
	
}
