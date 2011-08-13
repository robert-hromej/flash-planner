package planner{
	import flash.xml.XMLNode;
	
	public class DayType extends Object{
		
		private var id:uint
		private var name:String
		private var description:String
		
		public function DayType(xml:XML):void{
			this.id = xml.attribute("id")
			this.name = xml.attribute("name")
			this.description = xml.attribute("description")
		}
		
		public function get xml():XMLNode{
			var dt:XMLNode = new XMLNode(1,"day-type")
				dt.attributes = {	
									"id":id,
									"name":name,
									"description":description
								}
			return dt
		}
		
	}
}