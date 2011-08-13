package fl.data{
	
	import fl.data.DataProvider
	import flash.xml.XMLNode
	import planner.Task
	
	public class TaskDataProvider extends DataProvider{
		
		public function TaskDataProvider(tasksXML):void{
			init(tasksXML)
		}
		
		public function init(tasksXML):void{
			removeAll()
			Task.dataBase = new Array()
			readTasks(tasksXML)
			refresh()			
		}
		
		public function readTasks(element,parentId=null){
			var elements = element.elements("task")
			for each(var el in elements){
				var task:Task = new Task(el,element.attribute("id"))
				if (parentId){
					task.parentId = parentId;
				}
				Task.insert(task)
				readTasks(el)
			}
			
		}

		private function loadDate(tasks):void{
			for (var i in tasks){
				addItem(tasks[i])
				if (tasks[i].open){
					loadDate(tasks[i].subTasks)
				}
			}
		}
		
		public function refresh():TaskDataProvider{
			removeAll()
			loadDate(Task.findAllByParentId(-1))
			return this
		}
		
		public function get xml():XMLNode{
			var rootTasks:Array = Task.findAllByParentId(-1)
			var ts:XMLNode = new XMLNode(1,"tasks")
			for each(var t in rootTasks){
				ts.insertBefore(t.xml,null)
			}
			return ts
		}
		
	}
}