package utils.methods{
	public function maxDate(ar:Array):Date{
		var p:Date
		for each(var a:Date in ar){
			if (!p){p=a}
			if (p < a){
				p = a
			}
		}
		return p
	}
}