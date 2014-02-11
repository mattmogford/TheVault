package vault.transitions.fade
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	
	import vault.transitions.TransitionType;

	public class Transition_FadeOutFromLeft extends TransitionType
	{		
		public function Transition_FadeOutFromLeft( from:Bitmap, to:Bitmap )
		{
			super( from, to );
		}
		
		override public function start():void
		{
			TweenNano.to( _from, 1, { alpha : 0, onComplete:stop } );
			_to.x = _from.x - _from.width;
			TweenNano.to( _to, 1, { x : 0 } );
		}
	}
}