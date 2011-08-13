package utils {
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	
	import mx.core.IVisualElement;
	
	import planner.Project;
	
	import spark.components.Group;
	
	public class Global{
		
		public static var sp:Group;
		public static var printContainer:Group;
		
		
		public static var origialFile:String
		
		[Bindable] public static var project:Project
		
		public static var tasksContainer:Group
		public static var predecessorsContainer:Group
		
		public static var paneContainer:Group
		public static var app:*
		public static var projectItem:ContextMenuItem
		public static var resourcesItem:ContextMenuItem
		
		public static var _currentPage:IVisualElement
			
	}
}