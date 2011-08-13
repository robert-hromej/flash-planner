package fl.controls.cellRenderers{
	
	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	
	public class WBS extends CellRenderer{
		
		public function WBS(){
			var format:TextFormat = new TextFormat();
			format.align = "left";
			format.font = "Arial, Tahoma, sans-serif"
			format.size = 10;
			
			setStyle("upSkin",wbs_background);
			setStyle("downSkin",wbs_background);
			setStyle("overSkin",wbs_background);
			setStyle("selectedUpSkin",wbs_background);
			setStyle("selectedDownSkin",wbs_background);
			setStyle("selectedOverSkin",wbs_background);
			
			setStyle("textFormat", format); 
		}
	}
}
