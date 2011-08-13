package planner{
	
	import flash.display.Arrow
	import flash.xml.XMLNode
	import utils.methods.clearTabs
	
	public class Predecessor extends Object{
		
		public var id:uint
		public var predecessor_id:uint
		public var type:String
		
		private var parentTask_id:uint
		
		public function Predecessor(xml,parentTask:Task):void{
			this.parentTask_id = parentTask.id
			if (xml){
				this.id = xml.attribute("id")
				this.predecessor_id = xml.attribute("predecessor-id")
				this.type = xml.attribute("type")
			}
		}
		
		public function copy(parentTask:Task):Predecessor{
			var pred:Predecessor = new Predecessor(null,parentTask);
			pred.id = id;
			pred.predecessor_id = predecessor_id;
			pred.type = type;
			return pred;
		}
		
		public function destroy():void{
			var ar:Array = new Array()
			var tempPred:Predecessor
			while (parentTask.predecessors.length > 0){
				tempPred = parentTask.predecessors.shift()
				if (tempPred != this){
					ar.push(tempPred)
				}
			}
			parentTask.predecessors = ar
			parentTask.addToUpdate()
			Task.update()
		}
		
		public function get delColumn():String{
			return " Delete"
		}

		public function get parentTask():Task{
			return Task.findById(parentTask_id)
		}
		
		public function get predTask():Task{
			return Task.findById(predecessor_id)
		}
		
		public function get predTaskName():String{
			return predTask.wbsName
		}
		
		public function toString():String{
			return "predecessor_id: "+predecessor_id
		}
		
		public function get arrow():Arrow{
			if (predTask){
				var color:uint = (predTask.isParent()) ? 0x000000 : 0x0000e9;
				switch (type){
					case "FF":
						return new Arrow(predTask.lineTime.end,parentTask.lineTime.end,type, color);
						break;
					case "SS":
						return new Arrow(predTask.lineTime.start,parentTask.lineTime.start,type, color);
						break;
					case "SF":
						return new Arrow(predTask.lineTime.start,parentTask.lineTime.end,type, color);
						break;
					case "FS":
						return new Arrow(predTask.lineTime.end,parentTask.lineTime.start,type, color);
						break;
					default:
						return null;
				}
			}else{
				return null;
			}
		}
		
		public function get xml():XMLNode{
			var predXml:XMLNode = new XMLNode(1,"predecessor");
				predXml.attributes = {	"id":id,
										"predecessor-id":predecessor_id + Task.deltaId,
										"type":type
									 };;
			return predXml;;
		}

	}
}