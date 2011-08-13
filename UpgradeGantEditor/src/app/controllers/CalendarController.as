package app.controllers{
	import app.views.GantView;
	import app.views.LineTimeView;
	
	import mx.collections.ArrayCollection;
	
	import planner.Task;
	import planner.WorkInterval;
	
	import spark.components.DataGroup;
	import spark.components.Group;
	import spark.components.Scroller;
	
	import utils.Global;
	
	public class CalendarController extends ApplicationController{
		
		private var _dataProvider:ArrayCollection;
		public var cal:DataGroup;
		public var calendarScroll:Scroller;
		
		public function CalendarController(){
			super();
		}
		
		public function get dataProvider():ArrayCollection{
			if (_dataProvider == null){
				_dataProvider = new ArrayCollection(Task.findAll());
			}
			return _dataProvider;
		}
		
		override public function refresh():void{
			refreshDataProvider();
		}
		
		private function countStartX(item:Task):uint {
			var work_start:uint = 3600*item.work_start.getHours() + item.work_start.getMinutes()*60;
			var s:uint;
			for each(var interval:WorkInterval in proj.calendar.intervals){
				if (interval.isIn(work_start)) {
					s += work_start - interval.start;
					break;
				} else if ( interval.start < work_start ) {
					s += interval.duration;
				}
				
			}
			var result:uint;
			result = 24*s;
			result = result/proj.calendar.workDuration;
			result += uint((item.work_start.getTime() - proj.calendar.startCalendar.getTime()) / (3600*1000*24))*24;
			return result;
		}
		
		private function countEndX(item:Task):uint {
			var work_end:uint = 3600*item.end.getHours() + item.end.getMinutes()*60;
			var s:uint;
			for each(var interval:WorkInterval in proj.calendar.intervals){
				if (interval.isIn(work_end)) {
					s += work_end - interval.start;
					break;
				} else if ( interval.start < work_end ) {
					s += interval.duration;
				}
			}
			return 24*s/proj.calendar.workDuration+uint((item.end.getTime() - proj.calendar.startCalendar.getTime()) / (3600*1000*24))*24;
		}
		
		public function refreshDataProvider():void{
			dataProvider.removeAll();
			addTasks(Task.rootTasks);
			for each(var line:LineTimeView in dataProvider) {
				line.x = countStartX(line.task);
				line.y = dataProvider.getItemIndex(line)*21;
				line.length = countEndX(line.task) - line.x;
			}
		}
		
		private function addTasks(tasks:Array):void{
			for each(var task:Task in tasks){
				dataProvider.addItem(task.newLineTime);
				if (task.children && Global.gant.treeTasks.tree.openItems.indexOf(task) != -1){
					addTasks(task.children);
				}
			}
		}
		
		
	}
}