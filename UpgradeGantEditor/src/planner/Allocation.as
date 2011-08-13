package planner{
	
	import app.controllers.ApplicationController;
	
	import flash.xml.XMLNode;
	
	import planner.Task;
	
	import utils.Global;
	
	public class Allocation extends Object{
		
		public var taskId:uint
		public var resource_id:uint
		public var units:Number
		
		public function Allocation(xml:XML):void{
			if (xml){
				this.taskId = xml.attribute("task-id")
				this.resource_id = xml.attribute("resource-id")
				this.units = xml.attribute("units")
			}
		}
		
		public function get task():Task{
			return Task.findById(taskId)
		}
		
		public function get resource():Resource{
			return ApplicationController.proj.f(resource_id)
		}
		
		public function get xml():XMLNode{
			var thisXml:XMLNode = new XMLNode(1,"allocation")
			thisXml.attributes = {
									"task-id":taskId,
									"resource-id":resource_id,
									"units":units
								 }
			return thisXml
		}
		
	}
}