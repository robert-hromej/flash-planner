package flash.display{

	import flash.text.TextField
	import flash.text.TextFormat
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.xml.XMLNode;
	import flash.display.PredecessorArrow;
	import fl.containers.ScrollPane;
	import fl.data.TaskDataProvider;
	import planner.Task;
	import planner.Project;
	import planner.DateType;
	import planner.WorkInterval;
	import utils.Global;
	import utils.DefaultWeek;
	import utils.methods.*;

	public class Calendar extends Sprite {

		private var _day_types:Array = new Array();
		public var intervals:Array = new Array();
		private var _default_week:DefaultWeek;
		private var content:Sprite = new Sprite();
		private var background:Sprite = new Sprite();
		private var _startCalendar:Date;
		public static var _selectedTask:Task;
		private static var startDrawArrow:PredecessorArrow;
		public static var durationDay:uint;

		public function Calendar(xml):void {
			Global.taskLineContainer.addChild(this);
			loadDateType(xml);
			_default_week=new DefaultWeek(xml.elements("calendar").elements("default-week"));
			loadIntervals(xml.elements("calendar").elements("overridden-day-types").elements("overridden-day-type"));
			addChild(background);
			addChild(content);
		}

		public function get day_types():Array {
			if (_day_types==null) {
				_day_types = new Array();
			}
			return _day_types;
		}

		public function get workDuration():uint {
			var d:uint;
			for (var i in intervals) {
				d+=intervals[i].duration;
			}
			return d;
		}

		private function loadDateType(xml):void {
			var elements=xml.elements("day-types").elements("day-type");
			for (var i:uint; elements.length()>i; i++) {
				day_types.push(new DateType(elements[i]));
			}
		}

		private function loadIntervals(xml):void {
			durationDay=0;
			intervals = new Array();
			var elms=xml.elements("interval");
			for (var i in elms) {
				var interval:WorkInterval=new WorkInterval(elms[i]);
				intervals.push(interval);
				durationDay+=interval.duration;
			}
			intervals.sortOn("start");
		}


		public function refresh():void {
			while (content.numChildren > 0) {
				content.removeChildAt(0);
			}

			Global.header.refresh();
			
			var tempDay:Date = new Date(startCalendar.getTime());
			var dp = Global.project.dataProvider;
			background.graphics.clear();
			background.graphics.lineStyle(1, 0xaaaaaa, 1);
			var rows:uint = dp.length;
			var maxHeight:uint = rows*20;

			var i:uint;
			var days:uint = (Global.project.end.getTime() - startCalendar.getTime())/(1000*3600*24);
			
			var today:Date = new Date();
			while (tempDay < Header.lastDay ) {
				if (tempDay.getDate()==today.getDate()&&tempDay.getFullYear()==today.getFullYear()&&tempDay.getMonth()==today.getMonth()) {
					background.graphics.beginFill(0x32FFFF);
					background.graphics.drawRect(i*24,0,24,maxHeight);
				}

				background.graphics.moveTo(i*24,0);
				background.graphics.lineTo(i*24,maxHeight);
				tempDay=nextDay(tempDay);
				i++;
			}

			for (i=0; dp.length>i; i++) {

				var item=dp.getItemAt(i);
				if (item.type=="milestone") {
					item.lineTime.type="MILESTONE";
				} else if (item.type == "normal") {
					if (item.isParent()) {
						item.lineTime.type="PARENT";
					} else {
						item.lineTime.type="CHILD";
					}
				}

				item.lineTime.x=countStartX(item);
				item.lineTime.length=countEndX(item)-item.lineTime.x;
				item.lineTime.rowIndex = i;
				
				content.addChild(item.lineTime);

				var taskSp:Sprite = new Sprite();
					taskSp.y = i*20 + 40;
					
				var f:TextFormat = new TextFormat();
					f.size = 14;
					f.bold = true;
					
				var taskNameLabel:TextField = new TextField();
					taskNameLabel.height = 20;
					taskNameLabel.maxChars = 50;
					taskNameLabel.width = 325;
					taskNameLabel.text = item.name;
					taskNameLabel.setTextFormat(f);
				taskSp.addChild(taskNameLabel);
				
				f.align = "right";
				var durationLabel:TextField = new TextField();
					durationLabel.x = 330;
					durationLabel.height = 20;
					durationLabel.maxChars = 10;
					durationLabel.width = 70;
					durationLabel.text = item.workColumn;
					durationLabel.setTextFormat(f);
				taskSp.addChild(durationLabel);
				
				taskSp.graphics.lineStyle(1, 0xdddddd, 1);
				taskSp.graphics.moveTo(0,20);
				taskSp.graphics.lineTo(Global.header.width + 327,20);
				
				Global.taskTreeContainer.addChild(taskSp);				
			}

			for (i=0; dp.length > i; i++) {
				var it=dp.getItemAt(i);
				for each (var pr in it.predecessors) {
					content.addChild(pr.arrow);
				}
			}
		}

		private function countEndX(item):uint {
			var work_end=3600*item.end.getHours()+item.end.getMinutes()*60;
			var s:uint;
			for (var i:uint=0; intervals.length>i; i++) {
				if (intervals[i].isIn(work_end)) {
					s+=work_end-intervals[i].start;
					i=intervals.length;
				} else if ( intervals[i].start < work_end ) {
					s+=intervals[i].duration;
				}
			}
			return 24*s/workDuration+uint((item.end.getTime() - _startCalendar.getTime()) / (3600*1000*24))*24;
		}

		private function countStartX(item):uint {
			var work_start=3600*item.work_start.getHours()+item.work_start.getMinutes()*60;
			var s:uint;
			for (var i:uint=0; intervals.length>i; i++) {

				if (intervals[i].isIn(work_start)) {
					s+=work_start-intervals[i].start;
					i=intervals.length;
				} else if ( intervals[i].start < work_start ) {
					s+=intervals[i].duration;
				}

			}
			return 24*s/workDuration+uint((item.work_start.getTime() - _startCalendar.getTime()) / (3600*1000*24))*24;
		}

		public function get startCalendar():Date {
			_startCalendar=new Date(Global.project.start.getTime());
			
			for each(var t:Task in Task.findAll()){
				if (_startCalendar > t.work_start) {
					_startCalendar = new Date(t.work_start.getTime());
				}
			}
			
			if (_startCalendar.getDay()==0){
				_startCalendar = addDays(_startCalendar,-6);
			}else{
				_startCalendar = addDays(_startCalendar,-_startCalendar.getDay()+1);
			}
			
			return _startCalendar;
		}

	}
}