package fl.controls{
	
	import fl.controls.List;
	
	import planner.Task;
	
	import utils.Global;
	import utils.History;
	
	public class MenuList extends List{
		
		public function MenuList():void{
			name = "menuList"
			rowCount = 13
			selectable = false
			
			
			addItem({label:"Insert Task", action:newTask});
			addItem({label:"Insert Subtask", action:newSubTask});
			
			addItem({label:"copy", action:copyTask});
			addItem({label:"paste", action:pasteTask});
			
			addItem({label:"Remove Task", action:destroyTask});
			addItem({label:"Unlink Task", action:unlinkTask});
			addItem({label:"Edit Task", action:editTask});
			

			addItem({label:"Indent Task", action:indentTask});
			addItem({label:"Unindent Task", action:unindentTask});

			addItem({label:"Move Task Up", action:moveTaskUp});
			addItem({label:"Move Task Down", action:moveTaskDown});

			addItem({label:"Resources", action:openResourcesPage});
			addItem({label:"Project", action:openProjectPage});
			
		}
		
		public function copyTask(selectTask:Task):void{
			if (selectTask){
				selectTask.copyTaskGroup();
			}
		}
		
		public function pasteTask(selectTask:Task):void{
			if (selectTask){
				selectTask.pasteTaskGroup();
			}
		}
		
		public function openProjectPage(selectTask:Task):void{
			if (selectTask){
				Global.main.openProjectPage();
			}
		}
		
		public function openResourcesPage(selectTask:Task=null):void{
			Global.openResourcesPage();
		}
		
		public function unlinkTask(selectTask:Task):void{
			if (selectTask){
				selectTask.unlink();
				Task.update();
				History.changed();
				Main.refresh();
			}
		}
		
		public function indentTask(selectTask:Task):void{
			if (selectTask){
				selectTask.indent();
				selectTask.addToUpdate();
				Task.update();
				History.changed();
				Main.refresh();
			}
		}
		
		public function unindentTask(selectTask:Task):void{
			if (selectTask){
				unlinkTask(selectTask);
				selectTask.unindent();
				selectTask.addToUpdate();
				Task.update();
				History.changed();
				Main.refresh();
			}
		}
		
		public function newTask(selectTask:Task):void{
			var task:Task;
			if(selectTask){
				task = Task.insert(new Task(null,selectTask.parentId));
			}else{
				task = Task.insert(new Task(null,-1));
			}
			if (task && task.parent){
				task.parent.addToUpdate();
				Task.update();
			}
			if(selectTask){
				while(task.index > selectTask.index+1){
					task.moveUp();
				}
			}
			History.changed();
			Main.refresh();
		}
		
		public function moveTaskUp(selectTask:Task):void{
			if (selectTask){
				selectTask.moveUp();
				Main.refresh();
			}
		}
		
		public function moveTaskDown(selectTask:Task):void{
			if (selectTask){
				selectTask.moveDown();
				Main.refresh();
			}
		}
		
		public function editTask(selectTask:Task):void{
			if (selectTask){
				Global.openEditTask(selectTask);
			}
		}

		
		public function empty(selectTask:Task):void{
		}
		
		public function newSubTask(selectTask:Task):void{
			if (selectTask){
				selectTask.addSubTask();
			}
		}
		
		public function destroyTask(selectTask:Task):void{
			if (selectTask){
				selectTask.destroy();
				Task.clearPredecessors();
				Global.project.clearAllocations();
				Task.update();
				History.changed();
				Main.refresh();
			}
		}
	}
}