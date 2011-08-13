package flash.display{
	
	import flash.text.TextField
	import flash.text.TextFormat
	
	import flash.display.MovieClip
	import flash.display.Sprite
	import flash.geom.Point
	import flash.events.MouseEvent
	import flash.events.EventDispatcher
	import flash.events.Event
	import planner.Task
	
	import utils.Global;
	import flash.ui.ContextMenu
	import flash.ui.ContextMenuItem
	import flash.events.ContextMenuEvent
	
	public class LineTime extends MovieClip{
		
		private var childLine:ChildLine
		private var parentLine:ParentLine
		private var milestone:Milestone
		private var task:Task
		private var _type:String
		private var _resources:TextField
		private var f:TextFormat
		
		private var _line:Sprite
		
		public function LineTime(task:Task,t:String="CHILD"):void{
			this.f = new TextFormat()
			this.f.size = 14
			this.f.bold = true
			
			this.parentLine = new ParentLine()
			this.childLine = new ChildLine()
			this.milestone = new Milestone()
			this.type = t
			this.task = task
		}
		
		private function get line():Sprite{
			if (_line == null){
				_line = new Sprite()
				_line.addChild(this.parentLine)
				_line.addChild(this.childLine)
				_line.addChild(this.milestone)
				addChild(_line)
			}
			return _line
		}
		
		public function set type(t:String):void{
			while (line.numChildren > 0){
				line.removeChildAt(0)
			}			
			this._type = t
			if (_type == "CHILD"){
				line.addChild(this.childLine)
				refreshResources()
			}else if (_type == "MILESTONE"){
				line.addChild(this.milestone)
				refreshResources()
			}else if (_type == "PARENT"){
				line.addChild(this.parentLine)
//				refreshResources()
			}
		}
		
		public function get type():String{
			return this._type
		}
		
		public function set rowIndex(i:uint):void{
			y = i*20
		}
		
		public function set length(width):void{
			childLine.setLength(width,task.percent_complete)
			parentLine.length = width
			resources.x = width+10
		}
		
		public function get start():Point{
			return new Point(x,y+10)
		}
		
		public function get end():Point{
			if (type == "CHILD"){
				return new Point(x+childLine.width,y+10)
			}else if (type == "PARENT"){
				return new Point(x+parentLine.width-4,y+10)
			}else if (type == "MILESTONE"){
				return start
			}else{
				return null
			}
		}
		
		private function get resources():TextField{
			if (_resources == null){
				_resources = new TextField()
				_resources.height = 20
				_resources.maxChars = 1000
			}
			return _resources
		}
		
		private function refreshResources():void{
			var str:String = ""
			if (task){
				for each(var al in task.allocations){
					str += al.resource.name
					if(al.units < 100){
						str += "("+al.units+")";
					}
					str += ";"
				}
			}
			resources.width = 8*str.length
			resources.text = str
			resources.setTextFormat(f)
			addChild(resources)
		}
		
	}
}