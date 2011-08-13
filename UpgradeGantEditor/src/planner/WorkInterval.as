package planner{
	
	import flash.xml.XMLNode;
	
	import utils.methods.*;
		
	public class WorkInterval{
		
		public var start:uint
		public var end:uint
			
		public function WorkInterval(xml:XML):void{
			start = strToSecond(xml.attribute("start"))
			end = strToSecond(xml.attribute("end"))
		}
		
		public function get duration():uint{
			return end-start
		}
		
		public function isIn(s:uint):Boolean{
			return (start <= s && end >= s)
		}
		
		
		public function toString():String{
			return minuteToStr(start/60)+"-"+minuteToStr(end/60)
		}
		
		public function get xml():XMLNode{
			var thisXML:XMLNode = new XMLNode(1,"interval")
			thisXML.attributes = {
									"start":minuteToStr(start/60),
									"end":minuteToStr(end/60)
								 }
			return thisXML
		}
				
		
	}
}