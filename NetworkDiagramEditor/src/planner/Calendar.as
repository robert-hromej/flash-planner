package planner{
	
	import flash.xml.XMLNode;
	import utils.DefaultWeek;
	
	
	public class Calendar{
		
		private var id:uint
		private var name:String
		
		private var defaultWeek:DefaultWeek
		public var overriddenDayTypes:Array
		
		public function Calendar(xml:XML):void{
			id = xml.attribute("id")
			name = xml.attribute("name")
			defaultWeek = new DefaultWeek(xml.elements("default-week"))
			loadOverriddenDayTypes(xml.elements("overridden-day-types")[0])
		}
		
		private function loadOverriddenDayTypes(xml:XML):void{
			overriddenDayTypes = new Array()
			overriddenDayTypes.push(new OverriddenDayType(xml.child("overridden-day-type")[0]))
		}
		
		public function get xml():XMLNode{
			var calendarXML:XMLNode = new XMLNode(1,"calendar")
				calendarXML.attributes = {id:id, name:name}
				calendarXML.insertBefore(defaultWeek.xml,null)
				calendarXML.insertBefore(overriddenDayTypesXML,null)
			return calendarXML
		}
		
		private function get overriddenDayTypesXML():XMLNode{
			var overridden_d_t_xml:XMLNode = new XMLNode(1,"overridden-day-types")
			for each(var d:OverriddenDayType in overriddenDayTypes){
				overridden_d_t_xml.insertBefore(d.xml,null)
			}
			return overridden_d_t_xml
		}
		
	}
}