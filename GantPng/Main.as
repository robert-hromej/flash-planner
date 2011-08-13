package{
	
	import fl.controls.DataGrid;
	import fl.controls.ProgressBar;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.data.DataProvider;
	import fl.data.TaskDataProvider;
	import fl.events.DataGridEvent;
	import fl.events.ListEvent;
	import fl.events.ScrollEvent;
	
	import flash.display.ChildLine;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.drm.VoucherAccessInfo;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.xml.*;
	
	import org.alivepdf.colors.RGBColor;
	import org.alivepdf.display.Display;
	import org.alivepdf.events.ProcessingEvent;
	import org.alivepdf.fonts.FontFamily;
	import org.alivepdf.fonts.Style;
	import org.alivepdf.layout.Orientation;
	import org.alivepdf.layout.Size;
	import org.alivepdf.layout.Unit;
	import org.alivepdf.pdf.PDF;
	import org.alivepdf.saving.Method;
	
	import planner.Project;
	import planner.Task;
	
	import utils.ExportPDF;
	import utils.ExportPNG;
	import utils.Global;
	
	public class Main extends MovieClip{
		
		public function Main(){
			
			
//			if (LoaderInfo(loaderInfo).parameters.exportMode){
//				Seating.exportMode = LoaderInfo(loaderInfo).parameters.exportMode;
//			}
//			
//			trace(Seating.exportMode);
			if (ExternalInterface.available){
				ExternalInterface.addCallback("load", load)
				ExternalInterface.addCallback("resize", resize)
			}
			
			
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
			stage.addEventListener(Event.RESIZE, resizeHandler)
			
			Global.gant = scroll;
			
			Global.scrollContainer.addChild(Global.sp);
			
			Global.taskLineContainer.x = 408;
			Global.taskLineContainer.y = 37;
			Global.sp.addChild(Global.taskLineContainer);
			
			Global.header.x = 408;
			Global.sp.addChild(Global.header);
						
			Global.sp.addChild(Global.taskTreeContainer);
			
			try{
				ExternalInterface.call(Seating.jsLoadFunction)
			}catch(error){
				trace("not found method")
			}
			
		}
		
		public function load(file:String):void{
			Global.project = new Project(new XML(file))
			refresh();
			if (Seating.exportMode == "PNG"){
				ExportPNG.getNet(Global.scrollContainer);
			}else{
				generate_btn.addEventListener( MouseEvent.CLICK, generatePDF );
			}
		}

		private function resize(w,h):void{
			try{
				scroll.width = w;
				if (Seating.exportMode == "PNG"){
					scroll.y = 0;
					scroll.height = h;
				}else{
					scroll.y = 40;
					scroll.height = h-40;
				}
			}catch(ex:*){}
		}
		
		private function resizeHandler(event:Event):void {
			try{
				resize(stage.stageWidth,stage.stageHeight)
			}catch(ex){}
		}
				
		public function init(){
			Global.main = this;
			resizeHandler(null);
			if (Seating.exportMode == "PNG"){
				generate_btn.visible = false;
			}
		}
		
		public static function refresh():void{
			Global.project.refresh()
			Global.gant.source = Global.scrollContainer;
			Global.gant.update()
		}
		
		private function generatePDF ( e:MouseEvent ){
			generate_btn.removeEventListener(MouseEvent.CLICK, generatePDF);
			generate_btn.enabled = false;
			openAlertPage();
			ExportPDF.generate();
		}
		
		public function complectGenerate(ev:Event):void{
			closeAlertPage();
			trace("Complect generate PDF");
			generate_btn.addEventListener(MouseEvent.CLICK, downloadPDF);
			generate_btn.label = "download PDF";
			generate_btn.enabled = true;
		}
		
		private function downloadPDF(ev){
			var btArray:ByteArray = ExportPDF.pdf.save( Method.LOCAL);
			var myFile:FileReference = new FileReference();
			myFile.save(btArray,""+Global.project.name+".pdf");
			trace("complect");
		}
		
		private function openAlertPage():void{
			addChild(Global.alert);
			Global.alert.x = stage.width/2
			Global.alert.y = stage.height/2
		}
		
		public function setProgressValue(value):void{
			ProgressBar(Global.alert.progresBar).maximum = ExportPDF.pages;
			ProgressBar(Global.alert.progresBar).value = value;
		}
		
		private function closeAlertPage():void{
			removeChild(Global.alert);
		}
		
	}
}