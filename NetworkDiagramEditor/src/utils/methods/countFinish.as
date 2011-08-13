﻿package utils.methods{
	import planner.OverriddenDayType;
	import planner.Task;
	import planner.WorkInterval;
	import utils.Global;

	public function countFinish(task:Task):Date{
		var end:Date = task.work_start
		
		var workCount:uint = task.lengthWork
		
		end = addDays(end,7*uint(workCount/(40*3600)))
		workCount = workCount%(40*3600)
		
		var intervals:Array = OverriddenDayType(Global.project.calendars.calendar.overriddenDayTypes[0]).intervals
						
		while (workCount > 0){
			if (end.getDay() == 0 || end.getDay() == 6){
				end = nextDay(end)
				continue
			}else
			
			if (end.getHours() < intervals[0].start/3600){
				end.setHours(intervals[0].start/3600)
				continue
			}else
			
			if (end.getHours() >= intervals[1].end/3600){
				end = nextDay(end)
				continue
			}else
			
			if (end.getHours() >= intervals[0].end/3600 && end.getHours() < intervals[1].start/3600){
				end.setHours(intervals[1].start/3600)//,intervals[1].start/60)
				continue						
			}else{
			
			for each(var interval:WorkInterval in intervals){
				if (end.getHours() >= interval.start/3600 && end.getHours() < interval.end/3600){
					if (workCount <= interval.duration){
						end = addSeconds(end,workCount)
						workCount = 0
						break
					}else{
						end = addHours(end,interval.duration/3600)
						workCount = workCount - interval.duration
						continue
					}
				}
			}
			}
			
		}
		task.end = end
		return end
	}
}