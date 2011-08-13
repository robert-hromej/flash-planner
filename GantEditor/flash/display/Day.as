package flash.display{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	
	public class Day extends Sprite{

		public static const DAYS:Array = ["S", "M", "T", "W", "T", "F", "S"];
		
		public function Day(date:Date):void{
			name = date.toString();
			y = 20;
			
			graphics.lineStyle(1, 0xA7A6AA)
//			if (date.getDay() == 6 || date.getDay() == 0){
//				graphics.beginFill(0xCCCCCC);
//			}
			var today:Date = new Date();
			
			if (date.getDate() == today.getDate() && 
				date.getFullYear() == today.getFullYear() && 
				date.getMonth() == today.getMonth()) {
				graphics.beginFill(0x32FFFF);
			}
			
			graphics.drawRect(0,0,Calendar.CELL_WIDTH,18);
			
			var tf:TextFormat = new TextFormat();
			tf.align = "center";
			tf.font = "Arial, Tahoma, sans-serif"
			tf.size = 10;
			tf.bold = true;

			
			
			var myFieldLabel:TextField = new TextField();
			
//				myFieldLabel.setTextFormat(tf);
//				myFieldLabel.x = 2;
				myFieldLabel.height = 16;
				myFieldLabel.width = Calendar.CELL_WIDTH;
				myFieldLabel.text = DAYS[date.getDay()] ; //"H"//+date.getDate();
				myFieldLabel.setTextFormat(tf);
			addChild(myFieldLabel);
		}
		
	}
}