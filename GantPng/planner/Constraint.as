package planner{
	
	import flash.xml.XMLNode
	import utils.methods.strToDate
	import utils.methods.convertDateToXML
	
	public class Constraint extends Object{
		
		private var _time:Date
		public var type:String
		
		public function Constraint(xml):void{
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
		
	}
}