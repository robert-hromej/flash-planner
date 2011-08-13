package app.controllers{
	import flash.display.Week;
	
	import utils.methods.addWeeks;
	
	public class HeaderController extends ApplicationController{
		
		public function HeaderController(){
			super();
		}
		
		override public function refresh():void{
			removeAllElements();
//			while(numChildren > 0){removeChildAt(0)}
			
			var i:Number = -1
			
			var tempDay:Date = ApplicationController.proj.calendar.startCalendar
			tempDay = addWeeks(tempDay,-1)
			
			if (tempDay.getDay() == 0){
				i = 0
			}
			
			var end:Date = addWeeks(ApplicationController.proj.end,6)
			
			while (tempDay < end){
				addElement(new Week(tempDay,i*24*7))
//				addChild(new Week(tempDay,i*24*7))
				tempDay = addWeeks(tempDay,1)
				i++
			}
			
		}
		
	}
}