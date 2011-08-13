package planner{
	
	import flash.xml.XMLNode
	import fl.controls.Button
	import utils.Global
	
	public class Resource extends Object{
		
		public var id:uint
		public var name:String = ""
		public var short_name:String = ""
		public var type:Number = 1
		public var units:uint
		public var email:String = ""
		public var note:String = ""
		private var std_rate:Number = 0
		
		public var taskUnits:Number
		
		public function unitsByTask(task:Task=null):Number{
			if (!taskUnits && task){
				for each(var al:Allocation in Global.project.allocations){
					if (al.taskId == task.id && al.resource_id == id){
						taskUnits = al.units
					}
				}
			}
			return taskUnits
		}
		
		public function Resource(xml):void{
			if (xml){
				this.id = xml.attribute("id")
				this.name = xml.attribute("name")
				this.short_name = xml.attribute("short-name")
				this.type = xml.attribute("type")
				this.units = xml.attribute("units")
				this.email = xml.attribute("email")
				this.note = xml.attribute("note")
				this.std_rate = xml.attribute("std-rate")
			}
		}
		
		////////////////////////////////////////////////////
		//			static variables and methods
		////////////////////////////////////////////////////
		
		private static var _autoincrement:uint = 0
		
		private static function get autoincrement():uint{
			for each(var res in Global.project.resources){
				if (_autoincrement < res.id){
					_autoincrement = res.id
				}
			}
			return _autoincrement
		}
		
		private static function set autoincrement(id):void{
			_autoincrement = id
		}
		
		public static function insert(resource):Resource{
			autoincrement++
			resource.id = autoincrement
			Global.project.resources.push(resource)
			return resource
		}
		
	}
}