package planner{
	
	import flash.display.Arrow
	import flash.xml.XMLNode
	import utils.methods.clearTabs
	
	public class Predecessor extends Object{
		
		public var id:uint
		public var predecessor_id:uint
		public var type:String
		
		private var parentTask_id:uint
		
		public function Predecessor(xml,parentTask:Task):void{
			this.parentTask_id = parentTask.id
			if (xml){
				this.id = xml.attribute("id")
				this.predecessor_id = xml.attribute("predecessor-id")
				this.type = xml.attribute("type")
			}
		}
		
		public function get parentTask():Task{
			return Task.findById(parentTask_id)
		}
		
		public function get predTask():Task{
			return Task.findById(predecessor_id)
		}
		
		public function get predTaskName():String{
			return predTask.wbsName
		}
		
		public function toString():String{
			return "predecessor_id: "+predecessor_id
		}
		
		public function get arrow():Arrow{
			switch (type){
				case "FF":
					return new Arrow(predTask.lineTime.end,parentTask.lineTime.end,type)
					break
				case "SS":
					return new Arrow(predTask.lineTime.start,parentTask.lineTime.start,type)
					break
				case "SF":
					return new Arrow(predTask.lineTime.start,parentTask.lineTime.end,type)
					break
				case "FS":
					return new Arrow(predTask.lineTime.end,parentTask.lineTime.start,type)
					break
				default:
					return null
			}
		}
	}
}