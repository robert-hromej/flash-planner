package planner{
	
	import fl.controls.ProjectPage;
	
	import flash.display.Calendar;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.xml.*;
	
	import mx.collections.ArrayCollection;
	
	import org.osmf.events.TimeEvent;
	
	import planner.Allocation;
	import planner.Resource;
	import planner.Task;
	
	import utils.Global;
	import utils.methods.*;
	
	public class Project extends Object{
		
		public var name:String;
		public var start:Date;
		
		public var manager:String;
		public var company:String;
		public var mrprojectVersion:uint;
		public var calendarId:uint;
		public var phase:String;
		
		public var calendar:Calendar;
		public var dataProvider:ArrayCollection = new ArrayCollection();
		public var resources:Vector.<Resource> = new Vector.<Resource>();
		public var allocations:Vector.<Allocation> = new Vector.<Allocation>();
		
		
		public function Project(xml:XML):void{
			this.start = strToDate(xml.attribute("project-start"))
			this.manager = xml.attribute("manager")
			this.company = xml.attribute("company")
			this.name = xml.attribute("name")
			this.mrprojectVersion = xml.attribute("mrproject-version")
			this.calendarId = xml.attribute("calendar")
			this.phase = xml.attribute("phase")
			
			this.calendar = new Calendar(xml.elements("calendars"))
				
			loadTasks(xml.elements("tasks"));
			loadAllocation(xml.elements("allocations").elements("allocation"));
			loadResources(xml.elements("resources").elements("resource"));
		}
		
		public function loadTasks(tasksXML:XMLList):void{
			dataProvider.removeAll()
			Task.dataBase = new Array()
			parseTasksXML(tasksXML)
		}
		
		private function parseTaskXML(tasks:Array):void{
			for each(var task:Task in tasks){
				dataProvider.addItem(task)
				if (task.open){
					parseTaskXML(task.children)
				}
			}
		}
		
		private function parseTasksXML(element:XMLList):void{
			var elements:XMLList = element.elements("task");
			for each(var el:XML in elements){
				var task:Task = new Task(el,element.attribute("id"))
				Task.insert(task)
				parseTasksXML(XMLList(el));
			}
			
		}
		
		private function loadAllocation(allocationXML:XMLList):void{
			for each(var all:XML in allocationXML){
				allocations.push(new Allocation(all))
			}
		}
		
		private function loadResources(resourcesXML:XMLList):void{
			for each(var res:XML in resourcesXML){
				resources.push(new Resource(res))
			}
		}
		
		public function editAllocations(taskId:Number,resources:Array):void{
			var ar:Vector.<Allocation> = new Vector.<Allocation>();
			for each(var al:Allocation in allocations){
				if (al.taskId != taskId){
					ar.push(al)
				}else{
					if (!al.resource.taskUnits){
						al.resource.taskUnits = al.units
					}
				}
			}
			var a:Allocation
			for each(var res:Resource in resources){
				a = new Allocation(null)
				a.taskId = taskId
				a.resource_id = res.id
				if (res.taskUnits){
					a.units = res.taskUnits
				}else{
					a.units = 100
				}
//				res.taskUnits = null;
				ar.push(a)
			}
			allocations = ar
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
			var shipTimer:Timer = new Timer(Global.funcTimer, 1);
				shipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, func);
				shipTimer.start();			
			function func(ev:*):void{
				dataProvider.refresh()
				calendar.refresh()
			}
		}
		
		public function get end():Date{
			var ar:Array = Task.findAll();
			var maxEnd:Date = ar[0].end;
			for each(var task:Task in ar){
				if (maxEnd < task.end){
					maxEnd = task.end
				}
			}
			return maxEnd
		}
		
		public function clearAllocations():void{
			var ar:Vector.<Allocation> = new Vector.<Allocation>();
			var tempAllocation:Allocation;
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