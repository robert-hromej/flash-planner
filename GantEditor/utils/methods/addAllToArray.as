package utils.methods{
	
	public function addAllToArray(array1,array2):Array{
		if (array2 as Array){
			for each(var a in array2){
				if (array1.indexOf(a) == -1){
					array1.push(a)
				}
			}
		}else{
			if (array1.indexOf(array2) == -1){
				array1.push(array2)
			}			
		}
		return array1
	}
	
}