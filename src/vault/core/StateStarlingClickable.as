package vault.core
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	public class StateStarlingClickable extends StateStarling
	{
		public var enableTouch:Boolean = true;
		private var mIsDown:Boolean;
		private var originalPos:Point = new Point();
		
		public function StateStarlingClickable()
		{
			super();
		}
		
		override protected function onReady():void
		{
			super.onReady();
			
			this.addEventListener( TouchEvent.TOUCH, onTouch );
		}
		
		
		private function onTouch(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch( this );
			if( !this.enableTouch || touch == null ) return;
			
			if (touch.phase == TouchPhase.BEGAN && !mIsDown)
			{
				originalPos.x = this.x;
				originalPos.y = this.y;
				
				this.scaleX = this.scaleY = 0.95;
				this.x += (1.0 - 0.95) / 2.0 * this.width;
				this.y += (1.0 - 0.95) / 2.0 * this.height;
				mIsDown = true;
			}
			else if (touch.phase == TouchPhase.MOVED && mIsDown)
			{
				// reset button when user dragged too far away after pushing
				var buttonRect:Rectangle = getBounds(stage);
				if (touch.globalX < buttonRect.x - 50 ||
					touch.globalY < buttonRect.y - 50 ||
					touch.globalX > buttonRect.x + buttonRect.width + 50 ||
					touch.globalY > buttonRect.y + buttonRect.height + 50)
				{
					resetContents();
				}
			}
			else if (touch.phase == TouchPhase.ENDED && mIsDown)
			{
				resetContents();
				dispatchEventWith( Event.TRIGGERED, true, {} );
			}
		}
		private function resetContents():void
		{
			mIsDown = false;
			this.scaleX = this.scaleY = 1;
			this.x = originalPos.x;
			this.y = originalPos.y;
		}
		
		override public function purge(e:Event):void
		{
			super.purge(e);
		}		
	}
}