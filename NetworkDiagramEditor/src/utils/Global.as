package utils {
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	
	import mx.core.IVisualElement;
	
	import mxml.NewTaskPage;
	import mxml.ProjectEditPage;
	import mxml.ResourcesPage;
	
	import planner.Project;
	
	import spark.components.Group;
	
	public class Global{
		
		public static var origialFile:String
		
		[Bindable] public static var project:Project
		
		public static var tasksContainer:Group
		public static var predecessorsContainer:Group
		public static var paneContainer:Group
		public static var app:*
		public static var addNewTaskItem:ContextMenuItem
		public static var projectItem:ContextMenuItem
		public static var resourcesItem:ContextMenuItem
		
		public static var _currentPage:IVisualElement
			
		{
			addNewTaskItem = new ContextMenuItem("Insert Task")
			addNewTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function():void{
				Global.openPage(new NewTaskPage());
			})
			resourcesItem = new ContextMenuItem("Resources")
			resourcesItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function():void{
				Global.openPage(new ResourcesPage())
			})
			projectItem = new ContextMenuItem("Project")
			projectItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,function():void{
				Global.openPage(new ProjectEditPage())
			})
		}

		
		public function Global(){
		}
		
		public static function openPage(el:IVisualElement):void{
			closeAllPage();
			if (el){
				_currentPage = el
				el.x = paneContainer.mouseX
				el.y = paneContainer.mouseY
				paneContainer.addElement(el)
			}
		}
		
		public static function closeAllPage():void{
			paneContainer.removeAllElements()
			_currentPage = null
		}
		
		public static function get currentPage():IVisualElement{
			return _currentPage
		}
		
		public static function getChangedState():Boolean{
			return (project.xml.toString() != origialFile)
		}
		
		public static function clearChangedState():void{
			origialFile = project.xml.toString()
		}
		
	}
}