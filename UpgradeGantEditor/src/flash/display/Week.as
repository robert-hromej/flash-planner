﻿package flash.display{
	
	import flash.display.Calendar;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.controls.Label;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	import utils.methods.*;
	
	public class Week extends Group{
		
		private var _start:Date
		private var _title:String
		
		public function Week(date:Date,xi:uint):void{
			this._start = date
			var currentDay:Date = addDays(date,1-date.getDay())
			this.name = date.toString()
			this._title = currentDay.toString()
			
			this.x = xi-Math.floor((date.getDay()+6)%7)*24
			
			graphics.beginFill(0xEEEEEE)
			graphics.lineStyle(1, 0x000000)

			graphics.drawRect(0,-1,7*Calendar.durationDay/(20*60),37)
			
			var f:TextFormat = new TextFormat()
				f.size = 12
			
			var myFieldLabel:Label = new Label();
				myFieldLabel.x = 10;
				myFieldLabel.text = dateToString(currentDay);
//				myFieldLabel.setTextFormat(f)
			
			addElement(myFieldLabel);
			var i:uint = 0
			var d:Day
			while (i<7){
				d = new Day(currentDay)
				d.x = (uint(6+currentDay.getDay())%7)*24
					addElement(d)
//				addChild(d)
				currentDay = nextDay(currentDay)
				i++
			}
		}
				
	}
}