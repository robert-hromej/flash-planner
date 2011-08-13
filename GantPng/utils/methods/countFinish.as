package utils.methods{
	import utils.Global
	public function countFinish(task):Date{
		var end:Date = task.work_start
		
		var workCount:uint = task.lengthWork
		
		end = addDays(end,7*uint(workCount/(40*3600)))
		workCount = workCount%(40*3600)
		
		var intervals = Global.project.calendar.intervals
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
			
			for each(var interval in intervals){
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