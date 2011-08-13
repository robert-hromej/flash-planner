package flash.display{
	
	import flash.display.*
	import flash.events.MouseEvent
	import flash.events.EventDispatcher
	import flash.events.Event
	import planner.Task
	import flash.geom.Matrix
	
	public class ParentLine extends MovieClip{
		
		private var _start:Sprite
		private var _end:Sprite
		
		private var w:uint
		
		public function ParentLine():void{
			refresh()
		}
		
		private function get start():Sprite{
			if (!_start){
				_start = new Sprite()
				var matr:Matrix = new Matrix()
				matr.createGradientBox(8, 20,  Math.PI/2, 0, 0) 
				_start.graphics.beginGradientFill(GradientType.LINEAR,
												  [0xDDDDDD, 0x000000], [1, 1], 
												  [0,255], matr)
				_start.graphics.lineStyle(1, 0x000000)
				_start.graphics.moveTo(-4, 6)
				_start.graphics.lineTo(4, 6)
				_start.graphics.lineTo(4, 14)
				_start.graphics.lineTo(0, 18)
				_start.graphics.lineTo(-4, 14)
			}
			return _start
		}
		
		private function get end():Sprite{
			if (!_end){
				_end = new Sprite()
				var matr:Matrix = new Matrix()
				matr.createGradientBox(8, 20,  Math.PI/2, 0, 0) 
				_end.graphics.beginGradientFill(GradientType.LINEAR,
												  [0xDDDDDD, 0x000000], [1, 1], 
												  [0,255], matr)
				_end.graphics.lineStyle(1, 0x000000)
				_end.graphics.moveTo(-4, 6)
				_end.graphics.lineTo(4, 6)
				_end.graphics.lineTo(4, 14)
				_end.graphics.lineTo(0, 18)
				_end.graphics.lineTo(-4, 14)
			}
			return _end
		}
		
		private function get line():Sprite{
			var _line = new Sprite()
			var matr:Matrix = new Matrix()
			matr.createGradientBox(w, 14, Math.PI/2, 0, 0) 
			_line.graphics.beginGradientFill(GradientType.LINEAR,
											  [0xDDDDDD, 0x000000], [1, 1], 
											  [0,255], matr)
			_line.graphics.drawRect(0,6,w,8)
			return (_line)
		}
		
		public function set length(newWidth):void{
			w = newWidth
			refresh()
		}
		
		private function refresh():void{
			while(numChildren > 0){
				removeChildAt(0)
			}
			addChild(line)
			addChild(start)
			addChild(end)
			end.x = w
		}
		
	}
}