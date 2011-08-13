package fl.controls{
	
	import flash.display.Sprite
	import planner.Task
	import utils.History
	
	public class NotesPane extends Sprite{
		
		private var _task:Task
		
		public function NotesPane():void{
		}
		
		public function save():void{
			task.note = notesArea.text
			History.changed()
		}
				
		public function get task():Task{
			return _task
		}
		
		public function set task(t):void{
			_task = t
			notesArea.text = task.note
		}
		
	}
}