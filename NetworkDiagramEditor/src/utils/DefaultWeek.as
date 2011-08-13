package utils{
	
	import flash.xml.XMLNode;
	
	public class DefaultWeek extends Object{
		
		private var mon:uint
		private var tue:uint
		private var wed:uint
		private var thu:uint
		private var fri:uint
		private var sat:uint
		private var sun:uint
		
		public function DefaultWeek(xml:XMLList):void{
			this.mon = xml.attribute("mon")
			this.tue = xml.attribute("tue")
			this.wed = xml.attribute("wed")
			this.thu = xml.attribute("thu")
			this.fri = xml.attribute("fri")
			this.sat = xml.attribute("sat")
			this.sun = xml.attribute("sun")
		}
		
		public function get xml():XMLNode{
			var thisXML:XMLNode = new XMLNode(1,"default-week")
				thisXML.attributes = {
										"mon":mon,
										"tue":tue,
										"wed":wed,
										"thu":thu,
										"fri":fri,
										"sat":sat,
										"sun":sun
									 }
			return thisXML
		}
		
	}
	
}