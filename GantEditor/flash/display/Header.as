package flash.display{
	
	import flash.display.Sprite;
	
	import utils.Global;
	import utils.methods.addWeeks;
	import utils.methods.nextDay;
	
	public class Header extends Sprite{
		
		public function Header():void{
		}
		
		public function refresh():void{
			while(numChildren > 0){removeChildAt(0)}
			
			var i:Number = -1
			
			var tempDay:Date = Global.project.calendar.startCalendar
				tempDay = addWeeks(tempDay,-1)
			
			if (tempDay.getDay() == 0){
				i = 0
			}
			
			var end = addWeeks(Global.project.end,6)
			
			while (tempDay < end){
				addChild(new Week(tempDay,i*Calendar.CELL_WIDTH*7))
				tempDay = addWeeks(tempDay,1)
				i++
			}
			
		}

	}
}