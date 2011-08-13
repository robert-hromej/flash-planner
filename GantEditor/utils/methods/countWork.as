package utils.methods{
	
	import utils.Global
	
	public function countWork(start:Date,end:Date):Number{
		
		var workCount:uint = 0;
		var w:uint = (end.getTime()-start.getTime())/(7*24*3600*1000)
		workCount = w*40*3600
		start = addWeeks(start,w)
		
		var intervals = Global.project.calendar.intervals
		while (start <= end){
			
			if (start.getDay() == 0 || start.getDay() == 6){
				start = nextDay(start)
				continue
			}else
			
			if (start.getHours() < intervals[0].start/3600){
				start.setHours(intervals[0].start/3600,0,0,0)
				continue
			}else
			
			if (start.getHours() >= intervals[1].end/3600){
				start = nextDay(start)
				continue
			}else
			
			if (start.getHours() >= intervals[0].end/3600 && start.getHours() < intervals[1].start/3600){
				start.setHours(intervals[1].start/3600,0,0,0)//,intervals[1].start/60)
				continue						
			}else{
				for each(var interval in intervals){
					if (start.getHours() >= interval.start/3600 && start.getHours() < interval.end/3600){
						
						if ((end.getTime()-start.getTime()) > interval.duration*1000){
							workCount += interval.duration;
						}else{
							workCount += (end.getTime()-start.getTime())/1000;
						}
						
						start.setHours(interval.end/3600);
						
						
						/*
						if (workCount <= interval.duration){
							end = addSeconds(end,workCount)
							workCount = 0
							break
						}else{
							end = addHours(end,interval.duration/3600)
							workCount = workCount - interval.duration
							continue
						}
						*/
					}
				}
			}
			
		}
		return workCount;
	}
	
}