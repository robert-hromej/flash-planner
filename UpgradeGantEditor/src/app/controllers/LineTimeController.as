package app.controllers{
	import app.views.ChildLine;
	import app.views.MilestoneView;
	import app.views.ParentLineView;
	
	import planner.Task;
	
	public class LineTimeController extends ApplicationController{
		
		private var _type:String = "CHILD";
		
		public var task:Task;
		public var childLine:ChildLine;
		public var parentLine:ParentLineView;
		public var milestone:MilestoneView;
		
		public function LineTimeController(){
			super();
		}
		
		public function get type():String{
			return _type;
		}
		
		public function set type(newType:String):void{
			_type = newType;
			childLine.visible = isChild();
			parentLine.visible = isParent();
			milestone.visible = isMilestone();
		}
		
		public function isChild():Boolean{
			return type == "CHILD"
		}
		
		public function isParent():Boolean{
			return type == "PARENT"
		}
		
		public function isMilestone():Boolean{
			return type == "MILESTONE"
		}
		
		public function set length(width:Number):void{
			childLine.width = width;
//			childLine.setLength(width,task.percent_complete)
//			parentLine.length = width
//			resources.x = width+10
		}
	}
}