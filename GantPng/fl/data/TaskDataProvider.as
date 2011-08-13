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
		
		private function readTasks(element){
			var elements = element.elements("task")
			for each(var el in elements){
				var task:Task = new Task(el,element.attribute("id"))
				Task.insert(task)
				readTasks(el)
			}
			
		}

		private function loadDate(tasks):void{
			for (var i in tasks){
				addItem(tasks[i])
				loadDate(tasks[i].subTasks)
			}
		}
		
		public function refresh():TaskDataProvider{
			removeAll()
			loadDate(Task.findAllByParentId(-1))
			return this
		}
		
	}
}