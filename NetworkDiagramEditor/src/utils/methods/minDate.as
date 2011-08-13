package utils.methods{
	public function minDate(ar):Date{
		var p:Date
		for each(var a in ar){
			if (!p){p=a}
			if (p > a){
				p = a
			}
		}
		return p
	}
}