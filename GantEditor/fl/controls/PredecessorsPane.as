package fl.controls{
	
	import fl.data.DataProvider
	import flash.display.Sprite
	import planner.Task
	import utils.methods.clearTabs
	import utils.methods.copyArray
	import utils.History
	import flash.events.MouseEvent
	import fl.controls.dataGridClasses.DataGridColumn
	import flash.events.EventDispatcher
	import flash.events.Event
	import fl.events.ListEvent
	import fl.controls.cellRenderers.DeleteCellRenderer
	
	public class PredecessorsPane extends Sprite{
		
		private var _task:Task
		private var _predecessorsTaskDP:DataProvider
		
		public function PredecessorsPane():void{
			
			var statusColumn = dg.addColumn("predTaskName")
				statusColumn.headerText = "Task Name"
				statusColumn.width = 370
//				statusColumn.editable = false
//				statusColumn.resizable = false

			var typeColumn = dg.addColumn("type")
				typeColumn.headerText = "Type"
				typeColumn.width = 40
				typeColumn.resizable = false

			var delColumn = dg.addColumn("delColumn")
				delColumn.headerText = ""
				delColumn.width = 40
				delColumn.editable = false
				delColumn.resizable = false
				delColumn.cellRenderer = DeleteCellRenderer
			
			dg.dataProvider = predecessorsDataProvider
			addPredecessor.addEventListener(MouseEvent.CLICK,addPred)
			dg.addEventListener(ListEvent.ITEM_CLICK, destroy)
		}
		
		private function destroy(ev:ListEvent):void{
			if (ev.columnIndex == 2){
				ev.item.destroy()
				refresh()
			}
			History.changed()
 		}
		
		private function addPred(ev):void{
			task.addPredecessor(allTaskComboBox.selectedItem.task,type.selectedItem.data)
			dispatchEvent(new Event("update"))
			refresh()
			History.changed()
		}
		
		public function save():void{
		}
		
		public function get task():Task{
			return _task
		}
		
		public function set task(t):void{
			_task = t
			refresh()
		}
		
		private function get predecessorsDataProvider():DataProvider{
			if (_predecessorsTaskDP == null){
				_predecessorsTaskDP = new DataProvider()
			}
			return _predecessorsTaskDP
		}
		
		private function refresh():void{
			predecessorsDataProvider.removeAll()
			predecessorsDataProvider.addItems(task.predecessors)
			allTaskComboBox.dataProvider = task.newPredecessorsList
		}
		
	}
}