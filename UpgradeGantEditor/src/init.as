import app.controllers.ApplicationController;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;

import planner.Project;
import planner.Task;

import utils.Global;
import utils.Seating;
import utils.XMLService;

import flash.external.ExternalInterface;

private function beforeCreate():void{

	if (Seating.testMode){
//		loadXML("../example files/monsanto.planner");
//		loadXML("../example files/26-DataSwell-v5.dataswell.planner");
		loadXML("../example files/97-test2-v2.test2.planner");
	}
}

private function afterCreate():void{
	Seating.editor = (this.parameters.editor == "true");
//	ApplicationController.application = this;
//	trace(this.);
	Global.app = this;
	
	Global.gant = gant;
	
	try{
		if (ExternalInterface.available){
			ExternalInterface.addCallback("load", load)
			ExternalInterface.addCallback("getChangedState", Global.getChangedState)
			ExternalInterface.addCallback("clearChangedState", Global.clearChangedState)
			ExternalInterface.addCallback("save", save)
		}
	}catch(error:*){}
	
//	Global.tasksContainer = tasksContainer
//	Global.predecessorsContainer = predecessorsContainer
//	Global.paneContainer = paneContainer
	
//	contextMenu.hideBuiltInItems();
//	
//	if (Seating.editor){
//		contextMenu.customItems.push(Global.addNewTaskItem);
//	}
//	
//	contextMenu.customItems.push(Global.resourcesItem);
//	contextMenu.customItems.push(Global.projectItem);
//	
//	try{
//		ExternalInterface.call("Ganttzilla.UI.pertViewer.load()")
//	}catch(error:*){}
//
	
	gant.refresh();
}

private function loadXML(url:String):void{
	var request:URLRequest = new URLRequest(url);
	var loader:URLLoader = new URLLoader();
	loader.load(request);
	loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
}

private function loaderCompleteHandler(event:Event):void {
	load(event.target.data);
}

private function save(ev:*=null):String{
	return XMLService.projectXML(ApplicationController.proj).toString()
}

public function load(file:String):void{
	ApplicationController.proj = new Project(new XML(file));
	
	
//	refresh();
//	gant.treeTasks.refresh();
}

public static function refresh():void{
	ApplicationController.proj.refresh();
//	ApplicationController.application.gant.refresh();
}
