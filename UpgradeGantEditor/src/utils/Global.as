package utils{
		
	import app.controllers.ApplicationController;
	import app.views.GantView;
	
	import fl.controls.EditPage;
	import fl.controls.ResourcesPage;
	
	import flash.display.Header;
	
	import mx.core.Application;
	
	import planner.Project;
	
	public class Global{

		public static var gant:GantView;
		
		public static var app:UpgradeGantEditor;
		
		public static var openFileName:String = "file name.planner"

		public static var main:Main
		public static var calendarHeader:*
		public static var editPage:EditPage = new EditPage()
		public static var resourcesPage:ResourcesPage = new ResourcesPage()

		public static var origialFile:String
		
		public static var funcTimer:uint = 100
		
		
		public static function openEditTask(selectTask):void{
			main.addChild(editPage)
//			main.dg.enabled = false
//			main.gant.enabled = false
//			main.calendarHeader.enabled = false
			editPage.task = selectTask
			editPage.openGeneralPane()
		}
		
		public static function closeEditTask():void{
			main.removeChild(editPage)
//			main.dg.enabled = true
//			main.gant.enabled = true
//			main.calendarHeader.enabled = true
		}
		
		public static function openResourcesPage():void{
			main.addChild(resourcesPage)
//			main.dg.enabled = false
//			main.gant.enabled = false
//			main.calendarHeader.enabled = false
		}
		
		public static function closeResourcesPage():void{
			main.removeChild(resourcesPage)
//			main.dg.enabled = true
//			main.gant.enabled = true
//			main.calendarHeader.enabled = true
		}
				
		public static function getChangedState():Boolean{
			return (XMLService.projectXML(ApplicationController.proj).toString() != origialFile)
		}
		
		public static function clearChangedState():void{
			origialFile = XMLService.projectXML(ApplicationController.proj).toString()
		}
		
	}
	
}