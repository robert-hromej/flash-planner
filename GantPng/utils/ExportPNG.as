package utils{
	
	
	import com.adobe.images.PNGEncoder;
	
	import fl.controls.Button;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class ExportPNG{
		
		public static var w:Number = 2048;
		public static var h:Number = 2048;
		
		public static var col:uint = 1;
		public static var row:uint = 1;
		
		public static var netSprite:Sprite = new Sprite();
///*		
		private static var combination:Array = [
												{w:4080,h:4080},
												{w:4080,h:3060},
												{w:4080,h:2048},
												{w:4080,h:1530},
												{w:4080,h:1024},
												{w:4080,h:512},
												{w:4080,h:256},
												
												{w:2048,h:4080},
												{w:2048,h:2048},
												{w:2048,h:1024},
												{w:2048,h:512},
												{w:2048,h:256},
												
												{w:1024,h:4080},
												{w:1024,h:2048},
												{w:1024,h:1024},
												{w:1024,h:512},
												{w:1024,h:256},
												
												{w:512,h:4080},
												{w:512,h:2048},
												{w:512,h:1024},
												{w:512,h:512},
												{w:512,h:256},
												
												{w:256,h:4096},
												{w:256,h:2048},
												{w:256,h:1024},
												{w:256,h:512},
												{w:256,h:256}];	
//		*/
		/*
		private static var combination:Array = [
												{w:1024,h:1024},
//												{w:1024,h:512},
//												{w:1024,h:256},
												
//												{w:512,h:1024},
												{w:640,h:480},
												{w:512,h:512},
//												{w:512,h:256},
												
//												{w:256,h:1024},
//												{w:256,h:512},
												{w:256,h:256}];
		*/
		public function ExportPNG(){
		}
		
		public static function getNet(cont:Sprite):void{
			var contWidth:uint = cont.width;
			var contHeight:uint = cont.height + 14;
			
			var n:Number = 10000;
			
			for each(var ob:Object in combination){
				col = (contWidth/ob.w) > uint(contWidth/ob.w) ? uint(contWidth/ob.w)+1 : uint(contWidth/ob.w);
				row = (contHeight/ob.h) > uint(contHeight/ob.h) ? uint(contHeight/ob.h)+1 : uint(contHeight/ob.h);
				if (row*col <= n){
					n = col*row;
					w = ob.w;
					h = ob.h;
				}
			}
			
			col = (contWidth/w) > uint(contWidth/w) ? uint(contWidth/w)+1 : uint(contWidth/w);
			row = (contHeight/h) > uint(contHeight/h) ? uint(contHeight/h)+1 : uint(contHeight/h);
			
			
			netSprite.graphics.clear();
			netSprite.graphics.lineStyle(2, 0xff0000, 5);
			
			for(var i:uint=1;i<=col;i++){
				netSprite.graphics.moveTo(i*w,0);
				netSprite.graphics.lineTo(i*w,row*h);
			}
			
			for(var j:uint=1;j<=row;j++){
				netSprite.graphics.moveTo(0,j*h);
				netSprite.graphics.lineTo(col*w,j*h);
			}
			
			for(var x:uint=0;x<col;x++){
				for(var y:uint=0;y<row;y++){
					var d1:Button = new Button();
					d1.x = w*x + 30;
					d1.y = h*y + 5;
					d1.label = "page "+(y*col+x+1);
					d1.name = ""+x+"_"+y;
					d1.addEventListener(MouseEvent.CLICK,clickTODonwload)
					netSprite.addChild(d1);
					
					var d2:Button = new Button();
					d2.x = w*x + 30;
					d2.y = h*y + h-50;
					d2.label = "page "+(y*col+x+1);
					d2.name = ""+x+"_"+y;
					d2.addEventListener(MouseEvent.CLICK,clickTODonwload)
					netSprite.addChild(d2);
				}
			}
			
			function clickTODonwload(ev:MouseEvent):void{
				var str:Array = ev.target.name.split("_")
				var x:uint = str[0];
				var y:uint = str[1];
				getPNG(cont,x,y);
			}
			
			
			cont.addChild(netSprite);
			Global.gant.update()
		}
		
		public static function getPNG(sp:Sprite,x,y):void{
			var ba:BitmapData = new BitmapData(w,h,false,0xFFFFFF);
			
			netSprite.alpha = 0;
			Global.sp.x = -x*w;
			Global.sp.y = -y*h;
			
			ba.draw(sp);
			
			netSprite.alpha = 1;
			Global.sp.x = 0;
			Global.sp.y = 0;
			
			var png_binary:ByteArray = PNGEncoder.encode(ba)
			var localRef:FileReference = new FileReference();
				localRef.save(png_binary, ""+Global.project.name+" "+x+"x"+y+".png");
		}
		
	}
}