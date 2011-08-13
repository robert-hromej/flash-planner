package utils.methods{
	public function minuteToStr(min:Number):String{
		var m:String = ""
		var h:String = ""
		if (uint(min/60) > 9){
			h = ""+uint(min/60)
		}else{
			h = "0"+uint(min/60)
		}
		if (uint(min%60) > 9){
			m = ""+uint(min%60)
		}else{
			m = "0"+uint(min%60)
		}		
		return h+m
	}
}