package planner{
	
	import flash.xml.XMLNode;
	
	import utils.methods.convertDateToXML;
	import utils.methods.strToDate;
	
	public class Constraint extends Object{
		
		private var _time:Date
		public var type:String
		
		public function Constraint(xml:XMLList):void{
			if (xml){
				this.time = strToDate(xml.attribute("time"))
				this.type = xml.attribute("type")
			}
		}
		
		public function set time(newTime:Date):void{
			type = "start-no-earlier-than"
			this._time = newTime
		}
		
		public function get time():Date{
			return _time
		}
		
		public function get xml():XMLNode{
			var thisXML:XMLNode = new XMLNode(1,"constraint")
			thisXML.attributes = {
									"type":type,
									"time":convertDateToXML(_time)
								 }
			return thisXML
		}
		
	}
}