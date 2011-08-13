package utils.methods{
	import app.controllers.ApplicationController;
	
	import planner.Task;
	
	import utils.Global;

	public function countStart(task:Task):Date{
		
		var start:Date = task.end
		var workCount:uint = task.lengthWork
		
		start = addWeeks(start,-uint(workCount/(40*3600)))
		workCount = uint(workCount%(40*3600))
		
		var intervals:Array = ApplicationController.proj.calendar.intervals
		
		while (workCount > 0){
			
			if (task.id == 5){
				trace(workCount)
				trace(start)
			}
			
			if (start.getDay() == 0 || start.getDay() == 6){
				start = preDay(start)
				continue
			}else
			if (getSeconds(start) > intervals[1].end){
				start.setHours(intervals[1].end/3600)
				continue
			}else
			if (getSeconds(start) < intervals[0].end){
				start = preDay(start)
				continue
			}else
			if (start.getHours() <= intervals[1].start/3600 && start.getHours() > intervals[0].end/3600){
				start.setHours(intervals[0].end/3600)
			}else{
				for each(var interval:Array in intervals){
					if (start.getHours() > interval.start/3600 && start.getHours() <= interval.end/3600){
						if (workCount <= interval.duration){
							start = addSeconds(start,-workCount)
							workCount = 0
							break
						}else{
							start = addSeconds(start,-interval.duration)
							workCount = workCount - interval.duration
							continue
						}
					}
				}
			}			
		}
		task.start = start
		task.work_start = start
		return start
	}
	
}