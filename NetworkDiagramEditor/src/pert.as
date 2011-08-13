import com.adobe.images.JPGEncoder;
import com.adobe.images.PNGEncoder;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLRequest;

import flash.external.ExternalInterface;

import planner.Project;

import utils.Global;
import utils.Seating;

protected function init():void{
	
	Seating.editor = (this.parameters.editor == "true");
	Global.app = this;
	
	try{
		if (ExternalInterface.available){
			ExternalInterface.addCallback("load", load);
			ExternalInterface.addCallback("getChangedState", Global.getChangedState);
			ExternalInterface.addCallback("clearChangedState", Global.clearChangedState);
			ExternalInterface.addCallback("save", save);
		}
	}catch(error:*){}
	
	Global.tasksContainer = tasksContainer;
	Global.predecessorsContainer = predecessorsContainer;
	Global.paneContainer = paneContainer;

	this.contextMenu.hideBuiltInItems();
	
	if (Seating.editor){
		this.contextMenu.customItems.push(Global.addNewTaskItem);
	}
	
	this.contextMenu.customItems.push(Global.resourcesItem);
	this.contextMenu.customItems.push(Global.projectItem);
	
	try{
		ExternalInterface.call("Ganttzilla.UI.pertViewer.load()");
	}catch(error:*){
		trace("error");
	}
	
	if (Seating.testMode){
//		loadXML("../example files/monsanto.planner");
//		loadXML("../example files/26-DataSwell-v5.dataswell.planner");
		loadXML("../example files/97-test2-v2.test2.planner");
	}
}

private function loadXML(url:String):void{
	trace(1);
    var request:URLRequest = new URLRequest(url)
    var loader:URLLoader = new URLLoader()
	    loader.load(request)
	    loader.addEventListener(Event.COMPLETE, loaderCompleteHandler);
	trace(2);
}
		
private function loaderCompleteHandler(event:Event):void {
	load(event.target.data)
}

private function save(ev:*=null):String{
	return Global.project.xml.toString()
}

public function load(file:String):void{
	Global.project = new Project(new XML(file))
	refresh();
	Global.clearChangedState()
}

public static function refresh():void{
	Global.project.refresh()
}

private function fullscreenEnter():void{
	this.stage.addEventListener(Event.FULLSCREEN, fullscreenChange);
	this.stage.displayState = "fullScreen";
}

private function fullscreenExit():void{
	this.stage.addEventListener(Event.FULLSCREEN, fullscreenChange);
	this.stage.displayState = "normal";
}

private function fullscreenChange(ev:Event):void{
	fullscreenEnterBT.visible = (this.stage.displayState == "normal");
	fullscreenExitBT.visible = (this.stage.displayState != "normal");
}
