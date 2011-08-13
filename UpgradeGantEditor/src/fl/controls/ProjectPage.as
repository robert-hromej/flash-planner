package fl.controls{
	
	import flash.display.Sprite
	import planner.Project
	import utils.History
	import planner.Task
	import utils.methods.dateToString
	
	public class ProjectPage extends Sprite{
		
		private var project:Project
		
		public function ProjectPage(project):void{
//			this.project = project
//			saveBT.addEventListener("click", save)
//			exitBT.addEventListener("click", exit)
//			cancelBT.addEventListener("click", exit)
//			startField.text = dateToString(project.start)
//			startCalendar.addEventListener("SELECTED", selectedStart)
//			startCalendar.currentDay = project.start
		}
		
		private function selectedStart(ev):void{
			project.start = ev.target.currentDate
//			startField.text = dateToString(project.start)
			Task.updateAll()
			Main.refresh()
			History.changed()
		}
		
		public function init():void{
//			nameField.text = project.name
//			companyField.text = project.company
//			managerField.text = project.manager
		}
		
		private function save(ev:*):void{
//			project.name = nameField.text
//			project.company = companyField.text
//			project.manager = managerField.text
			this.parent.removeChild(this)
			History.changed()
		}
		
		private function exit(ev:*):void{
			this.parent.removeChild(this)
		}
	}
}