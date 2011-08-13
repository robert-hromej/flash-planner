package utils{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import org.alivepdf.display.Display;
	import org.alivepdf.encoding.PNGEncoder;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	
	public class ExportPDF{
		
		public static var pdfCol:uint = 1;
		public static var pdfRow:uint = 1;
		
		public static var pdfCellWidth:uint = 640;
		public static var pdfCellHeight:uint = 480;
		
		public static var pages:uint = 1;
		
		public static var pdf:PDF;
		
		public function ExportPDF(){}
		
		public static function generate():void{
			pdfCol = Math.ceil(Global.sp.width/pdfCellWidth);
			pdfRow = Math.ceil(Global.sp.height/pdfCellHeight);
			
			pages = pdfCol*pdfRow;
			
			var scale:uint = 1;
			
			var pageWidth:uint = pdfCol*pdfCellWidth;
			var pageHeight:uint = pdfRow*pdfCellHeight;
			
			while (pageWidth/scale > 14400 || pageHeight/scale > 14400){
				scale += 1;
			}
			
//			if (pageWidth > 14400){
//				scale = Math.ceil(pageWidth/14400);
//			}
//			
//			if (pageWidth < 14400 && pageHeight < 14400){
//			}else{
//				pageWidth = 14400;
//				pageHeight = 14400;
//				
//				s = Math.ceil(ExportPNG.pdfCellWidth*ExportPNG.pdfCol/pageWidth);
//				if (s < Math.ceil(ExportPNG.pdfCellHeight*ExportPNG.pdfRow/pageHeight)){
//					s = Math.ceil(ExportPNG.pdfCellHeight*ExportPNG.pdfRow/pageHeight);
//				}
//			}
			
			pdf = new PDF( Orientation.LANDSCAPE, Unit.POINT, new Size([pageHeight/scale, pageWidth/scale],"Gant",[200, 200],[797, 420]));
			pdf.setDisplayMode ( Display.REAL ); 
			pdf.addPage();
			
			var xi:uint = 0;
			var yi:uint = 0;
			
			var t:Timer = new Timer(10,pages);
			t.start();
			t.addEventListener(TimerEvent.TIMER, function addPictures(){
				pdf.addImageStream(getPNGForPDF(Global.scrollContainer,xi,yi),xi*pdfCellWidth/scale,yi*pdfCellHeight/scale,pdfCellWidth/scale,pdfCellHeight/scale);
				Global.main.setProgressValue(xi*pdfRow+yi+1);
				trace(xi,yi);
				yi += 1;
				if (yi == pdfRow){
					xi += 1
					yi = 0;
				}
			})
			
			t.addEventListener(TimerEvent.TIMER_COMPLETE, Global.main.complectGenerate);
			
		}
		
		public static function getPNGForPDF(sp:Sprite,x:uint,y:uint):ByteArray{
			var ba:BitmapData = new BitmapData(pdfCellWidth,pdfCellHeight,false,0xFFFFFF);
			
			Global.sp.x = -x*pdfCellWidth;
			Global.sp.y = -y*pdfCellHeight;
			
			ba.draw(sp,sp.transform.matrix);
			
			Global.sp.x = 0;
			Global.sp.y = 0;
			
			return PNGEncoder.encode(ba,1);
		}
		
	}
}