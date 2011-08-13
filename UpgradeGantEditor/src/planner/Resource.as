package planner{
	
	import app.controllers.ApplicationController;
	
	import flash.xml.XMLNode;
	
	import utils.Global;
	
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
				for each(var al:Allocation in ApplicationController.proj.allocations){
					if (al.taskId == task.id && al.resource_id == id){
						taskUnits = al.units
					}
				}
			}
			return taskUnits
		}
		
		public function Resource(xml:XML):void{
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
		
		public function destroy():Boolean{
			return Resource.destroy(this)
		}
		
		public function get delColumn():String{
			return " Delete"
		}
		
		public function get xml():XMLNode{
			var thisXML:XMLNode = new XMLNode(1,"resource")
			thisXML.attributes = {
									"id":id,
									"name":name,
									"short-name":short_name,
									"type":type,
									"units":units,
									"email":email,
									"note":note,
									"std-rate":std_rate
								 }
			return thisXML
		}
		
		
		
		////////////////////////////////////////////////////
		//			static variables and methods
		////////////////////////////////////////////////////
		
		private static var _autoincrement:uint = 0
		
		private static function get autoincrement():uint{
			for each(var res:Resource in ApplicationController.proj.resources){
				if (_autoincrement < res.id){
					_autoincrement = res.id
				}
			}
			return _autoincrement
		}
		
		private static function set autoincrement(id:uint):void{
			_autoincrement = id
		}
		
		public static function insert(resource:Resource):Resource{
			autoincrement++
			resource.id = autoincrement
			ApplicationController.proj.resources.push(resource)
			return resource
		}
		
		public static function destroy(resourse:Resource):Boolean{
			
			for each(var all:Allocation in ApplicationController.proj.allocations){
				if (all.resource == resourse){
					all.task.addToUpdate()
					//return false
				}
			}
			
			var ar:Vector.<Resource> = new Vector.<Resource>();
			var b:Boolean = false
			var tempResourse:Resource;
			while (ApplicationController.proj.resources.length > 0){
				tempResourse = ApplicationController.proj.resources.shift()
				if (tempResourse == resourse){
					b = true
				}else{
					ar.push(tempResourse)
				}
			}
			ApplicationController.proj.resources = ar
			ApplicationController.proj.clearAllocations()
			Task.update()
			Main.refresh()
			return b
		}
		
	}
}