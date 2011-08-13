package flash.display{
	
	import flash.display.Sprite
	import flash.geom.Point
	
	public class Arrow extends Sprite{
		
		public function Arrow(start,end,type):void{
			graphics.lineStyle(1, 0xFFD700, 1)
			switch (type){
				case "FF":
					drawFF(start,end)
					break
				case "SS":
					drawSS(start,end)
					break
				case "SF":
					drawSF(start,end)
					break
				case "FS":
					drawFS(start,end)
					break
				default:
			}
		}
		
		private function drawFF(start,end):void{
			var p = new Point()
				p = start.clone()
			graphics.moveTo(p.x,p.y)
			p.x += 10
			graphics.lineTo(p.x,p.y)
			if (p.x < end.x+10){
				p.x = end.x+10
				graphics.lineTo(p.x,p.y)
			}
			if (p.y < end.y){
				p.y = end.y
			}else{
				p.y = end.y
			}
			graphics.lineTo(p.x,p.y)
			p.x = end.x
			graphics.lineTo(p.x,p.y)
			
			drawStrila(p,90)
		}
		
		private function drawSS(start,end):void{
			var p = new Point()
				p = start.clone()
			graphics.moveTo(p.x,p.y)
				p.x -= 10
			graphics.lineTo(p.x,p.y)
				p.y = end.y
			graphics.lineTo(p.x,p.y)
				if (p.x < end.x-10){
					p.x = end.x-10
					graphics.lineTo(p.x,p.y)
				}
				p.x = end.x
			graphics.lineTo(p.x,p.y)
			drawStrila(p,270)
		}
		
		private function drawSF(start,end):void{
			var p = new Point()
			p = start.clone()
			graphics.moveTo(p.x,p.y)
			p.x += -5
			graphics.lineTo(p.x,p.y)
			if (p.x < end.x-5){
				p.x = end.x-5
				graphics.lineTo(p.x,p.y)
			}
			if (p.y < end.y){
				p.y = p.y+10
			}else{
				p.y = p.y-10
			}
			graphics.lineTo(p.x,p.y)
			
			p.x = end.x+10
			graphics.lineTo(p.x,p.y)
			p.y = end.y
			graphics.lineTo(p.x,p.y)
			p.x = end.x
			graphics.lineTo(p.x,p.y)
			
			drawStrila(p,90)
		}
		
		private function drawFS(start,end):void{
			var p = new Point()
			p = start.clone()
			graphics.moveTo(p.x,p.y)
			p.x += 5
			graphics.lineTo(p.x,p.y)
			if (p.x < end.x+5){
				p.x = end.x+5
				graphics.lineTo(p.x,p.y)
			}
			if (p.y < end.y){
				p.y = end.y-7
			}else{
				p.y = end.y+6
			}
			graphics.lineTo(p.x,p.y)
			if (start.y < end.y){
				drawStrila(p,0)
			}else{
				drawStrila(p,180)
			}
		}
		
		private function drawStrila(p,rot):void{
			var sp = new Sprite()
				sp.graphics.beginFill(0xFFD700)
				sp.graphics.lineTo(5, -6)
				sp.graphics.lineTo(-5,-6)
				sp.rotation = rot
				sp.x = p.x
				sp.y = p.y
			addChild(sp)
		}
		
	}
}