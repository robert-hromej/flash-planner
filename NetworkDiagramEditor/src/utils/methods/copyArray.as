package utils.methods{
	public function copyArray(ar:Array):Array{
		var result:Array = new Array()
		for each(var a:* in ar){
			result.push(a)
		}
		return result
	}
}