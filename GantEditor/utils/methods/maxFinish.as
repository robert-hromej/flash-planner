package utils.methods{
	
	public function maxFinish(ar):Date{
		var p:Date
		for each(var a in ar){
			if (!p){p=a.end}
			if (p < a.end){
				p = a.end
			}
		}
		return p
	}
	
}