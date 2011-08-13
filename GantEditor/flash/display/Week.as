package flash.display{
	
	import fl.controls.Label;
	
	import flash.display.Calendar;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import utils.methods.*;
	
	public class Week extends Sprite{
		
		private var _start:Date
		private var _title:String
		
		public function Week(date:Date,xi):void{
			y = 1;
			this._start = date;
			var currentDay:Date = addDays(date,1-date.getDay());
			this.name = date.toString();
			this._title = currentDay.toString();
			
			this.x = xi-Math.floor((date.getDay()+6)%7)*Calendar.CELL_WIDTH;
			
			graphics.beginFill(0xEBE9ED);
			graphics.lineStyle(1, 0xA7A6AA);

			graphics.drawRect(0,-1,7*Calendar.CELL_WIDTH,38);
			
			var tf:TextFormat = new TextFormat();
				tf.align = "center";
				tf.font = "Arial, Tahoma, sans-serif"
				tf.size = 10;
				tf.bold = true;
				
			var myFieldLabel:TextField = new TextField();
				myFieldLabel.width = 7*Calendar.CELL_WIDTH;
				myFieldLabel.text = "Mon " + dateToString(currentDay);
				myFieldLabel.setTextFormat(tf);
			
			addChild(myFieldLabel)
			var i:uint = 0;
			var d:Day;
			while (i<7){
				d = new Day(currentDay);
				d.x = (uint(6+currentDay.getDay())%7)*Calendar.CELL_WIDTH;
				addChild(d);
				currentDay = nextDay(currentDay);
				i++;
			}
		}
				
	}
}