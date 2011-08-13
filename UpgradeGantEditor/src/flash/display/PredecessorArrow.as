package flash.display{
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class PredecessorArrow extends Sprite{
		
		private var start:Point
		private var sp:Sprite = new Sprite()

		public function PredecessorArrow(start:Point):void{
			this.start = start;
			sp.graphics.beginFill(0x000000)
			sp.graphics.moveTo(0,2)
			sp.graphics.lineTo(5, -10)
			sp.graphics.lineTo(-5,-10)
			addChild(sp)
			draw(start)
		}
		
		public function draw(end:Point):void{
			graphics.clear()
			graphics.lineStyle(2,0x000000)
			graphics.moveTo(start.x,start.y)
			graphics.lineTo(end.x,end.y)
			sp.x = end.x
			sp.y = end.y
			sp.rotation = -45
		}
	}
}