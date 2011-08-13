package utils.methods{
	
	public function addHours(date:Date, hrs:Number):Date {
		return addMinutes(date, hrs*60)
	}
	
}