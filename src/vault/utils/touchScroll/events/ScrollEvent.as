package vault.utils.touchScroll.events
{
	import flash.events.Event;

	public class ScrollEvent extends Event
	{
		public static const TWEEN_COMPLETE:String = "myTweenComplete";		
		public static const MASK_WIDTH:String = "myMaskWidth";	
		public static const MASK_HEIGHT:String = "myMaskHeight";
		public static const ENTER_FRAME:String = "myEnterFrame";
		public static const MOUSE_DOWN:String = "onMouseDown";
		public static const MOUSE_MOVE:String = "onMouseMove";
		public static const MOUSE_UP:String = "onMouseUp";
		
		public static const TOUCH_TWEEN_UPDATE:String = "touchTweenUpdate";
		public static const TOUCH_TWEEN_COMPLETE:String = "touchTweenComplete";
		
		private var _param:*;		
		
		public function ScrollEvent(type:String, data:*=null, bubbles:Boolean=false, cancelable:Boolean=false):void
		{
			_param = data;
			super(type, bubbles, cancelable);
		}
		
		public function get param():*
		{
			return _param;
		}
	}
}