package flash.display{
	
	import app.controllers.ApplicationController;
	
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	
	import planner.DateType;
	import planner.Predecessor;
	import planner.Task;
	import planner.WorkInterval;
	
	import utils.DefaultWeek;
	import utils.Global;
	import utils.methods.addDays;
	import utils.methods.addWeeks;
	import utils.methods.copyArray;
	import utils.methods.nextDay;

	public class Calendar extends Sprite {

		public var _day_types:Vector.<DateType> = new Vector.<DateType>();
		public var intervals:Array = new Array();
		public var _default_week:DefaultWeek;
		public var content:Sprite = new Sprite();
		public var background:Sprite = new Sprite();
		public var _startCalendar:Date;
		public static var _selectedTask:Task;
		public static var startDrawArrow:PredecessorArrow;
		public static var durationDay:uint;

		public function Calendar(xml:XMLList):void {
//			Global.gant.source=this;
			loadDateType(xml);
			_default_week = new DefaultWeek(xml.elements("calendar")[0].elements("default-week")[0]);
			loadIntervals(xml.elements("calendar")[0].elements("overridden-day-types").elements("overridden-day-type"));
//			Global.calendarHeader.source = Global.header;
			addChild(background);
			addChild(content);
		}

		public function get day_types():Vector.<DateType> {
			if (_day_types==null) {
				_day_types = new Vector.<DateType>();
			}
			return _day_types;
		}

		public function get workDuration():uint {
			var d:uint;
			for each(var interval:WorkInterval in intervals) {
				d += interval.duration;
			}
			return d;
		}

		private function loadDateType(xml:XMLList):void {
			var elements:XMLList = xml.elements("day-types").elements("day-type");
			for each(var element:XML in elements){
				day_types.push(new DateType(element));
			}
		}

		private function loadIntervals(xml:XMLList):void {
			durationDay = 0;
			intervals = new Array();
			var elms:XMLList=xml.elements("interval");
			for each(var element:XML in elms) {
				var interval:WorkInterval = new WorkInterval(element);
				intervals.push(interval);
				durationDay += interval.duration;
			}
			intervals.sortOn("start");
		}


		public function refresh():void {
			while (content.numChildren > 0) {
				content.removeChildAt(0);
			}

			var tempDay:Date=new Date(startCalendar.getTime());
			var dp:ArrayCollection = ApplicationController.proj.dataProvider;
			background.graphics.clear();
			background.graphics.lineStyle(1, 0xaaaaaa, 1);
			var rows:uint=dp.length;
			var maxHeight:uint=rows*20;
//			if (Global.gant.height>maxHeight) {
//				maxHeight=Global.gant.height-16;
//			}

			var i:uint;
			var days:uint = (ApplicationController.proj.end.getTime() - startCalendar.getTime())/(1000*3600*24);
//			if (Global.gant.width>days*24) {
//				days=uint(Global.gant.width/24)+1;
//			}
			var today:Date = new Date();

			while (tempDay < addWeeks(ApplicationController.proj.end,2) || days+21 > i) {
				if (tempDay.getDate()==today.getDate()&&tempDay.getFullYear()==today.getFullYear()&&tempDay.getMonth()==today.getMonth()) {
					background.graphics.beginFill(0x32FFFF);
					background.graphics.drawRect(i*24,0,24,maxHeight);
				}

				background.graphics.moveTo(i*24,0);
				background.graphics.lineTo(i*24,maxHeight);
				tempDay = nextDay(tempDay);
				i++;
			}


			for (i=0; dp.length>i; i++) {
				var it:Task = Task(dp.getItemAt(i));
				for each (var pr:Predecessor in it.predecessors) {
					content.addChild(pr.arrow);
				}
			}
			Global.gant.calendar.header.refresh();
			try {
//				Global.gant.update();
			} catch (error:Error) {
			}
		}

		public function get startCalendar():Date {
			_startCalendar = new Date(ApplicationController.proj.start.getTime());
			var copyAllTask:Array=copyArray(Task.findAll());
			copyAllTask.sortOn("start");
			if (_startCalendar>copyAllTask[0].start) {
				_startCalendar=new Date(copyAllTask[0].start.getTime());
			}
			_startCalendar=addDays(_startCalendar,-7);
			return _startCalendar;
		}


		public static function get selectedTask():Task{
			var t:Task=_selectedTask;
			_selectedTask=null;
			return t;
		}

		public static function set selectedTask(task:Task):void {
			_selectedTask = task;
		}

	}
}