package app.controllers{
	import app.views.CalendarView;
	import app.views.GantView;
	import app.views.TaskListView;
	
	import flash.media.Video;
	
	import mx.controls.Tree;
	import mx.events.FlexEvent;
	
	public class GantController extends ApplicationController{
		
		public var treeTasks:TaskListView;
		public var calendar:CalendarView;
		
		public function GantController(){
			super();
//			gant = this;
		}
		
		public function created(view:GantView):void{
//			gant = view;
//			super.refresh();
		}
		
		override public function refresh():void{
			treeTasks.refresh();
			calendar.refresh();
		}
		
	}
}