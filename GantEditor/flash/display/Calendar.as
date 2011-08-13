package flash.display{

	import fl.containers.ScrollPane;
	import fl.data.TaskDataProvider;
	
	import flash.display.PredecessorArrow;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.xml.XMLNode;
	
	import planner.DateType;
	import planner.Project;
	import planner.Task;
	import planner.WorkInterval;
	
	import utils.DefaultWeek;
	import utils.Global;
	import utils.methods.*;

	public class Calendar extends Sprite {

		private var _day_types:Array = new Array();
		public var intervals:Array = new Array();
		private var _default_week:DefaultWeek;
		private var content:Sprite = new Sprite();
		private var predecessors:Sprite = new Sprite();
		private var background:Sprite = new Sprite();
		private var _startCalendar:Date;
		public static var _selectedTask:Task;
		private static var startDrawArrow:PredecessorArrow;
		public static var durationDay:uint;
		
		public static var CELL_WIDTH:uint = 24;

		public function Calendar(xml):void {
			Global.gant.source=this;
			loadDateType(xml);
			_default_week = new DefaultWeek(xml.elements("calendar")[0].elements("default-week")[0]);
			loadIntervals(xml.elements("calendar")[0].elements("overridden-day-types").elements("overridden-day-type"));
			Global.calendarHeader.source = Global.header;
			addChild(background);
			addChild(content);
			addChild(predecessors);
		}
		
		public function getDateByX(x:uint):Date{
			var date:Date = startCalendar;
			date = addDays(date,x/CELL_WIDTH);
			return date
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
			
			while (predecessors.numChildren > 0) {
				predecessors.removeChildAt(0);
			}
			predecessors.visible = true;
			var tempDay:Date=new Date(startCalendar.getTime());
			var dp=Global.project.dataProvider;
			background.graphics.clear();
			background.graphics.lineStyle(1, 0xd5d5d5, 1);
			var rows:uint=dp.length;
			var maxHeight:uint=rows*20;
			if (Global.gant.height>maxHeight) {
				maxHeight=Global.gant.height-16;
			}

			var i:uint;
			var days:uint = (Global.project.end.getTime() - startCalendar.getTime())/(1000*3600*CELL_WIDTH);
			if (Global.gant.width > days*CELL_WIDTH) {
				days = uint(Global.gant.width/CELL_WIDTH)+1;
			}
			var today:Date = new Date();

			while (tempDay < addWeeks(Global.project.end,2) || days+21 > i) {
				if (tempDay.getDate()==today.getDate()&&tempDay.getFullYear()==today.getFullYear()&&tempDay.getMonth()==today.getMonth()) {
					background.graphics.beginFill(0x32FFFF);
					background.graphics.drawRect(i*CELL_WIDTH,0,CELL_WIDTH,maxHeight);
				}

				background.graphics.moveTo(i*CELL_WIDTH,0);
				background.graphics.lineTo(i*CELL_WIDTH,maxHeight);
				
				if (tempDay.getDay() == 0 || tempDay.getDay() == 6){
					var bd:BitmapData = new BitmapData(4,2);
					bd.setPixel(0,0,0xd4d4d4);
					bd.setPixel(2,1,0xd4d4d4);
//					bd.setPixel(0,0,0x000000);
//					bd.setPixel(1,1,0x000000);
					background.graphics.beginBitmapFill(bd,new Matrix());
					background.graphics.drawRect(i*CELL_WIDTH,0,CELL_WIDTH,maxHeight);
					background.graphics.endFill();
				}
				
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

				item.lineTime.x = countStartX(item);
				item.lineTime.length = countEndX(item)-item.lineTime.x;
				item.lineTime.rowIndex = i;
				
				content.addChild(item.lineTime);
			}

			for (i=0; dp.length>i; i++) {
				var it = dp.getItemAt(i);
				for each (var pr in it.predecessors) {
					if (pr.arrow){
						predecessors.addChild(pr.arrow);
					}
				}
			}
			Global.header.refresh();
			try {
				Global.gant.update();
			} catch (error) {
			}
		}
		
		public function setPredecessorsVisible(b:Boolean):void{
			predecessors.visible = b;
		}

		private function countEndX(item):uint {
			var work_end = 3600*item.end.getHours()+item.end.getMinutes()*60;
			var s:uint;
			for (var i:uint=0; intervals.length>i; i++) {
				if (intervals[i].isIn(work_end)) {
					s += work_end-intervals[i].start;
					i = intervals.length;
				} else if ( intervals[i].start < work_end ) {
					s += intervals[i].duration;
				}
			}
			return (CELL_WIDTH*s/workDuration+uint((item.end.getTime() - _startCalendar.getTime()) / (3600*1000*CELL_WIDTH))*CELL_WIDTH)*CELL_WIDTH/24;
		}

		private function countStartX(item):uint {
			var work_start = 3600*item.work_start.getHours()+item.work_start.getMinutes()*60;
			var s:uint;
			for (var i:uint=0; intervals.length>i; i++) {

				if (intervals[i].isIn(work_start)) {
					s += work_start-intervals[i].start;
					i = intervals.length;
				} else if ( intervals[i].start < work_start ) {
					s += intervals[i].duration;
				}

			}
			return (CELL_WIDTH*s/workDuration+uint((item.work_start.getTime() - _startCalendar.getTime()) / (3600*1000*CELL_WIDTH))*CELL_WIDTH)*CELL_WIDTH/24;
		}

		public function get xml():XMLNode {
			var overridden_day_type:XMLNode=new XMLNode(1,"overridden-day-type");
			overridden_day_type.attributes={"id":0};
			for each (var interval in intervals) {
				overridden_day_type.insertBefore(interval.xml,null);
			}
			var overridden_day_types:XMLNode=new XMLNode(1,"overridden-day-types");
			overridden_day_types.insertBefore(overridden_day_type,null);
			var calendar_1:XMLNode=new XMLNode(1,"calendar");
			calendar_1.insertBefore(_default_week.xml,null);
			calendar_1.insertBefore(overridden_day_types,null);
			calendar_1.attributes = {"id":1,"name":"Standard"}
			var calendarXML:XMLNode=new XMLNode(1,"calendars");
			calendarXML.insertBefore(dateTypesXML,null);
			calendarXML.insertBefore(calendar_1,null);
			return calendarXML;
		}

		private function get dateTypesXML():XMLNode {
			var dt:XMLNode=new XMLNode(1,"day-types");
			for each (var d in day_types) {
				dt.insertBefore(d.xml,null);
			}
			return dt;
		}
		
		public function get startCalendar():Date {
			_startCalendar=new Date(Global.project.start.getTime());
			var copyAllTask:Array=copyArray(Task.findAll());
			copyAllTask.sortOn("start");
			if (_startCalendar>copyAllTask[0].start) {
				_startCalendar=new Date(copyAllTask[0].start.getTime());
			}
			_startCalendar=addDays(_startCalendar,-7);
			return _startCalendar;
		}


		public static function get selectedTask():Task {
			var t:Task=_selectedTask;
			_selectedTask=null;
			return t;
		}

		public static function set selectedTask(task):void {
			_selectedTask=task;
		}

	}
}