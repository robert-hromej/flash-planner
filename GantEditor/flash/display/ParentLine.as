package flash.display{
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import planner.Task;
	
	public class ParentLine extends MovieClip{
		
		private var _start:Sprite;
		private var _end:Sprite;
		
		private var w:uint
		private var percent_complete:uint
		
		public function ParentLine():void{
			refresh()
		}
		
		private function get start():Sprite{
			if (!_start){
				_start = new Sprite();
				_start.y = 10;
				_start.graphics.lineStyle(1, 0x000000);
				_start.graphics.beginFill(0x000000);
				_start.graphics.moveTo(0, 4);
				_start.graphics.lineTo(4, 0);
				_start.graphics.lineTo(0, -4);
				_start.graphics.lineTo(-4, 0);
			}
			return _start
		}
		
		private function get end():Sprite{
			if (!_end){
				_end = new Sprite();
				_end.y = 10;
				_end.graphics.lineStyle(1, 0x000000);
				_end.graphics.beginFill(0x000000);
				_end.graphics.moveTo(0, 4);
				_end.graphics.lineTo(4, 0);
				_end.graphics.lineTo(0, -4);
				_end.graphics.lineTo(-4, 0);
			}
			return _end
		}
		
		private function drawLine():void{
			var percent_line:Sprite = new Sprite();
				percent_line.graphics.beginFill(0x8a1af9);
				percent_line.graphics.drawRect(0,5,w*percent_complete/100,10);
			addChild(percent_line);
			
			var line:Sprite = new Sprite();
			line.y = 7;
			var matr:Matrix = new Matrix();
			matr.createGradientBox(w, 6, Math.PI/2, 0, 0) 
			line.graphics.beginGradientFill(GradientType.LINEAR,
											  [0xFFFFFF, 0x000000, 0x000000, 0xFFFFFF], [1, 1, 1, 1], 
											  [0, 256/20*7, 256/20*13, 255], matr);
			line.graphics.drawRect(0,0,w,6);
			addChild(line);
		}
		
		public function setLength(newWidth:uint,percent_complete:uint):void {
			w = newWidth;
			this.percent_complete = percent_complete;
			refresh();
		}
		
		private function refresh():void{
			while(numChildren > 0){
				removeChildAt(0);
			}
			drawLine();
			addChild(start);
			addChild(end);
			end.x = w;
		}
		
	}
}