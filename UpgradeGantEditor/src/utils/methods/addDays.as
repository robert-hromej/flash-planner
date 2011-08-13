package utils.methods{
	
	public function addDays(date:Date, days:Number):Date {
		return addHours(date, days*24)
	}
	
}