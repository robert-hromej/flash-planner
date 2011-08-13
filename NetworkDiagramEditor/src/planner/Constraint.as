package planner{
	import flash.xml.XMLNode;
	
	import utils.methods.convertDateToXML;
	import utils.methods.strToDate;
	
	public class Constraint extends Object{
		
		private var parentTask:Task
		
		private var _time:Date
		private var _type:String
		
		public function Constraint(xml:XML,parentTask:Task):void{
			this.parentTask = parentTask
			if (xml){
				this.time = strToDate(xml.attribute("time"))
				this.type = xml.attribute("type")
			}
		}
		
		public function set time(newTime:Date):void{
			type = "start-no-earlier-than"
			this._time = newTime
//			parentTask.addToUpdate()
		}
		
		public function get time():Date{
			return _time
		}
		
		public function set type(newType:String):void{
			this._type = newType
		}
		
		public function get xml():XMLNode{
			var thisXML:XMLNode = new XMLNode(1,"constraint")
			thisXML.attributes = {
									"type":_type,
									"time":convertDateToXML(_time)
								 }
			return thisXML
		}
		
		public static function create(xml:XML,parentTask:Task):Constraint{
			if (xml){
				return new Constraint(xml,parentTask)
			}
			return null
		}
		
	}
}