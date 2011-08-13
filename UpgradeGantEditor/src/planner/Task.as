﻿package planner{
	
	import app.controllers.ApplicationController;
	import app.views.LineTimeView;
	
	import flash.display.Calendar;
	import flash.display.LineTime;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.xml.SchemaTypeRegistry;
	
	import utils.Global;
	import utils.History;
	import utils.methods.*;
	
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
		
		public function Task(xml:XML, parentId:Number = -1 ):void {
			this.parentId = parentId;
			this.line = new LineTime(this)
			this._open = true
			if (xml){
				this.id = xml.attribute("id")
				this._name = xml.attribute("name")
				this.note = xml.attribute("note")
				this.work = xml.attribute("work")
				var preds:XMLList = xml.elements("predecessors").elements("predecessor")
				for each(var pred:XML in preds){
					predecessors.push(new Predecessor(pred,this))
				}
				if (xml.elements("constraint") != undefined){
					this.constraint = new Constraint(xml.elements("constraint"))
				}
				this.start = strToDate(xml.attribute("start"))
				this.end = strToDate(xml.attribute("end"))
				this.work_start = strToDate(xml.attribute("work-start"))				
				this.percent_complete = xml.attribute("percent-complete")
				this.priority = xml.attribute("priority")
				this._type = xml.attribute("type")
				this._scheduling = xml.attribute("scheduling")
			}else{
				initNewTask()
			}
		}
		
		private function initNewTask():void{
			var xml:XML = NEW_TASK_XML
			_autoincrement = _autoincrement+1
			this.id = _autoincrement
			this.name = "new task"
			this.note = ""
			if (parent){
				this.work = 3600*8
				this.start = parent.start
				this.work_start = parent.work_start
			}else{
				this.work = 3600*8
				this.start = ApplicationController.proj.start
				this.work_start = ApplicationController.proj.start
			}
			countEnd()
			this.percent_complete = 0
			this.priority = 0
			this._type = "normal"
			this.scheduling = "fixed-work"
		}
		
		
		public function get scheduling():String{
			if (_scheduling == null){
				_scheduling = "fixed-work"
			}
			if (isParent()){
				_scheduling = "fixed-duration"
			}
			return _scheduling
		}
		
		public function set scheduling(sch:String):void{
			_scheduling = sch
		}
		
		public function get constraint():Constraint{
			if (_constraint == null){
				_constraint = new Constraint(null)
				_constraint.time = ApplicationController.proj.start
			}
			return _constraint
		}
		
		public function set constraint(con:Constraint):void{
			_constraint = con
		}
		
		public function get constraintDate():Date{
			if (_constraint){
				return _constraint.time
			}
			return start
		}
		
		public function set constraintDate(date:Date):void{
			if (start != date){
				constraint.time = date
			}
		}
		
		public function get name():String{
			var str:String = _name
			for (var i:uint=1;idsTree.split('.').length > i;i++){
				str = "  "+str
			}
			return str
		}
		
		public function get wbsName():String{
			return idsTree + "  " +clearTabs(_name)
		}
		
		public function set name(n:String):void{
			this._name = clearTabs(n)
			History.changed()
		}
		
		public function get end():Date{
			if (type == "milestone"){
				return work_start
			}
			return this._end
		}
		
		public function set end(e:Date):void{
			this._end = e
		}
		
		public function get work():uint{
			if (type == "milestone"){
				return 0
			}else{
				return this._work
			}
		}
		public function set work(w:uint):void{
			this._work = w
		}
		
		public function get type():String{
			if (_type == null){
				_type = ""
			}
			return _type
		}
		
		public function set type(n:String):void{
			if (n == "milestone"){
				this._type = n
				addToUpdate()
				update()
			}else if(n == "normal"){
				this._type = n
				addToUpdate()
				update()
			}
		}
		
		public function get work_start():Date{
			if (_work_start){
				var intervals:Array = ApplicationController.proj.calendar.intervals
				if (intervals[0].start > (_work_start.getHours()*3600+_work_start.getMinutes()*60)){
					_work_start.setSeconds(intervals[0].start)
				}
			}
			return this._work_start
		}
		
		public function set work_start(ws:Date):void{
			this._work_start = ws
		}
		
		public function get open():Boolean{
			return this._open
		}
		
		public function set open(b:Boolean):void{
			this._open = b
			Main.refresh()
		}
		
		public function get parent():Task{
			return findById(parentId)
		}
		
		[Bindable]
		public function get workColumn():String{
			var d:uint
			var h:uint
			var str:String = ""
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
		
		public function set workColumn(i:String):void{
			if (isParent()){
				updateDuration()
			}else if (type != "milestone"){
				var newWork:uint
				var str:String = i
				var re:RegExp = /(d|h|w)/
				var ar:Array = str.split(re).reverse()
				for (var i:String in ar){
					if (ar[i] == "w"){
						newWork += uint(ar[i+1])*40*3600
					}else if (ar[i] == "d"){
						newWork += uint(ar[i+1])*8*3600
					}else if (ar[i] == "h"){
						newWork += uint(ar[i+1])*3600
					}
				}
				if (newWork > 3600){
					work = newWork
				}else{
					work = 3600
				}
				addToUpdate()
				update()
			}
			ApplicationController.proj.refresh()
			History.changed()
		}
		
		public function updateDuration():uint{
			if (isParent()){
				work = 0
				for each(var ch:Task in children){
					work = work + ch.work//updateDuration()
				}
			}else{
				// TODO				обчислити робочі години між початком і кінцем задачі
			}
			if (parent){
				parent.updateDuration()
			}
			return work
		}
		
		private function countEnd():void{
			if (isParent()){
				var tempEnd:Date = start
				for each(var s:Task in children){
					if (s.end > tempEnd){tempEnd = s.end}
				}
				if (tempEnd != end){
					end = tempEnd
				}
			}else{
				countFinish(this)
			}
		}
		
		private function updateStart():Boolean{
			if (isParent()){
				var ar:Array = children
				var tempStart:Date
				tempStart = ar[0].work_start
				for each(var s:Task in ar){
					if (s.work_start < tempStart){
						tempStart = s.work_start
					}
				}
				work_start = tempStart
				start = work_start
			}
			countEnd()
			return false
		}
		
		public function isParent():Boolean{
			return children != null;
		}
		
		
		public function isPredecessors(t:Task):Boolean{
			var pred:Predecessor
			for each(pred in predecessors){
				if (pred.predTask == t){
					return true
				}
			}
			return false
		}
		
		public function isChild(t:Task):Boolean{
			if (parent){
				if (parent == t){
					return true
				}else{
					return parent.isChild(t)
				}
			}
			return false
		}
		
		private function updateParent():void{
			if (parent){
				parent.updateStart()
				for each(var a:Task in parent.f()){
					a.addToUpdate()
				}
				parent.updateParent()
			}
		}
		
		private function updateFinish():void{
			countStart(this)
		}
		
		private static var tempPredecessors:ArrayCollection = new ArrayCollection()
			
		private function addToTempPredecessors():void{
			var a:Task
			if (tempPredecessors.getItemIndex(this) == -1){
				tempPredecessors.addItem(this)
				if(isParent()){
					for each(var ch:Task in children){
						ch.addToTempPredecessors()
					}					
				}else{
					var p:Task = parent
					while(p != null){
						if (tempPredecessors.getItemIndex(p) == -1){
							tempPredecessors.addItem(p)
						}
						for each(a in p.f()){
							a.addToTempPredecessors()
						}
						p = p.parent
					}
				}
				for each(a in f()){
					a.addToTempPredecessors()
				}
			}
		}
		
		public function get newPredecessorsList():ArrayCollection{
			var ar:ArrayCollection = new ArrayCollection()
			tempPredecessors.removeAll()
			for each(var ch:Task in allChildren){
				ch.addToTempPredecessors()
			}
			addToTempPredecessors()
			for each(var task:Task in copyArray(Task.findAll()).sortOn("wbsName",4)){
				if (task != this &&
					!isChild(task) &&
					!task.isChild(this) &&
					tempPredecessors.getItemIndex(task) == -1 &&
					!isPredecessors(task)){
					ar.addItem({label:task.wbsName, task:task})
				}
			}
			return ar
		}
		
		public function addPredecessor(task:Task,type:String):void{
			if(task){
				tempPredecessors.removeAll()
				for each(var ch:Task in allChildren){
					ch.addToTempPredecessors()
				}
				addToTempPredecessors()
				if (task != this && 
					!isChild(task) &&
					!task.isChild(this) &&
					tempPredecessors.getItemIndex(task) == -1 &&
					!isPredecessors(task)){
						var newPredecessor:Predecessor = new Predecessor(null,this)
							newPredecessor.type = type
							newPredecessor.predecessor_id = task.id
						predecessors.push(newPredecessor)
						addToUpdate()
						update()
				}
			}
		}
		
		private function get allPredecessors():Array{
			var ar:Array = copyArray(predecessors)
			if (parent){
				for each(var pred:Predecessor in parent.allPredecessors){
					if (ar.indexOf(pred) == -1){
						ar.push(pred)
					}
				}
			}
			return ar
		}
						
		public function addToUpdate():void{
			if (upTasks.indexOf(this) == -1){
				upTasks.push(this)
			}
		}
		
		public var criticalPredecessor:Task
		
		public static function update():void{
			var shipTimer:Timer = new Timer(Global.funcTimer, 1);
			shipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, func);
			shipTimer.start();			
			
			function func(ev:*):void{
				while (upTasks.length > 0){
					var task:Task = upTasks.shift()
					task.updateDuration()
					if (task.isParent()){
						for each(var ch:Task in task.children){
							ch.addToUpdate()
						}
						task.updateStart()
					}else{
						var s:Date = ApplicationController.proj.start;
						var e:Date = ApplicationController.proj.start;
						
						var ff:Task;
						var sf:Task;
						var ss:Task;
						var fs:Task;
						
						for each(var p:Predecessor in task.allPredecessors){
							if (!p.predTask){
								continue
							}
							switch (p.type){
								case "FF":
									ff = !ff || p.predTask.end > ff.end ? p.predTask : ff;
									e = p.predTask.end > e ? p.predTask.end : e;
									break
								case "SF":
									sf = !sf || p.predTask.work_start > sf.work_start ? p.predTask : sf;
									e = p.predTask.work_start > e ? p.predTask.work_start : e;
									break
								case "SS":
									ss = !ss || p.predTask.work_start > ss.work_start ? p.predTask : ss;
									s = p.predTask.work_start > s ? p.predTask.work_start : s;
									break
								case "FS":
									fs = !fs || p.predTask.end > fs.end ? p.predTask : fs;
									s = p.predTask.end > s ? p.predTask.end : s;
									break
								default:
							}
						}
						
						for each(var constr:Constraint in task.allConstraint){
							s = constr.time > s ? constr.time : s;
						}
						
						task.end = e;
						task.updateFinish();
						
						if (task.start < s){
							task.work_start = s;
							task.start = task.work_start;
							task.updateStart();
						}
					
						task.updateParent()
					}
					
					for each(var a:Task in task.f()){
						a.addToUpdate()
					}
				}
			}
		}
		
		public static function updateAll():void{
			for each(var task:Task in findAll()){
				task.addToUpdate()
			}
			update()
		}
		
		private function get allConstraint():Array{
			var ar:Array = new Array()
			if (constraint){
				ar.push(constraint)
			}
			if (parent){
				for each(var al:Constraint in parent.allConstraint){
					ar.push(al)
				}
			}
			return ar
		}
		
		public function get allChildren():Array{
			var ar:Array = copyArray(children)
			for each(var ch:Task in children.allChildren){
				ar.push(ch)
			}
			return ar
		}
		
		public function toString():String{
			return "\nid:"+id+", name:"+wbsName// + ", start: "+ work_start + ", end: " + end
		}
		
		private function f():Array{
			var ar:Array = new Array();
			for each(var t:Task in findAll()){
				for each(var p:Predecessor in t.predecessors){
					if (p.predecessor_id == id){
						if (ar.indexOf(p.parentTask) == -1){
							ar.push(p.parentTask)
						}
					}
				}
			}
			return ar
		}
		
		public function unlink():void{
			predecessors = new Array()
			addToUpdate()
			var ar:Array
			for each(var task:Task in f()){
				ar = new Array()
				for each(var pred:Predecessor in task.predecessors){
					if (pred.predTask != this){
						ar.push(pred)
					}else{
						task.addToUpdate()
					}
				}
				task.predecessors = ar
			}
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
		
		public function get newLineTime():LineTimeView{
			var l:LineTimeView = new LineTimeView();
			l.task = this;
			if (type == "milestone"){
				l.type = "MILESTONE"
			}else if (type == "normal"){
				if (isParent()){
					l.type = "PARENT"
				}else{
					l.type = "CHILD"
				}
			}
			return l
		}
		
		public function get children():Array{
			var ar:Array = findAllByParentId(id);
			if (ar.length == 0){
				return null;
			}
			return ar;
		}
		
		public function get label():String{
			return wbsName;
		}
		
		public function get status():String{
			if (!isParent()){
				return ""
			}else if (open){
				return "-"
			}else if (!open){
				return "+"
			}else{
				return ""
			}
		}
		
		public function get idsTree():String{
			var index:uint = 0
			var subs:Array = findAllByParentId(parentId)
			for (var i:* in subs){
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
		
		public function destroy():Boolean{
			addToUpdate()
			for each(var ff:Task in f()){
				ff.addToUpdate()
			}
			
			for each(var task:Task in children){
				task.destroy()
			}
			return Task.destroy(this)
		}
		
		public function addSubTask():Task{
			var subTask:Task = new Task(null,id)
			open = true
			insert(subTask)
			subTask.addToUpdate()
			Task.update()
			History.changed()
			return subTask
		}
		
		public function moveUp():void{
			var subs:Array
			if (parent != null){
				subs = parent.children
			}else{
				subs = findAllByParentId(-1)
			}
			var index:Number = subs.indexOf(this)
			if (index != 0){
				changePosition(this, subs[index-1])
				History.changed()
			}
		}
		
		public function moveDown():void{
			var subs:Array
			if (parent != null){
				subs = parent.children
			}else{
				subs = findAllByParentId(-1);
			}
			var index:Number = subs.indexOf(this)
			if (index != subs.length-1){
				changePosition(subs[index+1],this)
				History.changed()
			}			
		}
		
		public function unindent():void{
			if (this.parent){
				unlink()
				var oldParent:Task = this.parent
				this.parentId = this.parent.parentId
			}
		}
		
		public function indent():void{
			unlink()
			var subs:Array = Task.findAllByParentId(this.parentId)
			if (subs.indexOf(this) > 0){
				var indentTask:Task = subs[subs.indexOf(this)-1]
				parentId = indentTask.id
			}
		}
		
		public function get allocations():Array{
			var ar:Array = new Array()
			for each(var a:Allocation in ApplicationController.proj.allocations){
				if (a.taskId == this.id){
					ar.push(a)
				}
			}
			return ar
		}
		
		public function get resources():Array{
			var ar:Array = new Array()
			for each(var al:Allocation in allocations){
				ar.push(al.resource)
			}
			return ar
		}
		
		public function get lengthWork():uint{
			var unit:Number = 0
			for each(var al:Allocation in allocations){
				unit += al.units/100
			}
			if (unit > 0){
				return work/unit
			}
			return work
		}
		
		public function get index():uint{
			return dataBase.indexOf(this)
		}

		public function get xml():XMLNode{
			var thisXML:XMLNode = new XMLNode(1,"task")
			thisXML.attributes = {
									"id":id,
									"name":_name,
									"note":note,
									"work":_work,
									"start":convertDateToXML(start),
									"end":convertDateToXML(end),
									"work-start":convertDateToXML(work_start),
									"percent-complete":percent_complete,
									"priority":priority,
									"type":_type,
									"scheduling":_scheduling
								 }
			if (_constraint){
				thisXML.insertBefore(_constraint.xml,null)
			}
			thisXML.insertBefore(predecessorsXML,null)
			for each(var t:Task in children){
				thisXML.insertBefore(t.xml,null)
			}
			return thisXML
		}
		
		private function get predecessorsXML():XMLNode{
			var prs:XMLNode = new XMLNode(1,"predecessors")
			for each(var p:Predecessor in predecessors){
				prs.insertBefore(p.xml,null)
			}
			return prs
		}
		
		////////////////////////////////////////////////////
		//			static variables and methods
		////////////////////////////////////////////////////
		
		public static var dataBase:Array = new Array()
		private static var _autoincrement:uint = 0
		private static var upTasks:Array = new Array()
		
		public static function insert(task:Task):Task{
			if (task.id > _autoincrement){
				_autoincrement = task.id+1
			}
			if (dataBase.indexOf(task) == -1){
				dataBase.push(task)
				return task
			}
			return null
		}
		
		public static function clearPredecessors():void{
			var ar:Array
			for each(var task:Task in findAll()){
				ar = new Array()
				for each(var pred:Predecessor in task.predecessors){
					if (pred.predTask && pred.parentTask){
						ar.push(pred)
					}
				}
				task.predecessors = ar
			}
		}
		
		public static function findAll():Array{
			return dataBase
		}
		
		public static function get rootTasks():Array{
			return findAllByParentId(-1)
		}		
		
		public static function findById(id:uint):Task{
			for each(var task:Task in dataBase){
				if (task.id == id){
					return task
				}
			}
			return null
		}
		
		public static function findAllByParentId(parentId:Number):Array{
			var subs:Array = new Array()
			for each(var t:Task in dataBase){
				if (t.parentId == parentId){
					subs.push(t)
				}
			}
			return subs
		}
				
		public static function destroy(task:Task):Boolean{
			var ar:Array = new Array()
			var b:Boolean = false
			var tempTask:Task
			while (dataBase.length > 0){
				tempTask = dataBase.shift()
				if (tempTask == task){
					b = true
				}else{
					ar.push(tempTask)
				}
			}
			dataBase = ar
			if (dataBase.length == 0){
				dataBase.push(new Task(null))
			}
			return b
		}
		
		private static function changePosition(task1:Task,task2:Task):void{
			dataBase[dataBase.indexOf(task1)] = task2
			dataBase[dataBase.indexOf(task2)] = task1
		}
	}
}