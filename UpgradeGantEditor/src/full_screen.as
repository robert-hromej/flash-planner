private function fullscreenEnter():void{
	stage.addEventListener(Event.FULLSCREEN, fullscreenChange);
	stage.displayState = "fullScreen";
}

private function fullscreenExit():void{
	stage.addEventListener(Event.FULLSCREEN, fullscreenChange);
	stage.displayState = "normal";
}

private function fullscreenChange(ev:Event):void{
	if (stage.displayState == "normal"){
		fullscreenEnterBT.visible = true;
		fullscreenExitBT.visible = false;
	}else{
		fullscreenEnterBT.visible = false;
		fullscreenExitBT.visible = true;
	}
}
