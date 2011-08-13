package flash.display{
	
	import flash.text.TextField;
	
	import mx.controls.Label;
	
	import spark.components.Group;
	
	public class Day extends Group{
		
		public function Day(date:Date):void{
			name = date.toString()
			y = 18
			
			graphics.lineStyle(1, 0x000000)
			if (date.getDay() == 6 || date.getDay() == 0){
				graphics.beginFill(0xCCCCCC)
			}
			graphics.drawRect(0,0,Calendar.durationDay/(20*60),16)
			var myFieldLabel:Label = new Label();
				myFieldLabel.x = 4;
				myFieldLabel.height = 16;
				myFieldLabel.text = ""+date.getDate();
			addElement(myFieldLabel)
		}
		
	}
}