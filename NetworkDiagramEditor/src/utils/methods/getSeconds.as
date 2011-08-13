package utils.methods{
	public function getSeconds(date:Date):Number{
		return date.getHours()*3600+date.getMinutes()*60+date.getSeconds()
	}
}