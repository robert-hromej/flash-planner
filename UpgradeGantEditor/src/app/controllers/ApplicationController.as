package app.controllers{
	import app.views.GantView;
	
	import mx.collections.ArrayCollection;
	import mx.events.FlexEvent;
	
	import planner.Project;
	
	import spark.components.Group;
	
	public class ApplicationController extends Group{
		
		public static var proj:Project;
		
		public function ApplicationController(){
			super();
		}
		
		public function refresh():void{
		}
		
		public function refreshViewTasks():void{
		}
		
	}
}