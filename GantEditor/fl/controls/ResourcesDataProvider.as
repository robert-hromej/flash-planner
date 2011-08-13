package project.tasks{
	
	import fl.data.DataProvider
	import fl.controls.Button
	import flash.display.Sprite
	import flash.xml.XMLNode
	
	import flash.events.*
	
	import project.Project
	
	public class ResourcesDataProvider extends DataProvider{
		
		private var _parentProject
		
		public function ResourcesDataProvider(parentProject):void{
			this._parentProject = parentProject
			refresh()
		}
		
		private function get parentProject():Project{
			return _parentProject
		}
		
		public function refresh():ResourcesDataProvider{
			removeAll()
			for each(var res in parentProject.resources){
				addItem(res)
			}
			return this
		}
		
	}
}