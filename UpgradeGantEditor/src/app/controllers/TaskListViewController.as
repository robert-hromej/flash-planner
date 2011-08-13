package app.controllers{
	import flash.display.Day;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Tree;
	import mx.events.CollectionEvent;
	import mx.events.TreeEvent;
	
	import planner.Task;
	
	import utils.Global;
	
	public class TaskListViewController extends ApplicationController{
		
		private var d:Day;
		
		[Bindable]
		public var dataProvider:ArrayCollection = new ArrayCollection();
		
		public var tree:Tree;
		
		public function TaskListViewController(){
//			dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,refreshList);
			super();
		}
		
		public function refreshList():void{
			Global.gant.calendar.refreshDataProvider();
//			trace(tree.openItems)
//			super.refreshViewTasks();
			
		}
		
		override public function refresh():void{
			dataProvider.removeAll();
			for each(var task:Task in Task.rootTasks){
				dataProvider.addItem(task);
			}
		}
		
	}
}