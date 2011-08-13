package mx.collections{
	
	import flash.events.*;
	import flash.xml.XMLNode;
	
	import planner.Task;
	
	
	public class TaskDataProvider extends ArrayCollection{
		
		public function TaskDataProvider(tasksXML:XMLList):void{
			removeAll()
			Task.dataBase = new Array()
			readTasks(tasksXML)
//			refresh()
		}
		
		private function readTasks(xml:*):void{
			for each(var el:* in xml.elements("task")){
				var task:Task = new Task(el,xml.attribute("id"))
				Task.insert(task)
				readTasks(el)
			}
		}
//
//		private function loadDate(tasks):void{
//			for (var i in tasks){
//				addItem(tasks[i])
//				if (tasks[i].open){
//					loadDate(tasks[i].subTasks)
//				}
//			}
//		}
		
//		override public function refresh():TaskDataProvider{
//			removeAll()
//			trace(Task.findAllByParentId(-1).length)
//			loadDate(Task.findAllByParentId(-1))
//			return this
//		}
		
		public function get xml():XMLNode{
			var rootTasks:Array = Task.findAllByParentId(-1)
			var ts:XMLNode = new XMLNode(1,"tasks")
			for each(var t:Task in rootTasks){
				ts.insertBefore(t.xml,null)
			}
			return ts
		}
		
	}
}