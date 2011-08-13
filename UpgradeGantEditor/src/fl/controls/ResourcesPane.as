package fl.controls{
	
	import app.controllers.ApplicationController;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.events.ListEvent;
	
	import planner.Resource;
	import planner.Task;
	
	import utils.Global;
	
	public class ResourcesPane extends Sprite{
		
		private var _task:Task
		private var selectResources:Array = new Array()
		
		public function ResourcesPane():void{
//			addBT.addEventListener(MouseEvent.CLICK, addResource)
//			removeBT.addEventListener(MouseEvent.CLICK, removeResource)
//			taskResources.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,clickToResource)
//			saveUnitsBT.addEventListener(MouseEvent.CLICK, editUnitsStatus)
//			cancelUnitsBT.addEventListener(MouseEvent.CLICK, closeUnitsPane)
//			closeUnitsPane()
		}
		
		private function editUnitsStatus(ev:MouseEvent):void{
//			taskResources.selectedItem.data.taskUnits = unitsStepper.value
//			closeUnitsPane()
		}
		
		private function closeUnitsPane(ev:*=null):void{
//			taskResources.enabled = true
//			taskResources.alpha = 1
//			backFont.alpha = 0
//			backFont.x = 1000
//			unitsStepper.visible = false
//			unitsLabel.visible = false
//			saveUnitsBT.visible = false
//			cancelUnitsBT.visible = false
		}
		
		private function clickToResource(ev:ListEvent=null):void{
//			if (taskResources.selectedItem){
//				unitsStepper.value = taskResources.selectedItem.data.unitsByTask(_task)
//				taskResources.enabled = false
//				backFont.alpha = 1
//				backFont.x = 300
//				taskResources.alpha = 0.3
//				unitsStepper.visible = true
//				unitsLabel.visible = true
//				saveUnitsBT.visible = true
//				cancelUnitsBT.visible = true
//			}
		}
		
		private function addResource(ev:MouseEvent):void{
//			for each(var t in allResources.selectedItems){
//				selectResources.push(t.data)
//			}
//			refresh()
		}
		
		private function removeResource(ev:MouseEvent):void{
//			var res
//			var dels:Array = new Array()
//			for each(res in taskResources.selectedItems){
//				dels.push(res.data)
//			}
//			var ar:Array = new Array()
//			for each(res in selectResources){
//				if (dels.indexOf(res) == -1){
//					ar.push(res)
//				}
//			}
//			selectResources = ar
//			refresh()
		}
		
		public function save():void{
			ApplicationController.proj.editAllocations(task.id,selectResources)
		}
				
		public function get task():Task{
			return _task
		}
		
		public function set task(t:Task):void{
//			_task = t
//			if (task.isParent()){
//				taskResources.enabled = false
//				allResources.enabled = false
//				addBT.enabled = false
//				removeBT.enabled = false
//			}else{
//				taskResources.enabled = true
//				allResources.enabled = true
//				addBT.enabled = true
//				removeBT.enabled = true
//			}
//			selectResources = task.resources
//			refresh()
		}
		
		public function refresh():void{
//			var res:Resource
//			taskResources.removeAll()
//			for each(res in selectResources){
//				taskResources.addItem({label:res.name, data:res})
//			}
//			allResources.removeAll()
//			for each(res in Global.project.resources){
//				if (selectResources.indexOf(res) == -1){
//					allResources.addItem({label:res.name, data:res})
//				}
//			}
		}
		
	}
}