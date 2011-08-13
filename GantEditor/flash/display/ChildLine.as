package flash.display{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	public class ChildLine extends MovieClip {

		private var _w:uint = 10;
		private var _line:Sprite = new Sprite();
		public function ChildLine():void {
			addChild(_line);
			setLength(_w,0);
		}

		public function setLength(w,percent_complete):void {
			_w = w;
			_line.graphics.clear();
			_line.y = 3;
			var matr:Matrix = new Matrix();
			matr.createGradientBox(w, 14, Math.PI/2, 0, 0) 
			_line.graphics.beginGradientFill(GradientType.LINEAR,
				[0x0000e9, 0x9494fc, 0x9494fc, 0x0000e9], [1, 1, 1, 1], 
				[0, 256/20*7, 256/20*13, 255], matr);
			_line.graphics.drawRoundRect(0,0,w,14,4,22);
			
			_line.graphics.beginFill(0x000000);
			_line.graphics.drawRect(0,6.5,w*percent_complete/100,2);
			
		}

	}
}