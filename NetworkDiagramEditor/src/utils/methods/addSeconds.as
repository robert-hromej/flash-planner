package utils.methods{
	public function addSeconds(date:Date, secs:Number):Date {
		var mSecs:Number = secs * 1000
		var sum:Number = mSecs + date.getTime()
		return new Date(sum)
	}
}