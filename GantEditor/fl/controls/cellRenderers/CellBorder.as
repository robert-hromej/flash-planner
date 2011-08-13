package fl.controls.cellRenderers{
	
	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	
	public class CellBorder extends CellRenderer{
		
		public function CellBorder(){
			super();
			var format:TextFormat = new TextFormat("Verdana", 11);
			format.align = "left";
			format.font = "Arial, Tahoma, sans-serif"
			format.size = 10;
			
			setStyle("upSkin",cell_border);
			setStyle("downSkin",cell_border);
			setStyle("overSkin",cell_border);
			setStyle("selectedUpSkin",cell_border);
			setStyle("selectedDownSkin",cell_border);
			setStyle("selectedOverSkin",cell_border);
			
			setStyle("textFormat", format); 
		}
	}
}