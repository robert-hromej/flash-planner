package fl{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import fl.gs.TweenLite;
	import fl.gs.OverwriteManager;
	import fl.gs.easing.*;
	
	/**
	 * ...
	 * @author Armen Abrahamyan | http://abrahamyan.com | armflash (at) gmail.com
	 */
	 
	public class ToolTip extends MovieClip
	{
		public var _multiLine:Boolean = false;
		public var  labelMargin:Number = 10;
		public var arrowMargin:Number = 10;
		public var showDelay:Number = 0.5;
		public var hideDelay:Number = 0.5;
		//
		private static var instance:ToolTip;
		private static var allowInstance:Boolean;
		private var _label:String;
		private var _fixedWidth:Number = 50;
		private static const DIRECTION_LEFT:String = "directionleft";
		private static const DIRECTION_RIGHT:String = "directionright";
		private static const DIRECTION_TOP:String = "directiontop";
		private static const DIRECTION_BOTTOM:String = "directionbottom";
		private var _horDirection:String;
		private var _verticalDirection:String;
		private var _followMouse:Boolean = true;
		private var _timer:Timer;
		private var _xposition:Number;
		private var _yposition:Number;
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _labelColor:Number = 0x0000ff;
		
		/**
		 * 
		 */
		public function Tooltip() 
		{
			if (!allowInstance)
			{
				throw new Error("use ToolTip.getInstance() instead of new keyword !");
			}

		}
		/**
		 * 
		 * @return
		 */
		 
		public static function getInstance():ToolTip
		{
			if (instance == null)
			{
				allowInstance = true;
				instance = new ToolTip();
				allowInstance = false;
			}else
			{
				trace("ToolTip instance already exist !");
			}
			instance.init();
			return instance;
		}
		/**
		 * sets label multiline /singleline
		 */
		public function set multiLine(pEnabled:Boolean):void
		{
			_multiLine = pEnabled;
			if (_multiLine)
			{
				label_txt.multiline = true;
				label_txt.wordWrap = true;
				label_txt.width = _fixedWidth;
				label_txt.autoSize = TextFieldAutoSize.RIGHT;
				
			}else
			{
				label_txt.multiline = false;
				label_txt.wordWrap = false;
				label_txt.autoSize = TextFieldAutoSize.LEFT;
			}
		
		}
		/**
		 * sets fixed width for the multiline tooltips
		 * 
		 */
		public function set fixedWidth(pWidth:Number):void
		{
			_fixedWidth = Math.max(pWidth, 50);
		}
		/**
		 * sets new label color
		 */
		public function set labelColor(pColor:Number):void
		{
			_labelColor = pColor;
			label_txt.textColor = _labelColor;
		}
		
		/**
		 * returns label color
		 */
		public function get labelColor():Number
		{
			return _labelColor;
		}
		/**
		 * 
		 */
		private function init():void
		{
			alpha = 0;
			visible = false;
			cacheAsBitmap = true;
			this.mouseChildren = false;
			this.mouseEnabled = false;
			label_txt.x = labelMargin;
			label_txt.textColor = _labelColor;
			label_txt.autoSize = TextFieldAutoSize.LEFT;
			
			_horDirection = DIRECTION_RIGHT;
			_verticalDirection = DIRECTION_TOP;
			addEventListener(Event.ADDED_TO_STAGE, onAdded, false, 0, true);
			reSize();
		}
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded);
			onStageResize();
			stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
			
		}
		private function onStageResize(e:Event=null):void
		{
			_stageWidth = stage.stageWidth;
			_stageHeight = stage.stageHeight;
		
		}
		
		
		private function reSize():void
		{
			bg_mc.rect_mc.width = label_txt.textWidth + 2 * labelMargin +6;
			bg_mc.rect_mc.height = label_txt.textHeight +16;
			bg_mc.arrow_mc.scaleX = (_horDirection == DIRECTION_RIGHT)?1: -1;
			bg_mc.arrow_mc.scaleY = (_verticalDirection == DIRECTION_TOP)?1: -1;
			bg_mc.arrow_mc.x = (_horDirection == DIRECTION_RIGHT)?arrowMargin:(bg_mc.rect_mc.width-arrowMargin);
			bg_mc.arrow_mc.y = (_verticalDirection == DIRECTION_TOP)? bg_mc.rect_mc.height:0;
		}
		/**
		 * shows tooltip
		 * @param	pLabel label of tooltip
		 * @param	pXpos	if followMouse property is set to true, this property is X offset from mouse position, else postion of x coord. of tooltip
		 * @param	pYpos	if followMouse property is set to true, this property is Y offset from mouse position, else postion of y coord. of tooltip
		 */
		public function show(pLabel:String="", pXpos:Number=0,pYpos:Number=0):void
		{
			this.alpha = 0;
			this.visible = false;
			_label = pLabel;
			label_txt.text = _label;
			_xposition = pXpos;
			_yposition = pYpos;
			// check for timer, just in case...
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer = null;
			}
			updatePosition();
			
			TweenLite.killTweensOf(this);
			TweenLite.to(this, showDelay, { autoAlpha:1, ease:Linear.easeNone } );
			
			if (_followMouse)
			{
				_timer = new Timer(20);
				_timer.addEventListener(TimerEvent.TIMER, onTimer, false, 0, true);
				_timer.start();
			}
		}
		private function updatePosition():void
		{
			var xpos:Number = _followMouse?(stage.mouseX + _xposition):_xposition;
			var ypos:Number = _followMouse?(stage.mouseY + _yposition):_yposition;
			_horDirection = (xpos + bg_mc.rect_mc.width - arrowMargin > _stageWidth)?DIRECTION_LEFT:DIRECTION_RIGHT
			_verticalDirection = (ypos -bg_mc.rect_mc.height - bg_mc.arrow_mc.height < 0)?DIRECTION_BOTTOM:DIRECTION_TOP;
			reSize();
			this.x = Math.round((_horDirection == DIRECTION_LEFT)?(xpos-bg_mc.rect_mc.width+arrowMargin):(xpos-bg_mc.arrow_mc.x));
			this.y = Math.round((_verticalDirection == DIRECTION_TOP)?(ypos - bg_mc.rect_mc.height - bg_mc.arrow_mc.height):(ypos + bg_mc.arrow_mc.height));
		}
		/**
		 * hides tooltip
		 */
		public function hide():void
		{
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer = null;
			}
			TweenLite.killTweensOf(this);
			TweenLite.to(this, hideDelay, {autoAlpha:0,ease:Linear.easeNone } );
		}
		private function onTimer(e:TimerEvent):void
		{
			e.updateAfterEvent();
			updatePosition();
		}
		/**
		 * if true, tooltip will foloow mouse 
		 */
		public function set followMouse(pFollow:Boolean):void
		{
			_followMouse = pFollow;
		}
		/**
		 * returns boolean value if tooltips follows mouse or not
		 */
		public function get followMouse():Boolean
		{
			return _followMouse;
		}
		/**
		 * use destroy() method before removing tooltip from stage
		 * cleans/removes listheners/timers
		 */
		public function destroy():void
		{
			TweenLite.killTweensOf(this);
			stage.removeEventListener(Event.RESIZE, onStageResize);
			if (_timer)
			{
				_timer.stop();
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
				_timer = null;
			}
		}
	}
	
}