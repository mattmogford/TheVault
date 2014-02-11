package vault.transitions.fade
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	
	import vault.transitions.TransitionType;

	public class Transition_FadeInFromBottom extends TransitionType
	{		
		public function Transition_FadeInFromBottom( from:Bitmap, to:Bitmap )
		{
			super( from, to );
		}
		
		override public function start():void
		{
			_to.alpha = 0;
			_to.y = _from.y + _from.height;
			TweenNano.to( _to, 1, { y : 0, alpha:1, onComplete:stop } );
		}
	}
}