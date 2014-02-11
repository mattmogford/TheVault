package vault.transitions.move
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import vault.transitions.TransitionType;

	public class Transition_MoveLeftFromRight extends TransitionType
	{		
		public function Transition_MoveLeftFromRight( from:Bitmap, to:Bitmap )
		{
			super( from, to );
		}
		
		override public function start():void
		{
			TweenNano.to( _from, 1, { x : -_from.width, onComplete:stop } );
			_from.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		protected function onEnterFrame(event:Event):void
		{
			_to.x = _from.x + _from.width;
		}
		
		override public function stop():void
		{
			super.stop();
			_from.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
	}
}