package flash.display{
	
	import flash.geom.Matrix;
	
	import spark.components.Group;
	
	public class Milestone extends Group{
		
		public function Milestone():void{
			var matr:Matrix = new Matrix()
			matr.createGradientBox(5, 5,  Math.PI/2, 3, 3)
			graphics.beginGradientFill(GradientType.LINEAR,
											  [0xDDDDDD, 0x000000], [1, 1], 
											  [0,255], matr)
			graphics.lineStyle(1, 0x000000)
			graphics.moveTo(-4, -4)
			graphics.lineTo(4, -4)
			graphics.lineTo(4,4)
			graphics.lineTo(-4,4)
			graphics.lineTo(-4,-4)
			rotation = 45
			y = 10
		}
	}
}