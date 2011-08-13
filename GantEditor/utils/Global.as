package utils{
		
	import fl.ToolTip;
	import fl.containers.ScrollPane;
	import fl.controls.EditPage;
	import fl.controls.ResourcesPage;
	
	import flash.display.Header;
	
	import planner.Project;
	
	public class Global{
				
		public static var pleaseMessagePage:MessagePage;
		
		public static var tooltip:ToolTip = ToolTip.getInstance()
		public static var header:Header = new Header()
		public static var project:Project
		
		public static var openFileName:String = "file name.planner"

		public static var main:Main;
		public static var calendarHeader:ScrollPane;
		public static var gant:ScrollPane;
		public static var editPage:EditPage = new EditPage();
		public static var resourcesPage:ResourcesPage = new ResourcesPage();

		public static var origialFile:String;
		
		public static var funcTimer:uint = 100;
		
		public static function init():void{
			tooltip.multiLine = false;
		}
		
		
		public static function openMessagePage():void{
			pleaseMessagePage.x = main.stage.stageWidth/2;
			pleaseMessagePage.y = main.stage.stageHeight/2;
			pleaseMessagePage.visible = true;
		}
		
		public static function closeMessagePage():void{
			pleaseMessagePage.visible = false;
			Global.main.refreshMenu();
		}
		
		public static function openEditTask(selectTask):void{
			main.addChild(editPage);
			main.dg.enabled = false;
			main.gant.enabled = false;
			main.calendarHeader.enabled = false;
			editPage.task = selectTask;
			editPage.openGeneralPane();
		}
		
		public static function closeEditTask():void{
			main.removeChild(editPage);
			main.dg.enabled = true;
			main.gant.enabled = true;
			main.calendarHeader.enabled = true;
		}
		
		public static function openResourcesPage():void{
			main.addChild(resourcesPage);
			main.dg.enabled = false;
			main.gant.enabled = false;
			main.calendarHeader.enabled = false;
		}
		
		public static function closeResourcesPage():void{
			main.removeChild(resourcesPage)
			main.dg.enabled = true
			main.gant.enabled = true
			main.calendarHeader.enabled = true
		}
				
		public static function getChangedState():Boolean{
			return (project.xml.toString() != origialFile)
		}
		
		public static function clearChangedState():void{
			origialFile = project.xml.toString()
		}
		
	}
	
}