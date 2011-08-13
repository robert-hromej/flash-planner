package planner{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.xml.XMLNode;
	
	import flash.display.Arrow;
	import utils.Global;
	
	public class Predecessor extends Object{
		
		public var id:uint
		public var predecessor_id:uint
		[Bindable] public var type:String
		public var _arrow:Arrow
		
		[Bindable] public var parentTask:Task
		
		public function Predecessor(xml:XML,parentTask:Task):void{
			this.parentTask = parentTask
			if (xml){
				this.id = xml.attribute("id")
				this.predecessor_id = xml.attribute("predecessor-id")
				this.type = xml.attribute("type")
			}
		}
		
		public function get arrow():Arrow{
			if (_arrow == null){
				_arrow = new Arrow(predTask,parentTask,"predecessor")
			}
			return _arrow 
		}
		
		
		public function get predTask():Task{
			return Task.findById(predecessor_id)
		}
		
		public function get predTaskName():String{
			return predTask.name
			return predTask.wbsName
		}
		
		public function toString():String{
			return predecessor_id + type
		}
		
		public function get xml():XMLNode{
			var predXml:XMLNode = new XMLNode(1,"predecessor")
				predXml.attributes = {	"id":id,
										"predecessor-id":predecessor_id,
										"type":type
									 }
			return predXml
		}

	}
}