package planner{
	import flash.xml.XMLNode;
	
	public class Calendars{
		
		private var dayTypes:Array = new Array()
		public var calendar:Calendar
		
		public function Calendars(xml:XML){
			loadDayTypes(xml.child("day-types")[0])
			calendar = new Calendar(xml.child("calendar")[0])
		}
		
		private function loadDayTypes(xml:XML):void{
			for each(var el:XML in xml.child("day-type")){
				dayTypes.push(new DayType(el))
			}			
		}
		
		public function get xml():XMLNode{
			var calendarsXML:XMLNode = new XMLNode(1,"calendars")
				calendarsXML.insertBefore(dayTypesXML,null)
				calendarsXML.insertBefore(calendar.xml,null)
			return calendarsXML
		}
		
		private function get dayTypesXML():XMLNode{
			var dayTypesXML:XMLNode = new XMLNode(1,"day-types")
			for each(var res:DayType in dayTypes){
				dayTypesXML.insertBefore(res.xml,null)
			}
			return dayTypesXML
		}
		
		
	}
}