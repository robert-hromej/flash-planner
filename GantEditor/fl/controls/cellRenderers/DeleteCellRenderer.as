package fl.controls.cellRenderers{
	
	import fl.controls.listClasses.CellRenderer
	import flash.display.Shape
	import flash.text.TextFormat

	public class DeleteCellRenderer extends CellRenderer{
		
		public function DeleteCellRenderer(){
			buttonMode = true;
			useHandCursor = true;
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.align = "center";
			
			setStyle("disabledTextFormat", textFormat);
		}
	}
}