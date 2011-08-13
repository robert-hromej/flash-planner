package flash.display{
	
	import flash.geom.Point;
	import mx.core.UIComponent;
	import planner.Task;
	
	public class Arrow extends UIComponent{
		
		private var start:Task
		private var end:Task
		private var type:String
		
		public function Arrow(start:Task,end:Task,type:String):void{
			this.start = start
			this.end = end
			this.type = type
			refresh()
		}
		
		public function refresh():void{
			graphics.clear()
				
			while(numChildren > 0){
				removeChildAt(0)
			}
			
			var p:Point = new Point();
			
			if (type == "predecessor"){
				graphics.lineStyle(2, 0xFFD700, 1)
					
				p = start.component.startPoint.clone()
				graphics.moveTo(p.x,p.y)
					
				p.x += 10
				graphics.lineTo(p.x,p.y)
				
				if (start.component.startPoint.x > end.component.endPoint.x-20){
					p.y = (end.component.endPoint.y+start.component.startPoint.y)/2
					graphics.lineTo(p.x,p.y)
				}
					
				p.x = end.component.endPoint.x-10
				graphics.lineTo(p.x,p.y)
				
				p.y = end.component.endPoint.y
				graphics.lineTo(p.x,p.y)
					
				p.x = end.component.endPoint.x
				graphics.lineTo(p.x,p.y)
			}else if (type == "parent"){
				
//				var s:Point = new Point(start.component.x+100,start.component.y+40);
//				var f:Point = new Point(end.component.x+100,end.component.y+0);
				var s:Point = new Point(start.component.x+150,start.component.y+100);
				var f:Point = new Point(end.component.x+150,end.component.y+20);
					
				graphics.lineStyle(2, 0x000000, 1)
				
				p = s.clone()
				graphics.moveTo(p.x,p.y)
				
//				p.y += 10
				graphics.lineTo(p.x,p.y)
				
				p.y = f.y-10
				graphics.lineTo(p.x,p.y)
				
				p.x = f.x
				graphics.lineTo(p.x,p.y)
				
				p.y = f.y
				graphics.lineTo(p.x,p.y)
			}
			drawStrila(p)
		}
		
		private function drawStrila(p:Point):void{
			var sp:Sprite = new Sprite()
				if (type == "predecessor"){
					sp.graphics.beginFill(0xFFD700)
				}else{
					sp.graphics.beginFill(0x000000)
				}
				sp.graphics.lineTo(5, -6)
				sp.graphics.lineTo(-5,-6)
				if (type == "predecessor"){
					sp.rotation = -90
				}
				sp.x = p.x
				sp.y = p.y
			addChild(sp)
		}
		
	}
}