package utils{
	
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	import spark.components.Group;
	
	
	public class ImageService{
		
		public static var w:Number = 2048;
		public static var h:Number = 2048;
		
		public static var netSprite:Group = new Group();
		
//		/*
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
												
												{w:896,h:4080},
												{w:896,h:2048},
												{w:896,h:1024},
												{w:896,h:512},
												{w:896,h:256},
												
												{w:768,h:4080},
												{w:768,h:2048},
												{w:768,h:1024},
												{w:768,h:512},
												{w:768,h:256},
												
												{w:640,h:4080},
												{w:640,h:2048},
												{w:640,h:1024},
												{w:640,h:512},
												{w:640,h:256},
												
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
		public function ImageService(){
		}
		
		public static function getNet(cont:Group):Group{
			
//			trace(cont.width,cont.height);
//			trace();
			
			var n:Number = 10000;
			
			var ww:uint;
			var hh:uint;
			
			for each(var ob:Object in combination){
				ww = (cont.width/ob.w) > uint(cont.width/ob.w) ? uint(cont.width/ob.w)+1 : uint(cont.width/ob.w);
				hh = (cont.height/ob.h) > uint(cont.height/ob.h) ? uint(cont.height/ob.h)+1 : uint(cont.height/ob.h);
				if (ww*hh <= n){
					n = ww*hh;
					w = ob.w;
					h = ob.h;
				}
			}
			
//			trace(w,h);
			
			ww = (cont.width/w) > uint(cont.width/w) ? uint(cont.width/w)+1 : uint(cont.width/w);
			hh = (cont.height/h) > uint(cont.height/h) ? uint(cont.height/h)+1 : uint(cont.height/h);
				
			netSprite.graphics.clear();
			netSprite.graphics.lineStyle(2, 0xff0000, 5);
			
			for(var i:uint=1;i<=ww;i++){
				netSprite.graphics.moveTo(i*w,0);
				netSprite.graphics.lineTo(i*w,hh*h);
			}
			
			for(var j:uint=1;j<=hh;j++){
				netSprite.graphics.moveTo(0,j*h);
				netSprite.graphics.lineTo(ww*w,j*h);
			}
			
			for(var x:uint=0;x<ww;x++){
				for(var y:uint=0;y<hh;y++){
					var d:Button;
					d = new Button();
					d.x = w*x + 20;
					d.y = h*y + h-30;
					d.label = "page "+(y*ww+x+1);
					d.name = ""+x+"_"+y;
					d.addEventListener(MouseEvent.CLICK,clickTODonwload)
					netSprite.addElement(d);
					
					d = new Button();
					d.x = w*x + 20;
					d.y = h*y + 10;
					d.label = "page "+(y*ww+x+1);
					d.name = ""+x+"_"+y;
					d.addEventListener(MouseEvent.CLICK,clickTODonwload)
					netSprite.addElement(d);
					
				}
			}
			
			function clickTODonwload(ev:MouseEvent):void{
				var str:Array = ev.target.name.split("_")
				var x:uint = str[0];
				var y:uint = str[1];
				getPNG(cont,x,y);
			}
			
			cont.addElement(netSprite);
			return netSprite;
		}
		
		public static function getPNG(sp:Group,x:Number,y:Number):void{
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
				localRef.save(png_binary, ""+Global.project.name+""+x+"x"+y+".png");
		}
		
	}
}