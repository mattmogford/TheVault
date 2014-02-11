package vault.transitions.move
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import vault.transitions.TransitionType;

	public class Transition_MoveTopFromBottom extends TransitionType
	{		
		public function Transition_MoveTopFromBottom( from:Bitmap, to:Bitmap )
		{
			super( from, to );
		}
		
		override public function start():void
		{
			TweenNano.to( _from, 1, { y : -_from.height, onComplete:stop } );
			_from.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		protected function onEnterFrame(event:Event):void
		{
			_to.y = _from.y + _from.height;
		}
		
		override public function stop():void
		{
			super.stop();
			_from.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
	}
}