package planner{
	
	import fl.data.DataProvider
	import flash.events.MouseEvent
	import flash.events.TimerEvent
	
	import flash.utils.Timer
	
	import flash.xml.XMLNode
	import fl.controls.List
	
	import flash.display.Calendar
	import flash.display.LineTime
	
	import utils.methods.*
	import utils.Global;
	
	public class Task extends Object {
		
		private static var NEW_TASK_XML:XML = new XML('<task id="-1" name="" note="" work="28800" start="" end="" work-start="" percent-complete="0" priority="0" type="normal" scheduling="fixed-work" />')
		private static var selected_id:uint = 0
				
		public var id:uint
		private var  _name:String
		public var note:String
		private var _work:uint
		public  var start:Date
		public  var _end:Date
		private var _work_start:Date
		public var percent_complete:uint
		public var priority:uint
		private var _type:String
		private var _scheduling:String
		
		private var _open:Boolean
		public var parentId:Number
		private var line:LineTime
		public var predecessors:Array = new Array()
		
		private var _constraint:Constraint
		
		public function Task(xml:XML, parentId = -1 ):void {
			this.parentId = (parentId == undefined) ? -1 : parentId
			this.line = new LineTime(this)
			this._open = true
			if (xml){
				this.id = xml.attribute("id")
				this._name = xml.attribute("name")
				this.note = xml.attribute("note")
				this._work = xml.attribute("work")
				var preds = xml.elements("predecessors").elements("predecessor")
				for each(var pred in preds){
					predecessors.push(new Predecessor(pred,this))
				}
				this.start = strToDate(xml.attribute("start"))
				this._end = strToDate(xml.attribute("end"))
				this.work_start = strToDate(xml.attribute("work-start"))				
				this.percent_complete = xml.attribute("percent-complete")
				this.priority = xml.attribute("priority")
				this._type = xml.attribute("type")
			}
		}
		
		public function get name():String{
			var str = idsTree+". "+_name
			for (var i=1;idsTree.split('.').length > i;i++){
				str = "    "+str
			}
			return str
		}
		
		public function get wbsName():String{
			return idsTree + "  " +clearTabs(_name)
		}
		
		public function get end():Date{
			if (type == "milestone"){
				return work_start
			}
			return this._end
		}
		
		public function get work():uint{
			if (type == "milestone"){
				return 0
			}else{
				return this._work
			}
		}
		public function get type():String{
			if (_type == null){
				_type = ""
			}
			return _type
		}
		
		public function get work_start():Date{
			if (_work_start){
				var intervals = Global.project.calendar.intervals
				if (intervals[0].start > (_work_start.getHours()*3600+_work_start.getMinutes()*60)){
					_work_start.setSeconds(intervals[0].start)
				}
			}
			return this._work_start
		}
		
		public function set work_start(ws:Date):void{
			this._work_start = ws
		}
		
		public function get parent():Task{
			return findById(parentId)
		}
		
		public function get workColumn():String{
			var d:uint
			var h:uint
			var str = ""
			h = this.work/3600
			d = h/8
			h = h%8
			if (d != 0){
				str += ""+d+"d "
			}
			if (h != 0){
				str += ""+h+"h"
			}
			return str
		}
		
		public function isParent():Boolean{
			return subTasks.length > 0
		}
				
		public function toString():String{
			return "\nid:"+id+", name:"+wbsName// + ", start: "+ work_start + ", end: " + end
		}
		
		private function f():Array{
			var ar = new Array()
			for each(var t in findAll()){
				for each(var p in t.predecessors){
					if (p.predecessor_id == id){
						if (ar.indexOf(p.parentTask) == -1){
							ar.push(p.parentTask)
						}
					}
				}
			}
			return ar
		}
		
		public function get lineTime():LineTime{
			if (type == "milestone"){
				line.type = "MILESTONE"
			}else if (type == "normal"){
				if (isParent()){
					line.type = "PARENT"
				}else{
					line.type = "CHILD"
				}
			}
			return line
		}
		
		public function get subTasks():Array{
			return findAllByParentId(id)
		}
		
		public function get idsTree():String{
			var index:uint = 0
			var subs = findAllByParentId(parentId)
			for (var i in subs){
				if (subs[i].id == id){
					index = i+1
					i = subs.length
				}
			}
			if (this.parentId == -1){
				return (""+index)
			}else{
				return findById(this.parentId).idsTree+"."+index
			}
		}
		public function get allocations():Array{
			var ar:Array = new Array()
			for each(var a in Global.project.allocations){
				if (a.taskId == this.id){
					ar.push(a)
				}
			}
			return ar
		}
		
		public function get resources():Array{
			var ar = new Array()
			for each(var al in allocations){
				ar.push(al.resource)
			}
			return ar
		}
		
		////////////////////////////////////////////////////
		//			static variables and methods
		////////////////////////////////////////////////////
		
		public static var dataBase:Array = new Array()
		private static var _autoincrement:uint = 0
		private static var upTasks:Array = new Array()
		
		public static function insert(task):Task{
			if (task.id > _autoincrement){
				_autoincrement = task.id+1
			}
			if (dataBase.indexOf(task) == -1){
				dataBase.push(task)
				return task
			}
			return null
		}
		
		public static function findAll():Array{
			return dataBase
		}
		
		public static function findById(id):Task{
			for (var i in dataBase){
				var t:Task = dataBase[i]
				if (t.id == id){
					return t
				}
			}
			return null
		}
		
		public static function findAllByParentId(parentId):Array{
			var subs:Array = new Array()
			for each(var t in dataBase){
				if (t.parentId == parentId){
					subs.push(t)
				}
			}
			return subs
		}

	}
}