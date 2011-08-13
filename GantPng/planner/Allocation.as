package planner{
	
	import flash.xml.XMLNode
	import planner.Task
	import utils.Global
	
	public class Allocation extends Object{
		
		public var taskId:uint
		public var resource_id:uint
		public var units:Number
		
		public function Allocation(xml):void{
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
			return Global.project.f(resource_id)
		}
		
	}
}