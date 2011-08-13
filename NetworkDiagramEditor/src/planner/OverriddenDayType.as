package planner{
	import flash.xml.XMLNode;
	
	
	public class OverriddenDayType{
		
		public var intervals:Array
		
		public static var durationDay:uint
			
		public function OverriddenDayType(xml:XML){
			durationDay = 0
			intervals = new Array()
			for each(var el:XML in xml.child("interval")){
				var interval:WorkInterval = new WorkInterval(el)
				intervals.push(interval)
				durationDay += interval.duration
			}
			intervals.sortOn("start")
		}
		
		private function loadIntervals(xml:XML):void{
		}
		
		public function get workDuration():uint{
			var d:uint
//			for (var i in intervals){
//				d += intervals[i].duration
//			}
			return d
		}
		
		public function get xml():XMLNode{
			var thisXML:XMLNode = new XMLNode(1,"overridden-day-type")
				thisXML.attributes = {id:0}
			for each(var d:WorkInterval in intervals){
				thisXML.insertBefore(d.xml,null)
			}
			return thisXML
		}
		
	}
}