package utils.methods{
	
	public function nextDay(date:Date):Date {
//		date.setHours(23,59)
//		date = new Date(date.getTime()+60*1000)
		date = addDays(date, 1)
		date.setHours(3)
		date.setMinutes(0)
		return date
	}
	
}