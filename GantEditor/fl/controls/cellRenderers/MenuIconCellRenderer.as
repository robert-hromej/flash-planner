package fl.controls.cellRenderers{
	
	import fl.controls.listClasses.CellRenderer
	import flash.display.Sprite
	import flash.text.TextFormat

	public class MenuIconCellRenderer extends CellRenderer{
		
		public function MenuIconCellRenderer() {
			buttonMode = true
			useHandCursor = true
			setStyle("upSkin",MenuIcon)
			setStyle("downSkin",MenuIcon)
			setStyle("overSkin",MenuIcon)
			setStyle("selectedUpSkin",MenuIcon)
			setStyle("selectedDownSkin",MenuIcon)
			setStyle("selectedOverSkin",MenuIcon)
		}
	}
}