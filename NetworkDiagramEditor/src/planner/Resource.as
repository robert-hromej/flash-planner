package planner{
	import flash.xml.XMLNode;
	import utils.Global;
	
	public class Resource extends Object{
		
		public var id:uint
		[Bindable] public var name:String = ""
		public var short_name:String = ""
		public var type:Number = 1
		public var units:Number = 100
		public var email:String = ""
		public var note:String = ""
		private var std_rate:Number = 0
			
		public var taskUnits:Number = 100
		
		public function Resource(xml:XML=null):void{
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
		
		public static function create(name:String):void{
			var res:Resource = new Resource()
			res.name = name
			insert(res)
		}
		
		public function get label():String{
			return name
		}
		
		public function destroy():Boolean{
			return Resource.destroy(this)
		}
		
		public function unitsByTask(task:Task=null):Number{
			taskUnits = 100
			if (task){
				for each(var al:Allocation in Global.project.allocations){
					if (al.taskId == task.id && al.resource_id == id){
						taskUnits = al.units
					}
				}
			}
			return taskUnits
		}
		
//		public function get delColumn():String{
//			return "Delete"
//		}
		
		public function toString():String{
			return name
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
		
		
		
//		////////////////////////////////////////////////////
//		//			static variables and methods
//		////////////////////////////////////////////////////
		
		private static var _autoincrement:uint
		
		private static function get autoincrement():uint{
			for each(var res:Resource in Global.project.resources){
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
			Global.project.resources.push(resource)
			return resource
		}
		
		public static function destroy(resourse:Resource):Boolean{
			
			for each(var all:Allocation in Global.project.allocations){
				if (all.resource == resourse){
					all.task.addToUpdate()
				}
			}
			
			var ar:Array = new Array()
			var b:Boolean = false
			var tempResourse:Resource
			
			while (Global.project.resources.length > 0){
				tempResourse = Global.project.resources.shift()
				if (tempResourse == resourse){
					b = true
				}else{
					ar.push(tempResourse)
				}
			}
			Global.project.resources = ar;
			Global.project.clearAllocations();
			Task.update();
			Global.project.refresh();
			return b
		}
		
	}
}