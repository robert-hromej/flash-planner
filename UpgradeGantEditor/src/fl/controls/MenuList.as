package fl.controls{
	
	import mx.controls.List;
	
	import planner.Task;
	
	import utils.Global;
	import utils.History;
	
	public class MenuList extends List{
		
		public function MenuList():void{
			name = "menuList"
			rowCount = 11
			selectable = false
			
//			addItem({label:"Insert Task", action:newTask})
//			addItem({label:"Insert Subtask", action:newSubTask})
//			addItem({label:"Remove Task", action:destroyTask})
//			addItem({label:"Unlink Task", action:unlinkTask})
//			addItem({label:"Edit Task", action:editTask})
//
//			addItem({label:"Indent Task", action:indentTask})
//			addItem({label:"Unindent Task", action:unindentTask})
//
//			addItem({label:"Move Task Up", action:moveTaskUp})
//			addItem({label:"Move Task Down", action:moveTaskDown})
//
//			addItem({label:"Resources", action:openResourcesPage})
//			addItem({label:"Project", action:openProjectPage})
			
		}
		
		public function openProjectPage(selectTask):void{
			Global.main.openProjectPage()
		}
		
		public function openResourcesPage(selectTask):void{
			Global.openResourcesPage()
		}
		
		public function unlinkTask(selectTask):void{
			selectTask.unlink()
			Task.update()
			History.changed()
		}
		
		public function indentTask(selectTask):void{
			selectTask.indent()
			selectTask.addToUpdate()
			Task.update()
			History.changed()
		}
		
		public function unindentTask(selectTask):void{
			unlinkTask(selectTask)
			selectTask.unindent()
			selectTask.addToUpdate()
			Task.update()
			History.changed()
		}
		
		public function newTask(selectTask):void{
			var task
			if(selectTask){
				task = Task.insert(new Task(null,selectTask.parentId))
			}else{
				task = Task.insert(new Task(null,-1))
			}
			if (task && task.parent){
				task.parent.addToUpdate()
				Task.update()
			}
			if(selectTask){
				while(task.index > selectTask.index+1){
					task.moveUp()
				}
			}
			History.changed()
		}
		
		public function moveTaskUp(selectTask):void{
			selectTask.moveUp()
		}
		
		public function moveTaskDown(selectTask):void{
			selectTask.moveDown()
		}
		
		public function editTask(selectTask):void{
			Global.openEditTask(selectTask)
		}

		
		public function empty(selectTask):void{
		}
		
		public function newSubTask(selectTask):void{
			var task = selectTask.addSubTask()
		}
		
		public function destroyTask(selectTask):void{
			selectTask.destroy()
			Task.clearPredecessors()
			Global.project.clearAllocations()
			Task.update()
			History.changed()
		}
	}
}