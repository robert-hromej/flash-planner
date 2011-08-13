package planner{
	
	import flash.events.TimerEvent
	import flash.utils.Timer
	import flash.xml.*
	import flash.display.Calendar
	
	import fl.controls.ProjectPage
	import fl.data.TaskDataProvider
	
	import planner.Task
	import planner.Resource
	import planner.Allocation
	
	import utils.Global;
	import utils.methods.*
	
	public class Project extends Object{
		
		public var name:String
		public var start:Date
		
		public var manager:String
		public var company:String
		private var mrprojectVersion:uint
		private var calendarId:uint
		private var phase:String
		
		public var calendar:Calendar
		public var dataProvider:TaskDataProvider
		public var resources:Array = new Array()
		public var allocations:Array = new Array()
		
		public var projectPage:ProjectPage
		
		public function Project(xml):void{
			init(xml)
		}
		
		public function init(xml):void{
			this.start = strToDate(xml.attribute("project-start"))
			this.start.setHours(0,0,0,0);
			this.manager = xml.attribute("manager")
			this.company = xml.attribute("company")
			this.name = xml.attribute("name")
			this.mrprojectVersion = xml.attribute("mrproject-version")
			this.calendarId = xml.attribute("calendar")
			this.phase = xml.attribute("phase")
			
			this.calendar = new Calendar(xml.elements("calendars"))
			this.dataProvider = new TaskDataProvider(xml.elements("tasks"))
			
			for each(var all in xml.elements("allocations").elements("allocation")){
				allocations.push(new Allocation(all))
			}
			for each(var res in xml.elements("resources").elements("resource")){
				resources.push(new Resource(res))
			}
			projectPage = new ProjectPage(this)			
		}
		
		public function editAllocations(taskId,resources){
			var ar:Array = new Array()
			for each(var al in allocations){
				if (al.taskId != taskId){
					ar.push(al)
				}else{
					if (!al.resource.taskUnits){
						al.resource.taskUnits = al.units
					}
				}
			}
			var a:Allocation
			for each(var res in resources){
				a = new Allocation(null)
				a.taskId = taskId
				a.resource_id = res.id
				if (res.taskUnits){
					a.units = res.taskUnits
				}else{
					a.units = 100
				}
				res.taskUnits = null
				ar.push(a)
			}
			allocations = ar
		}
		
		public function f(id):Resource{
			for each(var res in resources){
				if (res.id == id){
					return res
				}
			}
			return null
		}
		
		public function refresh():void{
			Global.openMessagePage()
			var shipTimer = new Timer(Global.funcTimer, 1);
				shipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, func);
				shipTimer.start();			
			function func(ev:*):void{
				dataProvider.refresh()
				calendar.refresh()
				Global.closeMessagePage()
			}
		}
		
		public function get end():Date{
			var ar:Array = Task.findAll()
			var maxEnd:Date = ar[0].end
			for (var i in ar){
				if (maxEnd < ar[i].end){
					maxEnd = ar[i].end
				}
			}
			return maxEnd
		}
		
		public function clearAllocations(){
			var ar:Array = new Array()
			var tempAllocation
			while (allocations.length > 0){
				tempAllocation = allocations.shift()
				if (tempAllocation.task && tempAllocation.resource){
					ar.push(tempAllocation)
				}
			}
			allocations = ar
		}
		
		public function get xml():XMLNode{
			var projectXML:XMLNode = new XMLNode(1,"project")
			
			projectXML.attributes =	{	"name":name,
										"company":company,
										"manager":manager,
										"phase":phase,
										"mrproject-version":mrprojectVersion,
										"calendar":calendarId,
										"project-start":convertDateToXML(start)
							}
			
			projectXML.insertBefore(new XMLNode(1,"properties"),null)
			projectXML.insertBefore(new XMLNode(1,"phases"),null)
			projectXML.insertBefore(calendar.xml,null)
			projectXML.insertBefore(dataProvider.xml,null)
			projectXML.insertBefore(new XMLNode(1,"resource-groups"),null)
			projectXML.insertBefore(resourcesXML,null)
			projectXML.insertBefore(allocationsXML,null)
			
			return projectXML
		}
		
		private function get resourcesXML():XMLNode{
			var resXML:XMLNode = new XMLNode(1,"resources")
			for each(var res in resources){
				resXML.insertBefore(res.xml,null)
			}
			return resXML
		}
		
		private function get allocationsXML():XMLNode{
			var allXML:XMLNode = new XMLNode(1,"allocations")
			for each(var all in allocations){
				allXML.insertBefore(all.xml,null)
			}
			return allXML
		}
		
	}
	
}