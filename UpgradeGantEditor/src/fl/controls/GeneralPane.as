package fl.controls{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import planner.Task;
	
	import utils.History;
	import utils.methods.dateToString;
	
	public class GeneralPane extends Sprite{
		
		private var _task:Task
		
		public function GeneralPane():void{
//			startCalendar.addEventListener("SELECTED", selectedStart)
//			milestoneCheck.addEventListener("change", changeMilestoneCheck)
		}
		
		private function changeMilestoneCheck(ev:Event):void{
			if (ev.target.selected){
				task.type = "milestone"
			}else{
				task.type = "normal"
			}
			Main.refresh()
			dispatchEvent(new Event("update"))
		}
		
		private function selectedStart(ev:Event):void{
			task.constraintDate = ev.target.currentDate
//			startField.text = dateToString(ev.target.currentDate)
		}
		
		public function save():void{
//			task.percent_complete = percentComplete.value
//			task.priority = priority.value
			for each(var t:Task in task.allChildren){
				t.addToUpdate()
			}
			Task.update()
			History.changed()			
		}
				
		public function get task():Task{
			return _task
		}
		
		public function set task(t:Task):void{
			_task = t
//			percentComplete.value = task.percent_complete
//			priority.value = task.priority
//			startField.text = dateToString(task.start)
//			constraintField.text = dateToString(task.constraintDate)
//			finishField.text = dateToString(task.end)
//			startCalendar.currentDay = task.start
//			milestoneCheck.selected = (task.type == "milestone")
//			startCalendar.enabled = !task.isParent()
		}
	}
}