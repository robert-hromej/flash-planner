package fl.data{
	
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	
	import planner.Task;
	
	public class TaskDataProvider extends ArrayCollection{
		
		public function TaskDataProvider(tasksXML:XMLList):void{
			init(tasksXML)
		}
		
		public function init(tasksXML:XMLList):void{
			removeAll()
			Task.dataBase = new Array()
			readTasks(tasksXML)
			refresh()			
		}
		
		private function readTasks(element:XMLList):void{
			var elements:XMLList = element.elements("task");
			for each(var el:XML in elements){
				var task:Task = new Task(el,element.attribute("id"))
				Task.insert(task)
				readTasks(XMLList(el));
			}
			
		}

		private function loadDate(tasks:Array):void{
			for each(var task:Task in tasks){
				addItem(task)
				if (task.open){
					loadDate(task.children)
				}
			}
		}
		
		public function refresh2():TaskDataProvider{
			removeAll()
			loadDate(Task.findAllByParentId(-1))
			return this
		}
		
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