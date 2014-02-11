package vault.transitions.fade
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	
	import vault.transitions.TransitionType;

	public class Transition_FadeInFromLeft extends TransitionType
	{		
		public function Transition_FadeInFromLeft( from:Bitmap, to:Bitmap )
		{
			super( from, to );
		}
		
		override public function start():void
		{
			_to.alpha = 0;
			_to.x = _from.x - _from.width;
			TweenNano.to( _to, 1, { x : 0, alpha:1, onComplete:stop } );
		}
	}
}