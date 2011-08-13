package{
	
	import fl.ToolTip;
	import fl.controls.DataGrid;
	import fl.controls.MenuList;
	import fl.controls.cellRenderers.CellBorder;
	import fl.controls.cellRenderers.MenuIconCellRenderer;
	import fl.controls.cellRenderers.WBS;
	import fl.controls.dataGridClasses.DataGridColumn;
	import fl.controls.dataGridClasses.HeaderRenderer;
	import fl.controls.listClasses.CellRenderer;
	import fl.data.DataProvider;
	import fl.data.TaskDataProvider;
	import fl.events.DataGridEvent;
	import fl.events.ListEvent;
	import fl.events.ScrollEvent;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.LocalConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuBuiltInItems;
	import flash.ui.ContextMenuItem;
	import flash.xml.*;
	
	import planner.Project;
	import planner.Task;
	
	import utils.Global;
	import utils.History;
	
	public class Main extends MovieClip{
		
		private var menuList:MenuList = new MenuList();

		private var idColumn:DataGridColumn;
		private var statusColumn:DataGridColumn;
		private var nameColumn:DataGridColumn;
		private var abbreviationColumn:DataGridColumn;
		private var menuColumn:DataGridColumn;
		
		private var copyTaskItem:ContextMenuItem;
		
		private var insertTaskItem:ContextMenuItem;
		private var insertSubtaskItem:ContextMenuItem;
		private var removeTaskItem:ContextMenuItem;
		private var unlinkTaskItem:ContextMenuItem;
		private var editTaskItem:ContextMenuItem;
		private var indentTaskItem:ContextMenuItem;
		private var unindentTaskItem:ContextMenuItem;
		private var upTaskItem:ContextMenuItem;
		private var downTaskItem:ContextMenuItem;
		private var resourcesItem:ContextMenuItem;
		private var projectItem:ContextMenuItem;
		
		private static var lastIndex:int = -1;
		
		public function Main(){
			
			
			if (ExternalInterface.available){
				ExternalInterface.addCallback("getChangedState", Global.getChangedState)
				ExternalInterface.addCallback("clearChangedState", Global.clearChangedState)
				ExternalInterface.addCallback("load", load)
				ExternalInterface.addCallback("save", save)
				ExternalInterface.addCallback("resize", resize)
			}
			
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
			stage.addEventListener(Event.RESIZE, resizeHandler)
			
			Global.calendarHeader = calendarHeader;
			Global.gant = gant;
			
			Global.pleaseMessagePage = new MessagePage()
			addChild(Global.pleaseMessagePage)
			Global.pleaseMessagePage.visible = false
			
			History.undoBT = undoBT;
			History.redoBT = redoBT;
			History.init();
			Global.init();
						
			openBT.addEventListener("click",openFile)
			saveBT.addEventListener("click",openSave)
			
			try{
				ExternalInterface.call(Seating.jsLoadFunction)
			}catch(error){
				trace("not found method")
			}
			
			addEventListener(MouseEvent.CLICK, refreshMenu);
			
			DataGrid(dg).addEventListener(KeyboardEvent.KEY_DOWN, editable);
			function editable(ev:KeyboardEvent):void{
				
				if (ev.charCode == 13){
					if (DataGrid(dg).selectedIndex != -1){
						
						lastIndex = DataGrid(dg).selectedIndex;
						ab = false;
						if (DataGrid(dg).selectedIndex+1 == DataGrid(dg).length){
							DataGrid(dg).editedItemPosition = {columnIndex: 2, rowIndex: DataGrid(dg).selectedIndex};
							ab = true;
						}
					}
					
					DataGrid(dg).scrollToIndex(DataGrid(dg).selectedIndex);
					DataGrid(dg).editedItemPosition = {columnIndex: 2, rowIndex: DataGrid(dg).selectedIndex};
					DataGrid(dg).editable = true;
					
				}
			}
		}
		
		private static var ab:Boolean = false;
		
		private function openFile(ev:*):void{
			var myFile:FileReference = new FileReference()
			var plannerFilter:FileFilter = new FileFilter("Planner", "*.planner")
			myFile.browse([plannerFilter])
			myFile.addEventListener( Event.SELECT, selectFile)
			myFile.addEventListener(Event.COMPLETE, loadFile)
		}
		
		private function selectFile(ev:*):void{
			ev.target.load()
		}
		
		private function loadFile(ev:*):void{
			Global.openFileName = ev.target.name;
			load(ev.target.data)
			History.reset()
		}
		
		private function openSave(ev:*):void{
			var myFile:FileReference = new FileReference();
			var plannerFilter:FileFilter = new FileFilter("Planner", "*.planner");
			myFile.save(Global.project.xml.toString(),Global.openFileName);
		}

			
		public function save():String{
			return Global.project.xml.toString()
		}

		public function load(file:String):void{
			Global.project = new Project(new XML(file))
			dg.dataProvider = Global.project.dataProvider
			refresh()
			if (History.historyFiles.length == 0){
				History.changed()
			}
		}

		private function resize(w,h):void{
			try{
				if (w > 600){
					if (w > 900){
						dg.width = w/3
						gant.x = dg.width+17
						calendarHeader.x = dg.width+17
					}
					nameColumn.width = dg.width-300+160
					gant.width = w-(dg.width+27)
					calendarHeader.width = w-(dg.width+27)
				}
				if (h > 300){
					gant.height = h-85
					dg.height = h-50
				}
				Global.editPage.x = w/2
				Global.editPage.y = h/2
				
				Global.resourcesPage.x = w/2
				Global.resourcesPage.y = h/2
				
				Global.project.projectPage.x = w/2
				Global.project.projectPage.y = h/2
				
				fullscreenExitBT.x = w-35;
				fullscreenEnterBT.x = w-35;
			}catch(ex:*){}
		}
		
		private function resizeHandler(event:Event=null):void {
			try{
				resize(stage.stageWidth,stage.stageHeight)
			}catch(ex){}
		}
				
		public function init(){
			
			
			DataGrid(dg).addEventListener(Event.CHANGE, ref);
//			addEventListener(KeyboardEvent.KEY_DOWN, ref);
			
			function ref(ev:Event):void{
				refreshContextMenu();
			}
			
			fullscreenExitBT.visible = false;
//			fullscreenEnterBT.visible = false;
			stage.addEventListener(Event.FULLSCREEN, fullscreenChange);
			
			fullscreenEnterBT.addEventListener(MouseEvent.CLICK, fullscreenEnter);
			fullscreenExitBT.addEventListener(MouseEvent.CLICK, fullscreenExit);

			Global.main = this
			idColumn = dg.addColumn("idsTree");
				idColumn.headerText = "WBS";
				idColumn.minWidth = 40;
				idColumn.width = 40;
				idColumn.cellRenderer = WBS;
				
			statusColumn = dg.addColumn("status");
				statusColumn.headerText = "";
				statusColumn.width = 20;
				statusColumn.editable = false;
				statusColumn.resizable = false;

			nameColumn = dg.addColumn("name");
				nameColumn.width = 160;
				nameColumn.headerText = "Name";

			menuColumn = dg.addColumn("menu");
				menuColumn.headerText = "";
				menuColumn.width = 20;
				menuColumn.resizable = false;
				menuColumn.cellRenderer = MenuIconCellRenderer;
			
			abbreviationColumn = dg.addColumn(new DataGridColumn("workColumn"));
				abbreviationColumn.width = 40;
				abbreviationColumn.resizable = false;
				abbreviationColumn.headerText = "Work";
					
			var f:TextFormat = new TextFormat();
			f.size = 10;
//			f.bold = true;
			f.font = "Arial, Tahoma, sans-serif";
			DataGrid(dg).setRendererStyle("textFormat", f);
			
			dg.addEventListener(ListEvent.ITEM_CLICK, clickToStatus);
			dg.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, edit);
			dg.addEventListener(DataGridEvent.ITEM_EDIT_END,endEdit);
			
			gant.addEventListener(ScrollEvent.SCROLL,function calScroll(e:ScrollEvent):void {
				dg.verticalScrollPosition = gant.verticalScrollPosition
				Global.header.x = -gant.horizontalScrollPosition })
			dg.addEventListener(ScrollEvent.SCROLL,function calScroll(e:ScrollEvent):void {
				gant.verticalScrollPosition = dg.verticalScrollPosition })
			
			copyTaskItem = new ContextMenuItem("Insert Task");
			
			insertTaskItem = new ContextMenuItem("Insert Task");
			insertSubtaskItem = new ContextMenuItem("Insert Subtask");
			removeTaskItem = new ContextMenuItem("Remove Task");
			unlinkTaskItem = new ContextMenuItem("Unlink Task");
			editTaskItem = new ContextMenuItem("Edit Task");
			indentTaskItem = new ContextMenuItem("Indent Task");
			unindentTaskItem = new ContextMenuItem("Unindent Task");
			upTaskItem = new ContextMenuItem("Move Task Up");
			downTaskItem = new ContextMenuItem("Move Task Down");
			resourcesItem = new ContextMenuItem("Resources");
			projectItem = new ContextMenuItem("Project");
			
			copyTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.copyTask(Task(dg.selectedItem))})
			
			insertTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.newTask(Task(dg.selectedItem))})
			insertSubtaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.newSubTask(Task(dg.selectedItem))})
			removeTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.destroyTask(Task(dg.selectedItem))})
			unlinkTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.unlinkTask(Task(dg.selectedItem))})
			editTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.editTask(Task(dg.selectedItem))})
			indentTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.indentTask(Task(dg.selectedItem))})
			unindentTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.unindentTask(Task(dg.selectedItem))})
			upTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.moveTaskUp(Task(dg.selectedItem))})
			downTaskItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.moveTaskDown(Task(dg.selectedItem))})
			resourcesItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ menuList.openResourcesPage()})
			projectItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (){ openProjectPage()})
			
			refreshContextMenu();
			
			insertBT.addEventListener(MouseEvent.CLICK, function (){ menuList.newTask(Task(dg.selectedItem))});
			insertSubtaskBT.addEventListener(MouseEvent.CLICK, function (){ menuList.newSubTask(Task(dg.selectedItem))});
			removeBT.addEventListener(MouseEvent.CLICK, function (){ menuList.destroyTask(Task(dg.selectedItem))});
			unlinkBT.addEventListener(MouseEvent.CLICK, function (){ menuList.unlinkTask(Task(dg.selectedItem))});
			editBT.addEventListener(MouseEvent.CLICK, function (){ menuList.editTask(Task(dg.selectedItem))});
			indentBT.addEventListener(MouseEvent.CLICK, function (){ menuList.indentTask(Task(dg.selectedItem))});
			unindentBT.addEventListener(MouseEvent.CLICK, function (){ menuList.unindentTask(Task(dg.selectedItem))});
			upBT.addEventListener(MouseEvent.CLICK, function (){ menuList.moveTaskUp(Task(dg.selectedItem))});
			downBT.addEventListener(MouseEvent.CLICK, function (){ menuList.moveTaskDown(Task(dg.selectedItem))});
			resourcesBT.addEventListener(MouseEvent.CLICK, function (){ menuList.openResourcesPage()});
			projectBT.addEventListener(MouseEvent.CLICK, function (){ openProjectPage()});
			
			addChild(Global.tooltip);

			insertBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			insertSubtaskBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			removeBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			unlinkBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			editBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			indentBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			unindentBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			upBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			downBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			undoBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			redoBT.addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);

			insertBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			insertSubtaskBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			removeBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			unlinkBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			editBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			indentBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			unindentBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			upBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			downBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			undoBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);
			redoBT.addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);

			openBT.visible = !Seating.webApplication;
			saveBT.visible = !Seating.webApplication;
			resizeHandler();
		}
		
		private function toolTipOnOver(e:MouseEvent):void{			
			switch(e.target){
				case insertBT:
					Global.tooltip.show("Insert New Task",0,10);
					break;
				case insertSubtaskBT:
					Global.tooltip.show("Insert New SubTask",0,10);
					break;
				case removeBT:
					Global.tooltip.show("Remove Task",0,10);
					break;
				case unlinkBT:
					Global.tooltip.show("Unlink Task",0,10);
					break;
				case editBT:
					Global.tooltip.show("Edit Task",0,10);
					break;
				case indentBT:
					Global.tooltip.show("Indent Task",0,10);
					break;
				case unindentBT:
					Global.tooltip.show("Unindent Task",0,10);
					break;
				case upBT:
					Global.tooltip.show("Move Up Task",0,10);
					break;
				case downBT:
					Global.tooltip.show("Move Down Task",0,10);
					break;
				case undoBT:
					Global.tooltip.show("Undo",0,10);
					break;
				case redoBT:
					Global.tooltip.show("Redo",0,10);
					break;
			}
		}
		
		private function toolTipOnOut(e:MouseEvent):void{
			Global.tooltip.hide();
		}
				
		private function refreshContextMenu():void{
//			trace("refreshContextMenu()");
			var myContextMenu = new ContextMenu()
				myContextMenu.hideBuiltInItems()
				
				if (dg.selectedItem){
					myContextMenu.customItems.push(copyTaskItem)
					
					myContextMenu.customItems.push(insertTaskItem)
					myContextMenu.customItems.push(insertSubtaskItem)
					myContextMenu.customItems.push(removeTaskItem)
					myContextMenu.customItems.push(unlinkTaskItem)
					myContextMenu.customItems.push(editTaskItem)
					myContextMenu.customItems.push(indentTaskItem)
					myContextMenu.customItems.push(unindentTaskItem)
					myContextMenu.customItems.push(upTaskItem)
					myContextMenu.customItems.push(downTaskItem)
				}
				myContextMenu.customItems.push(resourcesItem)
				myContextMenu.customItems.push(projectItem)			
			contextMenu = myContextMenu			
		}
		
		public function openProjectPage():void{
			Global.project.projectPage.x = stage.stageWidth/2
			Global.project.projectPage.y = stage.stageHeight/2
			Global.project.projectPage.init()
			addChild(Global.project.projectPage)
		}		
		
		
		private function edit(ev:ListEvent){
			if (ev.columnIndex == 2 || (ev.columnIndex == 4 && ev.item.subTasks.length == 0 && ev.item.type != "milestone")){
				dg.editable = true;
				dg.editedItemPosition = ev;
			}		
		}
		
		private function endEdit(ev:DataGridEvent){
			
			trace("endEdit");
			if (ab){
				
				menuList.newTask(Task(DataGrid(dg).selectedItem));
				ab = false;
			}
			
			ev.target.dataProvider.refresh();
			dg.editable = false;
			Global.main.refreshContextMenu();
		}
		
		private function clickToStatus(ev:ListEvent){
			if (ev.columnIndex == 1){
				var t:Task = Task(ev.item);
				if (t.isParent()){
					t.open = !t.open;
				}
			}
			if (ev.columnIndex == 3){
				var cell:CellRenderer = ev.target.getCellRendererAt(ev.rowIndex,ev.columnIndex)
				var xi:uint = cell.x;
				var yi:uint = cell.y + cell.height*2;

				if (menuList.height > dg.height-cell.y-cell.height*2){
					yi -= menuList.height;
				}
				
				if (yi < 40){
					yi = 40;
				}
				
				menuList.move(xi+dg.x,yi+dg.y);
				
				Global.main.addChild(menuList);
				
				menuList.addEventListener(ListEvent.ITEM_CLICK, itemSelect)
				function itemSelect(e:ListEvent):void{
					e.item.action(ev.item)
					menuList.removeEventListener(ListEvent.ITEM_CLICK, itemSelect)
					Global.main.removeChild(menuList)
					Main.refresh()
				}
				
				dg.parent.addEventListener(MouseEvent.MOUSE_DOWN, cancelMenuList)
				function cancelMenuList(ev:Event){
					ev.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN, cancelMenuList)
					if (ev.target.parent.parent.parent.name != "menuList"){
						menuList.removeEventListener(ListEvent.ITEM_CLICK, itemSelect)
						Global.main.removeChild(menuList)							
					}
				}
			}
		}
		
		public function refreshMenu(ev:MouseEvent=null):void{
			insertSubtaskBT.enabled = (dg.selectedItem != null);
			removeBT.enabled = (dg.selectedItem != null);
			unlinkBT.enabled = (dg.selectedItem != null);
			editBT.enabled = (dg.selectedItem != null);
			indentBT.enabled = (dg.selectedItem != null);
			unindentBT.enabled = (dg.selectedItem != null);
			upBT.enabled = (dg.selectedItem != null);
			downBT.enabled = (dg.selectedItem != null);
			
			if (dg.selectedItem != null){
				insertSubtaskBT.alpha = 1;
				removeBT.alpha = 1;
				unlinkBT.alpha = 1;
				editBT.alpha = 1;
				indentBT.alpha = 1;
				unindentBT.alpha = 1;
				upBT.alpha = 1;
				downBT.alpha = 1;
			}else{
				insertSubtaskBT.alpha = .5;
				removeBT.alpha = .5;
				unlinkBT.alpha = .5;
				editBT.alpha = .5;
				indentBT.alpha = .5;
				unindentBT.alpha = .5;
				upBT.alpha = .5;
				downBT.alpha = .5;
			}
		}
		
		public static function refresh():void{
//			trace("refresh")
			Global.project.refresh();
			Global.resourcesPage.refresh();
			Global.main.refreshMenu();
			Global.main.refreshContextMenu();
		}
		
		private function fullscreenEnter(ev:MouseEvent=null):void{
			stage.displayState = "fullScreen";
		}
		
		private function fullscreenExit(ev:MouseEvent=null):void{
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
		
	}
}