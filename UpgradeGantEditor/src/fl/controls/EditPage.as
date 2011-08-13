package fl.controls{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import planner.Task;
	
	import utils.Global;
	import utils.History;
	import utils.methods.clearTabs;
	
	public class EditPage extends Sprite{
		
		private var _task:Task
		
		private var general:GeneralPane = new GeneralPane()
		private var predecessors:PredecessorsPane = new PredecessorsPane()
		private var resources:ResourcesPane = new ResourcesPane()
		private var notes:NotesPane = new NotesPane()
		
		private var pane:Sprite
		
		public function EditPage():void{
			
			pane = new Sprite()
			addChild(pane)
			pane.x = -230
			pane.y = -50
				
			general.addEventListener("update", refresh)
			predecessors.addEventListener("update", refresh)
			resources.addEventListener("update", refresh)
			notes.addEventListener("update", refresh)
			
//			generalBT.addEventListener(MouseEvent.CLICK,openGeneralPane)
//			predecessorsBT.addEventListener(MouseEvent.CLICK,openPredecessorsPane)
//			resourcesBT.addEventListener(MouseEvent.CLICK,openResourcesPane)
//			notesBT.addEventListener(MouseEvent.CLICK,openNotesPane)
//			
//			okBT.addEventListener(MouseEvent.CLICK,save)
//			cancelBT.addEventListener(MouseEvent.CLICK,close)
//			exitBT.addEventListener(MouseEvent.CLICK,close)
			
			openGeneralPane()
		}
		
		public function openGeneralPane(ev:MouseEvent=null):void{
			clearPane()
			pane.addChild(general)
//			gTab.alpha = 0
		}
		
		private function openPredecessorsPane(ev:MouseEvent=null):void{
			clearPane()
			pane.addChild(predecessors)
//			pTab.alpha = 0
		}
		
		private function openResourcesPane(ev:MouseEvent=null):void{
			clearPane()
			pane.addChild(resources)
//			rTab.alpha = 0
		}
		
		private function openNotesPane(ev:MouseEvent=null):void{
			clearPane()
			pane.addChild(notes)
//			nTab.alpha = 0
		}
		
		private function clearPane():void{
			while(pane.numChildren > 0){
				pane.removeChildAt(0)
			}
//			gTab.alpha = 1
//			pTab.alpha = 1
//			rTab.alpha = 1
//			nTab.alpha = 1
		}
		
		private function save(ev:MouseEvent):void{
			general.save()
			predecessors.save()
			resources.save()
			notes.save()
//			task.name = taskName.text
//			task.workColumn = taskDuration.text
			close()
			History.changed()
		}
		
		private function close(ev:MouseEvent=null):void{
			Global.closeEditTask()
			Main.refresh()
		}
		
		public function get task():Task{
			return _task
		}
		
		public function set task(t:Task):void{
			_task = t

//			taskName.text = clearTabs(task.name)
//			taskDuration.text = task.workColumn
//			taskDuration.enabled = (!task.isParent() && (task.type != "milestone"))
			
			general.task = task
			predecessors.task = task
			resources.task = task
			notes.task = task
		}

		private function refresh(ev:Event):void{
			task = task
		}
		
	}
}