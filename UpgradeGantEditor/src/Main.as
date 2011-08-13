package{
	
	import app.controllers.ApplicationController;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	import flash.xml.*;
	
	import planner.Project;
	import planner.Task;
	
	import utils.Global;
	import utils.History;
	import utils.XMLService;
	
	public class Main extends MovieClip{
		
		public function Main(){
			
			if (ExternalInterface.available){
				ExternalInterface.addCallback("getChangedState", Global.getChangedState)
				ExternalInterface.addCallback("clearChangedState", Global.clearChangedState)
				ExternalInterface.addCallback("load", load)
				ExternalInterface.addCallback("save", save)
//				ExternalInterface.addCallback("resize", resize)
			}
			
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
			
//			Global.calendarHeader = calendarHeader
//			Global.gant = gant			
			
//			Global.pleaseMessagePage = new MessagePage()
//			addChild(Global.pleaseMessagePage)
//			Global.pleaseMessagePage.visible = false
			
//			History.undoBT = undoBT
//			History.redoBT = redoBT
			History.init()
//			Global.init()
						
//			openBT.addEventListener("click",openFile)
//			saveBT.addEventListener("click",openSave)
			
			try{
//				ExternalInterface.call(Seating.jsLoadFunction)
			}catch(error:Error){
				trace("not found method")
			}
		}
		
		private function openFile(ev:*):void{
			var myFile:FileReference = new FileReference()
			var plannerFilter:FileFilter = new FileFilter("Planner", "*.planner")
			myFile.browse([plannerFilter])
			myFile.addEventListener( Event.SELECT, selectFile)
			myFile.addEventListener(Event.COMPLETE, loadFile)
		}
		
		private function selectFile(ev:*):void{
			ev.target.load()
		}
		
		private function loadFile(ev:*):void{
			Global.openFileName = ev.target.name
			load(ev.target.data)
			History.reset()
		}
		
		private function openSave(ev:*):void{
			
			var myFile:FileReference = new FileReference();
			var plannerFilter:FileFilter = new FileFilter("Planner", "*.planner");
			myFile.save(XMLService.projectXML(ApplicationController.proj).toString(),Global.openFileName)
			
			function sel(ev:*):void{
			}
		}

			
		public function save():String{
			return XMLService.projectXML(ApplicationController.proj).toString()
		}

		public function load(file:String):void{
			ApplicationController.proj = new Project(new XML(file))
			refresh()
			if (History.historyFiles.length == 0){
				History.changed()
			}
		}

		public function init():void{
			Global.main = this
		}
		
		
		private function refreshContextMenu():void{
			var myContextMenu:ContextMenu = new ContextMenu()
				myContextMenu.hideBuiltInItems()
				
//				if (dg.selectedItem){
//					myContextMenu.customItems.push(insertTaskItem)
//					myContextMenu.customItems.push(insertSubtaskItem)
//					myContextMenu.customItems.push(removeTaskItem)
//					myContextMenu.customItems.push(unlinkTaskItem)
//					myContextMenu.customItems.push(editTaskItem)
//					myContextMenu.customItems.push(indentTaskItem)
//					myContextMenu.customItems.push(unindentTaskItem)
//					myContextMenu.customItems.push(upTaskItem)
//					myContextMenu.customItems.push(downTaskItem)
//				}
//				myContextMenu.customItems.push(resourcesItem)
//				myContextMenu.customItems.push(projectItem)			
			contextMenu = myContextMenu			
		}
		
		public function openProjectPage():void{
//			Global.project.projectPage.x = stage.stageWidth/2
//			Global.project.projectPage.y = stage.stageHeight/2
//			Global.project.projectPage.init()
//			addChild(Global.project.projectPage)
		}		
		
		
//		private function endEdit(ev:DataGridEvent){
//			dg.editable = false
//			ev.target.dataProvider.refresh()
//		}
		
		public static function refresh():void{
			ApplicationController.proj.refresh()
//			Global.gant.update()
			Global.resourcesPage.refresh()
		}
		
	}
}