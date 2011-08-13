package utils{
	import flash.display.Calendar;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	
	import planner.Allocation;
	import planner.DateType;
	import planner.Project;
	import planner.Resource;
	import planner.Task;
	import planner.WorkInterval;
	
	import utils.methods.convertDateToXML;
	
	public class XMLService{
		
		public function XMLService(){
			
		}
		
		public static function projectXML(project:Project):XMLNode{
			var projectXML:XMLNode = new XMLNode(1,"project")
			
			projectXML.attributes =	{
				"name":project.name,
				"company":project.company,
				"manager":project.manager,
				"phase":project.phase,
				"mrproject-version":project.mrprojectVersion,
				"calendar":project.calendarId,
				"project-start":convertDateToXML(project.start)
			}
			
			projectXML.insertBefore(new XMLNode(1,"properties"),null)
			projectXML.insertBefore(new XMLNode(1,"phases"),null)
			projectXML.insertBefore(calendarXML(project.calendar),null)
			projectXML.insertBefore(tasksXML(),null)
			projectXML.insertBefore(new XMLNode(1,"resource-groups"),null)
			projectXML.insertBefore(resourcesXML(project.resources),null)
			projectXML.insertBefore(allocationsXML(project.allocations),null)
			
			return projectXML;
		}
		
		public static function resourcesXML(resources:Vector.<Resource>):XMLNode{
			var resXML:XMLNode = new XMLNode(1,"resources")
			for each(var res:Resource in resources){
				resXML.insertBefore(res.xml,null)
			}
			return resXML
		}
		
		public static function allocationsXML(allocations:Vector.<Allocation>):XMLNode{
			var allXML:XMLNode = new XMLNode(1,"allocations")
			for each(var all:Allocation in allocations){
				allXML.insertBefore(all.xml,null)
			}
			return allXML
		}
		
		public static function calendarXML(calendar:Calendar):XMLNode{
			var overridden_day_type:XMLNode = new XMLNode(1,"overridden-day-type");
			overridden_day_type.attributes={"id":0};
			for each (var interval:WorkInterval in calendar.intervals) {
				overridden_day_type.insertBefore(interval.xml,null);
			}
			var overridden_day_types:XMLNode=new XMLNode(1,"overridden-day-types");
			overridden_day_types.insertBefore(overridden_day_type,null);
			var calendar_1:XMLNode=new XMLNode(1,"calendar");
			calendar_1.insertBefore(calendar._default_week.xml,null);
			calendar_1.insertBefore(overridden_day_types,null);
			calendar_1.attributes = {"id":1,"name":"Standard"}
				;
			var calendarXML:XMLNode=new XMLNode(1,"calendars");
			calendarXML.insertBefore(dateTypesXML(calendar.day_types),null);
			calendarXML.insertBefore(calendar_1,null);
			return calendarXML;
		}
		
		public static function dateTypesXML(day_types:Vector.<DateType>):XMLNode {
			var dt:XMLNode=new XMLNode(1,"day-types");
			for each (var d:DateType in day_types) {
				dt.insertBefore(d.xml,null);
			}
			return dt;
		}
		
		public static function tasksXML():XMLNode{
			var rootTasks:Array = Task.findAllByParentId(-1)
			var ts:XMLNode = new XMLNode(1,"tasks")
			for each(var t:Task in rootTasks){
				ts.insertBefore(t.xml,null)
			}
			return ts
		}
		
			
	}
}