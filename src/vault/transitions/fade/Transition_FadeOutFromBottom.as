package vault.transitions.fade
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	
	import vault.transitions.TransitionType;

	public class Transition_FadeOutFromBottom extends TransitionType
	{		
		public function Transition_FadeOutFromBottom( from:Bitmap, to:Bitmap )
		{
			super( from, to );
		}
		
		override public function start():void
		{
			TweenNano.to( _from, 1, { alpha : 0, onComplete:stop } );
			_to.y = _from.y + _from.height;
			TweenNano.to( _to, 1, { y : 0 } );
		}
	}
}