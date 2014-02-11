package vault.transitions.scale
{
	import com.greensock.TweenNano;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import vault.transitions.TransitionType;

	public class Transition_ScaleDownFromRight extends TransitionType
	{
		private var _fromSprite:Sprite;
		
		public function Transition_ScaleDownFromRight( from:Bitmap, to:Bitmap )
		{
			super( from, to );
		}
		
		override public function start():void
		{
			var scaleDownTo:Number = 0.75;
			
			_to.x = _from.x + _from.width;
			
			_fromSprite = new Sprite;
			_from.parent.addChildAt( _fromSprite, 0 );
			_from.x = -( _from.width >> 1 );
			_from.y = -( _from.height >> 1 );
			_fromSprite.addChild( _from );
			_fromSprite.x = _fromSprite.width >> 1;
			_fromSprite.y = _fromSprite.height >> 1;
			
			TweenNano.to( _fromSprite, 1, { scaleX : scaleDownTo, scaleY : scaleDownTo, onComplete : resetBitmaps } );
			TweenNano.to( _to, 1, { x : 0 } );
		}
		
		private function resetBitmaps():void
		{
			_from.x =_from.y = 0;
			_fromSprite.parent.addChild( _from );
			_fromSprite.parent.removeChild( _fromSprite );
			
			stop();
		}
	}
}