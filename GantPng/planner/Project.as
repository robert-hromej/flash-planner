package planner{
	
	import flash.events.TimerEvent
	import flash.utils.Timer
	import flash.xml.*
	import flash.display.Calendar
	
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
				
		public function Project(xml):void{
			this.start = strToDate(xml.attribute("project-start"))
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
			dataProvider.refresh()
			calendar.refresh()
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
		
	}
	
}