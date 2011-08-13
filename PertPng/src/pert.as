import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;

import mx.core.UIComponent;

import planner.Project;

import utils.Global;
import utils.ImageService;
import utils.Seating;

protected function init():void{
	
	printContainer.addEventListener(Event.RESIZE,drawNetSprite)
	
	Global.app = this
	try{
		if (ExternalInterface.available){
			ExternalInterface.addCallback("load", load)
		}
	}catch(error:*){}
	
	Global.sp = sp;
	
	Global.tasksContainer = tasksContainer
	Global.predecessorsContainer = predecessorsContainer

	
	try{
		ExternalInterface.call("Ganttzilla.UI.pertViewer.load()")
	}catch(error:*){}
	
	if (Seating.testMode){
		loadXML("../example files/monsanto.planner");
//		loadXML("../example files/26-DataSwell-v5.dataswell.planner");
//		loadXML("../example files/97-test2-v2.test2.planner");
	}
}

private function drawNetSprite(ev:Event):void{
	ImageService.getNet(Global.printContainer);
}
 

private function loadXML(url:String):void{
    var request:URLRequest = new URLRequest(url)
    var loader:URLLoader = new URLLoader()
	    loader.load(request)
	    loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
}
		
private function loaderCompleteHandler(event:Event):void {
	load(event.target.data)
}

public function load(file:String):void{
	Global.project = new Project(new XML(file))
	Global.printContainer = printContainer;
	refresh()
}

public static function refresh():void{
	Global.project.refresh();
}
