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
	}
}