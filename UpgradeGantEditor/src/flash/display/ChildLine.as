package flash.display{

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	public class ChildLine extends MovieClip {

		private var _w:uint = 10;
		private var _blink:Sprite = new Sprite();
		public function ChildLine():void {
			setLength(_w,0);
		}

		public function setLength(w:uint,percent_complete:Number):void {
			_w = w;
			graphics.clear();
			var matr:Matrix = new Matrix();
			matr.createGradientBox(w, 16, Math.PI/2, 0, 0);
			graphics.beginGradientFill(GradientType.LINEAR,
			  [0x0000CC, 0x000088], [1, 1], 
			  [0,255], matr);
			graphics.drawRoundRect(0,4,w,12,8,12);
			graphics.beginFill(0xFFFFFF,0.8);
			graphics.drawRoundRect(0,8,w*percent_complete/100,4,6,8);
		}

		public function get blink():Sprite {
			addChild(_blink);
			_blink.alpha=1;
			_blink.addEventListener(Event.ENTER_FRAME, alphaBlink);
			function alphaBlink(ev:Event):void {
				if (_blink.alpha<0.05) {
					_blink.removeEventListener(Event.ENTER_FRAME, alphaBlink);
					removeChild(_blink);
				} else {
					_blink.alpha-=0.04;
				}
			}

			_blink.graphics.clear();
			var matr:Matrix = new Matrix();
			matr.createGradientBox(_w+20, 20, Math.PI/2, 0, 0);
			_blink.graphics.beginGradientFill(GradientType.LINEAR,
			  [0xffffff, 0xcccccc], [1, 1], 
			  [0,255], matr);
			_blink.graphics.drawRoundRect(-10,0,_w+20,20,8,12);
			return _blink;
		}

	}
}