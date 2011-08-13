package flash.display{
	
	import flash.display.Sprite
	import utils.methods.addWeeks
	import utils.methods.addDays
	import utils.methods.nextDay
	import utils.Global
	
	public class Header extends Sprite{
		
		public static var lastDay:Date
		
		public function Header():void{
		}
		
		public function refresh():void{
			while(numChildren > 0){removeChildAt(0)}
			
			var i:Number = 0
			
			var tempDay:Date = Global.project.calendar.startCalendar
//				tempDay = addWeeks(tempDay,-1)
			
			if (tempDay.getDay() == 0){
				i = 0
			}
			
			var end = addWeeks(Global.project.end,1)
			
			while (tempDay < end){
				addChild(new Week(tempDay,i*24*7))
				tempDay = addWeeks(tempDay,1)
				i++
			}
			
//			lastDay = new Date(tempDay.getTime())
//			lastDay = addDays(lastDay,7-lastDay.getDay())
			
		}

	}
}