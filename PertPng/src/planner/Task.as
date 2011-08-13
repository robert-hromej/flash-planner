package planner{
	import flash.display.Arrow;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenuItem;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	
	import mxml.TaskComponentPrint;
	
	import utils.Global;
	import utils.methods.clearTabs;
	import utils.methods.copyArray;
	import utils.methods.strToDate;
	
	
	public class Task extends Object {
		
		private static var NEW_TASK_XML:XML = new XML('<task id="-1" name="" note="" work="28800" start="" end="" work-start="" percent-complete="0" priority="0" type="normal" scheduling="fixed-work" />')
		private static var selected_id:uint = 0
				
		public var id:uint
		[Bindable] public var name:String
		[Bindable] public var note:String
		private var work:uint
		[Bindable] public  var start:Date
		[Bindable] public  var end:Date
		public var work_start:Date
		[Bindable] public var percent_complete:uint
		[Bindable] public var priority:uint
		public var type:String
		private var scheduling:String
		
		private var parentId:Number
		
		[Bindable] public var predecessors:ArrayCollection = new ArrayCollection()
		
		public var _component:TaskComponentPrint
		
		public var editMenuItem:ContextMenuItem 
		public var unlinkMenuItem:ContextMenuItem 
		public var infoMenuItem:ContextMenuItem 
		
		public var _arrow:Arrow
		
		public function Task(xml:XML, parentId:* = -1 ):void {
			this.parentId = (parentId == undefined) ? -1 : parentId
			if (xml){
				this.id = xml.attribute("id")
				this.name = xml.attribute("name")
				this.note = xml.attribute("note")
				this.work = xml.attribute("work")
				this.start = strToDate(xml.attribute("start"))
				this.end = strToDate(xml.attribute("end"))
				this.work_start = strToDate(xml.attribute("work-start"))				
				this.percent_complete = xml.attribute("percent-complete")
				this.priority = xml.attribute("priority")
				this.type = xml.attribute("type")
				this.scheduling = xml.attribute("scheduling")
					
				for each(var pred:XML in xml.elements("predecessors").elements("predecessor")){
					predecessors.addItem(new Predecessor(pred,this))
//					predecessors.push(new Predecessor(pred,this))
				}
				
			}
		}
		
		public function get wbsName():String{
			return idsTree + "  " +clearTabs(name)
		}
//		
		public function get parent():Task{
			return findById(parentId)
		}
		
		[Bindable] public function get workColumn():String{
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
		
		
		
		/**
		 * перераховує тривалість задач(парента і всіх парентів парента...)
		 * */
		public function updateDuration():uint{
			if (isParent()){
				work = 0
				for each(var ch:Task in subTasks){
					work = work + ch.work//updateDuration()
				}
			}
			if (parent){
				parent.updateDuration()
			}
			return work
		}
		
		
		/**
		 * обчислює дату закінчення задачі
		 * */
		private function countEnd():void{
			if (isParent()){
				var tempEnd:Date = start;
				for each(var s:Task in subTasks){
					if (s.end > tempEnd){tempEnd = s.end}
				}
				if (tempEnd != end){
					end = tempEnd;
				}
			}else{
			}
		}
		
		private function updateStart():Boolean{
			if (isParent()){
				var ar:Array = subTasks;
				var tempStart:Date;
				tempStart = ar[0].work_start;
				for each(var s:Task in ar){
					if (s.work_start < tempStart){
						tempStart = s.work_start;
					}
				}
				work_start = tempStart;
				start = work_start;
			}
			countEnd();
			return false;
		}
		
		public function isParent():Boolean{
			return subTasks.length > 0
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
		
		
		public function addPredecessor(task:Task,type:String):void{
//			tempPredecessors.removeAll()
//			task.addToTempPredecessors()
			tempPredecessors.removeAll()
			for each(var ch:Task in allChildren){
				ch.addToTempPredecessors()
			}
			addToTempPredecessors()
			if (tempPredecessors.getItemIndex(task) == -1){
				var newPredecessor:Predecessor = new Predecessor(null,this)
					newPredecessor.type = type
					newPredecessor.predecessor_id = task.id
				predecessors.addItem(newPredecessor)
				addToUpdate()
			}
		}
		
		public function get newPredecessorsList():ArrayCollection{
			var ar:ArrayCollection = new ArrayCollection()
			tempPredecessors.removeAll()
			for each(var ch:Task in allChildren){
				ch.addToTempPredecessors()
			}
			addToTempPredecessors()
			for each(var task:Task in copyArray(Task.findAll()).sortOn("wbsName")){
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
		
		private static var tempPredecessors:ArrayCollection = new ArrayCollection()
		
		private function addToTempPredecessors():void{
			var a:Task
			if (tempPredecessors.getItemIndex(this) == -1){
				tempPredecessors.addItem(this)
				if(isParent()){
					for each(var ch:Task in subTasks){
						ch.addToTempPredecessors()
					}					
				}else{
					var p:Task = parent
					while(p != null){
						if (tempPredecessors.getItemIndex(p) == -1){
							tempPredecessors.addItem(p)
						}
						for each(a in p.childPredecessors()){
							a.addToTempPredecessors()
						}
						p = p.parent
					}
				}
				for each(a in childPredecessors()){
					a.addToTempPredecessors()
				}
			}
		}
		
		
		public function isChild(task:Task):Boolean{
			var parent:Task = parent
			while (parent != null){
				if (parent == task){
					return true
				}
				parent = parent.parent
			}
			return false
		}
		
		private function updateParent():void{
			if (parent){
				parent.addToTempPredecessors()
				parent.updateStart()
				for each(var a:Task in parent.childPredecessors()){
					a.addToUpdate()
				}
				parent.updateParent()
			}
		}
		
		private function updateFinish():void{
		}
		
		public function get allPredecessors():Array{
			var ar:Array = copyArray(predecessors.source)
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
				addToTempPredecessors()
				upTasks.push(this)
			}
		}
		
		public function childPredecessors():Array{
			var ar:Array = new Array()
			for each(var task:Task in findAll()){
				for each(var p:Predecessor in task.predecessors){
					if (p.predecessor_id == id && ar.indexOf(p.parentTask) == -1){
						ar.push(p.parentTask)
					}
				}
			}
			return ar
		}
		
		public function get subTasks():Array{
			return findAllByParentId(id)
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
//		
//		public function destroy():Boolean{
//			
//			addToUpdate()
//			for each(var ff in f()){
//				ff.addToUpdate()
//			}
//			
//			var subs = subTasks
//			for (var i in subs){
//				subs[i].destroy()
//			}
//			return Task.destroy(this)
//		}
//		
//		public function addSubTask():Task{
//			var subTask:Task = new Task(null,id)
//			open = true
//			insert(subTask)
//			subTask.addToUpdate()
//			Task.update()
//			return subTask
//		}
//		
//		public function moveUp():void{
//			var subs:Array
//			if (parent != null){
//				subs = parent.subTasks
//			}else{
//				subs = findAllByParentId(-1)
//			}
//			var index = subs.indexOf(this)
//			if (index != 0){
//				changePosition(this, subs[index-1])
//			}
//		}
//		
//		public function moveDown():void{
//			var subs:Array
//			if (parent != null){
//				subs = parent.subTasks
//			}else{
//				subs = findAllByParentId(-1)
//			}
//			var index = subs.indexOf(this)
//			if (index != subs.length-1){
//				changePosition(subs[index+1],this)
//			}			
//		}
//		
//		public function unindent():void{
//			if (this.parent){
//				unlink()
//				var oldParent = this.parent
//				this.parentId = this.parent.parentId
//			}
//		}
//		
//		public function indent():void{
//			unlink()
//			var subs:Array = Task.findAllByParentId(this.parentId)
//			if (subs.indexOf(this) > 0){
//				var indentTask:Task = subs[subs.indexOf(this)-1]
//				parentId = indentTask.id
//			}
//		}
		
		public function get allocations():Array{
			var ar:Array = new Array()
			for each(var a:Allocation in Global.project.allocations){
				if (a.taskId == this.id){
					ar.push(a)
				}
			}
			return ar
		}
		
		[Bindable] 
		public function set resources(resources:Array):void{
			var ar:Array = new Array()
			for each(var al:Allocation in Global.project.allocations){
				if (al.taskId != id){
					ar.push(al)
				}
			}
			var a:Allocation
			for each(var res:Resource in resources){
				a = new Allocation(null)
				a.taskId = id
				a.resource_id = res.id
				a.units = res.taskUnits
				ar.push(a)
			}
			Global.project.allocations = ar
			addToUpdate()
		}
		
		public function get resources():Array{
			var ar:Array = new Array()
			for each(var al:Allocation in allocations){
				ar.push(al.resource)
//				ar.addItem(al.resource)
			}
			return ar
		}
		
//		public function get otherResources():ArrayCollection{
//			var ar:ArrayCollection = new ArrayCollection(Global.project.resources)
//			ar.filterFunction = function(it:Object):Boolean{
//				return (resources.getItemIndex(it) == -1)
//			}
//			ar.refresh()
//			return ar
//		}
		
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
		
		public function get parentLevel():uint{
			var i:uint
			var p:Task = parent
			while(p){
				i++
				p = p.parent
			}
			return i
		}

		
		private function get allChildren():Array{
			var ar:Array = copyArray(subTasks);
				for each(var child:Task in subTasks){
					for each(var t:Task in child.allChildren){
						ar.push(t);
					}
				}
			return ar
		}
		
//		public function get maxChildNumber():Number{
//			var levels:Array = new Array()
//			for each(var t:Task in allChildren){
//				if (levels[t.level] == null){
//					levels[t.level] = 0
//				}
//				levels[t.level] += 1
//			}
//			var max:uint
//			for each(var l:uint in levels){
//				if (l && l > max){
//					max = l
//				}
//			}
//			
//			return max
//		}
		
		public function isMilestone():Boolean{
			return type == "milestone"
		}
		
		public function get component():TaskComponentPrint{
			if (_component == null){
				_component = new TaskComponentPrint()
				_component.task = this
			}
			_component.refresh()
			return _component
		}
		
		public function get arrow():Arrow{
			if (parent != null && _arrow == null){
				_arrow = new Arrow(parent,this,"parent")
			}
			return _arrow 
		}
		
		public function get criticalTask():Task{
			if (isParent()){
				var st:Task;
				for each(var ch:Task in subTasks){
					st = !st || st.end < ch.end ? ch : st
				}
				return st;
			}else{
				var s:Date = Global.project.start;
				var e:Date = Global.project.start;
				
				var ff:Task = null;
				var sf:Task = null;
				var ss:Task = null;
				var fs:Task = null;
				
				for each(var p:Predecessor in allPredecessors){
					if (!p.predTask){
						continue
					}
					switch (p.type){
						case "FF":
							ff = !ff || p.predTask.end > ff.end ? p.predTask : ff;
							break
						case "SF":
							sf = !sf || p.predTask.work_start > sf.work_start ? p.predTask : sf;
							break
						case "SS":
							ss = !ss || p.predTask.work_start > ss.work_start ? p.predTask : ss;
							break
						case "FS":
							fs = !fs || p.predTask.end > fs.end ? p.predTask : fs;
							break
						default:
					}
				}
				
				s = ss && ss.work_start > s ? ss.work_start : s;
				s = fs && fs.end > s ? fs.end : s;
				
				if (work_start < s){
					if (ss && sf){
						if (ss.end > sf.end){
							return ss;
						}else{
							return sf;
						}
					}else if (ss){
						return ss;
					}else if (sf){
						return sf;
					}
				}else{
					if (ff && fs){
						if (ff.end > fs.end){
							return ff;
						}else{
							return fs;
						}
					}else{
						if (ff){
							return ff;
						}else if (fs){
							return fs;
						}
					}
				}
			}
			return null;
		}
		
		
		public function refresh():void{
			component.refresh()
		}
		
		public function toString():String{
			return wbsName;//"id:"+id+";"+wbsName;
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
//				for each(var pred in task.predecessors){
//					if (pred.predTask && pred.parentTask){
//						ar.push(pred)
//					}
//				}
//				task.predecessors = ar
			}
		}
		
		public static function findAll():Array{
			return dataBase
		}
		
		public static function findById(id:uint):Task{
			for each(var t:Task in dataBase){
				if (t.id == id){
					return t
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
		
		public static function get rootTasks():Array{
			return findAllByParentId(-1)
		}
		
//		public static function get maxLevel():uint{
//			var level:uint
//			for each(var task:Task in findAll()){
//				if (task.level > level){
//					level = task.level
//				}
//			}
//			return level
//		}
		
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
		
		public static function get criticPath():Array{
			
			var ar:Array = new Array();
			
			var lastTask:Task;
				
			for each(var t:Task in dataBase){
				lastTask = !lastTask || lastTask.end < t.end ? t : lastTask;
			}
				
			while(lastTask){
				ar.push(lastTask);
				lastTask = lastTask.criticalTask;
			}
			
			return ar;
		}
	}
}