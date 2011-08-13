package utils{
	import flash.events.TimerEvent
	import flash.utils.Timer
	import utils.Global;
	
	import flash.display.SimpleButton
	import fl.data.DataProvider
	
	public class History{
		
		private static var MAX:uint = 10;
		
		public static var historyFiles:DataProvider = new DataProvider();
		public static var selected:Number = -1;
	
		public static var undoBT:SimpleButton;
		public static var redoBT:SimpleButton;
		
		public static function init():void{
			refresh()
		}
		
		public static function undo(ev:*):void{
			if (historyFiles.length > 0 && selected > 0){
				selected = selected - 1
				Global.main.load(String(historyFiles.getItemAt(selected)))
			}
			Main.refresh()
			refresh()
		}
		
		public static function redo(ev:*):void{
			if (historyFiles.length-1 > selected){
				selected = selected + 1
				Global.main.load(String(historyFiles.getItemAt(selected)))
			}
			Main.refresh()
			refresh()
		}
		
		public static function changed():void{
			Global.openMessagePage()
			
			var shipTimer = new Timer(Global.funcTimer, 1);
			shipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, func);
			shipTimer.start();			
			
			function func(ev:*):void{
				try{
					var str:String = Global.project.xml.toString()
					if (selected == -1 || str != historyFiles.getItemAt(selected).toString()){
						while(selected < historyFiles.length-1){
							historyFiles.removeItemAt(historyFiles.length-1)
						}
						selected = selected + 1;
						historyFiles.addItem(str)
						if (historyFiles.length > MAX){
							historyFiles.removeItemAt(0)
							selected = selected - 1;
						}
//						Main.refresh()
						refresh()
					}
				}catch(ex:*){
					trace("error:"+ex)
				}
				Global.closeMessagePage();
			}
		}

		private static function refresh():void{
			undoBT.removeEventListener("click",undo);
			redoBT.removeEventListener("click",redo);
			
			if (selected < 1){
				undoBT.enabled = false
				undoBT.alpha = 0.5
			}else{
				undoBT.enabled = true
				undoBT.alpha = 1
				undoBT.addEventListener("click",undo)
			}
			if (selected < historyFiles.length-1){
				redoBT.enabled = true
				redoBT.alpha = 1
				redoBT.addEventListener("click",redo)
			}else{
				redoBT.enabled = false
				redoBT.alpha = 0.5
			}
//			Global.main.refreshMenu();
		}
		
		
		public static function reset():void{
			historyFiles.removeAll()
			selected = -1
			refresh()
		}
		
	}
	
	
}