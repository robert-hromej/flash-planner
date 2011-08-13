package utils.methods{
	
	public function copyArray(array):Array{
		var ar:Array = new Array()
		for each(var a in array){
			ar.push(a)
		}
		return ar
	}
	
}