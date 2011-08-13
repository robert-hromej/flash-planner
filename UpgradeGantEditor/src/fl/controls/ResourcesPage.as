﻿package fl.controls{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	
	import planner.Resource;
	
	import utils.Global;
	import utils.History;
	
	public class ResourcesPage extends Sprite{
		
		private var dataProvider:ArrayCollection = new ArrayCollection();
		
		public function ResourcesPage():void{
//			var idColumn = dg.addColumn("id")
//				idColumn.headerText = "ID"
//				idColumn.width = 30
//				idColumn.editable = false
//				idColumn.resizable = false
//
//			var nameColumn = dg.addColumn("name")
//				nameColumn.headerText = "Resource Name"
//				nameColumn.width = 300
//				nameColumn.editable = true
//				nameColumn.resizable = false
//
//			var shortNameColumn = dg.addColumn("short_name")
//				shortNameColumn.headerText = "Short Name"
//				shortNameColumn.width = 80
//				shortNameColumn.editable = true
//				shortNameColumn.resizable = false
//
//			var delColumn = dg.addColumn("delColumn")
//				delColumn.headerText = ""
//				delColumn.width = 50
//				delColumn.editable = false
//				delColumn.resizable = false
//				delColumn.cellRenderer = DeleteCellRenderer
//			
//			dg.dataProvider = dataProvider
//			dg.addEventListener(ListEvent.ITEM_CLICK, destroy)
//			addBT.addEventListener(MouseEvent.CLICK, addResources)
//			exitBT.addEventListener(MouseEvent.CLICK,close)
//			closeBT.addEventListener(MouseEvent.CLICK,close)
//			refresh()
		}
		
		private function close(ev:Event):void{
			Global.closeResourcesPage()
		}
		
		private function destroy(ev:ListEvent):void{
//			if (ev.columnIndex == 3){
//				ev.item.destroy()
//				refresh()
//			}
//			History.changed()
		}
		
		private function addResources(ev:MouseEvent):void{
//			var resource:Resource = new Resource(null)
//			resource.name = resourceNameField.text
//			resource.type = 1
//			resourceNameField.text = ""
//			Resource.insert(resource)
//			refresh()
//			History.changed()
		}
		
		public function refresh():void{
			dataProvider.removeAll()
			try{
//				dataProvider.addItems(Global.project.resources)
			}catch(ex:*){}
		}
		
		private function save():void{
		}
		
	}
}