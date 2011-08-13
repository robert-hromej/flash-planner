package flash.display{
	
	import flash.display.MovieClip
	import flash.geom.Matrix
	
	public class Milestone extends MovieClip{
		
		public function Milestone():void{
			y = 10;
			graphics.lineStyle(1, 0x000000);
			graphics.beginFill(0x000000);
			graphics.moveTo(0, 7);
			graphics.lineTo(7, 0);
			graphics.lineTo(0, -7);
			graphics.lineTo(-7, 0);
		}
	}
}