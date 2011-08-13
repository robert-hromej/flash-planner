package flash.display{
	
	import fl.ToolTip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ContextMenuEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Timer;
	
	import planner.Allocation;
	import planner.Task;
	
	import utils.Global;
	import utils.methods.addDays;
	import utils.methods.countWork;
	
	public class LineTime extends MovieClip{
		
		private var childLine:ChildLine
		private var parentLine:ParentLine
		private var milestone:Milestone
		private var _startIcon:Sprite
		private var _endIcon:Sprite
		private var _backGround:Sprite

		private var task:Task
		private var _type:String;
		private var _resources:TextField;
		private var _durationField:TextField;
		private var f:TextFormat;
		
		private var _line:Sprite;
		
		private static var editing:Boolean = false;
		
		public function LineTime(task:Task,t:String="CHILD"):void{
			
			addChild(durationField);
			
			addChild(backGround);
			
			addChild(startIcon);
			addChild(endIcon);
			
			this.f = new TextFormat();
			this.f.size = 11;
			this.f.bold = true;
			this.f.font = "Arial, Tahoma, sans-serif";
			
			
			this.parentLine = new ParentLine();
			this.childLine = new ChildLine();
			this.milestone = new Milestone();
			this.type = t;
			this.task = task;
			
			line.addEventListener(MouseEvent.MOUSE_DOWN, down)
			line.addEventListener(MouseEvent.MOUSE_UP, up)
			
			addEventListener(MouseEvent.MOUSE_OVER,toolTipOnOver,false,0,true);
			addEventListener(MouseEvent.MOUSE_OUT,toolTipOnOut,false,0,true);

			addEventListener(MouseEvent.MOUSE_OUT, editModeOff)
			addEventListener(MouseEvent.MOUSE_OVER, editModeOn)
			
			
		}
		
		private function editModeOff(ev:*=null):void{
			if (!editing){
				startIcon.alpha = 0;
				endIcon.alpha = 0;
				resources.alpha = 1;
				durationField.alpha = 0;
			}
		}
		
		private function editModeOn(ev:*):void{
			if (type == "CHILD" && !editing){
				startIcon.addEventListener(MouseEvent.MOUSE_DOWN, startTaskMove)
				endIcon.addEventListener(MouseEvent.MOUSE_DOWN, startWorkEdit)
				
				startIcon.alpha = 1;
				endIcon.alpha = 1;
				
				resources.alpha = 0;
				
				durationField.alpha = 1;
				
				durationField.width = 150;
				durationField.text = "work: " + task.workColumn;
				durationField.setTextFormat(f)
			}
		}
			
		private function startWorkEdit(ev:*){
			editing = true;
			Global.project.calendar.setPredecessorsVisible(!editing);
			stage.addEventListener(MouseEvent.MOUSE_UP, endWorkEdit)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, workEditing)
		}
		
		private function endWorkEdit(ev:*){
			editing = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, endWorkEdit);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, workEditing);
			task.addToUpdate();
			Task.update();
			Global.project.refresh();
			editModeOff();
		}
		
		private function workEditing(ev:*){
			if (this.mouseX > 0){
				endIcon.x = this.mouseX;
				
				this.length = endIcon.x;
				
				durationField.x = endIcon.x + 20;
				
				var end:Date = Global.project.calendar.startCalendar;
				
				end = addDays(end,(x+endIcon.x)/Calendar.CELL_WIDTH)

				var unit:Number = 0;
				for each(var al:Allocation in task.allocations){
					unit += al.units/100;
				}
				if (unit == 0){
					unit = 1;
				}

				var work = countWork(task.start,end)*unit;
				task.work = work;
				
				var d:uint
				var h:uint
				var str = ""
				h = work/3600
				d = h/8
				h = h%8
				if (d != 0){
					str += ""+d+"d "
				}
				if (h != 0){
					str += ""+h+"h"
				}
				
				durationField.text = "work: " + str;
				durationField.setTextFormat(f)
			}
		}
		
		private function startTaskMove(ev:*){
			editing = true;
			Global.project.calendar.setPredecessorsVisible(!editing);
			stage.addEventListener(MouseEvent.MOUSE_UP, endTaskMove)
			stage.addEventListener(MouseEvent.MOUSE_MOVE, taskMove)
		}
		
		private function taskMove(ev:*){
			x = Global.project.calendar.mouseX;
		}
			
		private function endTaskMove(ev:*){
			editing = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP, endTaskMove);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, taskMove);
			task.constraintDate = Global.project.calendar.getDateByX(x);
			task.addToUpdate();
			Task.update();
			Global.project.refresh();
			editModeOff();
		}
		
		private var t:Timer = new Timer(2000,1);
		
		private function toolTipOnOver(e:MouseEvent):void{
			t.addEventListener(TimerEvent.TIMER_COMPLETE, stTip);
			function stTip(ev:TimerEvent):void{
				Global.tooltip.show(task.name);
			}
			t.start();
		}
		
		private function toolTipOnOut(e:MouseEvent):void{
			Global.tooltip.hide();
			t.stop();
			t = new Timer(2000,1);
		}
		
		private function down(ev:MouseEvent):void{
			/*
			trace(task.predecessors);
			
			var t1:Array = copy(task) as Task;// Task(task);
			task.name = "sdgdfg";
			t1.name = "dsf dsgfdg df hfg f";
			
			trace(task);
			trace(t1);
			*/
			Calendar.selectedTask = task;
		}
		
		private function up(ev:MouseEvent):void{
			if(task != Calendar._selectedTask){
				task.addPredecessor(Calendar.selectedTask,"FS")
				Main.refresh()
			}else{
				Calendar.selectedTask;
			}
		}
		
		private function openEditPage(ev):void{
			Global.openEditTask(task)
		}
		
		private function get line():Sprite{
			if (_line == null){
				_line = new Sprite()
				_line.addChild(this.parentLine)
				_line.addChild(this.childLine)
				_line.addChild(this.milestone)
				_line.useHandCursor = true
				_line.buttonMode = true
				_line.addEventListener(MouseEvent.CLICK,openEditPage)
				addChild(_line)
			}
			return _line
		}
		
		public function set type(t:String):void{
			while (line.numChildren > 0){
				line.removeChildAt(0)
			}			
			this._type = t
			if (_type == "CHILD"){
				line.addChild(this.childLine)
				refreshResources()
			}else if (_type == "MILESTONE"){
				line.addChild(this.milestone)
				refreshResources()
			}else if (_type == "PARENT"){
				line.addChild(this.parentLine)
				refreshResources()
			}
		}
		
		public function get type():String{
			return this._type
		}
		
		public function set rowIndex(i:uint):void{
			y = i*20
		}
		
		public function set length(width):void{
			childLine.setLength(width,task.percent_complete);
			parentLine.setLength(width,task.percent_complete);
			resources.x = width+10;
			durationField.x = width+20;
			endIcon.x = line.width;
			backGround.width = width + 30; 
		}
		
		public function get start():Point{
			return new Point(x,y+10)
		}
		
		public function get end():Point{
			if (type == "CHILD"){
				return new Point(x+childLine.width,y+10)
			}else if (type == "PARENT"){
				return new Point(x+parentLine.width-4,y+10)
			}else if (type == "MILESTONE"){
				return start
			}else{
				return null
			}
		}
		
		private function get durationField():TextField{
			if (_durationField == null){
				_durationField = new TextField();
				_durationField.height = 20;
				_durationField.maxChars = 1000;
				_durationField.alpha = 0;
			}
			return _durationField;
		}
		
		private function get resources():TextField{
			if (_resources == null){
				_resources = new TextField()
				_resources.height = 20
				_resources.maxChars = 1000
			}
			return _resources
		}
		
		private function refreshResources():void{
			var str:String = ""
			if (task){
				for each(var al in task.allocations){
					str += al.resource.name
					if(al.units < 100){
						str += "("+al.units+")";
					}
					str += ";"
				}
			}
			resources.width = 8*str.length
			resources.text = str
			resources.setTextFormat(f)
			addChild(resources)
		}
		
		private function get startIcon():Sprite{
			if (_startIcon == null){
				_startIcon = new Sprite();
				_startIcon.graphics.beginFill(0xff0000)
				_startIcon.graphics.lineStyle(1, 0x000000)
				_startIcon.graphics.drawRect(0,0,11,11)
				_startIcon.x = -12
				_startIcon.y = 4
				_startIcon.alpha = 0;
			}
			return _startIcon
		}
		
		private function get endIcon():Sprite{
			if (_endIcon == null){
				_endIcon = new Sprite();
				_endIcon.graphics.beginFill(0xff0000)
				_endIcon.graphics.lineStyle(1, 0x000000)
				_endIcon.graphics.drawRect(0,0,11,11)
				_endIcon.y = 4
				_endIcon.alpha = 0;
			}
			return _endIcon;
		}
		
		private function get backGround():Sprite{
			if (_backGround == null){
				_backGround = new Sprite();
				_backGround.graphics.beginFill(0xff0000,0);
				_backGround.graphics.drawRect(0,0,12,12);
				_backGround.y = 3;
				_backGround.x = -15;
				_backGround.alpha = 0;
			}
			return _backGround;
		}
		
	}
}