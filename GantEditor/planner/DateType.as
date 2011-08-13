package planner{
	
	import flash.xml.XMLNode
	
	public class DateType extends Object{
		
		public var id:uint
		public var name:String
		public var description:String
		
		public function DateType(xml:XML):void{
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