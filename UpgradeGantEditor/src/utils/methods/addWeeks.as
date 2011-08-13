package utils.methods{
	
	public function addWeeks(date:Date, weeks:Number):Date {
		if (weeks > 0){
			var i:uint=0
			while(i < weeks*7){
				date = nextDay(date)
				i++
			}
		}else{
			date = addDays(date, weeks*7)
		}
		return date
	}
	
}