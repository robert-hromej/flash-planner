package planner{
	
	import flash.xml.XMLNode;
	
	import mx.collections.TaskDataProvider;
	
	import utils.Global;
	import utils.methods.strToDate;
	
	
	public class Project extends Object{
		
		[Bindable] public var name:String
		[Bindable] public var start:Date
		[Bindable] public var manager:String
		[Bindable] public var company:String
		private var mrproject_version:uint
		private var calendar_id:uint
		private var phase:String
		
		private var tasks:TaskDataProvider
		[Bindable] public var resources:Array = new Array()
		public var allocations:Array = new Array()
		
		public function Project(xml:XML):void{
			this.name = xml.attribute("name")
			this.start = strToDate(xml.attribute("project-start"))
			this.manager = xml.attribute("manager")
			this.company = xml.attribute("company")
			this.mrproject_version = xml.attribute("mrproject-version")
			this.calendar_id = xml.attribute("calendar")
			this.phase = xml.attribute("phase")
				
			this.tasks = new TaskDataProvider(xml.elements("tasks"))
			
			for each(var all:XML in xml.elements("allocations").elements("allocation")){
				allocations.push(new Allocation(all))
			}
			
			for each(var res:XML in xml.elements("resources").elements("resource")){
				resources.push(new Resource(res))
			}
		}
		
		public function f(id:uint):Resource{
			for each(var res:Resource in resources){
				if (res.id == id){
					return res
				}
			}
			return null
		}
		
		public function refresh():void{
			
			Global.tasksContainer.removeAllElements()
			Global.predecessorsContainer.removeAllElements()
//			Global.paneContainer.removeAllElements()
			
			for each(var t:Task in Task.findAll()){
				for each(var pred:Predecessor in t.predecessors){
					pred._arrow = null
				}
				t._component = null
			}
				
			drawComponent(Task.rootTasks)
			
			drawPredecessorsArrow()
			Task.criticPath	
		}
		
		private function drawComponent(tasks:Array):void{
			for each(var task:Task in tasks){
				Global.tasksContainer.addElement(task.component)
				drawComponent(task.subTasks)
			}
		}
		
		private function drawPredecessorsArrow():void{
			for each(var task:Task in Task.findAll()){
				for each(var pred:Predecessor in task.predecessors){
					Global.predecessorsContainer.addElement(pred.arrow)
				}
				if (task.arrow){
					Global.predecessorsContainer.addElement(task.arrow)
				}
			}
		}
		
//		
//		public function get end():Date{
//			var ar:Array = Task.findAll()
//			var maxEnd:Date = ar[0].end
//			for (var i in ar){
//				if (maxEnd < ar[i].end){
//					maxEnd = ar[i].end
//				}
//			}
//			return maxEnd
//		}
//		
		public function clearAllocations():void{
			var ar:Array = new Array()
			var tempAllocation:Allocation
			while (allocations.length > 0){
				tempAllocation = allocations.shift()
				if (tempAllocation.task && tempAllocation.resource){
					ar.push(tempAllocation)
				}
			}
			allocations = ar
		}
		
	}
	
}
