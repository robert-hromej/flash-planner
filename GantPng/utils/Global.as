package utils{
		
	import flash.display.Header;
	import flash.display.Sprite;
	
	import planner.Project;
	
	public class Global{
				
		public static var project:Project;
		
		public static var main:Main;
		
		public static var gant:*;
		
		public static var scrollContainer:Sprite = new Sprite();
		public static var sp:Sprite = new Sprite();
		
		public static var header:Header = new Header();
		public static var taskTreeContainer:Sprite = new Sprite();
		public static var taskLineContainer:Sprite = new Sprite();
		
		public static var alert:MessagePage = new MessagePage();
		

	}
	
}